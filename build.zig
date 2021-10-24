const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("zutty", null);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();
    exe.linkLibCpp();
    exe.linkSystemLibrary("freetype2");
    exe.linkSystemLibrary("xmu");
    exe.linkSystemLibrary("egl");
    exe.linkSystemLibrary("glesv2");

    if (exe.target.isLinux()) {
        exe.defineCMacro("LINUX", null);
    } else if (exe.target.isDarwin()) {
        exe.defineCMacro("MACOS", null);
    } // TODO: bsd, solaris

    const cxxflags_common = .{
        "-std=c++14",
        "-fno-omit-frame-pointer",
        "-fsigned-char",
        "-Wall",
        "-Wextra",
        "-Wsign-compare",
        "-Wno-unused-parameter",
    };
    const cxxflags_release = cxxflags_common ++ .{
        "-Werror",
        "-O3",
        "-march=native",
        "-mtune=native",
        "-flto",
    };
    const cxxflags_debug = cxxflags_common ++ .{
        "-Og",
        "-g",
        "-ggdb",
    };

    exe.addCSourceFiles(&.{
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
    }, if (b.is_release) &cxxflags_release else &cxxflags_debug);

    if (!b.is_release) {
        exe.defineCMacro("DEBUG", null);
    }

    // Construct version string
    // Inspired by https://github.com/ziglang/zig/blob/master/build.zig
    const git_describe = try b.exec(&.{ "git", "describe", "--tags", "--dirty" });
    // TODO: Can we get rid of "if ... else"? The only difference is in the formatstring which must
    // be known at comptime.
    var version: []u8 = undefined;
    if (b.is_release) {
        version = try std.fmt.allocPrint(
            std.heap.page_allocator,
            "\"{s}\"",
            .{std.mem.trim(u8, git_describe, " \n\r")},
        );
    } else {
        version = try std.fmt.allocPrint(
            std.heap.page_allocator,
            "\"{s}-debug\"",
            .{std.mem.trim(u8, git_describe, " \n\r")},
        );
    }
    exe.defineCMacro("ZUTTY_VERSION", version);
    // TODO: update version.txt?

}
