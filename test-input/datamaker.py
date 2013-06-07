#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import getopt
import math
import urllib2


class ANURandom:
    BINARY = "BINARY"
    HEX = "HEX"
    CHAR = "CHAR"
    numPool = ""
    posPool = 0
    lenPool = 0
    
    def getRandom(self,type):
        if type == self.BINARY:
            url = 'http://150.203.48.55/RawBin.php'
        elif type == self.HEX:
            url = 'http://150.203.48.55/RawHex.php'
        elif type == self.CHAR:
            url = 'http://150.203.48.55/RawChar.php'

        page = urllib2.urlopen(url, timeout=10)
        data = page.read()
        num = data.split('"rng"')[1].split('<td>\n')[1].split('</td>')[0]
        return num

    def getBin(self):
        return self.getRandom(self.BINARY)

    def getHex(self):
        return self.getRandom(self.HEX)

    def getChar(self):
        return self.getRandom(self.CHAR)

    def __init__(self):
        global numPool
        global posPool
        global lenPool
        numPool = self.getRandom(self.HEX)
        posPool = 0
        lenPool = len(numPool)
    
    def getNumber(self,byte=2):
        global numPool
        global posPool
        global lenPool
        
        endPool = posPool + byte*2
        if (endPool >= lenPool):
            self.__init__()
            endPool = posPool + byte*2
        numStr = numPool[posPool:endPool]
        posPool = endPool
        return int(numStr,16)


if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:],"n:m:e:r:", ["n_physical=","m_virtual=", "expected=", "max_range="])
    except getopt.GetoptError:
        print "[Usage example] %s -n 5 -m 4 -e 2 -r 1024" % (sys.argv[0])
        sys.exit(2)

    if (len(opts) < 4):
        print "Too few arguments. Only %d, expects 4." % (len(opts))
        sys.exit(3)
    
    for o, a in opts:
        if o == "-n":
            num_n_physical = int(a)
        elif o == "-m":
            num_m_virtual = int(a)
        elif o == "-e":
            num_expected = int(a)
        elif o == "-r":
            num_max_range = int(a)

    num_bytes_per_vm = math.trunc(math.log(num_max_range)/(math.log(2)*8.0))+2
    num_bytes_for_all = math.trunc(math.log(num_max_range*num_expected)/(math.log(2)*8.0))+2

    numberSource = ANURandom()
    print num_n_physical
    print num_m_virtual
    for i in range(num_n_physical):
        for j in range(num_m_virtual):
            print numberSource.getNumber(num_bytes_per_vm) % num_max_range,
        print 
    for j in range(num_m_virtual):
        print numberSource.getNumber(num_bytes_for_all) % (num_max_range * num_expected),
    sys.exit(0)

