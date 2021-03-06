#ifndef STACK_H
#define STACK_H

#include <stdio.h>

typedef unsigned char byte;

// string stack structure
typedef struct StackNode {
    struct StackNode *next;
    byte *value;
} stack_node_t;

typedef struct StackStructure {
    stack_node_t *node;
    size_t elem_size;
} stack_structure_t;

// stack methods
void create_stack(stack_structure_t *, int);
int stack_is_empty(stack_structure_t *);
void push_to_stack(stack_structure_t *, void *);
void pop_from_stack(stack_structure_t *stack, void *);
void top_from_stack(stack_structure_t *stack, void *);
void destroy_stack(stack_structure_t *stack);

#endif