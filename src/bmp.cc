#include "bmp.h"

#include <cmath>
#include <stdio.h>

#define HEADER_SIZE 14
#define INFO_HEADER_SIZE 40
#define NO_COMPRESION 0
#define MAX_NUMBER_OF_COLORS 256
#define ALL_COLORS_REQUIRED 0
#define BYTES_PER_PIXEL 4

void WriteImage(const char *fileName, uint8_t *pixels, int32_t width, int32_t height, uint16_t px, uint16_t py)
{
        FILE *outputFile = fopen(fileName, "wb");
        //*****HEADER************//
        const char *BM = "BM";
        fwrite(&BM[0], 1, 1, outputFile);
        fwrite(&BM[1], 1, 1, outputFile);
        int rowSize = width*BYTES_PER_PIXEL;
        int32_t fileSize = rowSize*height + HEADER_SIZE + INFO_HEADER_SIZE;
        fwrite(&fileSize, 4, 1, outputFile);
        int32_t reserved = 0x0000;
        fwrite(&reserved, 4, 1, outputFile);
        int32_t dataOffset = HEADER_SIZE+INFO_HEADER_SIZE;
        fwrite(&dataOffset, 4, 1, outputFile);

        //*******INFO*HEADER******//
        int32_t infoHeaderSize = INFO_HEADER_SIZE;
        fwrite(&infoHeaderSize, 4, 1, outputFile);
        fwrite(&width, 4, 1, outputFile);
        fwrite(&height, 4, 1, outputFile);
        int16_t planes = 1; //always 1
        fwrite(&planes, 2, 1, outputFile);
        int16_t bitsPerPixel = BYTES_PER_PIXEL * 8;
        fwrite(&bitsPerPixel, 2, 1, outputFile);
        //write compression
        int32_t compression = NO_COMPRESION;
        fwrite(&compression, 4, 1, outputFile);
        //write image size (in bytes)
        int32_t imageSize = width*height*BYTES_PER_PIXEL;
        fwrite(&imageSize, 4, 1, outputFile);
        int32_t resolutionX = 11811; //300 dpi
        int32_t resolutionY = 11811; //300 dpi
        fwrite(&resolutionX, 4, 1, outputFile);
        fwrite(&resolutionY, 4, 1, outputFile);
        int32_t colorsUsed = MAX_NUMBER_OF_COLORS;
        fwrite(&colorsUsed, 4, 1, outputFile);
        int32_t importantColors = ALL_COLORS_REQUIRED;
        fwrite(&importantColors, 4, 1, outputFile);

        uint8_t red;
        uint8_t green;
        uint8_t blue;
        uint8_t alpha = 0;

        for (int i = 0; i < height; i++)
        {
            for (int j = 0; j < width; j++) {
                int pixelOffset = (height - i - 1)*width + j;
                red = *(pixels + pixelOffset);
                green = *(pixels + pixelOffset);
                blue = *(pixels + pixelOffset);

                fwrite(&red, 1, 1, outputFile);
                fwrite(&green, 1, 1, outputFile);
                fwrite(&blue, 1, 1, outputFile);
                fwrite(&alpha, 1, 1, outputFile);
            }
        }
        fclose(outputFile);
}
