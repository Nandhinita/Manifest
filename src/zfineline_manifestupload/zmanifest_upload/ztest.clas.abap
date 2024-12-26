CLASS ztest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztest IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
      " Delete the entries
DELETE FROM zsupplier_conf.
  ENDMETHOD.
ENDCLASS.
