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

PROGRAM INIT_OWNER2
        ! TEST IF PERSISTENT OPTION IS WORKING
        ! WHEN PERSITENT IS SET TO TRUE, LAST DIM OF THE FIELD IS THE ONE FROM
        ! LBOUND AND UBOUND

        USE FIELD_MODULE
        USE FIELD_FACTORY_MODULE
        USE PARKIND1
        IMPLICIT NONE
        CLASS(FIELD_2RB), POINTER :: O => NULL()
        REAL(KIND=JPRB), POINTER :: PTR(:,:)

        CALL FIELD_NEW(O, LBOUNDS=[10,1], UBOUNDS=[21,11], PERSISTENT=.TRUE.)
        CALL O%GET_HOST_DATA_RDWR(PTR)
        PTR=42

        IF (SIZE(O%PTR,1) /= 12) THEN
                WRITE(*,*) "WRONG SIZE IN DIM 1"
                WRITE(*,*) "FOUND ", SIZE(O%PTR,1), "EXPECTING 12"
                ERROR STOP
        END IF
        IF (SIZE(O%PTR,2) /= 11) THEN
                WRITE(*,*)"WRONG SIZE IN DIM 2"
                WRITE(*,*) "FOUND ", SIZE(O%PTR,2), "EXPECTING 11"
                ERROR STOP
        END IF

        IF (.NOT. ALL(O%PTR == 42)) THEN
                WRITE(*,*) "EXPECTED ALL VALUES TO BE 42"
                ERROR STOP
        END IF 
        CALL FIELD_DELETE(O)
END PROGRAM INIT_OWNER2
