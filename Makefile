CC=gcc

ifeq ($(OS),Windows_NT)
	LEX=win_flex
	BISON=win_bison
	EXT=exe
else
	LEX=flex
	BISON=bison
	EXT=app
endif

all: komp.app

%.app: leksik.yy.c leksik.tab.c
	$(CC) -o $*.$(EXT) $? -fcommon

%.yy.c: %.l
	$(LEX) -o $@ $<

%.tab.c: sintaks.y
	$(BISON) -o $@ -dyv $<

test-%: %.app
	./$*.$(EXT) ./test/kod.pka

test: test-komp

clean:
	rm -f *.yy.* *.app *.tab.* *.output