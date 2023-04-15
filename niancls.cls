%%　年文檔類　黄京
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{niancls}{2023-04-15}{1.0.0}{Nian Document Class}
\prop_gput:Nnn \g_msg_module_name_prop { ncls } { niancls }
\cs_if_exist:NF \NewDocumentCommand
  { \RequirePackage { xparse } }
\RequirePackage { l3keys2e }
\@ifpackagelater { expl3 } { 2021-02-10 } { }
  {
    \msg_new:nnnn { ncls } { latex3-too-old }
      { Package~`l3kernel'~and~`l3packages'~too~old. }
      {
        You~need~to~update~your~installation~of~the~bundles~
        `l3kernel'~and~`l3packages'. \\
        Loading~niancls~will~abort!
      }
    \msg_critical:nn { ncls } { latex3-too-old }
  }
\@ifl@t@r \fmtversion { 2021-06-01 } { }
  {
    \msg_new:nnnn { ncls } { latex-too-old }
      { Format~LaTeX2e~version~too~old. }
      {
        You~need~to~update~your~LaTeX2e~to~the~latest~release. \\
        Loading~niancls~will~abort!
      }
    \msg_critical:nn { ncls } { latex-too-old }
  }
\sys_if_engine_luatex:TF { }
  {
    \msg_new:nnnn { ncls } { unsupported-engine }
      { LuaTeX~is~the~only~supported~engine~for~niancls. }
      {
        You~should~switch~to~LuaTeX~to~use~niancls. \\
        Loading~niancls~will~abort!
      }
    \msg_fatel:nn { ncls } { unsupported-engine }
  }
\cs_new_protected:Npn \__ncls_at_end:n { \AtEndOfClass }
\cs_new_protected:Npn \__ncls_doc_beg:n { \AtBeginDocument }
\seq_new:N \g__ncls_aftercls_del_seq
\cs_set:Nn \__ncls_aftercls_addtodel:N
  { \seq_gput_right:Nn \g__ncls_aftercls_del_seq { #1 } }
\__ncls_aftercls_addtodel:N \__ncls_aftercls_addtodel:N
\__ncls_at_end:n
  {
    \cs_undefine:N \g__ncls_aftercls_del_seq
  }
\cs_new:Npn \__ncls_luafunc_new:N { \newluafunction }
\cs_new:Npn \__ncls_luafunc_use:N { \luafunction }
\msg_new:nnnn { ncls } { unknown-choice }
  { Unknown~choice~given~to~key~`#1' }
  {
    Valid~choices~are:~#2; \\
    while~you~gave:~#3.
  }
\prop_new:N \g__ncls_papersizelist_prop
\tl_new:N \g__ncls_papersizeinfo_tl
\tl_new:N \g__ncls_papersizeaux_tl
\tl_new:N \g__ncls_papersizeconf_clist
\dim_new:N \g__ncls_paperwidth_dim
\dim_new:N \g__ncls_paperheight_dim
\tl_new:N \l__ncls_paperwidthaux_tl
\tl_new:N \l__ncls_paperheightaux_tl
\cs_set:Nn \__ncls_addpapersize:nnn
  {
    \prop_put_if_new:Nnn \g__ncls_papersizelist_prop
      { #1 }
      { { #2 }, { #3 } }
  }
  % \subsubsection{键对值用户接口}
\keys_define:nn { ncls }
  {
    paper .tl_gset:N = \g__ncls_papersizeinfo_tl,
    paper .value_required:n = true,
    paper .initial:n = { a4 }
  }
\prop_if_in:NoTF \g__ncls_papersizelist_prop
  { \tl_to_str:N \g__ncls_papersizeinfo_tl }
  {
    \prop_get:NoN \g__ncls_papersizelist_prop
      { \tl_to_str:N \g__ncls_papersizeinfo_tl }
      \g__ncls_papersizeaux_tl
  }
  {
    \tl_gset_eq:NN \g__ncls_papersizeaux_tl \g__ncls_papersizeinfo_tl
  }
\clist_gset:Nx \g__ncls_papersizeconf_clist
  { \g__ncls_papersizeaux_tl }
\clist_gpop \g__ncls_papersizeconf_clist \l__ncls_paperwidthaux_tl
\clist_gpop \g__ncls_papersizeconf_clist \l__ncls_paperheightaux_tl
\keys_define:nn { ncls }
  {
    orientation .choice:,
    orientation / portrait .code:n =
      {
        \dim_gset:Nn \g__ncls_paperwidth_dim
          { \tl_use:N \l__ncls_paperwidthaux_tl~mm }
        \dim_gset:Nn \g__ncls_paperheight_dim
          { \tl_use:N \l__ncls_paperheightaux_tl~mm }
      },
    orientation / landscape .code:n =
      {
        \dim_gset:Nn \g__ncls_paperwidth_dim
          { \tl_use:N \l__ncls_paperheightaux_tl }
        \dim_gset:Nn \g__ncls_paperheight_dim
          { \tl_use:N \l__ncls_paperwidthaux_tl }
      },
    orientation / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { orientation }
          { portrait, landscape }
          { \exp_not:n { #1 } }
      },
    orientation .value_required:n = true,
    orientation .initial:n = { portrait }
  }
\pdf_pagesize_gset:nn
  { \dim_use:N \g__ncls_paperwidth_dim }
  { \dim_use:N \g__ncls_paperheight_dim }
\__ncls_addpapersize:nnn { a0 } { 841 mm } { 1189 mm }
\__ncls_addpapersize:nnn { a1 } { 594 mm } {  841 mm }
\__ncls_addpapersize:nnn { a2 } { 420 mm } {  594 mm }
\__ncls_addpapersize:nnn { a3 } { 297 mm } {  420 mm }
\__ncls_addpapersize:nnn { a4 } { 210 mm } {  297 mm }
\__ncls_addpapersize:nnn { a5 } { 148 mm } {  210 mm }
\__ncls_addpapersize:nnn { a6 } { 105 mm } {  148 mm }
\__ncls_addpapersize:nnn { b0 } { 1000 mm } { 1414 mm }
\__ncls_addpapersize:nnn { b1 } {  707 mm } { 1000 mm }
\__ncls_addpapersize:nnn { b2 } {  500 mm } {  707 mm }
\__ncls_addpapersize:nnn { b3 } {  353 mm } {  500 mm }
\__ncls_addpapersize:nnn { b4 } {  250 mm } {  353 mm }
\__ncls_addpapersize:nnn { b5 } {  176 mm } {  250 mm }
\__ncls_addpapersize:nnn { b6 } {  125 mm } {  176 mm }
\__ncls_addpapersize:nnn { c0 } { 917 mm } { 1297 mm }
\__ncls_addpapersize:nnn { c1 } { 648 mm } {  917 mm }
\__ncls_addpapersize:nnn { c2 } { 458 mm } {  648 mm }
\__ncls_addpapersize:nnn { c3 } { 324 mm } {  458 mm }
\__ncls_addpapersize:nnn { c4 } { 229 mm } {  324 mm }
\__ncls_addpapersize:nnn { c5 } { 162 mm } {  229 mm }
\__ncls_addpapersize:nnn { c6 } { 114 mm } {  162 mm }
\__ncls_addpapersize:nnn { b0j } { 1030 mm } { 1456 mm }
\__ncls_addpapersize:nnn { b1j } {  728 mm } { 1030 mm }
\__ncls_addpapersize:nnn { b2j } {  515 mm } {  728 mm }
\__ncls_addpapersize:nnn { b3j } {  364 mm } {  515 mm }
\__ncls_addpapersize:nnn { b4j } {  257 mm } {  364 mm }
\__ncls_addpapersize:nnn { b5j } {  182 mm } {  257 mm }
\__ncls_addpapersize:nnn { b6j } {  128 mm } {  182 mm }
\__ncls_addpapersize:nnn { screen } { 225 mm } { 180 mm }
