const std = @import("std");
const microzig = @import("microzig");
const rp2xxx = microzig.hal;
const time = rp2xxx.time;

// Compile-time pin configuration
const pin_config = rp2xxx.pins.GlobalConfiguration{
    .GPIO25 = .{ .name = "led", .direction = .out },
};
const pins = pin_config.pins();

const uart = rp2xxx.uart.instance.num(0);
const baud_rate = 115200;
const uart_tx_pin = rp2xxx.gpio.num(0);
const uart_rx_pin = rp2xxx.gpio.num(1);
//const led = rp2xxx.gpio.num(25);

pub const microzig_options = .{
    .log_level = .debug,
    .logFn = rp2xxx.uart.logFn,
};

pub fn main() !void {
    inline for (&.{ uart_tx_pin, uart_rx_pin }) |pin| {
        pin.set_function(.uart);
    }
    uart.apply(.{ .baud_rate = baud_rate, .clock_config = rp2xxx.clock_config });
    rp2xxx.uart.init_logger(uart);
    std.log.info("Hello Logger", .{});
    // led.set_function(.sio);
    // led.set_direction(.out);
    pin_config.apply();

    var count: u32 = 0;
    while (true) {
        pins.led.toggle();
        std.log.info("toggle led {}", .{count});
        count += 1;
        time.sleep_ms(2000);
    }
}
