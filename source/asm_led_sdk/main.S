/*
 * pico-asm for Raspberry Pi Pico
 *
 * @version     1.2.0
 * @author      smittytone
 * @copyright   2022
 * @licence     MIT
 *
 */

.data
.balign                 4

a:
.skip                  16

.text

/*
 * CONSTANTS
 */
.equ    LED_ONES,      12
.equ    LED_TWOS,      13
.equ    LED_FOURS,     14
.equ    LED_EIGHTS,    15
.equ    GPIO_DIR_IN,    0
.equ    GPIO_DIR_OUT,   1
.equ    PIN_HIGH,       1
.equ    PIN_LOW,        0


/*
 * ASSEMBLY HEADER
 *
 * NOTE These macros need to be on separate lines
 */
.syntax unified                     @ Use ARM unified syntax, ie.
                                    @ mandate S suffix for lo registers
.thumb_func                         @ This code uses Thumb instructions
.global main                        @ Set entry point

/*
 * RUNTIME START
 */
main:
init:   bl stdio_init_all           @ Jump to SDK STDIO initialisation routine
        movs r0, #0x80              @ Set the delay period
        lsls r0, #4
        bl sleep_ms                 @ Delay to allow the STDIO-over-USB to ready

        movs r0, #LED_ONES          @ Set the pin number for ONES LED
        bl gpio_init                @ Jump to SDK GPIO initialisation routine

        movs r0, #LED_ONES          @ Set the pin number for ONES LED
        movs r1, #GPIO_DIR_OUT      @ Set the pin direction for ONES LED
        bl gpio_set_direction       @ Jump to SDK pin direction routine

        movs r0, #LED_TWOS          @ Set the pin number for TWOS LED
        bl gpio_init                @ Jump to SDK GPIO initialisation routine

        movs r0, #LED_TWOS          @ Set the pin number for TWOS LED
        movs r1, #GPIO_DIR_OUT      @ Set the pin direction for TWOS LED
        bl gpio_set_direction       @ Jump to SDK pin direction routine

        movs r0, #LED_FOURS         @ Set the pin number for FOURS LED
        bl gpio_init                @ Jump to SDK GPIO initialisation routine

        movs r0, #LED_FOURS         @ Set the pin number for FOURS LED
        movs r1, #GPIO_DIR_OUT      @ Set the pin direction for FOURS LED
        bl gpio_set_direction       @ Jump to SDK pin direction routine

        movs r0, #LED_EIGHTS        @ Set the pin number for EIGHTS LED
        bl gpio_init                @ Jump to SDK GPIO initialisation routine

        movs r0, #LED_EIGHTS        @ Set the pin number for EIGHTS LED
        movs r1, #GPIO_DIR_OUT      @ Set the pin direction for EIGHTS LED
        bl gpio_set_direction       @ Jump to SDK pin direction routine

        b info                      @ Jump to the CPU info readout
fibsetup:
        ldr   r1, =a                @ Set the address of the array
        movs  r2, #0                @ Index
fill_array:
        movs  r0, #LED_ONES         @ value to fill in array
        str   r0, [r1]              @ store the value
        movs  r0, #LED_TWOS         @ value to fill in array
        str   r0, [r1, #4]          @ store the value
        movs  r0, #LED_FOURS        @ value to fill in array
        str   r0, [r1, #8]          @ store the value
        movs  r0, #LED_EIGHTS       @ value to fill in array
        str   r0, [r1, #12]         @ store the value

/*
 ******************************************************************************
 * This is the way I did it before I remembered offset addressing mode.

        lsls  r2, #2                @ Multiply the index by 4
        adds  r3, r1, r2
        movs  r4, #LED_ONES         @ Prepare the value for storage
        str   r4, [r3]              @ Store the value of the index in the array
        lsrs  r2, #2                @ Divide by 4
        adds  r2, #1                @ increment index

        lsls  r2, #2                @ Multiply the index by 4
        adds  r3, r1, r2
        movs  r4, #LED_TWOS         @ Prepare the value for storage
        str   r4, [r3]              @ Store the value of the index in the array
        lsrs  r2, #2                @ Divide by 4
        adds  r2, #1                @ increment index

        lsls  r2, #2                @ Multiply the index by 4
        adds  r3, r1, r2
        movs  r4, #LED_FOURS        @ Prepare the value for storage
        str   r4, [r3]              @ Store the value of the index in the array
        lsrs  r2, #2                @ Divide by 4
        adds  r2, #1                @ increment index

        lsls  r2, #2                @ Multiply the index by 4
        adds  r3, r1, r2
        movs  r4, #LED_EIGHTS       @ Prepare the value for storage
        str   r4, [r3]              @ Store the value of the index in the array

        pop   {r4}                  @ Restore the value of r4
*******************************************************************************
*/


fib_infinite_loop:
        push  {r4, r5}               @ Save r4 and r5
        movs  r4, #9                 @ Number of fibs to compute
        movs  r5, #0                 @ Index to count fibs
fib_outer_loop:
        cmp   r5, r4                 @ index equal to number of fibs?
        beq   xfib_loop              @ if so, jump to the end of the outer loop
        movs  r0, r5                 @ Prepare for fib call
        bl    fib                    @ Call fib
/***********************************************************************

 Abstract this to C for now
fib_inner_loop:
        movs  r0, #0                 @ Set the initial value of the first term
        movs  r1, #1                 @ Set the initial value of the second term
        movs  r3, r5                 @ Index to compute fib
        movs  r2, r0                 @ Save a in r2
        movs  r0, r1                 @ Set a to b
        adds  r1, r2                 @ Set b to a + b
        subs  r3, #1                 @ Decrement n
        bne   fib_inner_loop         @ If n is not zero, loop
************************************************************************
*/
        ldr   r1, =a                 @ pin array address
        movs  r2, #4                 @ array length
        bl    put_value_on_pins      @ Display the value of a on the LEDs
        ldr   r0, #FIB_DELAY_MS      @ Set the delay period
        bl    sleep_ms               @ Delay
        adds  r5, #1                 @ Increment the index
        b     fib_outer_loop         @ Jump to the outer loop
xfib_loop:
        pop   {r4, r5}               @ Restore r4 and r5
        b     fib_infinite_loop      @ Jump to the start of the final loop
loop:   movs  r0, #LED_ONES          @ Set the pin number
        movs  r1, #PIN_HIGH          @ Set the pin state
        bl    gpio_set_state           @ Jump to SDK pin state routine

        ldr   r0, DELAY_TIME_MS       @ Set the delay period
                                    @ NOTE This form assembles as PC offset addressing,
                                    @      so make sure DELAY_TIME_MS is an address in the
                                    @      code space rather not the .data space
        bl    sleep_ms                 @ Delay

        movs  r0, #LED_ONES          @ Set the pin number
        movs  r1, #PIN_LOW           @ Set the pin state
        bl    gpio_set_state           @ Jump to SDK pin state routine

        ldr   r0, DELAY_TIME_MS       @ Set the delay period
        bl    sleep_ms                 @ Delay

        movs  r0, #LED_TWOS          @ Set the pin number
        movs  r1, #PIN_HIGH          @ Set the pin state
        bl    gpio_set_state           @ Jump to SDK pin state routine

        ldr   r0, DELAY_TIME_MS       @ Set the delay period
                                    @ NOTE This form assembles as PC offset addressing,
                                    @      so make sure DELAY_TIME_MS is an address in the
                                    @      code space rather not the .data space
        bl sleep_ms                 @ Delay

        movs r0, #LED_TWOS          @ Set the pin number
        movs r1, #PIN_LOW           @ Set the pin state
        bl gpio_set_state           @ Jump to SDK pin state routine

        ldr r0, DELAY_TIME_MS       @ Set the delay period
        bl sleep_ms                 @ Delay

        movs r0, #LED_FOURS         @ Set the pin number
        movs r1, #PIN_HIGH          @ Set the pin state
        bl gpio_set_state           @ Jump to SDK pin state routine

        ldr r0, DELAY_TIME_MS       @ Set the delay period
                                    @ NOTE This form assembles as PC offset addressing,
                                    @      so make sure DELAY_TIME_MS is an address in the
                                    @      code space rather not the .data space
        bl sleep_ms                 @ Delay

        movs r0, #LED_FOURS         @ Set the pin number
        movs r1, #PIN_LOW           @ Set the pin state
        bl gpio_set_state           @ Jump to SDK pin state routine

        ldr r0, DELAY_TIME_MS       @ Set the delay period
        bl sleep_ms                 @ Delay

        movs r0, #LED_EIGHTS        @ Set the pin number
        movs r1, #PIN_HIGH          @ Set the pin state
        bl gpio_set_state           @ Jump to SDK pin state routine

        ldr r0, DELAY_TIME_MS       @ Set the delay period
                                    @ NOTE This form assembles as PC offset addressing,
                                    @      so make sure DELAY_TIME_MS is an address in the
                                    @      code space rather not the .data space
        bl sleep_ms                 @ Delay

        movs r0, #LED_EIGHTS        @ Set the pin number
        movs r1, #PIN_LOW           @ Set the pin state
        bl gpio_set_state           @ Jump to SDK pin state routine

        ldr r0, DELAY_TIME_MS       @ Set the delay period
        bl sleep_ms                 @ Delay

        b loop                      @ Loop infinitely

info:   ldr r5, CPUID               @ Get the address of CPUID
        ldr r5, [r5]                @ Get the contents of CPUID

        @ Write out the CPUID register
        ldr r0, =TEXT0              @ Set the printf format string
        movs r1, r5                 @ Set the printf value
        bl printf

        @ Write out the part number
        ldr r0, =TEXT1              @ Set the format string
        movs r1, r5                 @ Set the printf value to the CPUID value
        movs r3, #0xFF              @ Set the AND mask
        lsls r3, #8
        adds r3, #0xF0
        ands r1, r3                 @ Mask CPUID bits 15-4
        lsrs r3, #4
        bl printf

        @ Write out the revision
        ldr r0, =TEXT2              @ Set the format string
        movs r1, r5                 @ Set the printf value to the CPUID value
        movs r3, #0x0F              @ Set the AND mask
        lsls r3, #20
        ands r1, r3                 @ Mask CPUID bits 23-20
        lsrs r3, #20
        bl printf

        @ Write out the variant number
        ldr r0, =TEXT3              @ Set the format string
        movs r1, r5                 @ Set the printf value to the CPUID value
        movs r3, #0x0F              @ Set the AND mask
        ands r1, r3                 @ Mask CPUID bits 3-0
        bl printf

        @ FROM 1.0.1 -- unified syntax test
        movs r0, #0                 @ Clear r0
        mvns r0, r0                 @ NOT r0 0x00000000 -> 0xFFFFFFFF
        movs r1, #1                 @ r1 = 1
        rsbs r1, #0                 @ r1 = 0 - r1 = 0xFFFFFFFF
        cmp r0, r1                  @ r1 == r2?
        bne xinfo                   @ Jump out if r1 != r2

        ldr r0, =TEXT4              @ Output match message
        bl printf

xinfo:  b test_pvop                 @ Test put_value_on_pins

put_value_on_pins:
        push   {r4, r5, r6, r7, r8} @ Save the registers we are going to use
        movs  r2, r0                @ Save the value to display
        movs  r3, #1                @ Bit masks
        // movs  r4, 0x02
        // movs  r5, 0x04
        // movs  r6, 0x08
        ldr   r8, =a
        ands  r4, r2, r3            @ Mask bit 0
        lsls  r3, #1                @ Shift the mask
        ands  r5, r2, r3            @ Mask bit 1
        lsls  r3, #1                @ Shift the mask
        ands  r6, r2, r3            @ Mask bit 2
        lsls  r3, #1                @ Shift the mask
        ands  r7, r2, r3            @ Mask bit 3

        ldr   r0, r8                @ Set the LED pin number
        movs  r1, #PIN_HIGH         @ Set the pin state
        cmp   r4, #0                @ Test bit 0
        bne   set_pin_high          @ Jump to set the pin high if bit 0 is set
        bl    gpio_set_state        @ Set the pin low if bit 0 is clear
        b     set_pin_low           @ Jump to set the pin low


test_pvop:
        movs r0, #15                 @ Value to display
        ldr  r1, =a                  @ Set the array address
        movs r2, #4                  @ Set the array size
        bl   put_value_on_pins         @ Call the put_value_on_pins routine

        ldr  r0, =FIB_DELAY_MS       @ Set the delay period
        bl   sleep_ms                 @ Delay

        b test_pvop                 @ Loop

finish:
        //movs  r0, 0                 @ index
        //ldr   r3, =a                @ array address

/*
 Use four-bytes to store the delay time so that we can load
 into r0 a 32-bit value, rather than move in an 8-bit value
 */
.align 4
DELAY_TIME_MS:  .word           25
FIB_DELAY_MS:   .word           2000
CPUID:          .word           0xE000ED00          @ Memory map address of CPUID register
TEXT0:          .asciz          "CPUID: 0x%08X\n"
TEXT1:          .asciz          "Part:  0x%08X\n"
TEXT2:          .asciz          "Rev:   0x%08X\n"
TEXT3:          .asciz          "Var:   0x%08X\n"
TEXT4:          .asciz          "MATCH\n"
