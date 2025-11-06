const std = @import("std");

pub fn main() void {
    var A: [10]f32 = undefined;

    std.debug.print("Real memory addresses:\n", .{});
    std.debug.print("Base address (A):     {*}\n", .{&A});
    std.debug.print("Address of A[0]:      {*}\n", .{&A[0]});
    std.debug.print("Address of A[1]:      {*}\n", .{&A[1]});
    std.debug.print("Address of A[2]:      {*}\n", .{&A[2]});
    std.debug.print("Address of A[5]:      {*}\n", .{&A[5]});

    // Demonstrate the calculation
    std.debug.print("\nVerification:\n", .{});
    const i: usize = 3;

    // Method 1: Using pointer arithmetic directly (simplest)
    const array_ptr: [*]f32 = &A;
    const calculated_ptr = array_ptr + i;

    std.debug.print("Calculated A[{}] address: {*}\n", .{ i, calculated_ptr });
    std.debug.print("Actual A[{}] address:    {*}\n", .{ i, &A[i] });

    // Method 2: Correct @ptrFromInt usage (single argument)
    const base_addr = @intFromPtr(&A[0]);
    const calculated_addr = base_addr + i * @sizeOf(f32);
    const calculated_ptr2: [*]f32 = @ptrFromInt(calculated_addr);

    std.debug.print("Method 2 A[{}] address:  {*}\n", .{ i, calculated_ptr2 });

    // Show memory layout and size information
    std.debug.print("\nMemory layout analysis:\n", .{});
    std.debug.print("sizeof(f32) = {} bytes\n", .{@sizeOf(f32)});

    const addr0 = @intFromPtr(&A[0]);
    const addr1 = @intFromPtr(&A[1]);

    std.debug.print("A[1] - A[0] = {} bytes\n", .{addr1 - addr0});
    std.debug.print("Expected stride = {} bytes\n", .{@sizeOf(f32)});
}
