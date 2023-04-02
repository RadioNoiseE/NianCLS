%%　年文檔類　黄京
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{niancls}{2023-03-24}{1.0.0}{Nian Document Class}
\prop_gput:Nnn \g_msg_module_name_prop { ncls } { niancls }
\cs_if_exist:NF \NewDocumentCommand
  { \RequirePackage { xparse } }
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
\seq_new:N \g__ncls_aftercls_delcs_seq
\seq_new:N \g__ncls_aftercls_delif_seq
\cs_set:Nn \__ncls_aftercls_addtodelcs:N
  { \seq_gput_right:Nn \g__ncls_aftercls_delcs_seq { #1 } }
\cs_set:Nn \__ncls_aftercls_addtodelif:N
  { \seq_gput_right:Nn \g__ncls_aftercls_delif_seq { #1 } }
\__ncls_aftercls_addtodelcs:N \__ncls_aftercls_addtodelcs:N
\__ncls_aftercls_addtodelcs:N \__ncls_aftercls_addtodelif:N
\__ncls_at_end:n
  {
    \cs_undefine:N \g__ncls_aftercls_delcs_seq
    \cs_undefine:N \g__ncls_aftercls_delif_seq
  }
