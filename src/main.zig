const c = @cImport({
    @cInclude("main.h");
});
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    const alloc = std.heap.page_allocator;
    var args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    // TODO: Fix argument passing. It segfaults. Probably need to 0-terminate the strings.
    const rc = c.old_main(@intCast(i32, args.len), @ptrCast([*c][*c]u8, args));
    if (rc != 0) {
        std.debug.print("Execution failed\n", .{});
    }
}
