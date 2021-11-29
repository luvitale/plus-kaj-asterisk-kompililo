#include <stdio.h>
#include <stdlib.h>
#include "stack.h"
#define INITIAL_CAPACITY 10

void create_stack(stack_str_t *s, int elemSize)
{
  byte_elem_t *storage;

  /* Try to allocate memory */
  storage = (byte_elem_t *)malloc(elemSize * INITIAL_CAPACITY);
  if (storage == NULL)
  {
    fprintf(stderr, "Insufficient memory to initialize stack.\n");
    exit(1);
  }

  /* Initialize an empty stack */
  s->top = 0;
  s->maxElements = INITIAL_CAPACITY;
  s->elemSize = elemSize;
  s->storage = storage;
}

int stack_is_full(stack_str_t *s)
{
  return s->top == s->maxElements;
}

int stack_is_empty(stack_str_t *s)
{
  return s->top == 0;
}

int stack_size(stack_str_t *s)
{
  return s->top;
}

void push_to_stack(stack_str_t *s, void *elem)
{
  if (stack_is_full(s))
  {
    s->maxElements *= 2;
    s->storage = (byte_elem_t *)realloc(s->storage, s->elemSize * s->maxElements);
    if (s->storage == NULL)
    {
      fprintf(stderr, "Insufficient memory to push element to stack.\n");
      exit(1);
    }
  }
  int start = s->top * s->elemSize, i;
  for (i = 0; i < s->elemSize; i++)
  {
    *(s->storage + start + i) = *((byte_elem_t *)(elem + i));
  }
  s->top = s->top + 1;
}

void *pop_from_stack(stack_str_t *s)
{
  if (stack_is_empty(s))
  {
    fprintf(stderr, "Can not pop from an empty stack.\n");
    exit(1);
  }
  void *elem = top_from_stack(s);
  s->top = s->top - 1;
  return elem;
}

void *top_from_stack(stack_str_t *s)
{
  if (stack_is_empty(s))
  {
    fprintf(stderr, "Can not pop from an empty stack.\n");
    exit(1);
  }
  int start = (s->top - 1) * s->elemSize, i;
  byte_elem_t *elem;
  elem = (byte_elem_t *)malloc(s->elemSize);
  for (i = 0; i < s->elemSize; i++)
  {
    *(elem + i) = *(s->storage + start + i);
  }
  return (void *)elem;
}

void free_stack(stack_str_t *s)
{
  free(s->storage);
  s->top = 0;
}