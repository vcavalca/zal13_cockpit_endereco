*----------------------------------------------------------------------*
***INCLUDE ZAL13_COCKPIT_ENDERECO_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9013  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9013 INPUT.
  DATA lv_pernr TYPE pa0002-pernr.
  DATA lo_update TYPE REF TO zcl13_update_end.
  DATA lo_bairro TYPE REF TO zcl13_update_end.
  DATA lv_message TYPE string.

  CASE sy-ucomm.
    WHEN 'FFIND'.
      CLEAR gv_name_func.
      CLEAR gv_primeiro_nome.
      CLEAR gv_sobrenome.
      CLEAR gv_cidade.
      CLEAR gv_bairro.
      lv_pernr = gwa_pa0006-pernr.

      SELECT SINGLE cname, vorna, nachn, gbdat INTO @DATA(lwa_name)
        FROM pa0002
       WHERE pernr EQ @gwa_pa0006-pernr.

      IF sy-subrc EQ 0.
        gv_name_func = lwa_name-cname.
        gv_primeiro_nome = lwa_name-vorna.
        gv_sobrenome = lwa_name-nachn.
        gv_nascimento = lwa_name-gbdat.
      ENDIF.

      SELECT SINGLE stras, ort01, ort02 INTO @DATA(lwa_endereco)
        FROM pa0006
       WHERE pernr EQ @gwa_pa0006-pernr
         AND begda <= @sy-datum
         AND endda >= @sy-datum.

      IF sy-subrc EQ 0.
        gwa_pa0006-stras = lwa_endereco-stras.
        gv_cidade = lwa_endereco-ort01.
        gv_bairro = lwa_endereco-ort02.
        gwa_pa0006-ort02 = lwa_endereco-ort02.
      ENDIF.

    WHEN 'FEDIT'.
      CREATE OBJECT lo_update.
      CREATE OBJECT lo_bairro.

      CALL METHOD lo_update->set_endereco
        EXPORTING
          in_pernr      = lv_pernr
          novo_endereco = gwa_pa0006-stras
        IMPORTING
          out_msg       = lv_message.

      CALL METHOD lo_bairro->set_bairro
        EXPORTING
          in_pernr  = lv_pernr
          in_bairro = gwa_pa0006-ort02
        IMPORTING
          out_msg   = lv_message.

      MESSAGE lv_message TYPE 'I'.

    WHEN 'FPRINT'.

      PERFORM f_get_dados.
      PERFORM f_imprime_dados.

    WHEN 'ENTE' OR 'CANCEL' OR 'BACK'.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
