const c = @cImport({
    @cInclude("main.h");
});
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    const allocator = std.heap.page_allocator;
    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    var argv = try allocator.alloc([*:0]u8, args.len);
    defer allocator.free(argv);
    for (args) |arg, i| {
        argv[i] = arg.ptr;
    }

    const rc = c.old_main(@intCast(c_int, argv.len), @ptrCast([*c][*c]u8, argv));
    if (rc != 0) {
        std.debug.print("Execution failed\n", .{});
    }
}
