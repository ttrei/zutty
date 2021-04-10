#include "bmp.h"

#include <cmath>
#include <stdio.h>

#define HEADER_SIZE 14
#define INFO_HEADER_SIZE 40
#define NO_COMPRESION 0
#define MAX_NUMBER_OF_COLORS 256
#define ALL_COLORS_REQUIRED 0
#define BYTES_PER_PIXEL 4

void WritePixel(FILE* f, uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    fwrite(&r, 1, 1, f);
    fwrite(&g, 1, 1, f);
    fwrite(&b, 1, 1, f);
    fwrite(&a, 1, 1, f);
}

void WriteImage(const char *fileName, uint8_t *atlasPixels,
                uint16_t px, uint16_t py, uint16_t nx, uint16_t ny,
                uint16_t pixelsAboveBaseline)
{
        // width and height include the additional pixels for grid lines
        int32_t width = nx*px + nx + 1;
        int32_t height = ny*py + ny + 1;
        int32_t imageSize = width*height*BYTES_PER_PIXEL;
        int32_t fileSize = imageSize + HEADER_SIZE + INFO_HEADER_SIZE;

        FILE *outputFile = fopen(fileName, "wb");
        //*****HEADER************//
        const char *BM = "BM";
        fwrite(&BM[0], 1, 1, outputFile);
        fwrite(&BM[1], 1, 1, outputFile);
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
        fwrite(&imageSize, 4, 1, outputFile);
        int32_t resolutionX = 11811; //300 dpi
        int32_t resolutionY = 11811; //300 dpi
        fwrite(&resolutionX, 4, 1, outputFile);
        fwrite(&resolutionY, 4, 1, outputFile);
        int32_t colorsUsed = MAX_NUMBER_OF_COLORS;
        fwrite(&colorsUsed, 4, 1, outputFile);
        int32_t importantColors = ALL_COLORS_REQUIRED;
        fwrite(&importantColors, 4, 1, outputFile);

        uint16_t pixelsBelowBaseline = py - pixelsAboveBaseline;

        uint8_t* rowCursor = atlasPixels + nx*px * (ny*py - 1);
        uint8_t* pixelCursor;
        for (uint16_t i = 0; i < height; i++) {
            bool separatorRow = (i % (py+1) == 0);

            // Positioned the baseline by trial and error.
            // This math is probably slightly off.
            bool baselineRow = (i % (py+1) == pixelsBelowBaseline);

            pixelCursor = rowCursor;
            for (uint16_t j = 0; j < width; j++) {
                bool separatorColumn = (j % (px+1) == 0);
                if (separatorRow || separatorColumn) {
                    WritePixel(outputFile, 0, 0, 0x80, 0);
                } else {
                    uint8_t saturation = *pixelCursor++;
                    if (baselineRow && saturation == 0) {
                        WritePixel(outputFile, 0, 0xFF, 0, 0);
                    } else {
                        WritePixel(outputFile, saturation, saturation, saturation, 0);
                    }
                }

            }
            if (!separatorRow) {
                rowCursor -= nx*px;
            }
        }
        fclose(outputFile);
}
