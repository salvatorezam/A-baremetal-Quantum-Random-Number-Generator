HEX
PERI_BASE 4 + CONSTANT GPFSEL1
FFFFFFC7 CONSTANT FSEL11_MASK
8 CONSTANT FSEL11.OUT
PERI_BASE 1C + CONSTANT GPSET0
PERI_BASE 28 + CONSTANT GPCLR0
: GPIO-LD-SETUP FSEL11.OUT GPFSEL1 FSEL11_MASK  SET-MASKED-BITS! ;
: LASER 800 GPSET0 GPCLR0 ;
: ON    DROP ! ;
: OFF   NIP ! ;