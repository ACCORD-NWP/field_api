!Copyright 2023 Meteo-France, ECMWF 
!
!Licensed under the Apache License, Version 2.0 (the "License");
!you may not use this file except in compliance with the License.
!You may obtain a copy of the License at
!
!    http://www.apache.org/licenses/LICENSE-2.0
!
!    Unless required by applicable law or agreed to in writing, software
!    distributed under the License is distributed on an "AS IS" BASIS,
!    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!    See the License for the specific language governing permissions and
!    limitations under the License.

PROGRAM FINAL_WRAPPER_GPU
        ! TEST IF DATA ARE CORRECTLY TRANSFERED ON CPU WHEN CALLING FNAL
        USE FIELD_MODULE
        USE FIELD_FACTORY_MODULE
        USE PARKIND1
        IMPLICIT NONE
        CLASS(FIELD_2RB), POINTER :: W => NULL()
        REAL(KIND=JPRB), ALLOCATABLE :: D(:,:)
        REAL(KIND=JPRB), POINTER :: D_GPU(:,:), D_CPU(:,:)
        INTEGER :: I,J

        ALLOCATE(D(10,10))
        D=7

        CALL FIELD_NEW(W, DATA=D)
        CALL W%GET_DEVICE_DATA_RDWR(D_GPU)

        !$ACC SERIAL PRESENT(D_GPU)
        DO I=1,10
        DO J=1,10
        D_GPU(J,I)=I*J
        END DO
        END DO
        !$ACC END SERIAL

        ! DATA SHOULD ALL BE 7 BECAUSE THEY HAVEN'T MOVED BACK FROM GPU
        ! YET. BUT IF OPENACC WAS DESACTIVATED THEN THE VALUES HAVE
        ! ALREADY CHANGED SINCE IT ALWAYS HAPPEN ON THE CPU MAIN MEMORY
        IF ( .NOT. ALL(D == 7))THEN
                ERROR STOP
        END IF

        CALL W%FINAL()

        DO I=1,10
        DO J=1,10
        IF (D(J,I)/=I*J) THEN
                ERROR STOP
        END IF
        END DO
        END DO
END PROGRAM FINAL_WRAPPER_GPU
