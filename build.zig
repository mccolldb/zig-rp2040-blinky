const std = @import("std");
const microzig = @import("microzig");
const MicroBuild = microzig.MicroBuild(.{ .rp2xxx = true });

pub fn build(b: *std.Build) void {
    const mz_dep = b.dependency("microzig", .{ .rp2xxx = true });
    const mb = MicroBuild.init(b, mz_dep) orelse return;

    const firmware = mb.add_firmware(.{
        .name = "blinky",
        .root_source_file = b.path("src/main.zig"),
        .target = mb.ports.rp2xxx.boards.raspberrypi.pico,
        .optimize = .ReleaseSmall,
    });

    mb.install_firmware(firmware, .{});
    mb.install_firmware(firmware, .{ .format = .elf });
}
