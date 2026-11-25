#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Antigravity CLI 1.5.16 Windows x64 Eligibility Bypass Patcher
原理: 将 AuthStatus.EligibilityError 开头的 TEST RAX, RAX (48 85 C0) 
修改为 XOR EAX, EAX (31 C0) + NOP (90)，强制返回 nil。
"""

import argparse
import hashlib
import os
import shutil
import sys
import tempfile
from pathlib import Path

EXPECTED_SHA256 = "eaec8e3fc809df032dd8c496a86f6d53351942ec6c5cb7215d04f2c72a85bff8"

# 经过 Ghidra 实测验证的修正位置：强制返回 nil
PATCHES = [
    (0x02BEAA32, bytes.fromhex("48 85 C0"), bytes.fromhex("31 C0 90"))
]

def sha256(path: Path) -> str:
    with path.open("rb") as f:
        return hashlib.file_digest(f, "sha256").hexdigest()

def verify_output(source: Path, output: Path) -> str:
    """验证生成的文件除了补丁点之外，其他地方和原文件完全一致。"""
    digest = hashlib.sha256()
    pos = 0
    with source.open("rb") as original, output.open("rb") as produced:
        while source_bytes := original.read(1024 * 1024):
            output_bytes = produced.read(len(source_bytes))
            expected = bytearray(source_bytes)
            for offset, old, new in PATCHES:
                begin = max(offset, pos)
                end = min(offset + len(new), pos + len(source_bytes))
                if begin < end:
                    expected[begin - pos:end - pos] = new[begin - offset:end - offset]
            if output_bytes != expected:
                raise RuntimeError(f"生成的文件在 0x{pos:08X} 附近出现异常修改")
            digest.update(output_bytes)
            pos += len(source_bytes)
    return digest.hexdigest()

def main() -> int:
    parser = argparse.ArgumentParser(description="Apply patch to agy.exe")
    parser.add_argument("source", type=Path, help="原始 agy.exe 的路径")
    parser.add_argument("output", type=Path, help="输出 patched.exe 的路径")
    args = parser.parse_args()
    src, dst = args.source, args.output

    if not src.is_file():
        parser.error(f"找不到原文件: {src}")
    if dst.exists():
        parser.error(f"输出文件已存在，请先删除: {dst}")

    # 1. 校验原版哈希
    actual = sha256(src)
    if actual != EXPECTED_SHA256:
        parser.error(f"SHA-256 不匹配！此补丁仅适用于 1.5.16 版本的 Windows 原版 agy.exe\n预期: {EXPECTED_SHA256}\n实际: {actual}")
    print(f"[+] 原文件校验通过，准备打补丁...")

    # 2. 校验机器码
    with src.open("rb") as f:
        for offset, old, new in PATCHES:
            f.seek(offset)
            found = f.read(len(old))
            if found != old:
                parser.error(f"偏移 0x{offset:08X} 原始字节不匹配，程序可能已损坏或版本不对。")
            print(f"[*] 目标位置 0x{offset:08X}: {old.hex(' ').upper()} -> {new.hex(' ').upper()}")

    # 3. 安全写入（临时文件 + 原子替换）
    fd, tmp_name = tempfile.mkstemp(prefix=".agy_patch_", suffix=".tmp", dir=str(dst.parent))
    temp_path = Path(tmp_name)
    try:
        with os.fdopen(fd, "w+b") as produced, src.open("rb") as original:
            shutil.copyfileobj(original, produced)
            for offset, _, new in PATCHES:
                produced.seek(offset)
                produced.write(new)
            produced.flush()
            os.fsync(produced.fileno())

        patched_hash = verify_output(src, temp_path)
        os.link(temp_path, dst)
        print(f"[+] 补丁生成成功！输出文件 SHA-256: {patched_hash}")
        print(f"[*] 输出路径: {dst}")
        return 0
    finally:
        temp_path.unlink(missing_ok=True)

if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        sys.exit(f"打补丁失败: {e}")