#ifndef TREE_H_INCLUDED
#define TREE_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct TreeNode
{
  struct TreeNode *left;
  struct TreeNode *right;
  char info[50];
} tree_node_t;

typedef tree_node_t *tree_t;

tree_node_t *create_leaf(char *);
tree_node_t *create_node(char *, tree_node_t *, tree_node_t *);
void save_inorder_in_file(tree_node_t *, char *);
void save_postorder_in_file(tree_node_t *, char *);
void postorder(tree_node_t *);

#endif // TREE_H_INCLUDED