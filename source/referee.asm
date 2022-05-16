# ==================================================
# Memory bank #1: referee (capture and repeat)
# ==================================================



# DEVICE BLOCK
# ==================================================
define ROM_CONTROLLER, 0xF0
define UI_REGISTER, 0xF8

define USER_PIT, 0xF1
define USER_MANCALA, 0xF7
define COMPUTER_PIT, 0xF9
define COMPUTER_MANCALA, 0xFF

define INITIALIZATION_BANK, 0
define REFEREE_BANK, 1
define USER_BANK, 2
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

switch_header:
    ldi r0, ROM_CONTROLLER
    ldi r2, 0
    ldi r3, 0
    st r0, r1

capture:
    if
        ldi r0, MOVE_ENDED                  #
        ld r0, r2                           #
        ldi r1, USER_MANCALA                #
        cmp r2, r1                          #
    is ne, and                              #
        ldi r1, COMPUTER_MANCALA            # 
        cmp r2, r1                          # 
    is ne, and                              # 
        ldi r1, 1                           # 
        ld r2, r0                           # 
        cmp r1, r0                          # is the last register a pit,
    is eq                                   # does it contain only one seed
    then                                    # and is it on the same side?
        if                                  #
            ldi r0, LAST_MOVE               #
            ldi r1, MOVE_ENDED              #
            ld r0, r2                       #
            ld r1, r3                       #
            xor r2, r3                      #
            shra r3                         #
            shra r3                         #
            shra r3                         #
        is z
            ld r1, r0                       # get address of the move end
            move r0, r3

            ldi r2, 0xFF                    #
            sub r2, r3                      # get address of the
            ldi r2, 0xF0                    # opposite pit
            add r2, r3                      #

            ld r3, r2
            if
                tst r2
            is z
                br skip
            fi

            ldi r2, MOVE_ENDED
            ld r0, r2

            ldi r1, 0                       # set zero
            st r0, r1                       # value for it
            
            move r3, r0

            ld r0, r1                       # number of seeds, which
            inc r1                          # should Sbe added to a mancala

            ldi r2, 0                       # nullify the
            st r0, r2                       # opposite pit

            ldi r3, LAST_PLAYER             # 
            ld r3, r0                       # get the last player
            ldi r2, 2                       #          

            if                              #
                cmp r0, r2                  #
            is eq                           #
                ldi r2, USER_MANCALA        # get address of his mancala
            else                            #
                ldi r2, COMPUTER_MANCALA    #
            fi                              #

            ld r2, r0                       #
            add r1, r0                      # add seeds
            st r2, r0                       #
        fi
    fi

skip:
    ldi r2, 0

    ldi r0, COMPUTER_PIT
    ldi r1, COMPUTER_MANCALA
    jsr check_pits

    ldi r0, USER_PIT
    ldi r1, USER_MANCALA
    jsr check_pits

    if                              #
        tst r2                      #
    is z                            # all pits are empty
        halt                        #
    fi                              #

    ldi r2, 0
    ldi r0, USER_PIT
    jsr check_pits

    if                              #
        tst r2                      #
    is z                            # USER player doesn't have an
        ldi r1, COMPUTER_BANK       # opportunity to make a move
        br switch_header            #
    fi                              #

    if                              #
        ldi r2, MOVE_ENDED          #
        ld r2, r1                   #
        cmp r0, r1                  # REPEAT RULE:
    is eq                           # USER!!!
        ldi r1, USER_BANK           #
        br switch_header            #
    fi                              #

    if                              #
        ldi r0, COMPUTER_PIT        #
        ldi r1, COMPUTER_MANCALA    #
        ldi r2, 0                   #
        jsr check_pits              # computer doesn't have an 
        tst r2                      # opportunity to make a move
    is z                            #
        ldi r1, USER_BANK           #
        br switch_header            #
    fi                              #

    if                              #
        ldi r2, MOVE_ENDED          #
        ld r2, r1                   #
        cmp r0, r1                  # REPEAT RULE:
    is eq                           # COMPUTER!!!
        ldi r1, COMPUTER_BANK       #
        br switch_header            #
    fi                              #

    ldi r1, 5                       #
    ldi r3, LAST_PLAYER             #
    ld r3, r0                       # player
    sub r1, r0                      # change
    move r0, r1                     #
    br switch_header                #

check_pits:
    while
        cmp r0, r1
    stays ne
        ld r0, r3
        add r3, r2
        inc r0
    wend
    rts

# ==================================================
# MAIN CODE BLOCK



end.
