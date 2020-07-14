const std = @import("std");
const exmem = @import("memEx.zig");

test "Iterate" {
    var i : usize = 0;
    while (i <= 100): (i += 1) {
        std.debug.print("{}\n", .{i});
    }
}

test "Process Test" {
    var proc: exmem.Process = undefined;

    proc.open("notepad.exe") catch |err| {
        std.debug.print("\n{}\n", .{err});
        std.process.exit(1);
    };
    defer proc.close();

    std.debug.print(
        "\n{} (Handle {}, Pid {}) (BaseAddr {X}) (Size {})\n", 
        .{proc.name, @ptrToInt(proc.handle), proc.pid, proc.baseaddr, proc.basesize}
    );

    std.debug.print("Ole32.dll = 0x{X}\n", .{proc.moduleAddress("ole32.dll")});

    var org = try proc.read(0xD49159E354, [20]u8);
    for (org) |v| std.debug.print("{}, ", .{v});

    std.debug.print("\n", .{});

    var moo = try proc.write(0xD49159E354, [_]u8{23, 0, 68, 0, 86, 0, 71, 0, 86});
    var mod = try proc.read(0xD49159E354, [20]u8);
    for (mod) |v| std.debug.print("{}, ", .{v});

    std.debug.print("\n", .{});
}