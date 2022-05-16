# ==================================================
# Memory bank #0: initilazing instructions
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

code:
	setsp 0xF0
    ldi r2, 4                   # pit value
    ldi r3, 0                   # mancala value

    ldi r0, USER_PIT            # start at
    ldi r1, USER_MANCALA        # stop at

    while
        cmp r1, r0              # is the next register not the player mancala 
    stays gt
        st r0, r2               # put 4 stones to a player's pit
        inc r0                  # go to the next pit
    wend

    st r0, r3                   # ensure that player's mancala is empty

    ldi r0, COMPUTER_PIT        # start at
    ldi r1, COMPUTER_MANCALA    # stop at

    while
        cmp r1, r0              # is the next register not the computer mancala 
    stays gt
        st r0, r2               # put 4 stones to a computer's pit
        inc r0                  # go to the next pit
    wend

    st r0, r3                   # ensure that computer's mancala is empty
	
    ldi r1, USER_BANK           # choose player's bank
    br switch_header            # go to the next bank

# ==================================================
# MAIN CODE BLOCK



end.
