  method SET_BAIRRO.

    data lwa_p0006 type p0006.
    data lwa_return type bapireturn1.

    call function 'HR_EMPLOYEE_ENQUEUE'
      exporting
        number = in_pernr
      importing
        RETURN = lwa_return.

    if lwa_return is initial.
      clear lwa_return.
      select single * into @data(lwa_pa0006)
              from pa0006
             where pernr eq @in_pernr
               and begda <= @sy-datum
               and endda >= @sy-datum.

      if sy-subrc eq 0.
        move-corresponding lwa_pa0006 to lwa_p0006.

        lwa_p0006-ort02 = in_bairro.

        lwa_p0006-infty = '0006'.

        call function 'HR_INFOTYPE_OPERATION'
          exporting
            infty         = '0006'
            number        = in_pernr
            subtype       = lwa_p0006-subty
            validityend   = lwa_p0006-endda
            validitybegin = lwa_p0006-begda
*           RECORDNUMBER  =
            record        = lwa_p0006
            operation     = 'MOD'
*           TCLAS         = 'A'
*           DIALOG_MODE   = '0'
*           NOCOMMIT      =
*           VIEW_IDENTIFIER        =
*           SECONDARY_RECORD       =
          importing
            return        = lwa_return.

        if lwa_return is not initial.
          out_msg = lwa_return-message.

          ELSE.

            "out_msg = 'Endereço Atualizado'.
            MESSAGE S000(ZCL13_MENSAGEM) INTO out_msg.

        endif.

        call function 'HR_EMPLOYEE_DEQUEUE'
          exporting
            number = in_pernr.

      endif.
    else.
      out_msg = lwa_return-message.

    endif.

  endmethod.
