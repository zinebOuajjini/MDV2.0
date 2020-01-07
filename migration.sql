--creation de migratinprocess
create table MIGRATIONPROCESS
                           (
                           
                           DATEEXEC                     TIMESTAMP          not null,
                           SCRIPTNAME                    varchar2(64)  null,
                           LINENUMBER                      varchar2(20)  null,  
                           KITNAME                   varchar2(200) null
                           );
						
--insert into migrationprocess
INSERT INTO MIGRATIONPROCESS (DATEEXEC) VALUES (
								sysdate
                             );

--creation de migrationprocesslog						
create table MIGRATIONPROCESSLOG
                           (
                           starttime                     timestamp           null,
                           stoptime                      timestamp           null, 
                           SCRIPTNAME                    varchar2(100)  null,
                           STEPNAME                      varchar2(100)  null,
                           SQLERRCODE                    varchar2(10)  null, 
                           SQLERRMESS                    varchar2(400)  null,
						   REQUETE						 varchar2(255)
                           );
						   

								


