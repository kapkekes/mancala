# ==================================================
# Memory bank #2: "AI" player
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

thinking:
    ldi r0, MOVE_REGISTER
    ldi r1, 0xFF
    st r0, r1                           # unlock MR (aka Move Register)
    

    ldi r0, COMPUTER_PIT
    ldi r2, 13
    ldi r3, COMPUTER_MANCALA

    while
        cmp r0, r3
    stays lt
        ld r0, r1
        while
            cmp r1, r2
        stays ge
            sub r1, r2
            move r2, r1
            ldi r2, 13
        wend
        add r0, r1
        if
            cmp r1, r3
        is eq
            br calculating
        fi
        inc r0
    wend


    ldi r0, COMPUTER_PIT
    while
        ldi r3, COMPUTER_MANCALA
        cmp r0, r3
    stays lt
        ld r0, r1
        if
            cmp r1, r2
        is eq, or
            add r0, r1
            ld r1, r3
            tst r3
        is z, and
            ld r0, r1
            tst r1
        is gt
        then
            br calculating
        fi
        inc r0
    wend

    ldi r0, COMPUTER_MANCALA
    dec r0
    ldi r1, COMPUTER_PIT

    while
        cmp r0, r1
    stays ge
        if
            ld r0, r2
            tst r2
        is gt
            br calculating
        fi
        dec r0
    wend

calculating:
    ldi r3, LAST_MOVE                   # load the RAM address
    st r3, r0                           # store chosen address
    move r0, r1

    ldi r0, MOVE_REGISTER
    ldi r2, 0xF0                        # a non-(0xFF) value to lock MR
    st r0, r2                           # locking of MR itself
    
    ld r1, r0                           # r0 stores seeds from chosen pit

    ldi r2, 0                           # empty chosen pit
    st r1, r2                           #

    while
        tst r0                          # are seeds run out
    stays gt                            # stop, if so

        if                              #
            ldi r2, COMPUTER_MANCALA    #
            cmp r1, r2                  # if needed, jump from COMPUTER_MANCALA (0xFF)
        is eq                           #                   to BANK_REGISTER    (0xF0)
            ldi r1, 0xF0                # 
        fi                              #

        inc r1                          # go to the next pit

        if                              #
            ldi r2, HUMAN_MANCALA       #
            cmp r1, r2                  # if needed, jump from HUMAN_MANCALA (0xF7)
        is eq                           #                   to COMPUTER_PIT  (0xF9)
            ldi r1, 0xF9                #
        fi                              #

        ld r1, r3                       # get seeds quantity from actual pit
        inc r3                          # add one seed
        st r1, r3                       # save result

        dec r0                          # subtract dropped seed
    
    wend
    
    ldi r3, MOVE_ENDED                  # save the last
    st r3, r1                           # pit address

    ldi r3, LAST_PLAYER
    ldi r2, 3
    st r3, r2
    
    ldi r1, REFEREE_BANK                # choose referee's bank
    br jumper                           # go to the next bank

# ==================================================
# MAIN CODE BLOCK



end.
