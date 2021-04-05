#pragma once

#include <cstdint>

void WriteImage(const char *fileName, uint8_t *atlasPixels,
                uint16_t px, uint16_t py, uint16_t nx, uint16_t ny);
