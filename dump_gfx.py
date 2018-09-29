import os
import struct
import subprocess
from collections import Counter


def write_image(rom, filename, size):
    pos = rom.tell()
    next_bank = (pos & (~0x3FFF)) + 0x4000
    with open(filename, 'wb') as tilemap:
        tilemap.write(rom.read(size))
    if rom.tell() >= next_bank:
        first_half = next_bank - pos
        print(f'INCBIN "{filename}", $0, ${first_half:x}')
        print('')
        print(f'SECTION "Frames Bank {next_bank >> 14}", ROMX [$4000], BANK [${next_bank >> 14:x}]')
        print(f'INCBIN "{filename}", ${first_half:x}, ${size - first_half:x}')
    else:
        print(f'INCBIN "{filename}"')


with open('baserom.gbc', 'rb') as rom:
    rom.seek(0x4000)
    assert rom.read(3) == b'IMG'
    headers = []
    img_frame = struct.Struct('<BHB')
    while True:
        bank, addr, size = img_frame.unpack(rom.read(4))
        if bank == 0:
            rom.seek(-3, os.SEEK_CUR)
            break
        headers.append((bank, addr, size))

    print('INCLUDE "constants.asm"')
    print('')
    print('SECTION "Image Headers", ROMX [$4000], BANK [1]')
    print('ImageHeader::')
    print('\tdb "IMG"')
    print('ImageData::')
    for i, (bank, addr, size) in enumerate(headers):
        print(f'\timg_frame Frame{i:02d}, ${size:02x}  ; ${bank:02x}:{addr:04x}')
    print('\tdb $0 ; terminator')
    print('')
    extra_idx = Counter()
    for i, (bank, addr, size) in enumerate(headers):
        pos = (bank << 14) | (addr & 0x3fff)
        if i == 0:
            print(f'SECTION "Frames Bank 1", ROMX [${addr:04x}], BANK [${bank:x}]')
        elif rom.tell() != pos:
            print(f'SECTION "Frames Bank 1 part {extra_idx[bank]}", ROMX [${addr:04x}], BANK [${bank:x}]')
            extra_idx[bank] += 1
        rom.seek(pos)
        print(f'Frame{i:02d}::')
        write_image(rom, f'gfx/frames/{i:02d}.bin', 0x168)
        if size != 0:
            write_image(rom, f'gfx/frames/{i:02d}.2bpp', (size + 1) * 16)
            subprocess.call(['python2.7', 'gfx.py', 'png', f'gfx/frames/{i:02d}.2bpp'])
