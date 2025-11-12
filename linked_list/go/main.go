package main

import (
	"fmt"
	"time"
)

type Node struct {
	data int
	next *Node
	prev *Node
}

func createList(n int, doubly, circular bool) *Node {
	var head, tail *Node
	for i := 0; i < n; i++ {
		node := &Node{data: i}
		if head == nil {
			head, tail = node, node
		} else {
			tail.next = node
			if doubly {
				node.prev = tail
			}
			tail = node
		}
	}
	if circular && head != nil && tail != nil {
		tail.next = head
		if doubly {
			head.prev = tail
		}
	}
	return head
}

func search(head *Node, target int, circular bool, n int) bool {
	curr := head
	count := 0
	for curr != nil && (!circular || count < n) {
		if curr.data == target {
			return true
		}
		curr = curr.next
		count++
	}
	return false
}

func benchmark(head *Node, target int, circular bool, n int) float64 {
	start := time.Now()
	search(head, target, circular, n)
	return time.Since(start).Seconds()
}

func main() {
	N := 1_000_000
	lists := []*Node{
		createList(N, false, false),
		createList(N, true, false),
		createList(N, false, true),
		createList(N, true, true),
	}
	names := []string{
		"Singly", "Doubly", "Circular Singly", "Circular Doubly",
	}

	for i, head := range lists {
		fmt.Printf("\n%s Linked List:\n", names[i])
		fmt.Printf("First: %f sec\n", benchmark(head, 0, i >= 2, N))
		fmt.Printf("Middle: %f sec\n", benchmark(head, N/2, i >= 2, N))
		fmt.Printf("Last: %f sec\n", benchmark(head, N-1, i >= 2, N))
	}
}
