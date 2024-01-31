temp-file = NianCLS.hd NianCLS.glo NianCLS.gls

.PHONY : build extract clean test

all : extract build clean

build : NianCLS.dtx
	lualatex NianCLS.dtx
	makeindex -s gglo.ist -o NianCLS.gls NianCLS.glo
	makeindex -s gind.ist -o NianCLS.ind NianCLS.idx
	lualatex NianCLS.dtx

extract : NianCLS.dtx
	luatex NianCLS.dtx
	rm NianCLS.log

clean :
	latexmk -c NianCLS.dtx
	rm $(temp-file)

test : niancls.cls texput.tex
	lualatex texput.tex
	latexmk -c texput.tex
