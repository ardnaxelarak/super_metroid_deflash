import yaml
import argparse
from math import ceil

def adjust_bank(offset, bank=None):
    if bank is None:
        return offset
    return ((bank << 15) & 0x3F8000) - 0x8000 + offset

def varint(value):
    len = max(1, ceil(value.bit_length() / 8.0))
    return [len] + [x for x in value.to_bytes(len, 'little')]

def output_indirect_section(out, section, bank=None):
    out += [1]
    out += varint(adjust_bank(section['offset'], bank))
    out += [2]
    sections = 0
    if 'pointers' in section:
        sections += len(section['pointers'])
    if 'writes' in section:
        sections += len(section['writes'])
    bank = None
    if 'bank' in section:
        bank = section['bank']
    out += varint(sections)
    if 'pointers' in section:
        for subsection in section['pointers']:
            output_indirect_section(out, subsection, bank)
    if 'writes' in section:
        for subsection in section['writes']:
            output_direct_section(out, subsection, bank)

def output_direct_section(out, section, bank=None):
    out += [0]
    out += varint(adjust_bank(section['offset'], bank))
    out += varint(2 * len(section['data']))
    for data in section['data']:
        out += [data & 0xFF, (data >> 8) & 0xFF]

parser = argparse.ArgumentParser(prog="build_glowpatch.py", description="Converts a YAML file into glowpatch format, optionally including IPS files into the patch as well.")
parser.add_argument("-i", dest="input", required=True, metavar="FILENAME", type=argparse.FileType("r"), help="Input YAML file")
# parser.add_argument("-p", dest="patches", metavar="FILENAME", type=argparse.FileType("rb"), help="Input IPS files", nargs="*")
parser.add_argument("-o", dest="output", required=True, metavar="FILENAME", type=argparse.FileType("wb"), help="Output glowpatch file")

args = parser.parse_args()

data = yaml.safe_load(args.input)
args.input.close()

outdata = []

outdata += varint(len(data))

bank = None
if 'bank' in data:
    bank = data['bank']

for section in data:
    output_indirect_section(outdata, section, bank)

args.output.write(bytes(outdata))
args.output.close()
