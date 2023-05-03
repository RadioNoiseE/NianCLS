%%　年文檔類　黄京
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{niancls}{2023-04-15}{1.0.0}{Nian Document Class}
\prop_gput:Nnn \g_msg_module_name_prop { ncls } { niancls }
\cs_if_exist:NF \NewDocumentCommand
  { \RequirePackage { xparse } }
\cs_if_exist:NTF \ProcessKeyOptions
  { \cs_new:Nn \__ncls_keyoptions_process:n { \ProcessKeyOptions { #1 } } }
  {
    \RequirePackage { l3keys2e }
    \cs_new:Nn \__ncls_keyoptions_process:n { \ProcessKeysOptions { #1 } }
  }
\cs_if_exist:NF \AtEndPreamble
  { \RequirePackage { etoolbox } }
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
\sys_if_engine_luatex:F
  {
    \msg_new:nnnn { ncls } { unsupported-engine }
      { LuaTeX~is~the~only~supported~engine~for~niancls. }
      {
        You~should~switch~to~LuaTeX~to~use~niancls. \\
        Loading~niancls~will~abort!
      }
    \msg_fatel:nn { ncls } { unsupported-engine }
  }
\cs_new_protected:Npn \__ncls_preamble_end:n { \AtEndPreamble }
\cs_new_protected:Npn \:n { \AtBeginDocument }
\seq_new:N \g__ncls_aftercls_del_seq
\cs_set:Nn \__ncls_aftercls_addtodel:N
  { \seq_gput_right:Nn \g__ncls_aftercls_del_seq { #1 } }
\__ncls_preamble_end:n
  {
    \ExplSyntaxOn
    \cs_undefine:N \g__ncls_aftercls_del_seq
    \ExplSyntaxOff
  }
\cs_new:Npn \__ncls_luafunc_new:N { \newluafunction }
\cs_new:Npn \__ncls_luafunc_use:N { \luafunction }
\msg_new:nnnn { ncls } { unknown-choice }
  { Unknown~choice~given~to~key~`#1' }
  {
    Valid~choices~are:~#2; \\
    while~you~gave:~#3.
  }
\__ncls_aftercls_addtodel:N \__ncls_keyoptions_process:n
\__ncls_aftercls_addtodel:N \__ncls_preamble_end:n
\__ncls_aftercls_addtodel:N \__ncls_at_doc_begin:n
\__ncls_aftercls_addtodel:N \__ncls_aftercls_addtodel:N
\__ncls_aftercls_addtodel:N \__ncls_luafunc_new:N
\__ncls_aftercls_addtodel:N \__ncls_luafunc_use:N
\tl_new:N \g__ncls_papersizeinfo_tl
\keys_define:nn { ncls }
  {
    paper .tl_gset:N = \g__ncls_papersizeinfo_tl,
    paper .value_required:n = true,
    peper .initial:n = { a4 }
  }
\bool_new:N \g__ncls_paper_portrait_bool
\keys_define:nn { ncls }
  {
    orientation .choice:,
    orientation / portrait .code:n = { \bool_gset_true:N \g__ncls_paper_portrait_bool },
    orientation / landscape .code:n = { \bool_gset_false:N \g__ncls_paper_portrait_bool },
    orientation / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { orientation }
          { portrait,~landscape }
          { \exp_not:n { #1 } }
      },
    orientation .value_required:n = true,
    orientation .initial:n = { portrait }
  }
\bool_new:N \g__ncls_dir_tate_bool
\keys_define:nn { ncls }
  {
    direction .choice:,
    direction / yoko .code:n = { \bool_gset_false:N \g__ncls_dir_tate_bool },
    direction / tate .code:n = { \bool_gset_true:N \g__ncls_dir_tate_bool },
    direction / unknown .code =
      {
        \msg_new:nnxxx { ncls } { unknown-choice }
          { direction }
          { yoko,~tate }
          { \exp_not:n { #1 } }
      },
    direction .value_required:n = true,
    direction .initial:n = { yoko }
  }
\tl_new:N \g__ncls_font_magscale_tl
\keys_define:nn { ncls }
  {
    fontsize .choice:,
    fontsize /  7pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 0.6940 } },
    fontsize /  8pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 0.8330 } },
    fontsize /  9pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 0.9130 } },
    fontsize / 10pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.0000 } },
    fontsize / 11pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.0953 } },
    fontsize / 12pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.2000 } },
    fontsize / 13pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.3000 } },
    fontsize / 14pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.4400 } },
    fontsize / 15pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.5000 } },
    fontsize / 16pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.6000 } },
    fontsize / 17pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 1.7280 } },
    fontsize / 20pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 2.0000 } },
    fontsize / 21pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 2.0740 } },
    fontsize / 24pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 2.4000 } },
    fontsize / 25pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 2.4880 } },
    fontsize / 30pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 2.9860 } },
    fontsize / 36pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 3.5830 } },
    fontsize / 43pt .code:n = { \tl_gset:Nn \g__ncls_font_magscale_tl { 4.3000 } },
    fontsize / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { fontsize }
          {
             7pt,~  8pt,~  9pt,~ 10pt,~ 11pt,~ 12pt,~ 13pt,~ 14pt,~ 15pt,~
            17pt,~ 20pt,~ 21pt,~ 24pt,~ 25pt,~ 30pt,~ 36pt,~ 43pt
          }
          { \exp_not:n { #1 } }
      },
    fontsize .value_required:n = true,
    fontsize .initial:n = { 10pt }
  }
\bool_new:N \g__ncls_lang_trad_bool
\bool_new:N \g__ncls_lang_smpl_bool
\bool_new:N \g__ncls_lang_jp_bool
\keys_define:nn { ncls }
  {
    language .choice:,
    language / trad .code:n = { \bool_gset_true:N \g__ncls_lang_trad_bool },
    language / smpl .code:n = { \bool_gset_true:N \g__ncls_lang_smpl_bool },
    language / jp .code:n = { \bool_gset_true:N \g__ncls_lang_jp_bool },
    language / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { language }
          { trad,~smpl,~jp }
          { \exp_not:n { #1 } }
      },
    language .value_required:n = true,
    language .initial:n = { jp }
  }
\tl_new:N \g__ncls_font_mincho_tl
\tl_new:N \g__ncls_font_gothic_tl
\keys_define:nn { ncls }
  {
    mincho .tl_gset:N = \g__ncls_font_mincho_tl,
    gothic .tl_gset:N = \g__ncls_font_gothic_tl,
    mincho .value_required:n = true,
    gothic .value_required:n = true,
    mincho .initial:n = { HaranoAji Mincho },
    gothic .initial:n = { HaranoAji Gothic }
  }
\tl_new:N \g__ncls_font_cjscale_tl
\keys_define:nn { ncls }
  {
    scale .tl_gset:N = \g__ncls_font_cjsacle_tl,
    scale .value_required:n = true,
    scale .initial:n = { 0.924715 }
  }
\bool_new:N \g__ncls_jfm_hanging_bool
\bool_new:N \g__ncls_jfm_linegap_bool
\keys_define:nn { ncls }
  {
    punct .multichoice:,
    punct / hanging .code:n = { \bool_gset_true:N \g__ncls_jfm_hanging_bool },
    punct / linegap .code:n = { \bool_gset_true:N \g__ncls_jfm_linegap_bool },
    punct .value_required:n = true
  }
\bool_new:N \g__ncls_font_xreal_bool
\keys_define:nn { ncls }
  {
    magstyle .choice:,
    magstyle / real .code:n = { \bool_gset_false:N \g__ncls_font_xreal_bool },
    magstyle / xreal .code:n = { \bool_gset_true:N \g__ncls_font_xreal_bool },
    magstyle .value_required:n = true,
    magstyle .initial:n = { xreal }
  }
\__ncls_keyoptions_process:n { ncls }
\prop_new:N \g__ncls_papersizelist_prop
\clist_new:N \g__ncls_papersizeconf_clist
\dim_new:N \g__ncls_paperwidth_dim
\dim_new:N \g__ncls_paperheight_dim
\tl_new:N \l__ncls_paperwidthaux_tl
\tl_new:N \l__ncls_paperheightaux_tl
\cs_new:Nn \__ncls_addpapersize:nnn
  {
    \prop_put_if_new:Nnn \g__ncls_papersizelist_prop
      { #1 }
      { { #2 }, { #3 } }
  }
\prop_if_in:NoT \g__ncls_papersizelist_prop
  { \tl_to_str:N \g__ncls_papersizeinfo_tl }
  {
    \prop_get:NoN \g__ncls_papersizelist_prop
      { \tl_to_str:N \g__ncls_papersizeinfo_tl }
      \g__ncls_papersizeinfo_tl
  }
\clist_gset:Nx \g__ncls_papersizeconf_clist
  { \g__ncls_papersizeinfo_tl }
\clist_gpop \g__ncls_papersizeconf_clist \l__ncls_paperwidthaux_tl
\clist_gpop \g__ncls_papersizeconf_clist \l__ncls_paperheightaux_tl
\bool_if:NTF \g__ncls_paper_portrait_bool
  {
    \dim_gset:Nn \g__ncls_paperwidth_dim
      { \tl_use:N \l__ncls_paperwidthaux_tl }
    \dim_gset:Nn \g__ncls_paperheight_dim
      { \tl_use:N \l__ncls_paperheightaux_tl }
  }
  {
    \dim_gset:Nn \g__ncls_paperwidth_dim
      { \tl_use:N \l__ncls_paperheightaux_tl }
    \dim_gset:Nn \g__ncls_paperheight_dim
      { \tl_use:N \l__ncls_paperwidthaux_tl }
  }
\pdf_pagesize_gset:nn
  { \dim_use:N \g__ncls_paperwidth_dim }
  { \dim_use:N \g__ncls_paperheight_dim }
\__ncls_addpapersize:nnn { a0  } {  841 mm } { 1189 mm }
\__ncls_addpapersize:nnn { a1  } {  594 mm } {  841 mm }
\__ncls_addpapersize:nnn { a2  } {  420 mm } {  594 mm }
\__ncls_addpapersize:nnn { a3  } {  297 mm } {  420 mm }
\__ncls_addpapersize:nnn { a4  } {  210 mm } {  297 mm }
\__ncls_addpapersize:nnn { a5  } {  148 mm } {  210 mm }
\__ncls_addpapersize:nnn { a6  } {  105 mm } {  148 mm }
\__ncls_addpapersize:nnn { b0  } { 1000 mm } { 1414 mm }
\__ncls_addpapersize:nnn { b1  } {  707 mm } { 1000 mm }
\__ncls_addpapersize:nnn { b2  } {  500 mm } {  707 mm }
\__ncls_addpapersize:nnn { b3  } {  353 mm } {  500 mm }
\__ncls_addpapersize:nnn { b4  } {  250 mm } {  353 mm }
\__ncls_addpapersize:nnn { b5  } {  176 mm } {  250 mm }
\__ncls_addpapersize:nnn { b6  } {  125 mm } {  176 mm }
\__ncls_addpapersize:nnn { c0  } {  917 mm } { 1297 mm }
\__ncls_addpapersize:nnn { c1  } {  648 mm } {  917 mm }
\__ncls_addpapersize:nnn { c2  } {  458 mm } {  648 mm }
\__ncls_addpapersize:nnn { c3  } {  324 mm } {  458 mm }
\__ncls_addpapersize:nnn { c4  } {  229 mm } {  324 mm }
\__ncls_addpapersize:nnn { c5  } {  162 mm } {  229 mm }
\__ncls_addpapersize:nnn { c6  } {  114 mm } {  162 mm }
\__ncls_addpapersize:nnn { b0j } { 1030 mm } { 1456 mm }
\__ncls_addpapersize:nnn { b1j } {  728 mm } { 1030 mm }
\__ncls_addpapersize:nnn { b2j } {  515 mm } {  728 mm }
\__ncls_addpapersize:nnn { b3j } {  364 mm } {  515 mm }
\__ncls_addpapersize:nnn { b4j } {  257 mm } {  364 mm }
\__ncls_addpapersize:nnn { b5j } {  182 mm } {  257 mm }
\__ncls_addpapersize:nnn { b6j } {  128 mm } {  182 mm }
\__ncls_addpapersize:nnn { screen } { 225 mm } { 180 mm }
\__ncls_aftercls_addtodel:N \__ncls_addpapersize:nnn
\__ncls_aftercls_addtodel:N \g__ncls_papersizelist_prop
\__ncls_aftercls_addtodel:N \g__ncls_papersizeinfo_tl
\__ncls_aftercls_addtodel:N \g__ncls_papersizeaux_tl
\__ncls_aftercls_addtodel:N \g__ncls_papersizeconf_clist
\__ncls_aftercls_addtodel:N \g__ncls_paperwidth_dim
\__ncls_aftercls_addtodel:N \g__ncls_paperheight_dim
\__ncls_aftercls_addtodel:N \g__ncls_paper_portrait_bool
\__ncls_aftercls_addtodel:N \l__ncls_paperwidthaux_tl
\__ncls_aftercls_addtodel:N \l__ncls_paperheightaux_tl
\clist_new:N \g__ncls_jfm_feats_clist
\clist_gset:Nn \g__ncls_jfm_feats_clist { nstd }
\__ncls_aftercls_addtodel:N \g__ncls_jfm_feats_clist
\bool_if:NT \g__ncls_dir_tate_bool
  {
    \RequirePackage { lltjext } \tate
    \__ncls_doc_beg:n
      {
        \message {《縦組モード》} \adjustbaseline
      }
  }
\__ncls_aftercls_addtodel \g__ncls_dir_tate_bool
\tl_new:N \g__ncls_font_langfeat_tl
\bool_if:NT \g__ncls_lang_trad_bool
  {
    \clist_gput_left:Nn \g__ncls_jfm_feats_clist { trad }
    \tl_gset:Nn \g__ncls_font_langfeat_tl { Chinese~Traditional }
  }
\bool_if:NT \g__ncls_lang_smpl_bool
  {
    \clist_gput_left:Nn \g__ncls_jfm_feats_clist { smpl }
    \tl_gset:Nn \g__ncls_font_langfeat_tl { Chinese~Simplified }
  }
\bool_if:NT \g__ncls_lang_jp_bool
  {
    \clist_gput_left:Nn \g__ncls_jfm_feats_clist { jp }
    \tl_gset:Nn \g__ncls_font_langfeat_tl { Japanese }
  }
\bool_if:NT \g__ncls_jfm_hanging_bool
  { \clist_gput_left:Nn \g__ncls_jfm_feats_clist { hgp } }
\bool_if:NT \g__ncls_jfm_linegap_bool
  { \clist_gput_left:Nn \g__ncls_jfm_feats_clist { lgp } }
\tl_gset:Nx \Cjascale { \tl_use:N \g__ncls_font_cjscale_tl }
\tl_gset:Nx \ltj@stdmcfont { \tl_use:N \g__ncls_font_mincho_tl }
\tl_gset:Nx \ltj@stdgtfont { \tl_use:N \g__ncls_font_gothic_tl }
\tl_gset:Nx \ltj@stdyokojfm
  { eva / { \clist_use:Nn \g__ncls_jfm_feats_clist { , } } }
\tl_gset:Nx \ltj@stdtatejfm
  { eva / { \clist_use:Nn \g__ncls_jfm_feats_clist { , } , vert } }
\dim_gset:Nn \mpt { \g__ncls_font_magscale_tl \p@ }
\dim_compare:nNnT
  { \mpt } < { 1 \p@ }
  { \tl_gset:Nn \@ptsize { -20 } }
\dim_compare:nNnT
  { \mpt } = { 1\p@ }
  { \tl_gset:Nn \@ptsize { 0 } }
\dim_compare:nNnT
  { \mpt } = { 1.095 \p@ }
  { \tl_gset:Nn \@ptsize { 1 } }
\dim_compare:nNnT
  { \mpt } = { 1.200 \p@ }
  { \tl_gset:Nn \@ptsize { 2 } }
\dim_compare:nNnT
  { \mpt } > { 1.200 \p@ }
  { \tl_gset:Nn \@ptsize { -20 } }
\bool_if:NTF \g__ncls_font_xreal_bool
  {
    \dim_compare:nNnT
      { \mpt } = { \p@ }
      { \bool_gset_false:N \g__ncls_font_xreal_bool }
  }
  { \dim_gset:Nn \mpt { \p@ } }
\bool_if:NT \g__ncls_font_xreal_bool
  {
    \exp_after:wN \cs_set_eq:NN \cs:w TU/lmr/m/n/10 \cs_end: \scan_stop:
    \exp_after:wN \cs_set_eq:NN \cs:w TU/lmss/m/n/10 \cs_end: \scan_stop:
    \exp_after:wN \cs_set_eq:NN \cs:w TU/lmtt/m/n/10 \cs_end: \scan_stop:
    \__ncls_luafunc_new:N \__ncls_magnify_font_calc
    \group_begin:
      % \char_set_catcode_other:N \$
      \char_set_catcode_other:N \%
      \char_set_catcode_space:n { 32 }
      \lua_now:e
        {
          local mpt = tex.getdimen('mpt')/65536
          lua.get_functions_table()[\the\__ncls_magnify_font_calc] = function()
            tex.sprint(-2, math.floor(0.5 + mpt * tex.getdimen(luatexbase.registernumber 'dimen@')))
          end
          function luatexja.ncls_unmagnify_fsize(e)
            local s = luatexja.print_scaled(floor(0.5 + e / mpt * 65536))
            tex.sprint(-2, (s:match('%.0\$)) and s:sub(1, -3) or s)
          end
        }
      \group_end:
      \cs_new:Npn \__ncls_magnify_external_font:w #1~at #2~at #3 \@nil
        {
          \tl_set:Nn \l_tempa_tl { #1 }
          \tl_set:Nn \l_tempb_tl { #2 }
          \tl_if_empty:NTF \l_tempb_tl
            {
              \tl_set:Nx \l_temlb_tl
                {
                  scaled \lua_now:e { tex.sprint(-2, math.floor(0.5 + \g__ncls_font_magscale_tl * 1000)) }
                }
            }
            {
              \dim_set:Nn \dimen@ { \l_tempb_tl }
              \tl_set:Nx \l_tempb_tl
                { at \__ncls_luafunc_use:N \__ncls_magnify_font_calc~sp }
            }
          \tl_set:Nx \l_tempa_tl
            {
              \tl_set:Nn \exp_not:N \external@font
                { \l_tempa_tl \l_tempb_tl }
            }
        }
      \cs_new_eq:NN \__ncls_get_externalfont_orig: { \get@external@font }
      \cs_gset:Nn \get@external@font
        {
          \tl_gset:Nx \f@size
            { \lua_now:e { luatexja.ncls_unmagnify_fsize(\f@size) } }
          \__ncls_get_externalfont_orig:
          \group_begin:
            \tl_set:Nx \l_tempa_tl
              { \external@font \c_space_tl~at \c_space_tl~at }
            \exp_after:wN \__ncls_magnify_external_font:w \l_tempa_tl \@nil
            \exp_after:wN
          \group_end:
          \tl_use:N \l_tempa_tl
        }
  }
\__ncls_aftercls_addtodel:N \g__ncls_font_magscale_tl
\__ncls_aftercls_addtodel:N \g__ncls_lang_trad_bool
\__ncls_aftercls_addtodel:N \g__ncls_lang_smpl_bool
\__ncls_aftercls_addtodel:N \g__ncls_lang_jp_bool
\__ncls_aftercls_addtodel:N \g__ncls_font_langfeat_tl
\__ncls_aftercls_addtodel:N \g__ncls_font_mincho_tl
\__ncls_aftercls_addtodel:N \g__ncls_font_gothic_tl
\__ncls_aftercls_addtodel:N \g__ncls_font_cjscale_tl
\__ncls_aftercls_addtodel:N \g__ncls_jfm_hanging_tl
\__ncls_aftercls_addtodel:N \g__ncls_jfm_linegap_tl
\__ncls_aftercls_addtodel:N \g__ncls_font_xreal_bool
