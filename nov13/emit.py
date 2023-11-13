#!/usr/bin/env python3

outFile = None

def main ():
    name = "TRY"
    length = 10
    start = 0x100
    human = True
    objFile = ObjectFile("out.bin", length, name, start, human)

    objFile.emitSIC(0x100, 0x13, 1, 0x7bcd)
#    objFile.emitType1(10, 0x13)
#    objFile.emitType2(10, 0x13, 4, 6)
#    objFile.emitType3(10, 0x13, 0, 0, 1, 0, 1, 0xabc)
#    objFile.emitType2(10, 0x22, 4, 6)
#    for loc in range(0x100, 0x100 + 10, 3):
#        objFile.emitSIC(loc, 0x4c, 1, 0xabc)

#    for loc in range(0x300, 0x300 + 70):
#        objFile.emitByte(loc, 0x4c)
        
#    objFile.emitSIC(20, 0x4c, 1, 0xabc)
#    objFile.emitType3(24, 0x4c, 1, 0, 1, 0, 1, 0xabc)
#    objFile.emitType4(20, 0x4c, 1, 0, 1, 0, 1, 0xabc)
    objFile.close(10)

class ObjectFile:
    def __init__(self, filename, length, name = "", startAddress = 0,
                 humanReadable = False):
        self._human = humanReadable
        self._outFile = open(filename, "wb")
        self._byteBuffer = []
        self._bufferLoc = None

        self._emitHeader(name, startAddress, length)

    def emitSIC(self, loc, opcode, X, addr):
        pass

    def emitType1(self, loc, opcode):
        pass

    def emitType2(self, loc, opcode, reg1, reg2):
        pass

    def emitType3(self, loc, opcode, N, I, X, B, P, disp):
        pass

    def emitType4(self, loc, opcode, N, I, X, B, P, addr):
        pass

    def emitByte(self, loc, byte):
        pass

    def emitText(self, loc, text):
        pass

    def close(self, entryPoint = 0):
        pass
        # Make sure to flush all of the buffered bytes first
        
    def _emitHeader(self, name, start, length):
        pass

    def _emitEnd(self, entryPoint):
        pass

    def _write(self, *args):
        pass

    def _flushBuffer(self):
        pass

    def _emitBytes(self, loc, byteList):
        pass

#
# intToBytes - convert an integer into a list of 8-bit integers
#

def intToBytes(value, size):
    bytes = []
    for _ in range(size):
        byte = value & 0xff
        bytes = [byte] + bytes
        value >>= 8
    return bytes

if __name__ == "__main__":
    main()
