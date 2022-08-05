MODULE POINT_TO
        IMPLICIT NONE
CONTAINS
        SUBROUTINE POINT_TO_WRAPPER(PTR)
                USE FIELD_MODULE
                IMPLICIT NONE
                CLASS(FIELD_2D), POINTER, INTENT(INOUT) :: PTR
                TYPE(FIELD_2D_WRAPPER), POINTER :: W
                REAL(KIND=JPRB), POINTER :: DATA(:,:)
                ALLOCATE(DATA(10,10))
                ALLOCATE(W)
                CALL W%INIT(DATA)
                PTR => W                                        
        END SUBROUTINE
        SUBROUTINE POINT_TO_OWNER(PTR)
                USE FIELD_MODULE
                IMPLICIT NONE
                CLASS(FIELD_2D), POINTER, INTENT(INOUT) :: PTR
                TYPE(FIELD_2D_OWNER), POINTER :: O
                ALLOCATE(O)
                CALL O%INIT(LBOUNDS=[1,1],UBOUNDS=[10,10])
                PTR => O                                        
        END SUBROUTINE
END MODULE POINT_TO

PROGRAM POINTER_TO_OWNER_WRAPPER
        USE FIELD_MODULE
        USE POINT_TO
        IMPLICIT NONE

        TYPE(FIELD_2D_PTR) :: PTR
        CALL POINT_TO_WRAPPER(PTR%PTR)
        CALL PTR%PTR%FINAL()
        CALL POINT_TO_OWNER(PTR%PTR)
        CALL PTR%PTR%FINAL()
END PROGRAM POINTER_TO_OWNER_WRAPPER