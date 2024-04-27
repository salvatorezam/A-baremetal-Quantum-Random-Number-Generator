HEX
FE000000 CONSTANT BASE_ADDRESS
BASE_ADDRESS 200000 + CONSTANT PERI_BASE
PERI_BASE CONSTANT GPFSEL0
804000                    CONSTANT BSC1OFFSET
BASE_ADDRESS BSC1OFFSET + CONSTANT BSC1
BSC1 CONSTANT I2C_CONTROL_REG
1           CONSTANT I2CC.READ
1 4 LSHIFT  CONSTANT I2CC.CLRF
1 7 LSHIFT  CONSTANT I2CC.ST
1 F LSHIFT  CONSTANT I2CC.EN
BSC1 4 +    CONSTANT I2C_STATUS_REG
1           CONSTANT I2CS.TA
1 1 LSHIFT  CONSTANT I2CS.DONE
1 8 LSHIFT  CONSTANT I2CS.ERR
1 9 LSHIFT  CONSTANT I2CS.CLKT
BSC1 8 + CONSTANT I2C_DLEN_REG
BSC1 C + CONSTANT I2C_SLAVE_ADDR
BSC1 10 + CONSTANT I2C_DATA_FIFO
48 CONSTANT ADS1115.SLAVE_ADDR
00 CONSTANT ADS1115.CONVR_REG
01 CONSTANT ADS1115.CONF_REG
FF CONSTANT BYTEMASK
: SETBITS! TUCK @ OR SWAP ! ;
: CLEARBITS! SWAP INVERT OVER @ AND SWAP ! ;
: SET-MASKED-BITS! OVER @ AND 2 PICK OR SWAP ! DROP ;
: GPIO-I2C-SETUP 900 GPFSEL0  SETBITS! ;
: ENABLE-I2C  I2CC.EN I2C_CONTROL_REG  SETBITS! ;
: DISABLE-I2C I2CC.EN I2C_CONTROL_REG  CLEARBITS! ;
: SET-SLAVE-ADDR ADS1115.SLAVE_ADDR I2C_SLAVE_ADDR  SETBITS! ;
: SET-DLEN I2C_DLEN_REG FFFF0000  SET-MASKED-BITS! ;
: CLEAR-DONE I2CS.DONE I2C_STATUS_REG  SETBITS! ;
: CLEAR-STATUS I2CS.DONE I2CS.ERR I2CS.CLKT OR OR I2C_STATUS_REG  SETBITS! ;
: CLEAR-FIFO I2CC.CLRF I2C_CONTROL_REG  SETBITS! ;
: RESET-I2C CLEAR-STATUS CLEAR-FIFO ;
: WAIT-FOR-TRANSFER BEGIN I2C_STATUS_REG @ I2CS.TA AND 0= UNTIL CLEAR-DONE ;
: INIT-I2C ENABLE-I2C RESET-I2C SET-SLAVE-ADDR ;
: BYTE-OFFSET 8 * ;
: SHIFT-MASK SWAP LSHIFT ;
: APPLY-MASK DUP BYTE-OFFSET DUP BYTEMASK SHIFT-MASK 3 PICK AND ;
: GET-BYTE SWAP RSHIFT ;
: PUSH-BYTE-TO-FIFO I2C_DATA_FIFO ! ;
: PUSH-BYTES-TO-FIFO 1- BEGIN DUP 0>= WHILE APPLY-MASK GET-BYTE PUSH-BYTE-TO-FIFO 1- REPEAT 2DROP ;
: POP-BYTE-FROM-FIFO I2C_DATA_FIFO @ FF AND ;
: UPDATE-BUFFER OVER BYTE-OFFSET LSHIFT 2 PICK @ OR 2 PICK ! ;
: FIFO>BUFFER 1- BEGIN DUP 0>= WHILE POP-BYTE-FROM-FIFO UPDATE-BUFFER 1- REPEAT 2DROP ;
: SETUP-I2C-WRITE TUCK PUSH-BYTES-TO-FIFO SET-DLEN ;
: START-WRITE I2CC.READ I2C_CONTROL_REG  CLEARBITS! I2CC.ST I2C_CONTROL_REG  SETBITS! ;
: I2CWRITE> SETUP-I2C-WRITE START-WRITE WAIT-FOR-TRANSFER ;
: START-READ I2CC.READ I2CC.ST OR I2C_CONTROL_REG  SETBITS! ;
: REPEATED-START-READ DUP SET-DLEN START-READ WAIT-FOR-TRANSFER ;
: >I2CREAD  SWAP 1 I2CWRITE> REPEATED-START-READ FIFO>BUFFER ;