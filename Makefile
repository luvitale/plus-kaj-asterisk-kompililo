CC=gcc

# check if flex exists
LEX := $(shell which flex)
ifndef LEX
	# if not, try to find it in the path
	LEX := $(shell which win_flex)
	ifndef LEX
		# error
		echo "flex not found"
		exit 1
	endif
endif

BISON := $(shell which bison)
ifndef BISON
	# if not, try to find it in the path
	BISON := $(shell which win_bison)
	ifndef BISON
		# error
		echo "bison not found"
		exit 1
	endif
endif

ifeq ($(OS),Windows_NT)
	EXT=exe
else
	EXT=app
endif

DOT := $(shell which dot)

all: komp.app

%.app: %.yy.c %.tab.c tree.c rpn.c tac.c stack.c
	$(CC) -o $*.$(EXT) $? -fcommon

%.yy.c: leksik.l
	$(LEX) -o $@ $<

%.tab.c: sintaks.y
	$(BISON) -o $@ -dyv $<

test-%: %.app
	$*.$(EXT) test/kod.pka

test: test-komp

clean:
	rm -f *.yy.* *.app *.tab.* *.output