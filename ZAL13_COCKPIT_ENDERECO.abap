*&---------------------------------------------------------------------*
*& Report ZAL13_COCKPIT_ENDERECO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zal13_cockpit_endereco.

INCLUDE: zal13_cockpit_endereco_top,
         zal13_cockpit_endereco_f01.

START-OF-SELECTION.
  CALL SCREEN 9013.

INCLUDE zal13_cockpit_endereco_o01.

INCLUDE zal13_cockpit_endereco_i01.
