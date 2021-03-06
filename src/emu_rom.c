#include "emu_rom.h"
#include "emu_debug.h"
#include <stdio.h>

EMUROM_Return EMUROM_read(char* romPath, uint8_t* romBuf, uint16_t* romSize)
{
  EMUROM_Return retVal = EMUROM_NOK;

  FILE* romFile = fopen(romPath, "rb");

  EMU_DEBUG_ASSERT_COND(romFile);

  if(romFile)
  {
    fseek(romFile, 0, SEEK_END);
    *romSize = ftell(romFile);
    fseek(romFile, 0, SEEK_SET);
    fread(romBuf, 1, *romSize, romFile);
    fclose(romFile);
    retVal = EMUROM_OK;
  }

  return retVal;
}
