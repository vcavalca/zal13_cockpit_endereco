*&---------------------------------------------------------------------*
*&  Include           ZAL13_COCKPIT_ENDERECO_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*** Declaração das tabelas
*&---------------------------------------------------------------------*

TABLES: pa0006,
        pa0002,
        zal13_comp_calc,
        zal13_conf_calc,
        zal13_calc_salvo.

*&---------------------------------------------------------------------*
*** Declaração dos tipos
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_relatorio,
         pernr          TYPE pa0002-pernr,
         cname          TYPE pa0002-cname,
         qtdedias       TYPE i,
         hire_date      TYPE sy-datum,
         valorcalculado TYPE betrg,
       END OF ty_relatorio.

*&---------------------------------------------------------------------*
*** Declaração das tabelas internas
*&---------------------------------------------------------------------*

DATA: gt_pa0006          TYPE STANDARD TABLE OF pa0006,
      gt_pa0002          TYPE TABLE OF pa0002,
      gt_zal13_comp_calc TYPE TABLE OF zal13_comp_calc,
      gt_zal13_conf_calc TYPE TABLE OF zal13_conf_calc,
      gt_relatorio       TYPE TABLE OF ty_relatorio,
      gt_zal3_calc_salvo TYPE TABLE OF zal13_calc_salvo.

*&---------------------------------------------------------------------*
*** Declaração das work areas globais
*&---------------------------------------------------------------------*

DATA: gwa_pa0006           TYPE pa0006,
      gwa_pa0002           TYPE pa0002,
      gwa_zal13_comp_calc  TYPE zal13_comp_calc,
      gwa_zal13_conf_calc  TYPE zal13_conf_calc,
      gwa_relatorio        TYPE ty_relatorio,
      gwa_zal13_calc_salvo TYPE zal13_calc_salvo.

*&---------------------------------------------------------------------*
*** Declaração dos campos module
*&---------------------------------------------------------------------*

DATA: gv_name_func     TYPE pa0002-cname,
      gv_primeiro_nome TYPE pa0002-vorna,
      gv_sobrenome     TYPE pa0002-nachn,
      gv_cidade        TYPE pa0006-ort01,
      gv_bairro        TYPE pa0006-ort02,
      gv_nascimento    TYPE pa0002-gbdat.

*&---------------------------------------------------------------------*
*&  ESTRUTURAS DO ALV                                                  *
*&---------------------------------------------------------------------*
DATA:  vg_nrcol(4) TYPE c.

DATA: ty_layout       TYPE slis_layout_alv,
      ty_top          TYPE slis_t_listheader,
      ty_watop        TYPE slis_listheader,
      ty_fieldcat_col TYPE slis_t_fieldcat_alv,
      ty_fieldcat     TYPE slis_fieldcat_alv,
      ty_events       TYPE slis_t_event.

DATA : sch_repid TYPE sy-repid,
       sch_dynnr TYPE sy-dynnr,
       sch_field TYPE dynpread-fieldname,
       sch_objec TYPE objec,
       sch_subrc TYPE sy-subrc,
       per_beg   TYPE sy-datum,
       per_end   TYPE sy-datum.

TABLES hrvpv6a.
