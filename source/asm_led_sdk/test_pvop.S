test_pvop:
        movs r0, #15                 @ Value to display
        ldr  r1, =a                  @ Set the array address
        movs r2, #4                  @ Set the array size
        bl   put_value_on_pins         @ Call the put_value_on_pins routine

        ldr  r0, =FIB_DELAY_MS       @ Set the delay period
        bl   sleep_ms                 @ Delay

        b test_pvop                 @ Loop