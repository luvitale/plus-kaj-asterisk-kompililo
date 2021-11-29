%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include "rpn.h"
#include "tac.h"

#define KOLOR_RUGA "\033[1;31m"
#define KOLOR_REKOMENCIGITA "\033[0m"

#define DOSIERNOM "prog"

int linionum;

int yystopparser = 0;

FILE *yyin;

char *regul[14] = {
  "R0. P -> KOD",
  "R1. KOD -> KOD L",
  "R2. KOD -> L",
  "R3. L -> A punktokom",
  "R4. A -> id op_asig E",
  "R5. A -> id op_asig A",
  "R6. E -> E op_sum T",
  "R7. E -> T",
  "R8. T -> T op_mul F",
  "R9. T -> F",
  "R10. F -> id",
  "R11. F -> nk",
  "R12. F -> sk",
  "R13. F -> malferma_krampo E ferma_krampo)",
};

char *yyltext;
char *yytext;

// Inversa pola notacio
rpn_t *ipn;

// Tri adreskodo
tac_t *a_indeks;
tac_t *a_id_indeks;
tac_t *e_indeks;
tac_t *t_indeks;
tac_t *f_indeks;

// Arbo
tree_t arbo;
tree_node_t *kod_montril;
tree_node_t *l_montril;
tree_node_t *a_montril;
tree_node_t *a_id_montril;
tree_node_t *e_montril;
tree_node_t *t_montril;
tree_node_t *f_montril;

int yylex();
int yyerror(char *);
%}

%union {
  double num_val;
  char *s_val;
}

%token punktokom

%token <s_val> id
%token <num_val> nk
%token <s_val> sk

%token op_asig
%token op_sum op_mul

%token malferma_krampo ferma_krampo

%%
P: KOD {
  // Arbo
  arbo = kod_montril;

  puts(regul[0]);
};

KOD: KOD L {
  // Arbo
  kod_montril = create_node(strdup(";"), kod_montril, l_montril);

  puts(regul[1]);
} | L {
  // Arbo
  kod_montril = l_montril;

  puts(regul[2]);
};

L: A punktokom {
  // Arbo
  l_montril = a_montril;

  puts(regul[3]);
};

A: id op_asig E {
  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup($1));
  add_cell_to_rpn(ipn, strdup("<-"));

  // Tri adreskodo
  a_id_indeks = create_tac(strdup($1), NULL, NULL);
  a_indeks = create_tac(strdup("<-"), a_id_indeks, e_indeks);

  // Arbo
  a_id_montril = create_leaf(strdup($1));
  a_montril = create_node(strdup("<-"), a_id_montril, e_montril);

  puts(regul[4]);
} | id op_asig A {
  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup($1));
  add_cell_to_rpn(ipn, strdup("<-"));

  // Tri adreskodo
  a_id_indeks = create_tac(strdup($1), NULL, NULL);
  a_indeks = create_tac(strdup("<-"), a_id_indeks, a_indeks);

  // Arbo
  a_id_montril = create_leaf(strdup($1));
  a_montril = create_node(strdup("<-"), a_id_montril, a_montril);

  puts(regul[5]);
};

E: E op_sum T {
  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup("+"));

  // Tri adreskodo
  e_indeks = create_tac(strdup("+"), e_indeks, t_indeks);

  // Arbo
  e_montril = create_node(strdup("+"), e_montril, t_montril);

  puts(regul[6]);
} | T {
  // Tri adreskodo
  e_indeks = t_indeks;

  // Arbo
  e_montril = t_montril;

  puts(regul[7]);
};

T: T op_mul F {
  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup("*"));

  // Tri adreskodo
  t_indeks = create_tac(strdup("*"), t_indeks, f_indeks);

  // Arbo
  t_montril = create_node(strdup("*"), t_montril, f_montril);

  puts(regul[8]);
} | F {
  // Tri adreskodo
  t_indeks = f_indeks;

  // Arbo
  t_montril = f_montril;

  puts(regul[9]);
};

F: id {
  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup($1));

  // Tri adreskodo
  f_indeks = create_tac(strdup($1), NULL, NULL);

  // Arbo
  f_montril = create_leaf(strdup($1));

  puts(regul[10]);
} | nk {
  char num[100];

  sprintf(num, "%lf", $1);

  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup(num));

  // Tri adreskodo
  f_indeks = create_tac(strdup(num), NULL, NULL);

  // Arbo
  f_montril = create_leaf(strdup(num));

  puts(regul[11]);
} | sk {
  // Inversa pola notacio
  add_cell_to_rpn(ipn, strdup($1));

  // Tri adreskodo
  f_indeks = create_tac(strdup($1), NULL, NULL);

  // Arbo
  f_montril = create_leaf(strdup($1));

  puts(regul[12]);
} | malferma_krampo E ferma_krampo {
  puts(regul[13]);
};
%%

int main(int argc, char *argv[]) {
  const char* dosiernom = argv[1];
  FILE* arg_dosiero = fopen(dosiernom, "rt");

  if (arg_dosiero == NULL) {
    printf("Dosiero ne povas esti malfermita: %s\n", dosiernom);
    printf("Uzante norman enigon\n\n");
  }
  else {
    yyin = arg_dosiero;
  }

  ipn = create_rpn(); // Inversa pola notacio
  initialize_tac(DOSIERNOM); // Tri adreskodo

  yyparse();

  save_postorder_in_file(arbo, DOSIERNOM); // Arbo
  save_rpn_in_file(ipn, DOSIERNOM);

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *eraro) {
  fprintf(stderr, KOLOR_RUGA "\nlinio %d: %s\n" KOLOR_REKOMENCIGITA, linionum, eraro);
  fclose(yyin);
  exit(1);
}
