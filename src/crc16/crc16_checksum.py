# -*- coding: utf-8 -*-

#
# Test CRC16 on dummy data
#

import os

def main():
    data = '2BpVLhw7KJFlaY70tyDXx5iR33UX8xUs'.encode('ascii')
    
    print('0x%04X' % crc16(data))

def crc16(data):
    crc = int(0)
    
    poly = 0x1021
    
    for c in data: # fetch byte
        crc ^= (c << 8) # xor into top byte
        for i in range(8): # prepare to rotate 8 bits
            crc = crc << 1 # rotate
            if crc & 0x10000:
                crc = (crc ^ poly) & 0xFFFF # xor with XMODEN polynomic
    
    return crc

if __name__ == '__main__':
    main()