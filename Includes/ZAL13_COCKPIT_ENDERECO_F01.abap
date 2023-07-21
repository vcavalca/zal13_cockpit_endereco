*&---------------------------------------------------------------------*
*&  Include           ZAL13_COCKPIT_ENDERECO_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_GET_DADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_dados .
  DATA: lo_calculo   TYPE REF TO zcl13_calcula_bonus,
        lv_hire_date TYPE sy-datum,
        lv_days      TYPE  numc3,
        lv_months    LIKE  t5a4a-dlymo,
        lv_signum    LIKE  t5a4a-split,
        lv_years     LIKE  t5a4a-dlyyr,
        lv_qtddias   TYPE j_1befd_qtd,
        lv_calculo   TYPE betrg.

  CREATE OBJECT lo_calculo.

  SELECT pernr, cname INTO TABLE @DATA(lt_pa0002)
      FROM pa0002
     WHERE pernr EQ @gwa_pa0006-pernr.

  IF sy-subrc EQ 0.

    LOOP AT lt_pa0002 INTO DATA(lwa_pa0002).
      CLEAR gwa_relatorio.
      gwa_relatorio-pernr = lwa_pa0002-pernr.
      gwa_relatorio-cname = lwa_pa0002-cname.

      " LOGICA PARA BUSCAR A DATA DE CONTRATACAO DO FUNCIONRIO
      CLEAR lv_hire_date.
      lv_days = 0.
      lv_months = 0.
      lv_years = 0.
      lv_signum = '+'.

      CALL FUNCTION 'RP_GET_HIRE_DATE'
        EXPORTING
          persnr          = gwa_relatorio-pernr
          check_infotypes = '0000'
        IMPORTING
          hiredate        = lv_hire_date.

      gwa_relatorio-hire_date = lv_hire_date.

      CALL FUNCTION 'ZAL13_CALC_DIAS'
        EXPORTING
          p_in_data_inicio = gwa_relatorio-hire_date
          p_in_data_final  = sy-datum
        IMPORTING
          p_out_qtd_dias   = lv_qtddias.

      gwa_relatorio-qtdedias = lv_qtddias.

      IF sy-subrc EQ 0.

        CALL METHOD lo_calculo->get_calcula_bonus
          EXPORTING
            in_pernr  = lwa_pa0002-pernr
          IMPORTING
            out_bonus = lv_calculo.

        gwa_relatorio-valorcalculado = lv_calculo.
      ENDIF.
      APPEND gwa_relatorio TO gt_relatorio.

    ENDLOOP.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_IMPRIME_DADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_imprime_dados .

  PERFORM cabecalho.
  PERFORM monta_layout.
  PERFORM monta_campo.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout              = ty_layout           "estrutura com detalhes do layout.
      i_callback_top_of_page = 'TOP_PAGE'          "Estrutura para montar o cabeçalho
      i_callback_program     = sy-repid            "variável do sistema (nome do programa). 'Sy-repid' = 'zcurso_alv1'
*     I_CALLBACK_USER_COMMAND = 'F_USER_COMMAND'    "Chama a função "HOTSPOT"
      i_save                 = 'A'                 "layouts podem ser salvos (aparece os botões para alteração do layout).
*     it_sort                = t_sort[]             "Efetua a quebra com o parametro determinado.
      it_fieldcat            = ty_fieldcat_col     "tabela com as colunas a serem impressas.
    TABLES
      t_outtab               = gt_relatorio.          "Tabela com os dados a serem impressos.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CABECALHO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cabecalho .

  DATA: vl_data(10),
        vl_hora(10).

  CLEAR ty_watop.
  ty_watop-typ  = 'H'.    "H = Grande, destaque | S = Pequena | A = Média com itálico
  ty_watop-info = TEXT-m01.

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.
  CONCATENATE TEXT-m02 sy-uname
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

  CLEAR ty_watop.

  ty_watop-typ  = 'S'.

  WRITE sy-datum TO vl_data USING EDIT MASK '__/__/____'.
  WRITE sy-uzeit TO vl_hora USING EDIT MASK '__:__'.

  CONCATENATE TEXT-m03 vl_data  vl_hora
    INTO ty_watop-info
      SEPARATED BY space.

  APPEND ty_watop TO ty_top.

ENDFORM.                    " CABECALHO

*&**********************************************************************
*&      Form  top_page                                                 *
*&**********************************************************************
*       Define o cabeçalho do ALV
*----------------------------------------------------------------------*
FORM top_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ty_top.
*      I_LOGO             = ''.

ENDFORM.                    "top_page

*&---------------------------------------------------------------------*
*&      Form  MONTA_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM monta_layout .
  ty_layout-zebra             = 'X'.                            "Zebrado
  ty_layout-colwidth_optimize = 'X'.                            "Otimizar larguras de colunas automaticamente
ENDFORM.                    " MONTA_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  MONTA_CAMPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM monta_campo .
  "CLEAR IT_HRP1000.

  PERFORM monta_coluna USING  'PERNR'          'GT_RELATORIO' TEXT-t01      ' '  ' '  '80'  ' '  'L' ' '.
  PERFORM monta_coluna USING  'CNAME'          'GT_RELATORIO' TEXT-t02      ' '  ' '  '80'  ' '  'L' ' '.
  PERFORM monta_coluna USING  'HIRE_DATE'      'GT_RELATORIO' TEXT-t03      ' '  ' '  '50'  ' '  'L' ' '.
  PERFORM monta_coluna USING  'QTDEDIAS'       'GT_RELATORIO' TEXT-t04      ' '  ' '  '50'  ' '  'L' ' '.
  PERFORM monta_coluna USING  'VALORCALCULADO' 'GT_RELATORIO' TEXT-t05      ' '  ' '  '50'  ' '  'L' ' '.

ENDFORM.                    " MONTA_CAMPO

*&---------------------------------------------------------------------*
*&       FORM MONTA_COLUNA                                             *
*----------------------------------------------------------------------*
*        Limpa todas as tabelas e variáveis.
*----------------------------------------------------------------------*
FORM monta_coluna USING p_fieldname
                        p_tabname
                        p_texto
                        p_ref_fieldname
                        p_ref_tabname
                        p_outputlen
                        p_emphasize
                        p_just
                        p_do_sum.
  "P_ICON.

  ADD 1 TO vg_nrcol.
  ty_fieldcat-col_pos       = vg_nrcol.            "POSIÇÃO DO CAMPO (COLUNA).
  ty_fieldcat-fieldname     = p_fieldname.         "CAMPO DA TABELA INTERNA.
  ty_fieldcat-tabname       = p_tabname.           "TABELA INTERNA.
  ty_fieldcat-seltext_l     = p_texto.             "NOME/TEXTO DA COLUNA.
  ty_fieldcat-ref_fieldname = p_ref_fieldname.     "CAMPO DE REFERÊNCIA.
  ty_fieldcat-ref_tabname   = p_ref_tabname.       "TABELA DE REFERÊNCIA.
  ty_fieldcat-outputlen     = p_outputlen.         "LARGURA DA COLUNA.
  ty_fieldcat-emphasize     = p_emphasize.         "COLORE UMA COLUNA INTEIRA.
  ty_fieldcat-just          = p_just.              "
  ty_fieldcat-do_sum        = p_do_sum.            "TOTALIZA.
  "TY_FIELDCAT-ICON          = P_ICON.

  APPEND ty_fieldcat TO ty_fieldcat_col.           "Insere linha na tabela interna TY_FIELDCAT_COL.

ENDFORM.                    " F_monta_coluna
