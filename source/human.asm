# ==================================================
# Memory bank #2: human player handler
# ==================================================



# DEVICE BLOCK
# ==================================================
define BANK_REGISTER, 0xF0
define MOVE_REGISTER, 0xF8

define HUMAN_PIT, 0xF1
define HUMAN_MANCALA, 0xF7
define COMPUTER_PIT, 0xF9
define COMPUTER_MANCALA, 0xFF

define INITIALIZATION_BANK, 0
define REFEREE_BANK, 1
define HUMAN_BANK, 2
define COMPUTER_BANK, 3
# ==================================================
# DEVICE BLOCK



# RAM BLOCK
# ==================================================
asect 0xE0
LAST_PLAYER: ds 1
LAST_MOVE:   ds 1
MOVE_ENDED:  ds 1
# ==================================================
# RAM BLOCK



# MAIN CODE BLOCK
# ==================================================
asect 0x00

jumper:
    ldi r0, BANK_REGISTER
    ldi r2, 0
    ldi r3, 0
    st r0, r1

code:
    ldi r0, MOVE_REGISTER
    ldi r1, 0xFF
    ldi r2, 0xFF
    st r0, r1                           # unlock MR (aka Move Register)

    do
        ld r0, r1                       # after completion of the cycle
        cmp r1, r2                      # r1 will store address of chosen pit
    until ne

    ldi r2, 0xF0                        # a non-(0xFF) value to lock MR
    st r0, r2                           # locking of MR itself

    ldi r3, LAST_MOVE                   # load the RAM address
    st r3, r1                           # store chosen address

    
    ld r1, r0                           # r0 stores seeds from chosen pit

    ldi r2, 0                           # empty chosen pit
    st r1, r2                           #

    while
        tst r0                          # are seeds run out
    stays gt                            # stop, if so

        inc r1                          # go to the next pit

        if                              #
            ldi r2, 0xF8                #
            cmp r1, r2                  # if needed, jump from MOVE_REGISTER (0xF8)
        is eq                           #                   to COMPUTER_PIT  (0xF9)
            inc r1                      # 
        fi                              #
        
        if                              #
            ldi r2, COMPUTER_MANCALA    #
            cmp r1, r2                  # if needed, jump from COMPUTER_MANCALA (0xFF)
        is eq                           #                   to HUMAN_PIT        (0xF1)
            ldi r1, 0xF1                #
        fi                              #

        ld r1, r3                       # get seeds quantity from actual pit
        inc r3                          # add one seed
        st r1, r3                       # save result

        dec r0                          # subtract dropped seed
    
    wend
    
    ldi r3, MOVE_ENDED                  # save the last
    st r3, r1                           # pit address

    ldi r3, LAST_PLAYER
    ldi r2, 2
    st r3, r2
    
    ldi r1, REFEREE_BANK                # choose referee's bank
    br jumper                           # go to the next bank

# ==================================================
# MAIN CODE BLOCK



end
