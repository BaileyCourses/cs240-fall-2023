#!/usr/bin/env python3

import sys

def main ():
    name = "TRY"
    length = 10
    start = 0x100
    human = True

    objFile = ObjectFile("out.bin", length, name, start, human)

    objFile.emitType3(10, 13, 0, 0, 0, 0, 0, 20)
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
        self._maxLen = 1

        self._emitHeaderRecord(name, startAddress, length)

    # Layer 4: supports instruction formats and data definitions

    def emitSIC(self, loc, opcode, X, addr):
        pass

    def emitType1(self, loc, opcode):
        pass

    def emitType2(self, loc, opcode, reg1, reg2):
        pass

    def emitType3(self, loc, opcode, N, I, X, B, P, disp):

        loc &= 0xfffff
        opcode &= 0x3f
        N &= 1
        I &= 1
        X &= 1
        B &= 1
        P &= 1
        disp &= 0xfff

        bytes = [opcode << 2 | N << 1 | I] + intToBytes(X << 15 | B << 14 | P << 13 | disp, 2)

        self._emitTextBytes(loc, bytes)


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

        if self._bufferLoc is None:
            self._bufferLoc = loc
        else:
            endLoc = self._bufferLoc + len(self._byteBuffer)
            
            if loc > endLoc:
                self._flushBuffer()
                self._bufferLoc = loc
                
        self._byteBuffer += byteList
        
        while len(self._byteBuffer) >= self._maxLen:
            self._emitTextRecord(self._bufferLoc, self._byteBuffer[:self._maxLen])
            self._byteBuffer = self._byteBuffer[self._maxLen:]
            self._bufferLoc += self._maxLen


    def _flushBuffer(self):
        pass

    # Layer 2: emits object code records

    def _emitTextRecord(self, loc, text):
        locASCII = intToBytes(loc, 3)
        lengthASCII = intToBytes(len(text), 1)
        self._write('T', locASCII, lengthASCII, text)

    def _emitHeaderRecord(self, name, start, length):
        name = (name + "      ")[:6]
        startASCII = intToBytes(start, 3)
        lengthASCII = intToBytes(length, 3)
        self._write('H', name, startASCII, lengthASCII)

    def _emitEndRecord(self, entryPoint):
        entryASCII = intToBytes(entryPoint, 3)
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
                if self._human:
                    self._outFile.write(bytearray("%02X" % arg, "utf-8"))
                else:
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

    
