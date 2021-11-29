#include "tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define EXTENSION "tree.mkg"

// create leaf
tree_node_t *create_leaf(char *value)
{
  tree_node_t *leaf = (tree_node_t *)malloc(sizeof(tree_node_t));
  if (!leaf)
  {
    printf("No memory to create leaf.\n");
    return NULL;
  }

  leaf->left = NULL;
  leaf->right = NULL;
  strcpy(leaf->info, value);
  return leaf;
}

// create node
tree_node_t *create_node(char *value, tree_node_t *left_child, tree_node_t *right_child)
{
  tree_node_t *parent = (tree_node_t *)malloc(sizeof(tree_node_t));

  if (!parent)
  {
    printf("No memory to create node.\n");
    return NULL;
  }

  parent->left = left_child;
  parent->right = right_child;
  strcpy(parent->info, value);

  return parent;
}

// save inorder
void save_inorder(tree_node_t *root, FILE *fp)
{
  if (root)
  {
    save_inorder(root->left, fp);
    fprintf(fp, "%s ", root->info);
    save_inorder(root->right, fp);
  }
}

// save inorder in file
void save_inorder_in_file(tree_node_t *root, char *filename)
{
  FILE *fp;
  char file[100];
  sprintf(file, "%s.%s", filename, EXTENSION);
  fp = fopen(file, "w+");
  if (!fp)
  {
    printf("Cannot open file.\n");
    return;
  }

  save_inorder(root, fp);
  fclose(fp);
}

// save postorder
void save_postorder(tree_node_t *root, FILE *fp)
{
  if (root)
  {
    save_postorder(root->left, fp);
    save_postorder(root->right, fp);
    fprintf(fp, "%s ", root->info);
  }
}

// save postorder in file
void save_postorder_in_file(tree_node_t *root, char *filename)
{
  FILE *fp;
  char file[100];
  sprintf(file, "%s.%s", filename, EXTENSION);
  fp = fopen(file, "w+");
  if (!fp)
  {
    printf("Cannot open file.\n");
    return;
  }

  save_postorder(root, fp);
  fclose(fp);
}

// show postorder
void postorder(tree_node_t *root)
{
  if (root)
  {
    postorder(root->left);
    postorder(root->right);
    printf("%s ", root->info);
  }
}
