temp-file = NianCLS.hd NianCLS.glo NianCLS.gls

.PHONY : build extract clean test

build : NianCLS.dtx build.sh
	lualatex NianCLS.dtx
	dash build.sh
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
