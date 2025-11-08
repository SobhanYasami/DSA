fn binary_search(arr: &[i32], target: i32) -> Option<usize> {
    let mut low = 0;
    let mut high = arr.len();

    while low < high {
        let mid = low + (high - low) / 2;

        if arr[mid] == target {
            return Some(mid);
        } else if arr[mid] < target {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    None
}

fn main() {
    let arr = [2, 4, 6, 8, 10, 12, 14];
    let target = 10;

    match binary_search(&arr, target) {
        Some(i) => println!("Found {} at index {}", target, i),
        None => println!("Not found"),
    }
}
