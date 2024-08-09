import argparse

parser = argparse.ArgumentParser(prog="apply_glowpatch", description="Apply a glowpatch file to a rom.")
parser.add_argument("-i", dest="input", required=True, metavar="FILENAME", type=argparse.FileType("rb"), help="Input rom file")
parser.add_argument("-p", dest="patch", required=True, metavar="FILENAME", type=argparse.FileType("rb"), help="Input glowpatch file")
parser.add_argument("-o", dest="output", required=True, metavar="FILENAME", type=argparse.FileType("wb"), help="Output rom file")

args = parser.parse_args()

romBytes = args.input.read()
args.input.close()
rom = [b for b in romBytes]

def get_varint(stream):
    len = stream.read(1)[0]
    return int.from_bytes(stream.read(len), "little")

def parse_direct_section(patch, baseOffset):
    sectionOffset = get_varint(patch)
    totalOffset = baseOffset + sectionOffset
    dataLength = get_varint(patch)
    data = patch.read(dataLength)
    # print(f"writing {dataLength} bytes to addr {hex(totalOffset)}")
    for i in range(dataLength):
        rom[totalOffset + i] = data[i]

def parse_indirect_section(patch, baseOffset):
    sectionOffset = get_varint(patch)
    totalOffset = baseOffset + sectionOffset
    addrLength = patch.read(1)[0]
    addrValue = int.from_bytes(rom[totalOffset:totalOffset+addrLength], "little")
    sections = get_varint(patch)
    for i in range(sections):
        parse_section(patch, addrValue)

def parse_section(patch, baseOffset):
    sectionType = patch.read(1)[0]
    if sectionType == 0:
        parse_direct_section(patch, baseOffset)
    elif sectionType == 1:
        parse_indirect_section(patch, baseOffset)
    else:
        raise "Unexpected section type " + sectionType

topLevelSections = get_varint(args.patch)
for i in range(topLevelSections):
    parse_section(args.patch, 0)

args.patch.close();

args.output.write(bytes(rom))
args.output.close()
