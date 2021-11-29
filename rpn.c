#include "rpn.h"
#include "stack.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define INITIAL_CAPACITY 100
#define EXTENSION "rpn.mkg"
#define ASM_EXTENSION "rpn.asm"

// create RPN
rpn_t *create_rpn()
{
  rpn_t *rpn = malloc(sizeof(rpn_t));
  rpn->size = 0;
  rpn->capacity = INITIAL_CAPACITY;
  rpn->value = malloc(sizeof(char *) * rpn->capacity);
  return rpn;
}

int rpn_is_full(rpn_t *rpn)
{
  return rpn->size == rpn->capacity;
}

// add a cell to RPN
void add_cell_to_rpn(rpn_t *rpn, char *value)
{
  if (rpn_is_full(rpn))
  {
    rpn->capacity *= 2;
    rpn->value = realloc(rpn->value, rpn->capacity * sizeof(char *));
  }
  rpn->value[rpn->size++] = value;
}

// set cell of RPN
void set_cell_of_rpn(rpn_t *rpn, char *value, int cell)
{
  rpn->value[cell - 1] = value;
}

// get cell from RPN
char *get_cell_from_rpn(rpn_t *rpn, int cell)
{
  return rpn->value[cell - 1];
}

// get size of RPN
int get_size_of_rpn(rpn_t *rpn)
{
  return rpn->size;
}

// get last cell from RPN
int get_last_cell_from_rpn(rpn_t *rpn)
{
  return rpn->size;
}

// free RPN
void free_rpn(rpn_t *rpn)
{
  for (int i = 0; i < rpn->size; i++)
  {
    free(rpn->value[i]);
  }
  free(rpn->value);
  free(rpn);
}

int get_actual_cell_from_rpn(rpn_t *rpn)
{
  return rpn->size;
}

// save RPN in file
void save_rpn_in_file(rpn_t *rpn, char *filename)
{
  FILE *fp;
  char file[100];
  sprintf(file, "%s.%s", filename, EXTENSION);
  fp = fopen(file, "w");
  for (int i = 0; i < rpn->size; i++)
  {
    fprintf(fp, "%s\n", rpn->value[i]);
  }
  fclose(fp);
}

// show RPN
void show_rpn(rpn_t *rpn)
{
  for (int i = 0; i < rpn->size; i++)
  {
    printf("%s ", rpn->value[i]);
  }
}

void rpn_assembly(rpn_t *rpn, char *filename)
{
  stack_str_t *l_stack;
  create_stack(l_stack, sizeof(char) * 100);

  char file[100];
  sprintf(file, "%s.tmp.%s", filename, ASM_EXTENSION);
  FILE *fp = fopen(file, "w+");

  char value[100];
  char op1[100];
  char op2[100];
  char result[100];

  int last_cell = get_last_cell_from_rpn(rpn);

  for (int i = 1; i <= last_cell; ++i)
  {
    strcpy(value, (char *)get_cell_from_rpn(rpn, i));

    if (strcmp(value, "<-") == 0)
    {
      strcpy(op1, (char *)pop_from_stack(l_stack));
      strcpy(op2, (char *)pop_from_stack(l_stack));

      fprintf(
          fp,
          "MOV %s %s\n",
          op1,
          op2);
    }
    else if (strcmp(value, "+") == 0)
    {
      strcpy(op2, (char *)pop_from_stack(l_stack));
      strcpy(op1, (char *)pop_from_stack(l_stack));

      fprintf(
          fp,
          "FLD %s\n",
          op1);

      fprintf(
          fp,
          "FLD %s\n",
          op2);

      fprintf(
          fp,
          "FADD\n");

      strcpy(result, "@result");

      fprintf(
          fp,
          "FSTP %s\n",
          result);

      fprintf(
          fp,
          "FFREE\n");

      push_to_stack(l_stack, result);
    }
    else if (strcmp(value, "*") == 0)
    {
      strcpy(op2, (char *)pop_from_stack(l_stack));
      strcpy(op1, (char *)pop_from_stack(l_stack));

      fprintf(
          fp,
          "FLD %s\n",
          op1);

      fprintf(
          fp,
          "FLD %s\n",
          op2);

      fprintf(
          fp,
          "FMUL\n");

      strcpy(result, "@result");

      fprintf(
          fp,
          "FSTP %s\n",
          result);

      fprintf(
          fp,
          "FFREE\n");

      push_to_stack(l_stack, result);
    }
    // id || cte
    else
    {
      push_to_stack(l_stack, value);
    }
  }
}