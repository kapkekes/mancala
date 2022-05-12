# Memory bank, number 0
# Initilazing instructions

# MAIN CODE BLOCK
asect 0x00
    ldi r2, 4       # pit value
    ldi r3, 0       # mancala value

    ldi r0, 0xF1    # start at
    ldi r1, 0xF7    # stop at

    while
        cmp r1, r0  # is the next register not the player mancala 
    stays gt
        st r0, r2   # put 4 stones to a player's pit
        inc r0      # go to the next pit
    wend

    st r0, r3       # ensure that player's mancala is empty

    ldi r0, 0xF9    # start at
    ldi r1, 0xFF    # stop at

    while
        cmp r1, r0  # is the next register not the computer mancala 
    stays gt
        st r0, r2   # put 4 stones to a computer's pit
        inc r0      # go to the next pit
    wend

    st r0, r3       # ensure that computer's mancala is empty

    ldi r0, 0xEF    # store to active bank register
    ldi r1, 2       # choose player's bank
	st r0, r1       # activate player
# MAIN CODE BLOCK

# RESOURCE BLOCK

# RESOURCE BLOCK
