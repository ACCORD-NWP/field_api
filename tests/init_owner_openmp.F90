PROGRAM INIT_OWNER_OPENMP
        ! TEST IF OWNER IS REALLY ALLOCATING THE DATA
        ! WHEN PERSITENT IS SET TO FALSE OR IS NOT GIVEN IN ARGUMENT,
        ! THEN THE LAST DIM OF THE FIELD IS THE NUMBER OF OPENMP THREADS

        USE FIELD_MODULE
        USE OMP_LIB
        IMPLICIT NONE
        TYPE(FIELD_2D_OWNER) :: O
        REAL(KIND=JPRB), POINTER :: PTR(:,:)

        CALL OMP_SET_NUM_THREADS(4)
        CALL O%INIT([10,1], [21,11])
        CALL O%GET_HOST_DATA_RDWR(PTR)
        PTR=42

        IF (SIZE(O%PTR,1) /= 12) THEN
                ERROR STOP
        END IF
        !4 BECAUSE WE SET THE NUMBER OF THREADS TO 4
        IF (SIZE(O%PTR,2) /= 4) THEN
                ERROR STOP
        END IF

        IF (.NOT. ALL(O%PTR == 42)) THEN
                ERROR STOP
        END IF 
END PROGRAM INIT_OWNER_OPENMP