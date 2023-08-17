#luatex NianCLS.dtx
#lualatex NianCLS.dtx
makeindex -s gglo.ist -o NianCLS.gls NianCLS.glo
makeindex -s gind.ist -o NianCLS.ind NianCLS.idx
#lualatex NianCLS.dtx
#latexmk -c NianCLS.dtx
