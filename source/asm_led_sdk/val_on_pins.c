#include "val_on_pins.h"

void put_value_on_pins(int value, int pins[], int num_pins) {
    int i;
    for (i = 0; i < num_pins; ++i) {
        gpio_set_state(pins[i], value & 1);
        value >>= 1;
    }
}