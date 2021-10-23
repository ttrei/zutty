const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    // TODO: debug mode

    const zutty = b.addExecutable("zutty", null);
    zutty.setTarget(target);
    zutty.setBuildMode(mode);
    zutty.install();
    zutty.linkLibCpp();
    zutty.linkSystemLibrary("freetype2");
    zutty.linkSystemLibrary("xmu");
    zutty.linkSystemLibrary("egl");
    zutty.linkSystemLibrary("glesv2");
    if (zutty.target.isLinux()) {
        zutty.defineCMacro("LINUX", null);
    } else if (zutty.target.isDarwin()) {
        zutty.defineCMacro("MACOS", null);
    }
    // TODO: bsd, solaris
    zutty.addCSourceFiles(&.{
        "src/charvdev.cc",
        "src/font.cc",
        "src/fontpack.cc",
        "src/frame.cc",
        "src/gl.cc",
        "src/log.cc",
        "src/main.cc",
        "src/options.cc",
        "src/pty.cc",
        "src/renderer.cc",
        "src/selmgr.cc",
        "src/vterm.cc",
    }, &.{
        "-std=c++14",
        "-fno-omit-frame-pointer",
        "-fsigned-char",
        "-Wall",
        "-Wextra",
        "-Wsign-compare",
        "-Wno-unused-parameter",
    });

    // Inspired by https://github.com/ziglang/zig/blob/master/build.zig
    const git_describe = try b.exec(&[_][]const u8{
        "git",
        "-C",
        b.build_root,
        "describe",
        "--tags",
        "--dirty",
    });
    const version = try std.fmt.allocPrint(
        std.heap.page_allocator,
        "\"{s}\"",
        .{std.mem.trim(u8, git_describe, " \n\r")},
    );
    zutty.defineCMacro("ZUTTY_VERSION", version);
    // TODO: update version.txt?

}
