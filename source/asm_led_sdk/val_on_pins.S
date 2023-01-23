put_value_on_pins:
        push  {r4, r5, r6, r7}      @ Save the registers we are going to use
        movs  r3, r0                @ Save the value to display
        movs  r1, #1                @ Bit mask initial value
        movs  r4, #0                @ index
set_pin:
        movs  r5, #4                @ compute the offset
        muls  r5, r4                @ the offset
        ands  r1, r3                @ Mask a bit, value stays in r3
        ldr   r0, [r6, r5]          @ fetch pin value from array at r6 offset by r5
        bl    gpio_set_state        @ set the pin
        adds  r4, #1                @ increment index
        cmp   r4, r2                @ 0 bits remaining?
        bne   set_pin               @ if not, jump to set the next pin
        pop   {r4, r5, r6, r7}      @ restore saved registers
        bx    lr                    @ return to caller