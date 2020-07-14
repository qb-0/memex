const std = @import("std");
const exmem = @import("../src/memEx.zig");

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

    var foo = try proc.read(0xD49159E354, [20]u8);
    proc.write(0xD49159E354, [20]u8);
    for (foo) |v| std.debug.print("{} ", .{v});

    std.debug.print("\n", .{});
}