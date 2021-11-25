%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define KOLOR_RUGA "\033[1;31m"
#define KOLOR_REKOMENCIGITA "\033[0m"

#define DOSIERNOM "prog"

int linionum;

int yystopparser = 0;

FILE *yyin;

char *yyltext;
char *yytext;

int yylex();
int yyerror(char *);
%}

%union {
  double num_val;
  char *s_val;
}

%token punktokom

%token id
%token <num_val> nk
%token <s_val> sk

%token op_asig
%token op_sum op_mul

%token malferma_krampo ferma_krampo

%%
P: KOD;

KOD: KOD L | L;

L: A punktokom;

A: id op_asig E | id op_asig A;

E: E op_sum T | T;

T: T op_mul F | F;

F: id | nk | sk | malferma_krampo E ferma_krampo;
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

  yyparse();

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *eraro) {
  fprintf(stderr, KOLOR_RUGA "\nlinio %d: %s\n" KOLOR_REKOMENCIGITA, linionum, eraro);
  fclose(yyin);
  exit(1);
}
