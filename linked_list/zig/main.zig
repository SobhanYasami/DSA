const std = @import("std");

const Node = struct {
    data: usize,
    next: ?*Node,
};

fn createList(allocator: std.mem.Allocator, n: usize) !?*Node {
    var head: ?*Node = null;
    var tail: ?*Node = null;
    for (0..n) |i| {
        const node = try allocator.create(Node);
        node.* = Node{ .data = i, .next = null };
        if (head == null) {
            head = node;
        } else {
            tail.?.next = node;
        }
        tail = node;
    }
    return head;
}

fn search(head: ?*Node, target: usize) bool {
    var curr = head;
    while (curr) |node| {
        if (node.data == target) return true;
        curr = node.next;
    }
    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const n = 1_000_000;
    const head = try createList(alloc, n);

    var timer = try std.time.Timer.start();
    _ = search(head, 0);
    const first = timer.read() / 1_000_000_000.0;

    timer = try std.time.Timer.start();
    _ = search(head, n / 2);
    const mid = timer.read() / 1_000_000_000.0;

    timer = try std.time.Timer.start();
    _ = search(head, n - 1);
    const last = timer.read() / 1_000_000_000.0;

    std.debug.print("Zig Singly Linked List:\n", .{});
    std.debug.print("First: {d:.6} sec\n", .{first});
    std.debug.print("Middle: {d:.6} sec\n", .{mid});
    std.debug.print("Last: {d:.6} sec\n", .{last});
}
