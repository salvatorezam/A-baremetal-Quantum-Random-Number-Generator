HEX
FE000000 CONSTANT BASE_ADDRESS
BASE_ADDRESS 3000 +  CONSTANT SYSTEM_TIMER_BASE
SYSTEM_TIMER_BASE     CONSTANT CS
0                     CONSTANT CS.M0
SYSTEM_TIMER_BASE 4 + CONSTANT CLO
SYSTEM_TIMER_BASE 8 + CONSTANT CHI
SYSTEM_TIMER_BASE C + CONSTANT C0
7A120 CONSTANT DELTAT
: SET-MASKED-BITS! OVER @ AND 2 PICK OR SWAP ! DROP ;
: RESET-TIMER CLO @ DELTAT + C0 ! ;
: ?TIMERMATCH CS @ 1 AND 1 = ;
: CLEAR-MATCH 1 CS ;
: MATCH-ACTIONS RESET-TIMER CLEAR-MATCH .S ;
: TIMER RESET-TIMER BEGIN ?TIMERMATCH IF MATCH-ACTIONS THEN AGAIN ;