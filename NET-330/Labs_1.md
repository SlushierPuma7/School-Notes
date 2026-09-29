# Lab 1.0 Notes
Website Used: https://www.greenteksolutionsllc.com/blog/reset-your-cisco-3750-series-switch-in-11-easy-steps-greentek-solutions 

## Steps used to reset the device
1. Connect switch to workstation and open it in PuTTY
2. Disconnect the power cord from the switch and begin to hold the mode button
3. Continue to hold the mode button as the power cord is plugged back in, and continue to hold either till the SYSTEM LED turns solid green from flashing green or switch: appears in the console
4. In the console, type flash_init
    1. Followed by dir flash
    2. Command: rename: flash:config.text flash:config.old
    3. Command: boot
    4. Answer no when the initial configuration prompt appears
5. Once NVRAM message pops up, hit enter to get to ‘switch>’. Type ‘enable’ to get to privileged EXEC mode
6. Configure file to original name: rename flash:config.old flash:config.text
7. Run copy flash:config.text system:running-config
8. Run ‘configure terminal’ to enter config if not already there. Run ‘enable secret’ and ‘enable password’ to set passwords. Secret password is used whenever you want to run enable. Password is for the switch itself. 
    1. SECRET: bad
    2. PASSWORD: badpassword
9. Exit config mode and run ‘write memory’
10. YOU HAVE SUCCESSFULLY RESET YOUR PASSWORD

Issues experienced:
* When doing the assignment, came across an issue where we couldn't leave the password for SECRET blank, so we set it to 'bad'
  * Solution: Disable SECRET password by typing 'no enable secret'

Recommendation:
* Understand what you are doing before doing, instead of going with the flow and setting the SECRET password to be something different, should have searched how to leave it blank or remove it.
