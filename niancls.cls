%%　年文檔類　黄京
%%%%%% ^^X MetaComment |=>
%%%%%% ^^X <=|
%%%%%% ^^X Title |=>
%%%%%% ^^X <=|
%%%%%% ^^X Abstract |=>
%% \begin{abstract}
%% 为在{\LuaTeX}下排印中日文本而作的文档类。基于{\sffamily expl3}构建。设计初衷不同于ltj／bxjs系列，不考虑对旧版本的支持。
%% 目标为提供一个灵活的可配置的文档类。支持简中、繁中及日本语。
%% \end{abstract}
%%%%%% ^^X <=|
%%%%%% ^^X TableOfContents |=>
%%%%%% ^^X <=|
%%%%%% ^^X 初始化 |=>
%%%%% ^^X 載入{\LaTeX3}並檢驗依賴 |=>
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{niancls}{2023-08-05}{0.0.0}{Nian Document Class}
\prop_gput:Nnn \g_msg_module_name_prop { ncls } { niancls }
\cs_if_exist:NF \NewDocumentCommand
  { \RequirePackage { xparse } }
\cs_if_exist:NTF \ProcessKeyOptions
{ \cs_new:Nn \__ncls_keyoptions_process:n { \ProcessKeyOptions [ #1 ] } }
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
%%%%% ^^X <=|
%%%%% ^^X 私有定義 |=>
\cs_new_protected:Npn \__ncls_at_preamble_end:n { \AtEndPreamble }
\cs_new_protected:Npn \__ncls_at_cls_end:n { \AtEndOfClass }
\cs_new_protected:Npn \__ncls_at_doc_beg:n { \AtBeginDocument }
\seq_new:N \g__ncls_aftercls_del_seq
\cs_new:Nn \__ncls_macro_release:N
  { \seq_gput_right:Nn \g__ncls_aftercls_del_seq { #1 } }
\__ncls_at_preamble_end:n
  {
    \ExplSyntaxOn
    \cs_undefine:N \g__ncls_aftercls_del_seq
    \ExplSyntaxOff
  }
\cs_new_protected:Npn \__ncls_luafunc_new:N { \newluafunction }
\cs_new_protected:Npn \__ncls_luafunc_use:N { \luafunction }
\msg_new:nnnn { ncls } { unknown-choice }
  { Unknown~choice~given~to~key~`#1'. }
  {
    Valid~choices~are:~#2; \\
    while~you~gave:~#3.
  }
\dim_new:N \mpt
\dim_set:Nn \mpt { \p@ }
%%%%% ^^X <=|
%%%%% ^^X 內存清理 |=>
\__ncls_macro_release:N \__ncls_keyoptions_process:n
\__ncls_macro_release:N \__ncls_at_preamble_end:n
\__ncls_macro_release:N \__ncls_at_cls_end:n
\__ncls_macro_release:N \__ncls_at_doc_begin:n
\__ncls_macro_release:N \__ncls_macro_release:N
\__ncls_macro_release:N \__ncls_luafunc_new:N
\__ncls_macro_release:N \__ncls_luafunc_use:N
%%%%% ^^X <=|
%%%%%% ^^X <=|
%%%%%% ^^X 鍵對直之「預處理」 |=>
%%%%% ^^X 紙張配置用 |=>
%%%% ^^X 尺寸信息 |=>
\tl_new:N \l__ncls_paper_sizeinfo_tl
\keys_define:nn { ncls }
  {
    paper .tl_set:N = \l__ncls_paper_sizeinfo_tl,
    paper .value_required:n = true,
    peper .initial:n = { a4 }
  }
%%%% ^^X <=|
%%%% ^^X 輔助線 |=>
\bool_new:N \l__ncls_paper_corpmark_mark_bool
\bool_new:N \l__ncls_paper_corpmark_date_bool
\keys_define:nn { ncls }
  {
    corpmark .choice:,
    corpmark / tombow .code:n =
      {
        \bool_set_true:N \l__ncls_paper_corpmark_mark_bool
        \bool_set_true:N \l__ncls_paper_corpmark_date_bool
      },
    corpmark / mentuke .code:n =
      {
        \bool_set_true:N \l__ncls_paper_corpmark_mark_bool
        \bool_set_false:N \l__ncls_paper_corpmark_date_bool
      },
    corpmark / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { corpmark }
          { tombow,~mentuke }
          { \exp_not:n { #1 } }
      },
    corpmark .value_required:n = true
  }
%%%% ^^X <=|
%%%% ^^X 頁面方向 |=>
\bool_new:N \l__ncls_paper_portrait_bool
\keys_define:nn { ncls }
  {
    orientation .choice:,
    orientation / portrait .code:n = { \bool_set_true:N \l__ncls_paper_portrait_bool },
    orientation / landscape .code:n = { \bool_set_false:N \l__ncls_paper_portrait_bool },
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
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%% ^^X 選項設定 |=>
%%%% ^^X 組版方向 |=>
\bool_new:N \l__ncls_layout_tate_bool
\keys_define:nn { ncls }
  {
    direction .choice:,
    direction / yoko .code:n = { \bool_set_false:N \l__ncls_layout_tate_bool },
    direction / tate .code:n = { \bool_set_true:N \l__ncls_layout_tate_bool },
    direction / unknown .code:n =
      {
        \msg_new:nnxxx { ncls } { unknown-choice }
          { direction }
          { yoko,~tate }
          { \exp_not:n { #1 } }
      },
    direction .value_required:n = true,
    direction .initial:n = { yoko }
  }
%%%% ^^X <=|
%%%% ^^X 基準語言 |=>
\bool_new:N \l__ncls_layout_english_bool
\keys_define:nn { ncls }
  {
    basis .choice:,
    basis / english .code:n = { \bool_set_true:N \l__ncls_layout_english_bool },
    basis / cjk .code:n = { \bool_set_false:N \l__ncls_layout_english_bool },
    basis / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { basis }
          { english,~cjk }
          { \exp_not:n { #1 } }
      },
    basis .value_required:n = true,
    basis .initial:n = { cjk }
  }
%%%% ^^X <=|
%%%% ^^X 文檔類型 |=>
\bool_new:N \l__ncls_layout_restonecol_bool
\bool_new:N \l__ncls_layout_twoside_bool
\bool_new:N \l__ncls_layout_mparswitch_bool
\bool_new:N \l__ncls_layout_titlepage_bool
\bool_new:N \l__ncls_layout_openleft_bool
\bool_new:N \l__ncls_layout_openright_bool
\str_new:N \l__ncls_layout_doctype_str
\keys_define:nn { ncls }
  {
    doctype .choice:,
    doctype / article .code:n =
      {
        \str_set:Nn \l__ncls_layout_doctype_str { a }
        \bool_set_false:N \l__ncls_layout_twoside_bool
        \bool_set_false:N \l__ncls_layout_mparswitch_bool
        \bool_set_false:N \l__ncls_layout_titlepage_bool
        \bool_set_true:N \l__ncls_layout_openleft_bool
        \bool_set_true:N \l__ncls_layout_openright_bool
      },
    doctype / report .code:n =
      {
        \str_set:Nn \l__ncls_layout_doctype_str { r }
        \bool_set_true:N \l__ncls_layout_twoside_bool
        \bool_set_false:N \l__ncls_layout_mparswitch_bool
        \bool_set_true:N \l__ncls_layout_titlepage_bool
        \bool_set_true:N \l__ncls_layout_openleft_bool
        \bool_set_true:N \l__ncls_layout_openright_bool
      },
    doctype / book .code:n =
      {
        \str_set:Nn \l__ncls_layout_doctype_str { b }
        \bool_set_true:N \l__ncls_layout_twoside_bool
        \bool_set_true:N \l__ncls_layout_mparswitch_bool
        \bool_set_true:N \l__ncls_layout_titlepage_bool
        \bool_set_false:N \l__ncls_layout_openleft_bool
        \bool_set_true:N \l__ncls_layout_openright_bool
      },
    doctype .value_required:n = true,
    doctype .initial:n = { article }
  }
%%%% ^^X <=|
%%%% ^^X 分欄 |=>
\keys_define:nn { ncls }
  {
    column .choice:,
    column / one .code:n = { \bool_set_false:N \l__ncls_layout_restonecol_bool },
    column / two .code:n = { \bool_set_true:N \l__ncls_layout_restonecol_bool },
    column / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { column }
          { one,~two }
          { \exp_not:n { #1 } }
      },
    column .value_required:n = true,
    column .initial:n = { one }
  }
\tl_new:N \l__ncls_layout_column_gap_tl
\keys_define:nn { ncls }
  {
    column_gap .tl_set:N = \l__ncls_layout_column_gap_tl,
    column_gap .value_required:n = true,
    column_gap .initial:n = { 2 \zw }
  }
%%%% ^^X <=|
%%%% ^^X 單雙面 |=>
\keys_define:nn { ncls }
  {
    print .choice:,
    print / oneside .code:n =
      {
        \bool_set_false:N \l__ncls_layout_twoside_bool
        \bool_set_false:N \l__ncls_layout_mparswitch_bool
      },
    print / twoside .code:n =
      {
        \bool_set_true:N \l__ncls_layout_twoside_bool
        \bool_set_true:N \l__ncls_layout_mparswitch_bool
      },
    print / vartwoside .code:n =
      {
        \bool_set_true:N \l__ncls_layout_twoside_bool
        \bool_set_false:N \l__ncls_layout_mparswitch_bool
      },
    print / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { print }
          { oneside,~twoside,~vartwoside }
          { \exp_not:n { #1 } }
      },
    print .value_required:n = true
  }
%%%% ^^X <=|
%%%% ^^X 標題頁 |=>
\keys_define:nn { ncls }
  {
    titlepage .bool_set:N = \l__ncls_layout_titlepage_bool,
    titlepage .value_required:n = true
  }
%%%% ^^X <=|
%%%% ^^X 章節起 |=>
\keys_define:nn { ncls }
  {
    open .choice:,
    open / left .code:n =
      {
        \bool_set_true:N \l__ncls_layout_openleft_bool
        \bool_set_false:N \l__ncls_layout_openright_bool
      },
    open / right .code:n =
      {
        \bool_set_false:N \l__ncls_layout_openleft_bool
        \bool_set_true:N \l__ncls_layout_openright_bool
      },
    open / any .code:n =
      {
        \bool_set_true:N \l__ncls_layout_openleft_bool
        \bool_set_true:N \l__ncls_layout_openright_bool
      },
    open / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { open }
          { left,~right,~any }
          { \exp_not:n { #1 } }
      },
    open .value_required:n = true
  }
%%%% ^^X <=|
%%%% ^^X 編譯模式 |=>
\bool_new:N \l__ncls_layout_draft_bool
\keys_define:nn { ncls }
  {
    version .choice:,
    version / draft .code:n =
      {
        \bool_set_true:N \l__ncls_layout_draft_bool
        \dim_set:Nn \overfullrule { 6 \mpt }
      },
    version / final .code:n =
      {
        \bool_set_false:N \l__ncls_layout_draft_bool
        \dim_set:Nn \overfullrule { 0 \mpt }
      },
    version / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { version }
          { draft,~final }
          { \exp_not:n { #1 } }
      },
    version .value_required:n = true,
    version .initial:n = { final }
  }
%%%% ^^X <=|
%%%% ^^X 數學公式 |=>
\bool_new:N \l__ncls_layout_fleqn_bool
\keys_define:nn { ncls }
  {
    eqalign .choice:,
    eqalign / left .code:n = { \bool_set_true:N \l__ncls_layout_fleqn_bool },
    eqalign / middle .code:n = { \bool_set_false:N \l__ncls_layout_fleqn_bool },
    eqalign / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { eqalign }
          { left,~middle }
{ \exp_not:n { #1 } }
      },
    eqalign .value_required:n = true,
    eqalign .initial:n = { middle }
  }
\bool_new:N \l__ncls_layout_leqno_bool
\keys_define:nn { ncls }
  {
    eqnum .choice:,
    eqnum / left .code:n = { \bool_set_true:N \l__ncls_layout_leqno_bool },
    eqnum / right .code:n = { \bool_set_false:N \l__ncls_layout_leqno_bool },
    eqnum / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { eqnum }
          { left,~right }
{ \exp_not:n { #1 } }
      },
    eqnum .value_required:n = true,
    eqnum .initial:n = { right }
  }
%%%% ^^X <=|
%%%% ^^X 參考文獻式樣設定 |=>
\bool_new:N \l__ncls_layout_openbib_bool
\keys_define:nn { ncls }
  {
    bibstyle .choice:,
    bibstyle / open .code:n = { \bool_set_true:N \l__ncls_layout_openbib_bool },
    bibstyle / plain .code:n = { \bool_set_false:N \l__ncls_layout_openbib_bool },
    bibstyle / unknown .code:n =
      {
        \msg_error:nnxxx { ncls } { unknown-choice }
          { bibstyle }
          { open,~plain }
          { \exp_not:n { #1 } }
      },
    bibstyle .value_required:n = true,
    bibstyle .initial:n = { plain }
  }
%%%% ^^X <=|
%%%% ^^X 依存係設定缺省給 |=>
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%% ^^X 字體相關配置用 |=>
%%%% ^^X 全局基準字體參數設定 |=>
\tl_new:N \l__ncls_font_magscale_tl
\keys_define:nn { ncls }
  {
    fontsize .choice:,
    fontsize /  7pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 0.6940 } },
    fontsize /  8pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 0.8330 } },
    fontsize /  9pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 0.9130 } },
    fontsize / 10pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.0000 } },
    fontsize / 11pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.0953 } },
    fontsize / 12pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.2000 } },
    fontsize / 13pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.3000 } },
    fontsize / 14pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.4400 } },
    fontsize / 15pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.5000 } },
    fontsize / 16pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.6000 } },
    fontsize / 17pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 1.7280 } },
    fontsize / 20pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 2.0000 } },
    fontsize / 21pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 2.0740 } },
    fontsize / 24pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 2.4000 } },
    fontsize / 25pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 2.4880 } },
    fontsize / 30pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 2.9860 } },
    fontsize / 36pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 3.5830 } },
    fontsize / 43pt .code:n = { \tl_set:Nn \l__ncls_font_magscale_tl { 4.3000 } },
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
%%%% ^^X <=|
%%%% ^^X 語言設定 |=>
\str_new:N \l__ncls_lang_cj_str
\keys_define:nn { ncls }
  {
    language .choice:,
    language / trad .code:n = { \str_set:Nn \l__ncls_lang_cj_str { t } },
    language / smpl .code:n = { \str_set:Nn \l__ncls_lang_cj_str { s } },
    language / jp .code:n = { \str_set:Nn \l__ncls_lang_cj_str { j } },
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
%%%% ^^X <=|
%%%% ^^X 字體設定 |=>
\tl_new:N \l__ncls_font_mincho_tl
\tl_new:N \l__ncls_font_gothic_tl
\keys_define:nn { ncls }
  {
    mincho .tl_set:N = \l__ncls_font_mincho_tl,
    gothic .tl_set:N = \l__ncls_font_gothic_tl,
    mincho .value_required:n = true,
    gothic .value_required:n = true,
    mincho .initial:n = { HaranoAji Mincho },
    gothic .initial:n = { HaranoAji Gothic }
  }
%%%% ^^X <=|
%%%% ^^X 字間距 |=>
\tl_new:N \l__ncls_font_kanjiskip_tl
\keys_define:nn { ncls }
  {
    kanjiskip .tl_set:N = \l__ncls_font_kanjiskip_tl,
    kanjiskip .value_required:n = true,
    kanjiskip .initial:n = { \z@ \@plus .1\zw \@minus .01\zw }
  }
\tl_new:N \l__ncls_font_xkanjiskip_tl
\keys_define:nn { ncls }
  {
    xkanjiskip .tl_set:N = \l__ncls_font_xkanjiskip_tl,
    xkanjiskip .value_required:n = true,
    xkanjiskip .initial:n = .25em \@plus .15em \@minus .06em
  }
%%%% ^^X <=|
%%%% ^^X 字體縮放率設定 |=>
\tl_new:N \l__ncls_font_cjscale_tl
\keys_define:nn { ncls }
  {
    scale .tl_set:N = \l__ncls_font_cjscale_tl,
    scale .value_required:n = true,
    scale .initial:n = { 0.924715 }
  }
%%%% ^^X <=|
%%%% ^^X 字體矩陣高級設定 |=>
\bool_new:N \l__ncls_jfm_hanging_bool
\bool_new:N \l__ncls_jfm_linegap_bool
\keys_define:nn { ncls }
  {
    punct .multichoice:,
    punct / hanging .code:n = { \bool_set_true:N \l__ncls_jfm_hanging_bool },
    punct / linegap .code:n = { \bool_set_true:N \l__ncls_jfm_linegap_bool },
    punct .value_required:n = true
  }
%%%% ^^X <=|
%%%% ^^X 視覺字號補正 |=>
\bool_new:N \l__ncls_font_xreal_bool
\keys_define:nn { ncls }
  {
    magstyle .choice:,
    magstyle / real .code:n = { \bool_set_false:N \l__ncls_font_xreal_bool },
    magstyle / xreal .code:n = { \bool_set_true:N \l__ncls_font_xreal_bool },
    magstyle .value_required:n = true,
    magstyle .initial:n = { xreal }
  }
%%%% ^^X <=|
%%%% ^^X 回滾字體特性 |=>
\bool_new:N \l__ncls_font_fallback_bool
\tl_new:N \l__ncls_font_fallback_tl
\keys_define:nn { ncls }
  {
    fallback .code:n =
      {
        \bool_set_true:N \l__ncls_font_fallback_bool
        \tl_set:Nn \l__ncls_font_fallback_tl { #1 }
      },
    fallback .value_required:n = true
  }
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%% ^^X 初始化處理 |=>
\__ncls_keyoptions_process:n { ncls }
%%%%% ^^X <=|
%%%%% ^^X 衝突檢測 |=>
%%%% ^^X 選項設置 |=>
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%%% ^^X <=|
%%%%%% ^^X 主要特性 |=>
%%%%% ^^X 紙張尺寸配置 |=>
%%%% ^^X 全局宏申明 |=>
\prop_new:N \l__ncls_paper_sizelist_prop
\clist_new:N \l__ncls_paper_sizeconf_clist
%%%% ^^X <=|
%%%% ^^X 主要功能宏 |=>
\cs_new:Nn \__ncls_paper_addsize:nnn
  {
    \prop_put_if_new:Nnn \l__ncls_paper_sizelist_prop
      { #1 }
{ #2 , #3 }
  }
%%%% ^^X <=|
%%%% ^^X 尺寸參數設定 |=>
\__ncls_paper_addsize:nnn { a0  } {  841 mm } { 1189 mm }
\__ncls_paper_addsize:nnn { a1  } {  594 mm } {  841 mm }
\__ncls_paper_addsize:nnn { a2  } {  420 mm } {  594 mm }
\__ncls_paper_addsize:nnn { a3  } {  297 mm } {  420 mm }
\__ncls_paper_addsize:nnn { a4  } {  210 mm } {  297 mm }
\__ncls_paper_addsize:nnn { a5  } {  148 mm } {  210 mm }
\__ncls_paper_addsize:nnn { a6  } {  105 mm } {  148 mm }
\__ncls_paper_addsize:nnn { b0  } { 1000 mm } { 1414 mm }
\__ncls_paper_addsize:nnn { b1  } {  707 mm } { 1000 mm }
\__ncls_paper_addsize:nnn { b2  } {  500 mm } {  707 mm }
\__ncls_paper_addsize:nnn { b3  } {  353 mm } {  500 mm }
\__ncls_paper_addsize:nnn { b4  } {  250 mm } {  353 mm }
\__ncls_paper_addsize:nnn { b5  } {  176 mm } {  250 mm }
\__ncls_paper_addsize:nnn { b6  } {  125 mm } {  176 mm }
\__ncls_paper_addsize:nnn { c0  } {  917 mm } { 1297 mm }
\__ncls_paper_addsize:nnn { c1  } {  648 mm } {  917 mm }
\__ncls_paper_addsize:nnn { c2  } {  458 mm } {  648 mm }
\__ncls_paper_addsize:nnn { c3  } {  324 mm } {  458 mm }
\__ncls_paper_addsize:nnn { c4  } {  229 mm } {  324 mm }
\__ncls_paper_addsize:nnn { c5  } {  162 mm } {  229 mm }
\__ncls_paper_addsize:nnn { c6  } {  114 mm } {  162 mm }
\__ncls_paper_addsize:nnn { b0j } { 1030 mm } { 1456 mm }
\__ncls_paper_addsize:nnn { b1j } {  728 mm } { 1030 mm }
\__ncls_paper_addsize:nnn { b2j } {  515 mm } {  728 mm }
\__ncls_paper_addsize:nnn { b3j } {  364 mm } {  515 mm }
\__ncls_paper_addsize:nnn { b4j } {  257 mm } {  364 mm }
\__ncls_paper_addsize:nnn { b5j } {  182 mm } {  257 mm }
\__ncls_paper_addsize:nnn { b6j } {  128 mm } {  182 mm }
\__ncls_paper_addsize:nnn { screen } { 225 mm } { 180 mm }
%%%% ^^X <=|
%%%% ^^X 內部參數處理 |=>
\prop_get:NoN \l__ncls_paper_sizelist_prop
  { \l__ncls_paper_sizeinfo_tl }
  \l__ncls_paper_sizeinfo_tl
\clist_set:No \l_tmpa_clist
  { \l__ncls_paper_sizeinfo_tl }
\clist_pop:NN \l_tmpa_clist \l_tmpa_tl
\clist_pop:NN \l_tmpa_clist \l_tmpb_tl
%%%% ^^X <=|
%%%% ^^X 頁面方向 |=>
\bool_if:NTF \l__ncls_paper_portrait_bool
  {
    \dim_set:Nn \l_tmpa_dim
      { \tl_use:N \l_tmpa_tl }
    \dim_set:Nn \l_tmpb_dim
      { \tl_use:N \l_tmpb_tl }
  }
  {
    \dim_set:Nn \l_tmpa_dim
      { \tl_use:N \l_tmpb_tl }
    \dim_set:Nn \l_tmpb_dim
      { \tl_use:N \l_tmpa_tl }
  }
%%%% ^^X <=|
%%%% ^^X 輔助線判定 |=>
\bool_if:NT \l__ncls_paper_corpmark_mark_bool
  {
    \legacy_if_set_true:n { tombow }
    \bool_if:NTF \l__ncls_paper_corpmark_date_bool
      {
        \legacy_if_set_true:n { tombowdate }
        \dim_set:Nn \@tombowwidth { .1 \mpt }
        \@bannertoken
          {
            \str_use:N \c_sys_jobname_str
            \tl_use:N \c_space_tl (
            \int_use:N \c_sys_year_int -
            \exp_args:No \two@digits { \int_use:N \c_sys_month_int } -
            \exp_args:No \two@digits { \int_use:N \c_sys_day_int }
            \tl_use:N \c_space_tl
            \exp_args:No \two@digits { \int_use:N \c_sys_hour_int } :
            \exp_args:No \two@digits { \int_use:N \c_sys_minute_int } )
          }
        \maketombowbox
      }
      {
        \legacy_if_set_false:n { tombowdate }
        \dim_set:Nn \@tombowwidth { \z@ }
        \maketombowbox
      }
  }
%%%% ^^X <=|
%%%% ^^X 完成設置 |=>
\dim_set:Nn { \paperwidth } \l_tmpa_dim
\dim_set:Nn { \paperheight } \l_tmpb_dim
\bool_if:NT \l__ncls_paper_corpmark_mark_bool
  {
    \dim_if_exist:NF \stockwidth
      { \dim_new:N \stockwidth }
    \dim_if_exist:NF \stockheight
      { \dim_new:N \stockheight }
    \dim_set:Nn \stockwidth { \l_tmpa_dim + 2 in }
    \dim_set:Nn \stockheight { \l_tmpb_dim + 2 in }
    \dim_set_eq:NN \l_tmpa_dim \stockwidth
    \dim_set_eq:NN \l_tmpb_dim \stockheight
  }
\pdf_pagesize_gset:nn
  { \dim_use:N \l_tmpa_dim }
  { \dim_use:N \l_tmpb_dim }
%%%% ^^X <=|
%%%% ^^X 清除內存 |=>
\__ncls_macro_release:N \__ncls_paper_addsize:nnn
\__ncls_macro_release:N \g__ncls_paper_sizelist_prop
\__ncls_macro_release:N \l__ncls_paper_sizeinfo_tl
\__ncls_macro_release:N \l__ncls_paper_corpmark_mark_bool
\__ncls_macro_release:N \l__ncls_paper_corpmark_date_bool
\__ncls_macro_release:N \l__ncls_paper_portrait_bool
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%% ^^X 字體矩陣配置 |=>
%%%% ^^X 全局宏申明 |=>
\clist_new:N \l__ncls_jfm_feats_clist
%%%% ^^X <=|
%%%% ^^X 主要 |=>
\clist_set:Nn \l__ncls_jfm_feats_clist { nstd }
%%%% ^^X <=|
%%%% ^^X 內存管理 |=>
\__ncls_macro_release:N \l__ncls_jfm_feats_clist
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%% ^^X 選項設定 |=>
%%%% ^^X 組版方向設定 |=>
\bool_if:NT \l__ncls_layout_tate_bool
  {
    \RequirePackage { lltjext } \tate
    \__ncls_at_doc_beg:n
      {
        \iow_term:n {《縦組モード》} \adjustbaseline
      }
  }
%%%% ^^X <=|
%%%% ^^X 單雙欄設定 |=>
\bool_if:NTF \l__ncls_layout_restonecol_bool
  { \legacy_if_set_true:n { @twocolumn } }
  { \legacy_if_set_false:n { @twocolumn } }
%%%% ^^X <=|
%%%% ^^X 單雙面設定 |=>
\bool_if:NTF \l__ncls_layout_twoside_bool
  { \legacy_if_set_true:n { @twoside } }
  { \legacy_if_set_false:n { @twoside } }
\bool_if:NTF \l__ncls_layout_mparswitch_bool
  { \legacy_if_set_true:n { @mparswitch } }
  { \legacy_if_set_false:n { @mparswitch } }
%%%% ^^X <=|
%%%% ^^X 標題頁設定 |=>
%%%% ^^X <=|
%%%% ^^X 章節起設定 |=>
%%%% ^^X <=|
%%%% ^^X 編譯模式設定 |=>
%%%% ^^X <=|
%%%% ^^X 數學公式設定 |=>
\bool_if:NT \l__ncls_layout_fleqn_bool
  { \file_input:n { fleqn.clo } }
\bool_if:NT \l__ncls_layout_leqno_bool
  { \file_input:n { leqno.clo } }
%%%% ^^X <=|
%%%% ^^X 「開明」參考文獻設定 |=>
\bool_if:NT \l__ncls_layout_openbib_bool
  {
    \__ncls_at_doc_beg:n
      {
        \cs_set_nopar:Nn \@openbib@code
          {
            \dim_add:Nn \leftmargin { \bibindent }
            \dim_set_eq:Nn \itemindent { -\bibindent }
            \dim_set_eq:NN \listparindent \itemindent
            \dim_set:Nn \parsep { \z@ }
          }
        \cs_set_nopar:Nn \newblock { \par }
      }
  }
%%%% ^^X <=|
%%%% ^^X 內存管理 |=>
\__ncls_macro_release:N \l__ncls_layout_tate_bool
\__ncls_macro_release:N \l__ncls_layout_restonecol_bool
\__ncls_macro_release:N \l__ncls_layout_column_gap_tl
\__ncls_macro_release:N \l__ncls_layout_twoside_bool
\__ncls_macro_release:N \l__ncls_layout_mparswitch_bool
\__ncls_macro_release:N \l__ncls_layout_titlepage_bool
\__ncls_macro_release:N \l__ncls_layout_doctype_bool
\__ncls_macro_release:N \l__ncls_layout_openleft_bool
\__ncls_macro_release:N \l__ncls_layout_openright_bool
\__ncls_macro_release:N \l__ncls_layout_draft_bool
\__ncls_macro_release:N \l__ncls_layout_fleqn_bool
\__ncls_macro_release:N \l__ncls_layout_leqno_bool
\__ncls_macro_release:N \l__ncls_layout_openbib_bool
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%% ^^X 字體相關配置 |=>
%%%% ^^X 全局宏申明 |=>
\tl_new:N \l__ncls_font_langfeat_tl
%%%% ^^X <=|
%%%% ^^X 主要設定 |=>
\str_if_eq:VnT \l__ncls_lang_cj_str { t }
  {
    \clist_put_left:Nn \l__ncls_jfm_feats_clist { trad }
    \tl_set:Nn \l__ncls_font_langfeat_tl { Chinese~Traditional }
  }
\str_if_eq:VnT \l__ncls_lang_cj_str { s }
  {
    \clist_put_left:Nn \l__ncls_jfm_feats_clist { smpl }
    \tl_set:Nn \l__ncls_font_langfeat_tl { Chinese~Simplified }
  }
\str_if_eq:VnT \l__ncls_lang_cj_str { j }
  {
    \clist_put_left:Nn \l__ncls_jfm_feats_clist { jp }
    \tl_set:Nn \l__ncls_font_langfeat_tl { Japanese }
  }
%%%% ^^X <=|
%%%% ^^X 字體矩陣高級設置 |=>
\bool_if:NT \l__ncls_jfm_hanging_bool
  { \clist_put_left:Nn \l__ncls_jfm_feats_clist { hgp } }
\bool_if:NT \l__ncls_jfm_linegap_bool
  { \clist_put_left:Nn \l__ncls_jfm_feats_clist { lgp } }
%%%% ^^X <=|
%%%% ^^X 載入中日文支持宏集 |=>
\tl_set:Nx \Cjascale { \tl_use:N \l__ncls_font_cjscale_tl }
\tl_set:Nx \ltj@stdmcfont { \tl_use:N \l__ncls_font_mincho_tl }
\tl_set:Nx \ltj@stdgtfont { \tl_use:N \l__ncls_font_gothic_tl }
\tl_set:Nx \ltj@stdyokojfm
  { eva / { \clist_use:Nn \l__ncls_jfm_feats_clist { , } } }
\tl_set:Nx \ltj@stdtatejfm
  { eva / { \clist_use:Nn \l__ncls_jfm_feats_clist { , } , vert } }
\RequirePackage { luatexja }
\RequirePackage { luatexja-adjust }
\ltjenableadjust
  [
    lineend = extended,
    priority = true
  ]
%%%% ^^X <=|
%%%% ^^X 補正用單位 |=>
\dim_set:Nn \mpt { \l__ncls_font_magscale_tl \p@ }
\dim_compare:nNnT
  { \mpt } < { 1 \p@ }
  { \tl_set:Nn \@ptsize { -20 } }
\dim_compare:nNnT
  { \mpt } = { 1\p@ }
  { \tl_set:Nn \@ptsize { 0 } }
\dim_compare:nNnT
  { \mpt } = { 1.095 \p@ }
  { \tl_set:Nn \@ptsize { 1 } }
\dim_compare:nNnT
  { \mpt } = { 1.200 \p@ }
  { \tl_set:Nn \@ptsize { 2 } }
\dim_compare:nNnT
  { \mpt } > { 1.200 \p@ }
  { \tl_set:Nn \@ptsize { -20 } }
%%%% ^^X <=|
%%%% ^^X 視覺字號補正 |=>
\bool_if:NTF \l__ncls_font_xreal_bool
  {
    \dim_compare:nNnT
      { \mpt } = { \p@ }
      { \bool_set_false:N \l__ncls_font_xreal_bool }
  }
  { \dim_set:Nn \mpt { \p@ } }
\bool_if:NT \l__ncls_font_xreal_bool
  {
    \exp_after:wN \cs_set_eq:NN \cs:w TU/lmr/m/n/10 \cs_end: \scan_stop:
    \exp_after:wN \cs_set_eq:NN \cs:w OMX/cmex/m/n/10 \cs_end: \scan_stop:
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
            tex.sprint(-2, (s:match('%.0\$')) and s:sub(1, -3) or s)
          end
        }
      \group_end:
      \cs_new:Npn \__ncls_magnify_external_font:w #1~at #2~at #3 \q_nil
        {
          \tl_set:Nn \l_tmpa_tl { #1 }
          \tl_set:Nn \l_tmpb_tl { #2 }
          \tl_if_empty:NTF \l_tmpb_tl
            {
              \tl_set:Nx \l_tmpb_tl
                {
                  scaled \lua_now:e { tex.sprint(-2, math.floor(0.5 + \l__ncls_font_magscale_tl * 1000)) }
                }
            }
            {
              \dim_set:Nn \dimen@ { \tl_use:N \l_tmpb_tl }
              \tl_set:Nx \l_tmpb_tl
                { at \__ncls_luafunc_use:N \__ncls_magnify_font_calc~sp }
            }
          \tl_set:Nx \l_tmpa_tl
            {
              \tl_set:Nn \exp_not:N \external@font
                { \tl_use:N \l_tmpa_tl \tl_use:N \l_tmpb_tl }
            }
        }
      \cs_new_eq:NN \__ncls_get_externalfont_orig: { \get@external@font }
      \cs_set:Nn \get@external@font
        {
          \tl_set:Nx \f@size
            { \lua_now:e { luatexja.ncls_unmagnify_fsize(\f@size) } }
          \__ncls_get_externalfont_orig:
          \group_begin:
            \tl_set:Nx \l_tmpa_tl
              { \external@font \tl_use:N \c_space_tl~at \tl_use:N \c_space_tl~at }
            \exp_after:wN \__ncls_magnify_external_font:w \tl_use:N \l_tmpa_tl \q_nil
            \exp_after:wN
          \group_end:
          \tl_use:N \l_tmpa_tl
        }
  }
%%%% ^^X <=|
%%%% ^^X 回滾字體可選特性 |=>
\bool_if:NT \l__ncls_font_fallback_bool
  {
    \group_begin:
      \char_set_catcode_space:n { 32 }
      \lua_now:e
        {
          luaotfload.add_fallback
            (
              " nclsfallback ",
              { " \tl_use:N \l__ncls_font_fallback_tl : mode = node ; script = cjk ; language = \tl_use:N \l__ncls_font_langfeat_tl " }
            )
        }
    \group_end:
  }
%%%% ^^X <=|
%%%% ^^X 中日NFSS設定 |=>
\exp_after:wN \cs_set_eq:NN \cs:w JY3/mc/m/n/10 \cs_end: \scan_stop:
\cs_new:Nn \__ncls_font_declareshape:nnnn
  {
    \bool_if:NTF \l__ncls_font_fallback_bool
      {
        \DeclareFontShape { #1 } { #2 } { m } { n }
          {
            <-> s * [ \tl_use:N \l__ncls_font_cjscale_tl ] #3 :
            - kern ; script = cjk ; language = \tl_use:N \l__ncls_font_langfeat_tl ;
            jfm = eva / { \clist_use:Nn \l__ncls_jfm_feats_clist { , } #4 } ;
            fallback = nclsfallback
					} { }
      }
      {
        \DeclareFontShape { #1 } { #2 } { m } { n }
          {
            <-> s * [ \tl_use:N \l__ncls_font_cjscale_tl ] #3 :
            - kern ; script = cjk ; language = \tl_use:N \l__ncls_font_langfeat_tl ;
            jfm = eva / { \clist_use:Nn \l__ncls_jfm_feats_clist { , } #4 }
					} { }
      }
  }
\__ncls_font_declareshape:nnnn { JY3 } { mc } { \tl_use:N \l__ncls_font_mincho_tl } { }
\__ncls_font_declareshape:nnnn { JY3 } { gt } { \tl_use:N \l__ncls_font_gothic_tl } { }
\__ncls_font_declareshape:nnnn { JT3 } { mc } { \tl_use:N \l__ncls_font_mincho_tl } { , vert }
\__ncls_font_declareshape:nnnn { JT3 } { gt } { \tl_use:N \l__ncls_font_gothic_tl } { , vert }
\clist_map_inline:nn { JY3, JT3 }
  {
    \clist_map_inline:nn { n, it, sl, sc }
      {
        \clist_map_inline:nn { m, b, bx, sb }
          {
            \bool_if:nF { \str_if_eq_p:nn { ##1 } { n } && \str_if_eq_p:nn { ####1 } { m } }
              { \DeclareFontShape { #1 } { gt } { ####1 } { ##1 } { <-> ssub * gt/m/n } { } }
          }
        \str_if_eq:nnF { ##1 } { n }
          { \DeclareFontShape { #1 } { mc } { m } { ##1 } { <-> ssub * mc/m/n } { } }
        \clist_map_inline:nn { b, bx, sb }
          { \DeclareFontShape { #1 } { mc } { ####1 } { ##1 } { <-> ssub * gt/m/n } { } }
      }
  }
%%%% ^^X <=|
%%%% ^^X 字體尺寸及連結參數 |=>
\cs_set:Npn \@setfontsize #1 #2 #3
  {
    \ExplSyntaxOn
    \cs_if_eq:NNT \protect \@typeset@protect
      { \tl_set:Nn \@currsize { #1 } }
    \fontsize { #2 } { #3 } \selectfont
    \dim_compare:nNnT { \parindent } > { \z@ }
      {
        \str_if_eq:VnTF \l__ncls_lang_cj_str { j }
          { \dim_set:Nn \parindent { 1 \zw } }
          { \dim_set:Nn \parindent { 2 \zw } }
        \bool_if:NT \l__ncls_layout_english_bool
          { \dim_set:Nn \parindent { 1 em } }
      }
    \ltj@setpar@global
    \exp_after:wN \ltjsetkanjiskip \tl_use:N \l__ncls_font_kanjiskip_tl
    \dim_set:Nn \l_tmpa_dim { \ltjgetparameter { xkanjiskip } }
    \dim_compare:nNnT { \l_tmpa_dim } > { \z@ }
      { \exp_after:wN \ltjsetxkanjiskip \tl_use:N \l__ncls_font_xkanjiskip_tl }
  }
\cs_new:Nn \__ncls_font_setsize:nnn
  { \@setfontsize #1 { #2 \mpt } { #3 \mpt } }
%%%% ^^X <=|
%%%% ^^X 行距設定 |=>
\newif \ifnarrowbaselines
\cs_new:Nn \__ncls_baseline_narrow:
  {
    \ExplSyntaxOn
    \legacy_if_set_true:n { narrowbaselines }
    \skip_new:N \l__ncls_abovedisplay_temp_skip
    \skip_new:N \l__ncls_abovedisplayshort_temp_skip
    \skip_new:N \l__ncls_belowdisplay_temp_skip
    \skip_new:N \l__ncls_belowdisplayshort_temp_skip
    \skip_set_eq:NN \l__ncls_abovedisplay_temp_skip \abovedisplayskip
    \skip_set_eq:NN \l__ncls_abovedisplayshort_temp_skip \abovedisplayshortskip
    \skip_set_eq:NN \l__ncls_belowdisplay_temp_skip \belowdisplayskip
    \skip_set_eq:NN \l__ncls_belowdisplayshort_temp_skip \belowdisplayshortskip
    \@currsize \selectfont
    \skip_set_eq:NN \abovedisplayskip \l__ncls_abovedisplay_temp_skip
    \skip_set_eq:NN \abovedisplayshortskip \l__ncls_abovedisplayshort_temp_skip
    \skip_set_eq:NN \belowdisplayskip \l__ncls_belowdisplay_temp_skip
    \skip_set_eq:NN \belowdisplayshortskip \l__ncls_belowdisplayshort_temp_skip
    \ExplSyntaxOff
  }
\cs_new:Nn \__ncls_baseline_wide:
  {
    \ExplSyntaxOn
    \legacy_if_set_false:n { narrowbaselines }
    \@currsize \selectfont
    \ExplSyntaxOff
  }
\cs_new:Npn \__ncls_baseline_ifnarrow:nn
  {
    \legacy_if:nTF { narrowbaselines }
  { \use_i:nn }
      { \use_ii:nn }
  }
%%%% ^^X <=|
%%%% ^^X 字體尺寸 |=>
\cs_set:Npn \normalsize
{
    \__ncls_baseline_ifnarrow:nn
  { \__ncls_font_setsize:nnn { \normalsize } { 10 pt } { 12 pt } }
{ \__ncls_font_setsize:nnn { \normalsize } { 10 pt } { 16 pt } }
    \skip_set:Nn \abovedisplayskip { 11 \mpt~plus 3\mpt~minus 4\mpt } % FIXME
    \skip_set:Nn \abovedisplayshortskip { 0 \mpt~plus 3\mpt } % FIXME
\skip_set:Nn \belowdisplayskip { 9 \mpt~plus 3\mpt~4\mpt } % FIXME
\skip_set:Nn \belowdisplayshortskip { 0 \mpt~plus 3 \mpt } % FIXME
\cs_new_eq:NN \@listi \@listI
}
\mcfamily \selectfont \normalsize
\hbox_set:Nn \l_tmpa_box { 年 }
\dim_new:N \Cht
\dim_new:N \Cdp
\dim_new:N \Cwd
\dim_new:N \Cvs
\dim_new:N \Chs
\dim_set:Nn \Cht { \box_ht:N \l_tmpa_box }
\dim_set:Nn \Cdp { \box_dp:N \l_tmpa_box }
\dim_set:Nn \Cwd { \box_wd:N \l_tmpa_box }
\dim_set:Nn \Cvs { \baselineskip }
%%%% ^^X <=|
%%%% ^^X 清理內存 |=>
\__ncls_macro_release:N \l__ncls_font_magscale_tl
\__ncls_macro_release:N \l__ncls_lang_cj_str
\__ncls_macro_release:N \l__ncls_font_langfeat_tl
\__ncls_macro_release:N \l__ncls_font_mincho_tl
\__ncls_macro_release:N \l__ncls_font_gothic_tl
\__ncls_macro_release:N \l__ncls_font_cjscale_tl
\__ncls_macro_release:N \l__ncls_jfm_hanging_tl
\__ncls_macro_release:N \l__ncls_jfm_linegap_tl
\__ncls_macro_release:N \l__ncls_font_xreal_bool
\__ncls_macro_release:N \l__ncls_font_fallback_bool
\__ncls_macro_release:N \l__ncls_font_fallback_tl
\__ncls_macro_release:N \__ncls_font_declareshape:nnnn
%%%% ^^X <=|
%%%%% ^^X <=|
%%%%%% ^^X <=|
%%%%%% ^^X 退場 |=>
\relax \endinput
%%%%%% ^^X <=|
