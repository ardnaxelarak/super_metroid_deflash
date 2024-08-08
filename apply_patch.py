import sys

romStream = open(sys.argv[1], "rb")
romBytes = romStream.read()
romStream.close()
rom = [b for b in romBytes]

patch = open(sys.argv[2], "rb")

def get_varint(stream):
    len = stream.read(1)[0]
    return int.from_bytes(stream.read(len), "little")

def parse_direct_section(baseOffset):
    sectionOffset = get_varint(patch)
    totalOffset = baseOffset + sectionOffset
    dataLength = get_varint(patch)
    data = patch.read(dataLength)
    # print(f"writing {dataLength} bytes to addr {hex(totalOffset)}")
    for i in range(dataLength):
        rom[totalOffset + i] = data[i]

def parse_indirect_section(baseOffset):
    sectionOffset = get_varint(patch)
    totalOffset = baseOffset + sectionOffset
    addrLength = patch.read(1)[0]
    addrValue = int.from_bytes(rom[totalOffset:totalOffset+addrLength], "little")
    sections = get_varint(patch)
    for i in range(sections):
        parse_section(addrValue)

def parse_section(baseOffset):
    sectionType = patch.read(1)[0]
    if sectionType == 0:
        parse_direct_section(baseOffset)
    elif sectionType == 1:
        parse_indirect_section(baseOffset)
    else:
        raise "Unexpected section type " + sectionType


topLevelSections = get_varint(patch)
for i in range(topLevelSections):
    parse_section(0)

outStream = open(sys.argv[3], "wb")
outStream.write(bytes(rom))
outStream.close()
