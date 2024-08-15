import yaml
import argparse
from math import ceil

def adjust_bank(offset, bank=None):
    if bank is None:
        return offset
    return ((bank << 15) & 0x3F8000) - 0x8000 + offset


def indirect_section(indent, section, bank=None):
    spaces = ' ' * indent
    offset = adjust_bank(section['offset'], bank)

    subbank = None
    if 'bank' in section:
        subbank = section['bank']

    sections = []
    if 'pointers' in section:
        for subsection in section['pointers']:
            sections += [indirect_section(indent + 4, subsection, subbank)]
    if 'writes' in section:
        for subsection in section['writes']:
            sections += [direct_section(indent + 4, subsection, subbank)]

    return spaces + '{"indirect": {\n' +\
        spaces + '  "offset": "' + "0x{:X}".format(offset) + '",\n' +\
        spaces + '  "read_length": 2,\n' +\
        spaces + '  "sections": [\n' +\
        ",\n".join(sections) + '\n' +\
        spaces + '  ]\n' +\
        spaces + '}}'


def direct_section(indent, section, bank=None):
    spaces = ' ' * indent
    offset = adjust_bank(section['offset'], bank)
    databytes = []
    for dataword in section['data']:
        databytes += [dataword & 0xFF, (dataword >> 8) & 0xFF]
    return spaces + '{"direct": {\n' +\
        spaces + '  "offset": "' + "0x{:X}".format(offset) + '",\n' +\
        spaces + '  "data": "' + "".join(map(lambda byte: '{:02X}'.format(byte), databytes)) + '"\n' +\
        spaces + '}}'


def direct_section_bytes(indent, offset, databytes):
    spaces = ' ' * indent
    return spaces + '{"direct": {\n' +\
        spaces + '  "offset": "' + "0x{:X}".format(offset) + '",\n' +\
        spaces + '  "data": "' + "".join(map(lambda byte: '{:02X}'.format(byte), databytes)) + '"\n' +\
        spaces + '}}'


def parse_ips(indent, ipsbytes):
    if ipsbytes[0:5] != b"PATCH" or ipsbytes[-3:] != b"EOF":
        raise ValueError("bad ips patch")
    loc = 5
    sections = []
    while loc < len(ipsbytes) - 3:
        offset = int.from_bytes(ipsbytes[loc:loc+3], "big")
        size = int.from_bytes(ipsbytes[loc+3:loc+5], "big")
        if size == 0:
            size = int.from_bytes(ipsbytes[loc+5:loc+7], "big")
            value = ipsbytes[loc+7]
            loc += 8
            section = direct_section_bytes(indent, offset, [value] * size)
        else:
            loc += 5
            section = direct_section_bytes(indent, offset, ipsbytes[loc:loc+size])
            loc += size
        if not (offset >= 0x7FDC and offset + size <= 0x7FE0):
            sections += [section]
    return sections


parser = argparse.ArgumentParser(prog="build_glowpatch.py", description="Converts a YAML file into glowpatch format, optionally including IPS files into the patch as well.")
parser.add_argument("-i", dest="input", required=True, metavar="FILENAME", type=argparse.FileType("r"), help="Input YAML file")
parser.add_argument("-p", dest="patches", metavar="FILENAME", type=argparse.FileType("rb"), help="Input IPS files", nargs="*")
parser.add_argument("-o", dest="output", required=True, metavar="FILENAME", type=argparse.FileType("w"), help="Output glowpatch file")

args = parser.parse_args()

data = yaml.safe_load(args.input)
args.input.close()

sections = []

bank = None
if 'bank' in data:
    bank = data['bank']

for section in data:
    sections += [indirect_section(4, section, bank)]

for patch in args.patches:
    sections += parse_ips(4, patch.read())

output = '{\n  "sections": [\n' + ",\n".join(sections) + '\n  ]\n}'

args.output.write(output)
args.output.close()
