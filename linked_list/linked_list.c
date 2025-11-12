#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct Node
{
    int data;
    struct Node *next, *prev;
} Node;

Node *createNode(int data)
{
    Node *n = malloc(sizeof(Node));
    n->data = data;
    n->next = n->prev = NULL;
    return n;
}

Node *createList(int n, int doubly, int circular)
{
    Node *head = NULL, *tail = NULL;
    for (int i = 0; i < n; i++)
    {
        Node *node = createNode(i);
        if (!head)
            head = tail = node;
        else
        {
            tail->next = node;
            if (doubly)
                node->prev = tail;
            tail = node;
        }
    }
    if (circular && head && tail)
    {
        tail->next = head;
        if (doubly)
            head->prev = tail;
    }
    return head;
}

int search(Node *head, int target, int circular, int n)
{
    Node *curr = head;
    int count = 0;
    do
    {
        if (curr->data == target)
            return 1;
        curr = curr->next;
        count++;
    } while (curr && (!circular || count < n));
    return 0;
}

double benchmark(Node *head, int target, int circular, int n)
{
    clock_t start = clock();
    search(head, target, circular, n);
    clock_t end = clock();
    return (double)(end - start) / CLOCKS_PER_SEC;
}

int main()
{
    int N = 1000000;
    Node *lists[4];
    lists[0] = createList(N, 0, 0);
    lists[1] = createList(N, 1, 0);
    lists[2] = createList(N, 0, 1);
    lists[3] = createList(N, 1, 1);
    const char *names[] = {
        "Singly", "Doubly", "Circular Singly", "Circular Doubly"};

    for (int i = 0; i < 4; i++)
    {
        printf("\n%s Linked List:\n", names[i]);
        printf("First: %f sec\n", benchmark(lists[i], 0, i >= 2, N));
        printf("Middle: %f sec\n", benchmark(lists[i], N / 2, i >= 2, N));
        printf("Last: %f sec\n", benchmark(lists[i], N - 1, i >= 2, N));
    }
}
