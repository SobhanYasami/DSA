use std::time::Instant;

#[derive(Debug)]
struct Node {
    data: usize,
    next: Option<Box<Node>>,
}

fn create_list(n: usize) -> Box<Node> {
    let mut head = Box::new(Node {
        data: 0,
        next: None,
    });
    let mut tail = &mut head;
    for i in 1..n {
        tail.next = Some(Box::new(Node {
            data: i,
            next: None,
        }));
        tail = tail.next.as_mut().unwrap();
    }
    head
}

fn search(mut head: &Box<Node>, target: usize) -> bool {
    loop {
        if head.data == target {
            return true;
        }
        match &head.next {
            Some(next) => head = next,
            None => return false,
        }
    }
}

fn benchmark(head: &Box<Node>, target: usize) -> f64 {
    let start = Instant::now();
    search(head, target);
    start.elapsed().as_secs_f64()
}

fn main() {
    let n = 1_000_000;
    let head = create_list(n);
    println!("Rust Singly Linked List:");
    println!("First: {} sec", benchmark(&head, 0));
    println!("Middle: {} sec", benchmark(&head, n / 2));
    println!("Last: {} sec", benchmark(&head, n - 1));
}
