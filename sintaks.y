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
P: KOD {
  puts(regul[0]);
};

KOD: KOD L {
  puts(regul[1]);
} | L {
  puts(regul[2]);
};

L: A punktokom {
  puts(regul[3]);
};

A: id op_asig E {
  puts(regul[4]);
} | id op_asig A {
  puts(regul[5]);
};

E: E op_sum T {
  puts(regul[6]);
} | T {
  puts(regul[7]);
};

T: T op_mul F {
  puts(regul[8]);
} | F {
  puts(regul[9]);
};
F: id {
  puts(regul[10]);
} | nk {
  puts(regul[11]);
} | sk {
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

  yyparse();

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *eraro) {
  fprintf(stderr, KOLOR_RUGA "\nlinio %d: %s\n" KOLOR_REKOMENCIGITA, linionum, eraro);
  fclose(yyin);
  exit(1);
}
