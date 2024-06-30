# -*- coding: utf-8 -*-

from PIL import Image
import numpy as np

def main():
    img = Image.open('diskette_128px.png')
    
    vga_palette = np.loadtxt('vga-palette.csv', delimiter=',', 
                             usecols=[0,1,2], dtype=np.uint8)
    
    pixels = img.load()
    data = bytearray()
    for y in range(128):
        for x in range(128):
            p = pixels[x,y]
            c = np.argmin(np.linalg.norm(vga_palette - p, axis=1))
            
            data.append(c)
            
    with open('DISKETTE.IMG', 'wb') as f:
        f.write(data)

if __name__ == '__main__':
    main()