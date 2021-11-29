#ifndef STACK_H
#define STACK_H

typedef unsigned char byte_elem_t;

// stack structure
typedef struct Stack
{
  int top;
  byte_elem_t *storage;
  int elemSize;
  int maxElements;
} stack_str_t;

void create_stack(stack_str_t *, int);
int stack_is_empty(stack_str_t *stack);
int stack_is_full(stack_str_t *stack);
void push_to_stack(stack_str_t *, void *);
void *pop_from_stack(stack_str_t *);
void *top_from_stack(stack_str_t *);
void free_stack(stack_str_t *);

#endif