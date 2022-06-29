PROGRAM INIT
        ! TEST IF STATS ARE CORRECTLY COMPUTED
        USE FIELD_MODULE
        IMPLICIT NONE
        TYPE(FIELD_2D_WRAPPER) :: W
        REAL(KIND=JPRB), ALLOCATABLE :: D(:,:)
        REAL(KIND=JPRB), POINTER :: D_GPU(:,:)
        REAL(KIND=JPRB), POINTER :: D_CPU(:,:)

        ALLOCATE(D(10,10))

        CALL W%INIT(D)
        CALL W%MOVE_DATA_TO_DEVICE_RDONLY(D_GPU)
        CALL W%MOVE_DATA_TO_DEVICE_RDONLY(D_GPU)
        ! SHOULD BE 1 BECAUSE THE DATA HAVE NOT CHENGED BETWEEN THE TWO MOVE
        IF (W%STATS%TRANSFER_CPU_TO_GPU /= 1) THEN
                ERROR STOP
        END IF
        IF (W%STATS%TOTAL_TIME_TRANSFER_CPU_TO_GPU == 0) THEN
                ERROR STOP
        END IF

        CALL W%MOVE_DATA_FROM_DEVICE_RDONLY(D_CPU)
        ! SHOULD BE ZERO, SINCE WE HAVE NOT MODIFED DATA ON THE GPU, THERE IS NO
        ! NEED TO TRANSFER DATA BACK ON CPU, THEY SHOULD BE STILL THE SAME
        IF (W%STATS%TRANSFER_GPU_TO_CPU /= 0) THEN
                ERROR STOP
        END IF

        ! PRETEND WE WILL MODIFIED THE DATA ON THE GPU
        CALL W%MOVE_DATA_TO_DEVICE_RDWR(D_GPU)
        CALL W%MOVE_DATA_FROM_DEVICE_RDONLY(D_CPU)
        ! SHOULD BE STILL ONE, BECAUSE WE ALREADY MOVED DATA ON THE GPU BEFORE
        ! AND THEY HAVE NOT BEEN MODIFIED SINCE
        IF (W%STATS%TRANSFER_CPU_TO_GPU /= 1) THEN
                ERROR STOP
        END IF
        IF(W%STATS%TRANSFER_GPU_TO_CPU /= 1 ) THEN
                ERROR STOP
        END IF
        write(*,*)w%stats

END PROGRAM INIT