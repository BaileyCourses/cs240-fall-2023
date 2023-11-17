#!/usr/bin/env python3

import sys

def main ():
    name = "TRY"
    length = 10
    start = 0x100
    human = True

    objFile = ObjectFile("out.bin", length, name, start, human)

    objFile._write(0x30, 0x31, 0x32)
    objFile._write("Hello")

    objFile.close(10)

def error(*values):
    raise RuntimeError(" ".join([str(value) for value in values]))

class ObjectFile:

    def __init__(self, filename, length, name = "", startAddress = 0,
                 humanReadable = False):
        self._human = humanReadable
        self._outFile = open(filename, "wb")
        self._byteBuffer = []
        self._bufferLoc = None
        self._maxLen = 64

        self._emitHeaderRecord(name, startAddress, length)

    # Layer 4: supports instruction formats and data definitions

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

    def emitBytes(self, loc, bytes):
        pass

    def close(self, entryPoint = 0):
        self._emitEndRecord(entryPoint)
        
    # Layer 3: Handles of buffering of code bytes

    def _emitTextBytes(self, loc, byteList):
        pass

    def _flushBuffer(self):
        pass

    # Layer 2: emits object code records

    def _emitTextRecord(self, loc, text):
        pass

    def _emitHeaderRecord(self, name, start, length):
        pass

    def _emitEndRecord(self, entryPoint):
        print(entryPoint)
        entryASCII = intToBytes(entryPoint, 3)
        print(entryASCII)
        self._write('E', entryASCII)

    # Layer 1: Writes ints or strings to a file (layers on top of system write)

    def _write(self, *args):
        newargs = []
        for arg in args:
            if type(arg) == list:
                newargs = newargs + arg
            else:
                newargs.append(arg)
        args = newargs

        for arg in args:
            if type(arg) == int:
                self._outFile.write(bytearray([arg]))
            elif type(arg) == str:
                self._outFile.write(bytearray(arg, "utf-8"))
            else:
                error("Unrecognized value: ", arg)
            
                

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

    
