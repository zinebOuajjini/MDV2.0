-- ------------
-- CIP-COBAC-2.1_ora.sql
-- ------------

-- ------------------------------------------------------------
-- SEQUENCE de DROP
-- ------------------------------------------------------------

-- DROP TABLE bkcip_idp_regul;
--alter table bkcip_idp drop CONSTRAINT CK_BKCIP_IDP$CTR ;
--alter table bkcip_ir drop CONSTRAINT CK_BKCIP_IR$CTR ;
-- ------------------------------------------------------------

UPDATE bkcip_cli SET ir_dec = 0 ;


alter table bkcip_idp drop CONSTRAINT CK_BKCIP_IDP$CTR ;
alter table bkcip_idp add CONSTRAINT CK_BKCIP_IDP$CTR
                                 CHECK (ctr IN ( '0' /*A traiter */
                                                ,'1' /*declare   */
                                                ,'2' /*en attente*/
                                                ,'3' /*acquittÃ©  */
                                                ,'4' /*anomalie*/
                                                ,'5' /*Suspendu*/
                                                ,'9' /*tmp       */));

alter table bkcip_ir drop CONSTRAINT CK_BKCIP_IR$CTR ;
alter table bkcip_ir add CONSTRAINT CK_BKCIP_IR$CTR
                                 CHECK (ctr IN ( '0' /*A traiter */
                                               ,'1' /*declare   */
                                               ,'2' /*en attente*/
                                               ,'3' /*acquittÃ©  */
                                               ,'4' /*anomalie  */
                                               ,'5' /*Suspendu*/
                                               ,'9' /*tmp       */));

-- ------------------------------------------------------------
-- @STEP  : 1.0
-- @TABLE : BKCIP_IDP_REGUL
-- @DESC  : CIP BEAC - audit evenment de regularisation
-- ------------------------------------------------------------
create table bkcip_idp_regul
( id_cip_idp    NUMBER(15,0)     CONSTRAINT NL_BKCIP_IDP_REGUL$ID_CIP_IDP   NOT NULL
 ,age           CHAR(5)          CONSTRAINT NL_BKCIP_IDP_REGUL$AGE          NOT NULL
 ,ope           CHAR(3)          CONSTRAINT NL_BKCIP_IDP_REGUL$OPE          NOT NULL
 ,eve           CHAR(6)          CONSTRAINT NL_BKCIP_IDP_REGUL$EVE          NOT NULL
 ,age_cpt       CHAR(5)          CONSTRAINT NL_BKCIP_IDP_REGUL$AGE_CPT      NOT NULL
 ,ncp           CHAR(11)         CONSTRAINT NL_BKCIP_IDP_REGUL$NCP          NOT NULL
 ,suf           CHAR(2)          CONSTRAINT NL_BKCIP_IDP_REGUL$SUF          NOT NULL
 ,dev           CHAR(3)          CONSTRAINT NL_BKCIP_IDP_REGUL$DEV          NOT NULL
 ,numval        CHAR(14)         CONSTRAINT NL_BKCIP_IDP_REGUL$NUMVAL       NOT NULL
 ,nat           CHAR(6)          CONSTRAINT NL_BKCIP_IDP_REGUL$NAT          NOT NULL
 ,dou           DATE             CONSTRAINT NL_BKCIP_IDP_REGUL$DOU          NOT NULL
 ,mht           NUMBER(15,4)     CONSTRAINT NL_BKCIP_IDP_REGUL$MHT          NOT NULL
 );

CREATE INDEX FK_BKCIP_IDP_REGUL$BKCIP_IDP ON BKCIP_IDP_REGUL (id_cip_idp);
ALTER TABLE BKCIP_IDP_REGUL ADD CONSTRAINT FK_BKCIP_IDP_REGUL$BKCIP_IDP FOREIGN KEY (id_cip_idp)
                          REFERENCES bkcip_idp (id_cip_idp);





-- ------------
-- mig_lien_crs_393_ora.sql
-- ------------

--DONNEE 393 : EXISTENCE D'UN LIEN D'UN TYPE DONNE AVEC UN INDIVIDU CRS

-- DELETE FROM abfseldce WHERE reffct = '027';
-- DELETE FROM abfseldcp WHERE reffct = '027';
-- DELETE FROM abfevadoe WHERE reffct = '602';
-- DELETE FROM abfevadop WHERE reffct = '602';


INSERT INTO abfseldce VALUES ('027','Selection lien entre client et individu CRS','882080','absel_type_lien_client_avec_individu_CRS');
INSERT INTO abfseldcp VALUES ('027','1','Type de lien','881467','S');

INSERT INTO abfevadoe VALUES ('602','Recherche existence lien avec individu CRS','882081','ab_rech_lien_avec_individu_CRS');
INSERT INTO abfevadop VALUES ('602','1','Type de lien','881467','E','O',' ','');
INSERT INTO abfevadop VALUES ('602','2','Existence du lien','881470','S','N','N','');


-- DELETE FROM ABDOMAD WHERE REFDO = '393';
-- DELETE FROM ABDOMADL WHERE REFDO = '393';
-- DELETE FROM ABDOMADC WHERE REFDO = '393';
-- DELETE FROM ABDOMADO WHERE REFDO = '393';

INSERT INTO ABDOMAD (REFDO, ORIGINE, TYPCLI, REFFCT, VALPAREFCT, NUMAFF, UTILSCEN, NOMLAB, DOU, DMO, UTI)
VALUES ('393', '2', 'T', ' ', ' ', 393, 'N', ' ', TO_DATE(SYSDATE,'DD/MM/YYYY'), NULL, 'DELT');
INSERT INTO ABDOMADL (REFDO, REFLIB, LANG, LIB)
VALUES ('393', 'C', '001', 'Existence d''un lien d''un type donnÃ© avec un client CRS');
INSERT INTO ABDOMADL (REFDO, REFLIB, LANG, LIB)
VALUES ('393', 'D', '001', 'Existence d''un lien avec individu CRS');
INSERT INTO ABDOMADC (REFDO, REFFCT, VALPAREFCT)
VALUES ('393', '027', ' ');
INSERT INTO ABDOMADO (REFDO, NATURE, NIVEAU, TYPOBT, NOMTABLE, NOMCOL, CARDEB, CARFIN, REFFCT, NUMPARSFCT, VALPAREFCT1, VALPAREFCT2)
VALUES ('393', ' ', 1, 'F', ' ', ' ', 0, 0, '602', 2, 'DONNEECPL1', ' ');




-- ------------
-- mig_crs_domad_correction_ora.sql
-- ------------
--Script de correction du script mig_crs_ora.sql qui aurait du Ãªtre dÃ©cloisonnÃ© ==>7961

DELETE FROM abfevadoe where reffct in ('096','600','601');
DELETE FROM abfevadop where reffct in ('096','600','601');
DELETE FROM abdomadl where refdo between '388' AND '392';
DELETE FROM abdomad where refdo between '388' AND '392';
DELETE FROM abdomado where refdo between '388' AND '392';
DELETE FROM abdomadc where refdo between '388' AND '392';


--Statut CRS d'un client
INSERT INTO ABDOMAD(REFDO,ORIGINE,TYPCLI,REFFCT,VALPAREFCT,NUMAFF,UTILSCEN,NOMLAB,DOU,DMO,UTI)
VALUES ('388', '2', 'T', '001', '072', 388, 'N', ' ', trunc(sysdate), NULL, 'USER');
INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('388', ' ', 1, 'T', 'bkcli', 'crs_status', 0, 0, ' ', 0, ' ', ' ');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('388', 'C', '001', 'Statut CRS');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('388', 'D', '001', 'Statut CRS                                        ');

--DonnÃ©e issur d'une nomenclature a partiru du statut CRS
INSERT INTO ABDOMAD(REFDO,ORIGINE,TYPCLI,REFFCT,VALPAREFCT,NUMAFF,UTILSCEN,NOMLAB,DOU,DMO,UTI)
VALUES ('389', '2', 'T', ' ', ' ', 389, 'N', ' ', trunc(sysdate), NULL, 'USER');
INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('389', ' ', 1, 'T', 'bkcli', 'crs_status', 0, 0, ' ', 0, ' ', ' ');
INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('389', ' ', 2, 'F', ' ', ' ', 0, 0, '001', 3, 'DONNEECPL1', 'DONNEECPL2');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('389', 'C', '001', 'DonnÃ©e issue d''une nomenclature Ã  partir du statut CRS');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('389', 'D', '001', 'DonnÃ©e issue nomenclature Ã  partir du statut CRS  ');
INSERT INTO ABDOMADC(REFDO,REFFCT,VALPAREFCT)
VALUES ('389', '003', ' ');

--Date de statut CRS d'un client
INSERT INTO ABDOMAD(REFDO,ORIGINE,TYPCLI,REFFCT,VALPAREFCT,NUMAFF,UTILSCEN,NOMLAB,DOU,DMO,UTI)
VALUES ('390', '2', 'T', ' ', ' ', 390, 'N', ' ', trunc(sysdate), NULL, 'USER');
INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('390', ' ', 1, 'T', 'bkcli', 'crs_date', 0, 0, ' ', 0, ' ', ' ');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('390', 'C', '001', 'Date de statut CRS');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('390', 'D', '001', 'Date de statut CRS                                ');

--AnciennetÃ© de date de statut CRS selon une periodicitÃ© donnÃ©e
INSERT INTO ABDOMAD(REFDO,ORIGINE,TYPCLI,REFFCT,VALPAREFCT,NUMAFF,UTILSCEN,NOMLAB,DOU,DMO,UTI)
VALUES ('391', '2', 'T', ' ', ' ', 391, 'N', ' ', trunc(sysdate), NULL, 'USER');
INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('391', ' ', 1, 'T', 'bkcli', 'crs_date', 0, 0, ' ', 0, ' ', ' ');
INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('391', ' ', 2, 'F', ' ', ' ', 0, 0, '027', 2, 'DONNEECPL1', ' ');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('391', 'C', '001', 'AnciennetÃ© de date de statut CRS');
INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('391', 'D', '001', 'AnciennetÃ© de date de statut CRS                  ');
INSERT INTO ABDOMADC(REFDO,REFFCT,VALPAREFCT)
VALUES ('391', '008', ' ');

--Existence residence fiscale FATCA ou CRS
INSERT INTO abfevadoe(reffct,inti,nummess,nomfct)
VALUES ('096','Recherche existence rÃ©sidence fiscale FATCA ou CRS','882028','ab_rech_existe_resid_fisc_crs_fatca');
INSERT INTO abfevadop(reffct,numpar,inti,nummess,typepar,doncpl,formatp,longp)
VALUES ('096','1','Existence rÃ©sidence fiscale FATCA ou CRS','882029','S','N','N',NULL);
INSERT INTO abdomadl(REFDO,REFLIB,LANG,LIB)
VALUES ('392', 'C', '001', 'Existence d''une rÃ©sidence fiscale CRS ou FATCA');
INSERT INTO abdomadl(REFDO,REFLIB,LANG,LIB)
VALUES ('392', 'D', '001', 'Existence d''une rÃ©sidence fiscale CRS ou FATCA    ');
INSERT INTO abdomad(REFDO,ORIGINE,TYPCLI,REFFCT,VALPAREFCT,NUMAFF,UTILSCEN,NOMLAB,DOU,DMO,UTI)
VALUES ('392', '2', 'T', ' ', ' ', '392', 'N', ' ', trunc(sysdate), NULL, 'USER');
INSERT INTO abdomado(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('392', ' ', '1', 'F', ' ', ' ', '0', '0', '096', '1', ' ', ' ');



-- ------------
-- BSIC-CI170118-03_ora.sql
-- ------------
--#===============================================================================
--# @author BOU - 01/2017
--# @desc   Ce script permet de modifier la contrainte sur le champ type afin d'y ajouter le type B : adresse agence
--#
--#===============================================================================

ALTER TABLE bkfacav_bookad DROP CONSTRAINT CK_BKFACAV_BOOKAD$TYP;

ALTER TABLE bkfacav_bookad ADD CONSTRAINT CK_BKFACAV_BOOKAD$TYP CHECK (typ  IN ('C', 'D','B'));



-- ------------
-- mig_ass_T2SA150402_ora.sql
-- ------------
-- EVOLUTION T2SA150402  - Modification de la saisie de pÃ©riodicitÃ© prÃ©lÃ¨vement
-- Ajout d'une valeur par dÃ©faut pour le champ : nombre de mois

INSERT INTO bklibel(MODU,IDEN,MESS,OBL,TYPC,CTRL,IDENM,ACCES)
values ('ASS','6','655768','O','S','',NULL,'O');
INSERT INTO bkcorres(MODU,PROG,TRAIT,FENET,ZONE,IDEN)
values ('ASS',' ',' ',' ','nb_mois_perprelv','6');



-- ------------
-- mig_TMAIBFS161114-03_ora.sql
-- ------------
--Antidote
--ALTER TABLE bkrecapfra DROP CONSTRAINT CK_BKRECAPFRA$orig;
--ALTER TABLE bkrecapfra ADD CONSTRAINT CK_BKRECAPFRA$orig CHECK (orig IN ('Q' /* Traitement quotidien */, 'R' /* reprise de l'historique */));

ALTER TABLE bkrecapfra DROP CONSTRAINT CK_BKRECAPFRA$orig;
ALTER TABLE bkrecapfra ADD CONSTRAINT CK_BKRECAPFRA$orig CHECK (orig IN ('Q' /* Traitement quotidien */, 'R' /* reprise de l'historique */, 'M' /* traitement manuel */));



-- ------------
-- mig_lab_BPCE160629-01_ora.sql
-- ------------
--Delete from abfevadoe where reffct ='097';
--Delete from abfevadop where reffct ='097';
--Delete from abdomad  where refdo ='394';
--Delete from abdomado where refdo ='394';
--Delete from abdomadl where refdo ='394';
--Delete from abdomadc where refdo ='394';

--DOMAD 394 : LibellÃ© du pays Ã  partir du code spÃ©cifique 5

INSERT INTO ABFEVADOE(REFFCT,INTI,NUMMESS,NOMFCT)
VALUES ('097', 'DonnÃ©e d''une nomenclature Ã  partir du code spÃ©cifique 5', '882082', 'ab_rech_pays_code_specifique_5') ;
INSERT INTO ABFEVADOP(REFFCT,NUMPAR,INTI,NUMMESS,TYPEPAR,DONCPL,FORMATP,LONGP)
VALUES ('097', 1, 'Code pays', '618626', 'S', 'N', 'A', 3);

INSERT INTO ABDOMAD(REFDO,ORIGINE,TYPCLI,REFFCT,VALPAREFCT,NUMAFF,UTILSCEN,NOMLAB,DOU,DMO,UTI)
VALUES ('394', '1', 'T', NULL, NULL, 394, 'N', NULL, TO_DATE(SYSDATE,'DD/MM/YYYY'), NULL, 'DELT');

INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('394', ' ', 1, 'F', NULL, NULL, 0, 0, '097', 1, NULL, NULL);

INSERT INTO ABDOMADO(REFDO,NATURE,NIVEAU,TYPOBT,NOMTABLE,NOMCOL,CARDEB,CARFIN,REFFCT,NUMPARSFCT,VALPAREFCT1,VALPAREFCT2)
VALUES ('394', ' ', 2, 'F', NULL, NULL, 0, 0, '001', 3, 'DONNEECPL1', 'DONNEECPL2');

INSERT INTO ABDOMADC(REFDO,REFFCT,VALPAREFCT)
VALUES ('394', '003', NULL);

INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('394', 'C', '001', 'DonnÃ©e issue d''une nomenclature Ã  partir du code spÃ©cifique 5');

INSERT INTO ABDOMADL(REFDO,REFLIB,LANG,LIB)
VALUES ('394', 'D', '001', 'DonnÃ©e issue d''une nom. Ã  partir du code spÃ©. 5   ');




-- ------------
-- BFVSG170302-01_ora.sql
-- ------------
-- BFVSG170302-01 :
-- Script correctif du champ hmaj
-- Forcage du champ hmaj en CHAR(6)

ALTER TABLE bkhmajcli      MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajicli     MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajmcl      MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajenfcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajdircli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajactcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajprfcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajdficli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajtelcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajemacli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajcntcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajpidcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajprocli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajadcli    MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajdoccli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajbudgcli  MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajrevcli   MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajchargcli MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajepatrcli MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajpatrcli  MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajopetrcli MODIFY (hmaj CHAR(6));
ALTER TABLE bkhmajcoj      MODIFY (hmaj CHAR(6));




-- ------------
-- mig_IFRS9_lot2_ora.sql
-- ------------
----DROP TABLE IF9_NOTE;
----DROP TABLE IF9_EAD;
----DROP TABLE IF9_PRV;
----DROP TABLE IF9_CYCLE;
----DROP TABLE IF9_NTVAL;
----DROP TABLE IF9_NTATTR;
----DROP TABLE IF9_NTPAR;
----DROP TABLE IF9_PGVAL;
----DROP TABLE IF9_PGATTR;
----DROP TABLE IF9_PGPAR;
----DROP TABLE IF9_EADGAR;
----DROP TABLE IF9_EADPAR;
----DROP TABLE IF9_EADNAT;
----ALTER TABLE IF9_VALCDT MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALCDT$ID_VALID NOT NULL);
----ALTER TABLE IF9_VALAUT MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALAUT$ID_VALID NOT NULL);
----ALTER TABLE IF9_VALCRC MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALCRC$ID_VALID NOT NULL);
----ALTER TABLE IF9_VALTIT MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALTIT$ID_VALID NOT NULL);
----ALTER TABLE IF9_VALCAU MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALCAU$ID_VALID NOT NULL);
----ALTER TABLE IF9_VALLSG MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALLSG$ID_VALID NOT NULL);
----ALTER TABLE IF9_VALISL MODIFY (ID_IF9_VALID NUMBER(10,0) CONSTRAINT NL_VALISL$ID_VALID NOT NULL);



-------------------------------------------------------------------------------
----                                         CREATION ET ALIMENTATION DES TABLES



-- Table pour cycle de notation et provision IFRS 9
CREATE TABLE IF9_CYCLE (
   ID_IF9_CYCLE  NUMBER(10,0)    CONSTRAINT NL_CYCLE$IDCYCLE NOT NULL,                                                        --- Identifiant unique (technique)
   ST_NOTE       NUMBER(1,0)     CONSTRAINT NL_CYCLE$ST_NOTE   NOT NULL,                                                      --- Statut de la phase de notation
                                 CONSTRAINT CK_CYCLE$ST_NOTE CHECK(ST_NOTE IN ('0','1')) ,                                    --0 - Ouverte
                                                                                                                              --1 - Cloturee
   DCALC_NOTE    DATE            CONSTRAINT NL_CYCLE$DCALC_NOTE NOT NULL,                                                    --- Date d'execution du calcul de la notation
   DFIN_NOTE     DATE            CONSTRAINT NL_CYCLE$DFIN_NOTE NOT NULL,                                                     --- Date de fin de la phase de notation
   UTI_NOTE      CHAR(10)        ,                                                                                           --- Utilisateur ayant cloture la phase de notation
   ST_PROV       NUMBER(1,0)     CONSTRAINT NL_CYCLE$ST_PROV NOT NULL,                                                        --- Statut de la phase de provision
                                 CONSTRAINT CK_CYCLE$ST_PROV CHECK(ST_PROV IN ('0','1')),                                     -- 0 - Ouverte
                                                                                                                              -- 1 - Cloturee
   DCALC_PROV    DATE ,                                                                                                      --- Date d'execution du calcul de provision
   UTI_CALPRV    CHAR(10) ,                                                                                                  --- Utilisateur ayant lancÃ© le calcul de provision
   DFIN_PROV     DATE ,                                                                                                      --- Date de fin de la phase de provision
   UTI_PROV      CHAR(10) ,                                                                                                  --- Utilisateur ayant cloture la phase de provision
   DEC_PROV      NUMBER(1,0)    CONSTRAINT CK_CYCLE$DEC_PROV CHECK(DEC_PROV IN ('0','1','2')),                               --- Decision sur la provision
   LAST_CYCLE    NUMBER(1,0)    CONSTRAINT CK_CYCLE$LAST_CYCLE CHECK(LAST_CYCLE IN ('0','1'))
);
CREATE UNIQUE INDEX PK_IF9CYCLE ON IF9_CYCLE (ID_IF9_CYCLE);
ALTER TABLE IF9_CYCLE ADD CONSTRAINT  PK_IF9CYCLE PRIMARY KEY (ID_IF9_CYCLE) ;
CREATE INDEX I1_IF9_CYCLE ON IF9_CYCLE (ST_NOTE);
CREATE INDEX I2_IF9_CYCLE ON IF9_CYCLE (ST_PROV);
CREATE INDEX I3_IF9_CYCLE ON IF9_CYCLE (LAST_CYCLE);



--Table pour le paramÃ©trage des rÃ¨gles de notation IFRS 9
CREATE TABLE IF9_NTPAR (
   ID_IF9_NTPAR  NUMBER(10,0)   CONSTRAINT NL_NTPAR$IDNTPAR NOT NULL,                                                      --- Identifiant unique (technique)
   PLEVEL        NUMBER(3,0)    CONSTRAINT NL_NTPAR$PLEVEL   NOT NULL,                                                     --- Niveau de paramÃ©trage
                                 CONSTRAINT CK_NTPAR$PLEVEL CHECK(PLEVEL IN ('100','110', '120', '130', '200',
                                                            '210', '220', '230', '300', '310', '320', '330')) ,              -- 100 - Global
                                                                                                                             -- 110 - Global/Client Particulier
                                                                                                                             -- 120 - Global/Client SocitÃ©tÃ©
                                                                                                                             -- 130 - Global/Client Entreprise Individuelle
                                                                                                                             -- 200 - Module
                                                                                                                             -- 210 - Module/Client Particulier
                                                                                                                             -- 220 - Module/Client SocitÃ©tÃ©
                                                                                                                             -- 230 - Module/Client Entreprise Individuelle
                                                                                                                             -- 300 - Produit
                                                                                                                             -- 310 - Produit/Client Particulier
                                                                                                                             -- 320 - Produit/Client SocietÃ©
                                                                                                                             -- 330 - Produit/Client Entreprise Individuelle
   MODU          CHAR(3)         CONSTRAINT CK_NTPAR$MODU  CHECK(MODU IN ('AUT','CDT', 'CRC', 'LSG', 'ISI',                 --- Code module - cas des paramÃ¨tres niveau module/produit
                                                                    'CAU', 'TIT')),
   TYPE_PROD     VARCHAR2(10)     ,                                                                                          --- Code type (produit) - cas des paramÃ¨tres niveau produit
                                                                                                                             -- AUT - Autorisations simples
                                                                                                                             -- CDT - CrÃ©dits amortissables
                                                                                                                             -- CRC - CrÃ©dits revolving
                                                                                                                             -- LSG - Leasing
                                                                                                                             -- ISI - Finance islamique
                                                                                                                             -- CAU - Cautions
                                                                                                                             -- TIT - Titres
   TYPE_CLI      CHAR(1)         CONSTRAINT CK_NTPAR$TYPE_CLI CHECK(TYPE_CLI IN ('1', '2', '3')),                           --- Type de client
                                                                                                                             -- 1 - Particulier
                                                                                                                             -- 2 - SociÃ©tÃ©
                                                                                                                             -- 3 - Entreprise individuelle
   DESCRIPTION   VARCHAR2(200)    CONSTRAINT NL_NTPAR$DESCRIPTION NOT NULL,                                                  --- Description longue de l'attribut
   NOTE          NUMBER(1,0)    CONSTRAINT NL_NTPAR$NOTE   NOT NULL,                                                        --- Note Ã  affecter
                                 CONSTRAINT CK_NTPAR$NOTE CHECK(NOTE IN ('0','1','2','3')) ,                                 -- 0 - Non notÃ©
                                                                                                                             -- 1 - S1 - Bucket 1
                                                                                                                             -- 2 - S2 - Bucket 2
                                                                                                                             -- 3 - Exclu du calcul
   ACTIVE        NUMBER(1,0)    CONSTRAINT NL_NTPAR$ACTIVE   NOT NULL,                                                      --- RÃ¨gle active
                                 CONSTRAINT CK_NTPAR$ACTIVE CHECK(ACTIVE IN ('0','1')) ,                                     -- 0  Non
                                                                                                                             -- 1  Oui
   DDEB          DATE ,                                                                                                     --- Date de dÃ©but d'application
   DFIN          DATE ,                                                                                                     --- Date de fin d'application
   UTI           CHAR(10)        CONSTRAINT NL_NTPAR$UTI NOT NULL,                                                          --- Utilisateur ayant crÃ©Ã© la rÃ¨gle
   HIS           NUMBER(1,0)    CONSTRAINT NL_NTPAR$HIS   NOT NULL,                                                         --- RÃ¨gle historisÃ©es
                                 CONSTRAINT CK_NTPAR$HIS CHECK(HIS IN ('0','1')) ,                                           -- 0 - Non
                                                                                                                             -- 1 - Oui
   DHIS          DATE                                                                                                       --- Date d'historisation
);
CREATE UNIQUE INDEX PK_IF9NTPAR ON IF9_NTPAR (ID_IF9_NTPAR);
ALTER TABLE IF9_NTPAR ADD CONSTRAINT  PK_IF9NTPAR PRIMARY KEY (ID_IF9_NTPAR) ;
CREATE INDEX I1_IF9_NTPAR ON IF9_NTPAR (PLEVEL);
CREATE INDEX I2_IF9_NTPAR ON IF9_NTPAR (MODU,TYPE_PROD,TYPE_CLI);
CREATE INDEX I3_IF9_NTPAR ON IF9_NTPAR (NOTE);
CREATE INDEX I4_IF9_NTPAR ON IF9_NTPAR (ACTIVE);



--Table pour le paramÃ©trage des rÃ¨gles de notation IFRS 9 - Attributs caractÃ©ristiques
CREATE TABLE IF9_NTATTR (
   ID_IF9_NTATTR  NUMBER(10,0)   CONSTRAINT NL_NTATTR$IDNTATTR NOT NULL,                                                    --- Identifiant unique (technique)
   ID_IF9_NTPAR   NUMBER(10,0)   CONSTRAINT NL_NTATTR$IDNTPAR  NOT NULL,                                                    --- Identifiant de rÃ¨gle (technique)
   TYPE           NUMBER(1,0)    CONSTRAINT NL_NTATTR$TYPE  NOT NULL,                                                       --- Type d'attribut
                                 CONSTRAINT CK_NTATTR$TYPE  CHECK(TYPE IN ('1','2', '3')),                                   -- 1 - ImpayÃ©
                                                                                                                             -- 2 - Client
                                                                                                                             -- 3 - IFRS9
   KEY_CODE       VARCHAR2(50)     CONSTRAINT NL_NTATTR$KEY_CODE  NOT NULL,                                                  --- Code identifiant (fonctionnel) de l'attribut
   OPERATOR       NUMBER(2,0)    CONSTRAINT CK_NTATTR$OPERATOR CHECK(OPERATOR IN ('1', '2', '3', '4', '5', '6',             --- OpÃ©rateur
                                                                              '7', '8', '9', '10', '11', '12')),             -- 1 - =
                                                                                                                             -- 2 - !=
                                                                                                                             -- 3 - >
                                                                                                                             -- 4 - <
                                                                                                                             -- 5 - >=
                                                                                                                             -- 6 - <=
                                                                                                                             -- 7 - Liste de valeurs incluses
                                                                                                                             -- 8 - Liste de valeurs exclues
                                                                                                                             -- 9 - Compris entre
                                                                                                                             -- 10 - Commence par
                                                                                                                             -- 11 - Fini par
                                                                                                                             -- 12 - Contient
   FORMAT         CHAR(1)         CONSTRAINT NL_NTATTR$FORMAT NOT NULL,                                                     --- Format de la valeur de lÂ¿attribut
                                  CONSTRAINT CK_NTATTR$FORMAT  CHECK(FORMAT IN ('A','N', 'E', 'D', 'B'))                     -- A  AlphanumÃ©rique, N  NumÃ©rique, E Entier, D  Date,  B  BoolÃ©en
);
CREATE UNIQUE INDEX PK_IF9NTATTR ON IF9_NTATTR (ID_IF9_NTATTR);
ALTER TABLE IF9_NTATTR ADD CONSTRAINT  PK_IF9NTATTR PRIMARY KEY (ID_IF9_NTATTR) ;
CREATE INDEX FK_IF9NTATTR$NTPAR ON IF9_NTATTR (ID_IF9_NTPAR);
ALTER TABLE IF9_NTATTR ADD CONSTRAINT FK_IF9NTATTR$IF9NTPAR FOREIGN KEY (ID_IF9_NTPAR) REFERENCES IF9_NTPAR (ID_IF9_NTPAR) ;
CREATE INDEX I1_IF9_NTATTR ON IF9_NTATTR (TYPE);
CREATE INDEX I2_IF9_NTATTR ON IF9_NTATTR (KEY_CODE);



--Table pour le paramÃ©trage des rÃ¨gles de notation IFRS 9 - Valeur des attributs
CREATE TABLE IF9_NTVAL (
   ID_IF9_NTVAL   NUMBER(10,0)   CONSTRAINT NL_NTVAL$IDNTVAL   NOT NULL,                                                    --- Identifiant unique (technique)
   ID_IF9_NTATTR  NUMBER(10,0)   CONSTRAINT NL_NTVAL$IDNTATTR  NOT NULL,                                                    --- Identifiant de l'attribut caractÃ©ristique
   DATAA          VARCHAR2(150)    ,                                                                                         --- Valeur de l'attribut au format A
   DATAN          NUMBER(22,7)   ,                                                                                          --- Valeur de l'attribut au format N ou E
   DATAD          DATE            ,                                                                                         --- Valeur de l'attribut au format D
   DATAB          NUMBER(1,0)    CONSTRAINT CK_NTVAL$DATAB  CHECK(DATAB IN ('0','1'))                                       --- Valeur de l'attribut au format B: 0  FAUX, 1  VRAI
);
CREATE UNIQUE INDEX PK_IF9NTVAL ON IF9_NTVAL (ID_IF9_NTVAL);
ALTER TABLE IF9_NTVAL ADD CONSTRAINT PK_IF9NTVAL PRIMARY KEY (ID_IF9_NTVAL) ;
CREATE INDEX FK_IF9NTVAK$IF9NTATTR ON IF9_NTVAL (ID_IF9_NTATTR);
ALTER TABLE IF9_NTVAL ADD CONSTRAINT FK_IF9NTVAL$IF9NTATTR FOREIGN KEY (ID_IF9_NTATTR) REFERENCES IF9_NTATTR (ID_IF9_NTATTR);



-- Table pour le paramÃ©trage des rÃ¨gles de propagation IFRS 9
CREATE TABLE IF9_PGPAR (
   ID_IF9_PGPAR  NUMBER(10,0)    CONSTRAINT NL_PGPAR$IDPGPAR NOT NULL,                                                      --- Identifiant unique (technique)
   PLEVEL        NUMBER(1,0)     CONSTRAINT NL_PGPAR$PLEVEL NOT NULL,                                                       --- Niveau de paramÃ©trage
                                 CONSTRAINT CK_PGPAR$PLEVEL CHECK(PLEVEL IN ('0','1', '2', '3')) ,                           --0  Global
                                                                                                                             --1 Client Particulier
                                                                                                                             --2 Client SociÃ©tÃ©
                                                                                                                             --3 Client Entreprise Individuelle
   DESCRIPTION   VARCHAR2(200)    CONSTRAINT NL_PGPAR$DESCRIPTION NOT NULL,                                                  ---Description longue de lÂ¿attribut
   PROPAG        NUMBER(1,0)     CONSTRAINT NL_PGPAR$PROPAG NOT NULL   ,                                                    --- Mode de propagation
                                 CONSTRAINT CK_PGPAR$PROPAG CHECK(PROPAG IN ('0','1', '2','3')) ,                            --0 - Pas de propagation
                                                                                                                             --1 - Propagation aux dossiers du client
                                                                                                                             --2 - Propagation aux dossiers du client et ses co-titulaires
                                                                                                                             --3 - Propagation aux dossiers du groupe (SociÃ©tÃ© et Entreprises individuelles)
   ACTIVE        NUMBER(1,0)     CONSTRAINT NL_PGPAR$ACTIVE NOT NULL,                                                       ---RÃ¨gle active
                                 CONSTRAINT CK_PGPAR$ACTIVE CHECK(ACTIVE IN ('0', '1')) ,                                     --0  Non
                                                                                                                              --1  Oui
   DDEB          DATE            ,                                                                                          ---Date de dÃ©but d'application
   DFIN          DATE            ,                                                                                          ---Date de fin d'application
   UTI           CHAR(10)        CONSTRAINT NL_PGPAR$UTI  NOT NULL ,                                                        ---Dernier utilisateur ayant crÃ©Ã©/modifiÃ© le paramÃ¨tre
   HIS           NUMBER(1,0)     CONSTRAINT NL_PGPAR$HIS NOT NULL,                                                          ---RÃ¨gle historisÃ©es
                                 CONSTRAINT CK_PGPAR$HIS CHECK(HIS IN ('0', '1')) ,                                          --0  Non
                                                                                                                             --1 - Oui
   DHIS          DATE                                                                                                       ---Date d'historisation
);
CREATE UNIQUE INDEX PK_IF9PGPAR ON IF9_PGPAR (ID_IF9_PGPAR);
ALTER TABLE IF9_PGPAR ADD CONSTRAINT  PK_IF9PGPAR PRIMARY KEY (ID_IF9_PGPAR) ;
CREATE INDEX I1_IF9_PGPAR ON IF9_PGPAR (PLEVEL);
CREATE INDEX I2_IF9_PGPAR ON IF9_PGPAR (PROPAG);
CREATE INDEX I3_IF9_PGPAR ON IF9_PGPAR (ACTIVE);



-- Table pour le paramÃ©trage des rÃ¨gles de propagation IFRS 9 - Attributs caractÃ©ristiques
CREATE TABLE IF9_PGATTR (
   ID_IF9_PGATTR  NUMBER(10,0)   CONSTRAINT NL_PGATTR$ID_PGATTR   NOT NULL,                                                 --- Identifiant unique (technique)
   ID_IF9_PGPAR   NUMBER(10,0)   CONSTRAINT NL_PGATTR$ID_PAGPAR   NOT NULL,                                                  --- RÃ©fÃ©rence Ã  la regle(IF9_PGPAR)
   TYPE           NUMBER(1,0)    CONSTRAINT NL_PGATTR$TYPE NOT NULL,                                                         --- Type de l'attribut
                                                                                                                             --1  - ImpayÃ©
                                                                                                                             --2  - Client
                                                                                                                             --3  - IFRS9
   KEY_CODE      VARCHAR2(50)     CONSTRAINT NL_PGATTR$KEY_CODE NOT NULL,                                                    ---Code identifiant (fonctionnel) de lÂ¿attribut
   OPERATOR      NUMBER(2,0)     CONSTRAINT CK_PGATTR$OPERATOR CHECK(OPERATOR IN                                            --- OpÃ©rateur de comparaison liÃ© au critÃ¨re de sÃ©lection (>, <, =, Â¿)
                                                               ('1', '2', '3', '4', '5', '6',                                -- 1 - =
                                                               '7', '8', '9', '10', '11', '12')),                            -- 2 - !=
                                                                                                                             -- 3 - >
                                                                                                                             -- 4 - <
                                                                                                                             -- 5 - >=
                                                                                                                             -- 6 - <=
                                                                                                                             -- 7 - Liste de valeurs incluses
                                                                                                                             -- 8 - Liste de valeurs exclues
                                                                                                                             -- 9 - Compris entre
                                                                                                                             -- 10 - Commence par
                                                                                                                             -- 11 - Fini par
                                                                                                                             -- 12 - Contient
   FORMAT         CHAR(1)        CONSTRAINT CK_PGATTR$FORMAT CHECK(FORMAT IN ('A','N', 'E', 'D', 'B'))                          --- Format de la valeur de l'attribut
);
CREATE UNIQUE INDEX PK_IF9PGATTR ON IF9_PGATTR (ID_IF9_PGATTR);
ALTER TABLE IF9_PGATTR ADD CONSTRAINT PK_IF9PGATTR PRIMARY KEY (ID_IF9_PGATTR);
CREATE INDEX FK_IF9PGATTR$PGPAR ON IF9_PGATTR (ID_IF9_PGPAR);
ALTER TABLE IF9_PGATTR ADD CONSTRAINT FK_IF9PGATTR$IF9PGPAR FOREIGN KEY (ID_IF9_PGPAR) REFERENCES IF9_PGPAR (ID_IF9_PGPAR);
CREATE INDEX I2_IF9_PGATTR ON IF9_PGATTR (TYPE);
CREATE INDEX I3_IF9_PGPATTR ON IF9_PGATTR (KEY_CODE);



-- Table pour le paramÃ©trage des rÃ¨gles de notation IFRS 9 - Valeur des attributs
CREATE TABLE IF9_PGVAL(
   ID_IF9_PGVAL    NUMBER(10,0)   CONSTRAINT NL_PGVAL$ID_PGVAL NOT NULL    ,                                                --- Identifiant unique (technique)
   ID_IF9_PGATTR   NUMBER(10,0)   CONSTRAINT NL_PGVAL$ID_PGATTR NOT NULL   ,                                                --- Identifiant de l'attribut caractÃ©ristique (IF9_PGATTR)
   DATAA           VARCHAR2(150)                                             ,                                               --- Valeur de l'attribut au format A
   DATAN           NUMBER(22,7)                                            ,                                                --- Valeur de l'attribut au format N/E
   DATAD           DATE                                                     ,                                               --- Valeur de l'attribut au format D
   DATAB           NUMBER(1,0)    CONSTRAINT CK_PGVAL$DATAB CHECK(DATAB IN ('0', '1'))                                      --- Valeur de l'attribut au format B: 0 - FAUX, 1 - VRAI
);
CREATE UNIQUE INDEX PK_IF9PGVAL ON IF9_PGVAL (ID_IF9_PGVAL);
ALTER TABLE IF9_PGVAL ADD CONSTRAINT PK_IF9PGVAL PRIMARY KEY (ID_IF9_PGVAL);
CREATE INDEX FK_IF9PGVAL$IF9PGATTR ON IF9_PGVAL (ID_IF9_PGATTR);
ALTER TABLE IF9_PGVAL ADD CONSTRAINT FK_IF9PGVAL$IF9PGATTR FOREIGN KEY (ID_IF9_PGATTR) REFERENCES IF9_PGATTR (ID_IF9_PGATTR);




-- Table pour le paramÃ©trages (IFRS 9) des taux par tranche d'exposition au dÃ©faut
CREATE TABLE IF9_EADPAR(
   ID_IF9_EADPAR   NUMBER(10,0)  CONSTRAINT NL_EADPAR$ID_EADPAR NOT NULL    ,                                               --- Identifiant unique (technique)
   PLEVEL          NUMBER(3,0)   CONSTRAINT NL_EADPAR$PLEVEL   NOT NULL,                                                    --- Niveau de paramÃ©trage
                                 CONSTRAINT CK_EADPAR$PLEVEL CHECK(PLEVEL IN ('100','110', '120', '130', '200',
                                                            '210', '220', '230', '300', '310', '320', '330')) ,              -- 100 - Global
                                                                                                                             -- 110 - Global/Client Particulier
                                                                                                                             -- 120 - Global/Client SocitÃ©tÃ©
                                                                                                                             -- 130 - Global/Client Entreprise Individuelle
                                                                                                                             -- 200 - Module
                                                                                                                             -- 210 - Module/Client Particulier
                                                                                                                             -- 220 - Module/Client SocitÃ©tÃ©
                                                                                                                             -- 230 - Module/Client Entreprise Individuelle
                                                                                                                             -- 300 - Produit
                                                                                                                             -- 310 - Produit/Client Particulier
                                                                                                                             -- 320 - Produit/Client SocietÃ©
                                                                                                                             -- 330 - Produit/Client Entreprise Individuelle
   MODU          CHAR(3)         CONSTRAINT CK_EADPAR$MODU  CHECK(MODU IN ('AUT','CDT', 'CRC', 'LSG', 'ISI',                --- Code module - cas des paramÃ¨tres niveau module/produit
                                                                    'CAU', 'TIT')),
   TYPE_PROD     VARCHAR2(10) ,                                                                                              --- Code type (produit) - cas des paramÃ¨tres niveau produit
                                                                                                                             -- AUT - Autorisations simples
                                                                                                                             -- CDT - CrÃ©dits amortissables
                                                                                                                             -- CRC - CrÃ©dits revolving
                                                                                                                             -- LSG - Leasing
                                                                                                                             -- ISI - Finance islamique
                                                                                                                             -- CAU - Cautions
                                                                                                                             -- TIT - Titres
   TYPE_CLI      CHAR(1)         CONSTRAINT CK_EADPAR$TYPE_CLI CHECK(TYPE_CLI IN ('1', '2', '3')),                          --- Type de client
                                                                                                                             -- 1 - Particulier
                                                                                                                             -- 2 - SociÃ©tÃ©
                                                                                                                             -- 3 - Entreprise individuelle
   B_S1          NUMBER(15,7) ,                                                                                             --- Taux part bilan S1
   B_S2          NUMBER(15,7) ,                                                                                             --- Taux part bilan S2
   HB_S1         NUMBER(15,7) ,                                                                                             --- Taux part hors-bilan S1
   HB_S2         NUMBER(15,7) ,                                                                                             --- Taux part hors-bilan S2
   UTI           CHAR(10)        CONSTRAINT NL_EADPAR$UTI  NOT NULL,                                                        --- Utilisateur ayant crÃ©Ã© la rÃ¨gle
   HIS           NUMBER(1,0)     CONSTRAINT NL_EADPAR$HIS  NOT NULL,                                                         --- RÃ¨gle historisÃ©es
                                 CONSTRAINT CK_EADPAR$HIS CHECK(HIS IN ('0','1')) ,                                          -- 0 - Non
                                                                                                                             -- 1 - Oui
   DHIS          DATE                                                                                                       --- Date d'historisation
);
CREATE UNIQUE INDEX PK_IF9EADPAR ON IF9_EADPAR (ID_IF9_EADPAR);
ALTER TABLE IF9_EADPAR ADD CONSTRAINT PK_IF9EADPAR PRIMARY KEY (ID_IF9_EADPAR);
CREATE INDEX I1_IF9_EADPAR ON IF9_EADPAR (PLEVEL);
CREATE INDEX I2_IF9_EADPAR ON IF9_EADPAR (MODU,TYPE_PROD,TYPE_CLI);



-- Table pour le paramÃ©trage (IFRS 9) des taux par EAD - DÃ©finition par tranche de garantie
CREATE TABLE IF9_EADGAR(
   ID_IF9_EADGAR   NUMBER(10,0)  CONSTRAINT NL_EADGAR$ID_EADGAR  NOT NULL ,                                                 --- Identifiant unique (technique)
   ID_IF9_EADPAR   NUMBER(10,0)  CONSTRAINT NL_EADGAR$ID_EADPAR  NOT NULL ,                                                 --- Identifiant de rÃ¨gle (technique)
   CNAT            CHAR(3)       CONSTRAINT NL_EADGAR$CNAT       NOT NULL ,                                                 --- Nature de garantie
   T_S1            NUMBER(15,7)  CONSTRAINT NL_EADGAR$T_S1       NOT NULL ,                                                                                           --- Taux S1
   T_S2            NUMBER(15,7)  CONSTRAINT NL_EADGAR$T_S2       NOT NULL                                                                                            --- Taux S2
);
CREATE UNIQUE INDEX PK_IF9EADGAR ON IF9_EADGAR (ID_IF9_EADGAR);
ALTER TABLE IF9_EADGAR ADD CONSTRAINT PK_IF9EADGAR PRIMARY KEY (ID_IF9_EADGAR);
CREATE INDEX FK_IF9EADGAR$IF9EADPAR ON IF9_EADGAR (ID_IF9_EADPAR);
ALTER TABLE IF9_EADGAR ADD CONSTRAINT FK_IF9EADGAR$IF9EADPAR FOREIGN KEY (ID_IF9_EADPAR) REFERENCES IF9_EADPAR (ID_IF9_EADPAR);



-- Table pour le paramÃ©trage (IFRS 9) mode de gestion par nature de garantie
CREATE TABLE IF9_EADNAT(
   ID_IF9_EADNAT   NUMBER(10,0)  CONSTRAINT NL_EADNAT$ID_EADNAT  NOT NULL ,                                                  --- Identifiant unique (technique)
   CNAT            CHAR(3)       CONSTRAINT NL_EADNAT$CNAT       NOT NULL ,                                                --- Nature de garantie
   IF9_PRV         NUMBER(1,0)   CONSTRAINT CK_EADNAT$IF9_PRV  CHECK(IF9_PRV IN ('0','1','2','3')) ,                        --- Provision IFRS 9
                                                                                                                             -- 0 - Non renseignÃ© (ou NULL)
                                                                                                                             -- 1 - Pas de prise en compte de la garantie
                                                                                                                             -- 2 - DÃ©duction sur l'exposition
                                                                                                                             -- 3 - DÃ©clinaison par tranche
   HIS             NUMBER(1,0)   CONSTRAINT NL_EADNAT$HIS  NOT NULL,                                                        --- RÃ¨gle historisÃ©es
                                 CONSTRAINT CK_EADNAT$HIS CHECK(HIS IN ('0','1')) ,                                          -- 0 - Non
                                                                                                                             -- 1 - Oui
   DHIS            DATE ,                                                                                                   --- Date d'historisation
   UTI             CHAR(10)      CONSTRAINT NL_EADNAT$UTI  NOT NULL                                                         --- Utilisateur ayant crÃ©Ã© la rÃ¨gle
);
CREATE UNIQUE INDEX PK_IF9EADNAT ON IF9_EADNAT (ID_IF9_EADNAT);
ALTER TABLE IF9_EADNAT ADD CONSTRAINT PK_IF9EADNAT PRIMARY KEY (ID_IF9_EADNAT);



--Table pour la notation IFRS 9 des dossiers
CREATE TABLE IF9_NOTE (
   ID_IF9_NOTE    NUMBER(10,0)   CONSTRAINT NL_NOTE$IDNOTE  NOT NULL,                                        --- Identifiant unique (technique)
   ID_IF9_VAL     NUMBER(10,0)   CONSTRAINT NL_NOTE$IDVAL   NOT NULL,                                        --- Identifiant du lien de valorisation
                                                                                                               -- AUT - Autorisations simples
                                                                                                               -- CDT - CrÃ©dits amortissables
                                                                                                               -- CRC - CrÃ©dits revolving
                                                                                                               -- LSG - Leasing
                                                                                                               -- ISI - Finance islamique
                                                                                                               -- CAU - Cautions
                                                                                                               -- TIT - Titres
   ID_IF9_CYCLE   NUMBER(10,0)   CONSTRAINT NL_NOTE$IDCYCLE NOT NULL,                                        --- Identifiant du cycle (technique)                                                                                                                           -- 2 - Client                                                                                                                        -- 3 - IFRS9
   MODU           CHAR(3)        CONSTRAINT NL_NOTE$MODU    NOT NULL,
                                 CONSTRAINT CK_NOTE$MODU    CHECK(MODU IN ('AUT', 'CDT', 'CRC',              --- Code module - cas des paramÃ¨tres niveau module/produit
                                                               'LSG', 'ISI', 'CAU','TIT')),
   NOTE_UNIT      NUMBER(1,0)    CONSTRAINT NL_NOTE$NOTE_UNIT  NOT NULL,                                     --- Notation issue de propagation
                                 CONSTRAINT CK_NOTE$NOTE_UNIT  CHECK(NOTE_UNIT IN ('0', '1', '2','3')),        -- 0 - Non notÃ©
                                                                                                               -- 1 - S1 - Bucket 1
                                                                                                               -- 2 - S2 - Bucket 2
                                                                                                               -- 3 - S3 - Bucket 3
   ID_IF9_NTPAR   NUMBER(10,0)  ,                                                                            --- Identifiant de rÃ¨gle (technique)
   DUNIT          DATE           CONSTRAINT NL_NOTE$DUNIT  NOT NULL,                                         --- Date de notation unitaire
   NOTE_PG        NUMBER(1,0)    CONSTRAINT CK_NOTE$NOTE_PG  CHECK(NOTE_PG IN ('1', '2')),                   --- Notation issue de propagation
                                                                                                               -- 1 - S1 - Bucket 1
                                                                                                               -- 2 - S2 - Bucket 2                                                                                                       -- 4 - <
   ID_IF9_PGPAR   NUMBER(10,0)  ,                                                                            --- Identifiant de rÃ¨gle (technique)
   DPROPAG        DATE ,                                                                                      --- Date de propagation
   NOTE_MAN       NUMBER(1,0)    CONSTRAINT CK_NOTE$NOTE_MAN  CHECK(NOTE_MAN IN ('0','1', '2')),             --- Notation manuelle
                                                                                                               -- 0 - Non notÃ©
                                                                                                               -- 1 - S1 - Bucket 1
                                                                                                               -- 2 - S2 - Bucket 2
   COMMENTAIRE    VARCHAR2(500)   ,                                                                            --- Commentaire liÃ© Ã  la notation manuelle
   DMAN           DATE ,                                                                                      --- Date de notation manuelle
   UTI_MAN        CHAR(10) ,                                                                                  --- Utilisateur ayant notÃ© manuellement
   NOTE           NUMBER(1,0)    CONSTRAINT CK_NOTE$NOTE CHECK(NOTE IN ('0','1', '2','3')),                  --- Notation en cours
                                                                                                               -- 0 - Non notÃ©
                                                                                                               -- 1 - S1 - Bucket 1
                                                                                                               -- 2 - S2 - Bucket 2
                                                                                                               -- 3 - S3 - Bucket 3
   ORIG           NUMBER(1,0)    CONSTRAINT CK_NOTE$ORIG CHECK(ORIG IN ('1', '2','3','4', '5')),             --- Origine de la notation en cours
                                                                                                               -- 1 - Unitaire
                                                                                                               -- 2 - Propagation
                                                                                                               -- 3 - Manuelle
                                                                                                               -- 4 - CDL
                                                                                                               -- 5 - CTX
   CLI            CHAR(15)        CONSTRAINT NL_NOTE$CLI  NOT NULL                                            --- Client liÃ© Ã  la notation
);
CREATE UNIQUE INDEX PK_IF9NOTE ON IF9_NOTE (ID_IF9_NOTE);
ALTER TABLE IF9_NOTE ADD CONSTRAINT  PK_IF9NOTE PRIMARY KEY (ID_IF9_NOTE) ;
CREATE UNIQUE INDEX I1_IF9NOTE ON IF9_NOTE (ID_IF9_VAL,ID_IF9_CYCLE,MODU);
CREATE INDEX FK_IF9NOTE$IF9CYCLE ON IF9_NOTE (ID_IF9_CYCLE);
ALTER TABLE IF9_NOTE ADD CONSTRAINT FK_IF9NOTE$IF9CYCLE FOREIGN KEY (ID_IF9_CYCLE) REFERENCES IF9_CYCLE (ID_IF9_CYCLE);
CREATE INDEX I2_IF9_NOTE ON IF9_NOTE (MODU);
CREATE INDEX I3_IF9_NOTE ON IF9_NOTE (CLI);



--Table pour les provisions IFRS 9 des dossiers
CREATE TABLE IF9_PRV (
   ID_IF9_PRV     NUMBER(10,0)   CONSTRAINT NL_PRV$IDPRV    NOT NULL,                                                       --- Identifiant unique (technique)
   ID_IF9_VAL     NUMBER(10,0)   CONSTRAINT NL_PRV$IDVAL    NOT NULL,                                                       --- Identifiant du lien de valorisation
                                                                                                                             -- AUT - Autorisations simples
                                                                                                                             -- CDT - CrÃ©dits amortissables
                                                                                                                             -- CRC - CrÃ©dits revolving
                                                                                                                             -- LSG - Leasing
                                                                                                                             -- ISI - Finance islamique
                                                                                                                             -- CAU - Cautions
                                                                                                                             -- TIT - Titres
   ID_IF9_CYCLE   NUMBER(10,0)  ,                                                                                           --- Type d'attribut                                                                                                                                                                                                                                                  -- 3 - IFRS9
   MODU           CHAR(3)         CONSTRAINT NL_PRV$MOU  NOT NULL,
                                  CONSTRAINT CK_PRV$MODU  CHECK(MODU IN ('AUT', 'CDT', 'CRC',                               --- Code module - cas des paramÃ¨tres niveau module/produit
                                                               'LSG', 'ISI', 'CAU','TIT')),
   TYPE_PROD      VARCHAR2(10)    ,                                                                                          --- Code type (produit) - cas des paramÃ¨tres niveau produit
   DEV_DOS        CHAR(3)         CONSTRAINT NL_PRV$DEV_DOS  NOT NULL,                                                      ---  Devise numÃ©rique du dossier
   TCHG           NUMBER(15,7)    CONSTRAINT NL_PRV$TCHG  NOT NULL,                                                                                           --- Taux de change (devise du dossier vers devise nat.)
   PROV_S1        NUMBER(19,4)  ,                                                                                           --- Provision S1 - Bucket 1 (en devise nat.)
   PROV_S2        NUMBER(19,4)  ,                                                                                           --- Provision S2 - Bucket 2 (en devise nat.)
   PROV_S1_DEV    NUMBER(19,4)  ,                                                                                           --- Provision S1 - Bucket 1 (en devise du dossier)
   PROV_S2_DEV    NUMBER(19,4)  ,                                                                                           --- Provision S2 - Bucket 2 (en devise du dossier)
   PROV           NUMBER(19,4)  ,                                                                                           --- Provision retenue (en devise nat.)
   PROV_DEV       NUMBER(19,4)  ,                                                                                           --- Provision retenue (en devise du dossier)
   DOT            NUMBER(19,4)  ,                                                                                           --- Montant de dotation (en devise nat.)
   REP            NUMBER(19,4)  ,                                                                                           --- Montant de la reprise (en devise nat.)
   DOT_DEV        NUMBER(19,4)  ,                                                                                           --- Montant de dotation (en devise du dossier)
   REP_DEV        NUMBER(19,4)  ,                                                                                           --- Montant de la reprise (en devise du dossier)
   REP_TOT        NUMBER(1,0)      CONSTRAINT NL_PRV$REP_TOT  NOT NULL,                                                     --- Reprise totale (fin de de provisionnement)
                                                                                                                             -- 0 - Ligne de provision standard
                                                                                                                             -- 1 - Ligne de provision de reprise totale
   CLI            CHAR(15)         CONSTRAINT NL_PRV$CLI  NOT NULL,                                                         --- Client liÃ© Ã  la notation
   TCLI           CHAR(1)          CONSTRAINT NL_PRV$TCLI  NOT NULL                                                          --- Client liÃ© Ã  la notation
);
CREATE UNIQUE INDEX PK_IF9PRV ON IF9_PRV (ID_IF9_PRV);
ALTER TABLE IF9_PRV ADD CONSTRAINT  PK_IF9PRV PRIMARY KEY (ID_IF9_PRV) ;
CREATE UNIQUE INDEX I1_IF9PRV ON IF9_PRV (ID_IF9_VAL,ID_IF9_CYCLE,MODU);
CREATE INDEX FK_IF9_PRV$IF9CYCLE ON IF9_PRV (ID_IF9_CYCLE);
ALTER TABLE IF9_PRV ADD CONSTRAINT FK_IF9PRV$IF9CYCLE FOREIGN KEY (ID_IF9_CYCLE) REFERENCES IF9_CYCLE (ID_IF9_CYCLE) ;
CREATE INDEX I2_IF9_PRV ON IF9_PRV (MODU, DEV_DOS, TYPE_PROD, TCLI);
CREATE INDEX I3_IF9_PRV ON IF9_PRV (CLI);



--Table pour les provisions IFRS 9 des dossiers - DÃ©tail par tanches
CREATE TABLE IF9_EAD (
   ID_IF9_EAD     NUMBER(10,0)   CONSTRAINT NL_EAD$IDEAD    NOT NULL,
   ID_IF9_PRV     NUMBER(10,0)   CONSTRAINT NL_EAD$IDPRV    NOT NULL,                                                       --- Identifiant unique (technique)
   ID_IF9_EADPAR  NUMBER(10,0)  ,                                                                                           --- Identifiant de la provision(technique)
   ID_IF9_EADGAR  NUMBER(10,0)  ,                                                                                           --- Identifiant du paramÃ©trage des taux (technique)
   ID_IF9_EADNAT  NUMBER(10,0)  ,                                                                                           --- Identifiant du paramÃ©trage des taux par tranche (technique)
   TYPE           NUMBER(1,0)   ,                                                                                           --- Identifiant de rÃ¨gle (technique)
                                                                                                                            --- Type de tranches
                                                                                                                             -- 1 - Hors-bilan
                                                                                                                             -- 2 - Bilan non couverte
                                                                                                                             -- 3 - Garantie
   CNAT           CHAR(3)       ,                                                                                           ---Nature de garantie
   IF9_PRV        NUMBER(1,0)    CONSTRAINT CK_EAD$IF9PRV    CHECK(IF9_PRV IN ('0', '1', '2','3')),                         --- Provision IFRS 9
                                                                                                                             -- 0 - Non renseignÃ© (ou NULL)
                                                                                                                             -- 1 - Pas de prise en compte de la garantie
                                                                                                                             -- 2 - DÃ©duction sur l'exposition
                                                                                                                             -- 3 - DÃ©clinaison par tranche                                                                                                                                                                    --- Code identifiant (fonctionnel) de l'attribut
   AGE_GAR        CHAR(5)        ,                                                                                          --- Agence de la garantie
   EVE_GAR        CHAR(6)        ,                                                                                          --- NumÃ©ro de la garantie
   AGE_ENG        CHAR(5)        ,                                                                                          --- Agence du lien engagement garantie
   EVE_ENG        CHAR(6)        ,                                                                                          --- Numero du lien engagement garantie
   MNT_BASE       NUMBER(19,4)   CONSTRAINT NL_EAD$MNT_MNT_BASE   NOT NULL ,                                                --- Montant de base de la tranche (en devise nat.)
   MNT_EAD        NUMBER(19,4)   CONSTRAINT NL_EAD$MNT_EAD   NOT NULL,                                                      --- Montant de l'EAD (en devise nat.)
   MNT_BASE_DEV   NUMBER(19,4)   CONSTRAINT NL_EAD$MNT_BASE_DEV NOT NULL ,                                                  --- Montant de base de la tranche (en devise du dossier)
   MNT_EAD_DEV    NUMBER(19,4)   CONSTRAINT NL_EAD$MNT_EAD_DEV   NOT NULL,                                                  --- Montant de l'EAD en devise du dossier (en devise du dossier)
   PROV_S1        NUMBER(19,4)  ,                                                                                           --- Provision S1 - Bucket 1 (en devise nat.)
   PROV_S2        NUMBER(19,4)  ,                                                                                           --- Provision S2 - Bucket 2 (en devise nat.)
   PROV_S1_DEV    NUMBER(19,4)  ,                                                                                           --- Provision S1 - Bucket 1 (en devise du dossier)
   PROV_S2_DEV    NUMBER(19,4)                                                                                              --- Provision S2 - Bucket 2 (en devise du dossier)
);
CREATE UNIQUE INDEX PK_IF9EAD ON IF9_EAD (ID_IF9_EAD);
ALTER TABLE IF9_EAD ADD CONSTRAINT  PK_IF9EAD PRIMARY KEY (ID_IF9_EAD) ;
CREATE INDEX FK_IF9EAD$IF9PRV ON IF9_EAD (ID_IF9_PRV);
ALTER TABLE IF9_EAD ADD CONSTRAINT FK_IF9EAD$IF9PRV FOREIGN KEY (ID_IF9_PRV) REFERENCES IF9_PRV (ID_IF9_PRV) ;
CREATE INDEX FK_IF9EAD$IF9EADPAR ON IF9_EAD (ID_IF9_EADPAR);
ALTER TABLE IF9_EAD ADD CONSTRAINT FK_IF9EAD$IF9EADPAR FOREIGN KEY (ID_IF9_EADPAR) REFERENCES IF9_EADPAR (ID_IF9_EADPAR) ;
CREATE INDEX FK_IF9EAD$IF9EADGAR ON IF9_EAD (ID_IF9_EADGAR);
ALTER TABLE IF9_EAD ADD CONSTRAINT FK_IF9EAD$IF9EADGAR FOREIGN KEY (ID_IF9_EADGAR) REFERENCES IF9_EADGAR (ID_IF9_EADGAR) ;
CREATE INDEX FK_IF9EAD$IF9EADNAT ON IF9_EAD (ID_IF9_EADNAT);
ALTER TABLE IF9_EAD ADD CONSTRAINT FK_IF9EAD$IF9EADNAT FOREIGN KEY (ID_IF9_EADNAT) REFERENCES IF9_EADNAT (ID_IF9_EADNAT) ;



--- Modification de la table IF9_VALAUT - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALAUT DROP CONSTRAINT NL_VALAUT$ID_VALID;



--- Modification de la table IF9_VALCDT - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALCDT DROP CONSTRAINT NL_VALCDT$ID_VALID;



--- Modification de la table IF9_VALCRC - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALCRC DROP CONSTRAINT NL_VALCRC$ID_VALID;



--- Modification de la table IF9_VALLSG - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALLSG DROP CONSTRAINT NL_VALLSG$ID_VALID;



--- Modification de la table IF9_VALTIT - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALTIT DROP CONSTRAINT NL_VALTIT$ID_VALID;



--- Modification de la table IF9_VALCAU - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALCAU DROP CONSTRAINT NL_VALCAU$ID_VALID;



--- Modification de la table IF9_VALISL - Suprresion de la contrainte NOT NULL
ALTER TABLE IF9_VALISL DROP CONSTRAINT NL_VALISL$ID_VALID;




-- ------------
-- BMAS161206-02_ora.sql
-- ------------
-- BMAS161206-02
-- Rendre optionelle la saisie de l'adresse fiscale dans la gestion des rÃ©sidences fiscales

ALTER TABLE bkrfisccli DROP CONSTRAINT NL_BKRFISCCLI$TYP_ADR;
DROP INDEX i0_BKRFISCCLI;
CREATE INDEX i0_BKRFISCCLI ON bkrfisccli (code,typ,typ_adr);


-- ------------
-- sgbdp170127-03_ora.sql
-- ------------
CREATE INDEX i3_mohis ON mohis (age,dev,ncp,suf);


-- ------------
-- mig_bsic_isi_17_E010_ora.sql
-- ------------
--ANTIDOTE --
--ALTER TABLE pi_type DROP CONSTRAINT CK_PITYPE$GES_PREM_TRAN;
--ALTER TABLE pi_type ADD CONSTRAINT CK_PI_TYPE$GES_PREM_TRAN CHECK(ges_prem_tran IN ('O','N'));
--ALTER TABLE pi_dossiers DROP CONSTRAINT CK_PIDOSSIERS$GES_PREM_TRAN;
--ALTER TABLE pi_dossiers ADD CONSTRAINT CK_PI_DOSSIERS$GES_PREM_TRAN CHECK(ges_prem_tran IN ('O','N'));

-- Ajout de la gestion sans benefice de la premiere tanche
ALTER TABLE pi_type DROP CONSTRAINT CK_PI_TYPE$GES_PREM_TRAN;
ALTER TABLE pi_type ADD CONSTRAINT CK_PITYPE$GES_PREM_TRAN CHECK(ges_prem_tran IN ('O','N','S'));

ALTER TABLE pi_dossiers DROP CONSTRAINT CK_PI_DOSSIERS$GES_PREM_TRAN;
ALTER TABLE pi_dossiers ADD CONSTRAINT CK_PIDOSSIERS$GES_PREM_TRAN CHECK(ges_prem_tran IN ('O','N','S'));



-- ------------
-- DIM_SGBCI170405-02_01_STR_ora.sql
-- ------------
-- SGBCI170405-01 --
-- Le champ Â« cas Â» de bkadcli Ã©tait passÃ© de DECIMAL(6,0) Ã  CHAR(9) dans l Ã©volution V91-CTB-333/CBAO091215-02, mais la table bkadcltrf n avait pas suivi.
ALTER TABLE bkadcltrf MODIFY (cas CHAR(9));


-- ------------
-- BES-FR170411-01_ora.sql
-- ------------
--Ajout d'un index sur txidhav

CREATE INDEX i1_bksepasdd ON bksepasdd(txidhav);


-- ------------
-- EVO_PCBUEMOA_CDT_16_E171_01_STR_ORA.sql
-- ------------
--ROADMAP - PCB UEMOA CDT - Décote restructuration - Version 11.1.1  26/04/2017

--ANTIDOTE
--DROP TABLE bkaccprt_001;

CREATE TABLE bkaccprt_001(
   age          CHAR(5) NOT NULL,
   typ          CHAR(3) NOT NULL,
   poste        CHAR(3) NOT NULL,
   decot_surcot CHAR(1) DEFAULT 'N' CONSTRAINT NL_BKACCPRTER$DECOT_SURCOT NOT NULL);
CREATE UNIQUE INDEX pk_bkaccprt_001 on bkaccprt_001(age,typ,poste);
ALTER TABLE bkaccprt_001 ADD CONSTRAINT pk_bkaccprt_001 PRIMARY KEY (age,typ,poste);
INSERT INTO bkaccprt_001(age,typ,poste) SELECT bkaccprt.age,bkaccprt.typ, bkaccprt.poste FROM bkaccprt;

-- -----------
-- DIM_SGA170405-01_01_STR_ora.sql
-- -----------

-- Mise a jout du poids par la nouvelle valeur par defaut
UPDATE bkacodeb SET poids = poids + (niveau * 10000) WHERE 1=1;
UPDATE bkacocre SET poids = poids + (niveau * 10000) WHERE 1=1;
UPDATE bkacofra SET poids = poids + (niveau * 10000) WHERE 1=1;
UPDATE bkacocde SET poids = poids + (niveau * 10000) WHERE 1=1;
UPDATE bkacocmo SET poids = poids + (niveau * 10000) WHERE 1=1;
UPDATE bkacoprl SET poids = poids + (niveau * 10000) WHERE 1=1;
UPDATE bkacoteg SET poids = poids + (niveau * 10000) WHERE 1=1;

-- Ajout index
CREATE INDEX i2_bkacodeb ON bkacodeb (poids);
CREATE INDEX i2_bkacocre ON bkacocre (poids);
CREATE INDEX i2_bkacofra ON bkacofra (poids);
CREATE INDEX i2_bkacocde ON bkacocde (poids);
CREATE INDEX i2_bkacocmo ON bkacocmo (poids);
CREATE INDEX i2_bkacoprl ON bkacoprl (poids);
CREATE INDEX i2_bkacoteg ON bkacoteg (poids);

-- -----------
-- EVO_CBT161010-01_STR_01_ora.sql
-- -----------

ALTER TABLE bkiso8583out MODIFY (fi057 varchar2(255));


-- -----------
-- DEF_8862_STR_ora.sql
-- -----------
CREATE TABLE tmp_bkec_factif AS SELECT * FROM bkec_factid;
CREATE TABLE tmp_bkec_contratid AS SELECT * FROM bkec_contratid;
DROP TABLE bkec_factid;
DROP TABLE bkec_contratid;


--Table des identifiant de la facture coté fournisseur
CREATE TABLE bkec_factid
(
id_facture                  NUMBER(9,0)       CONSTRAINT NL_FACTID$ID_FACTURE NOT NULL,         -- Identifiant unique d'une facture
id_fournisseur              NUMBER(6,0)       CONSTRAINT NL_FACTID$ID_FOURNISSEUR NOT NULL, -- Identifiant unique d'un fournisseur de services
type_donnee                 CHAR(1)           CONSTRAINT NL_FACTID$TYPE_DONNEE NOT NULL , -- Type de la donnée à identifier
                                              CONSTRAINT CK_FACTID$TYPE_DONNEE CHECK(type_donnee IN ('1','2','3')) ,
num_iden                    NUMBER(1,0)       CONSTRAINT NL_FACTID$NUM_IDEN NOT NULL,        -- Numéro de l'identifiant de la facture
val_iden                    CHAR(30)          CONSTRAINT NL_FACTID$VAL_IDEN NOT NULL         -- Valeur de l'identifiant
);

CREATE UNIQUE INDEX i0_bkec_factid ON bkec_factid (id_facture, id_fournisseur, type_donnee, num_iden);
CREATE INDEX i1_bkec_factid ON bkec_factid (id_fournisseur);
CREATE INDEX i2_bkec_factid ON bkec_factid (num_iden,val_iden,type_donnee,id_fournisseur,id_facture);
ALTER TABLE bkec_factid ADD CONSTRAINT PK_BKEC_FACTID PRIMARY KEY (id_facture, id_fournisseur, type_donnee, num_iden);
ALTER TABLE bkec_factid ADD CONSTRAINT FK_BKEC_FACTID$BKEC_FOUR FOREIGN KEY (id_fournisseur) REFERENCES bkec_four (id_fournisseur);



--Table des identifiant du contrat coté fournisseur
CREATE TABLE bkec_contratid
(
id_contrat	                NUMBER(9,0)       CONSTRAINT NL_CONTRATID$ID_CONTRAT NOT NULL,  --  Identifiant amplitude d'un contrat
id_fournisseur              NUMBER(6,0)       CONSTRAINT NL_CONTRATID$ID_FOURNISSEUR NOT NULL, -- Identifiant unique d'un fournisseur de services
type_donnee                 CHAR(1)           CONSTRAINT NL_CONTRATID$TYPE_DONNEE NOT NULL , -- Type de la donnée à identifier
                                              CONSTRAINT CK_CONTRATID$TYPE_DONNEE CHECK(type_donnee IN ('1','2')) ,
num_iden                    NUMBER(1,0)       CONSTRAINT NL_CONTRATID$NUM_IDEN NOT NULL,        -- Numéro de l'identifiant de la facture
cli                         CHAR(15)          ,                                                 -- Code client Amplitude
val_iden                    CHAR(30)          CONSTRAINT NL_CONTRATID$VAL_IDEN NOT NULL         -- Valeur de l'identifiant
);

CREATE UNIQUE INDEX i0_bkec_contratid ON bkec_contratid (id_contrat, id_fournisseur, type_donnee, num_iden);
CREATE INDEX i1_bkec_contratid ON bkec_contratid (id_fournisseur);
CREATE INDEX i2_bkec_contratid ON bkec_contratid (num_iden,val_iden,type_donnee,id_fournisseur,id_contrat);
ALTER TABLE bkec_contratid ADD CONSTRAINT PK_BKEC_CONTRATID PRIMARY KEY (id_contrat, id_fournisseur, type_donnee, num_iden);
ALTER TABLE bkec_contratid ADD CONSTRAINT FK_BKEC_CONTRATID$BKEC_FOUR FOREIGN KEY (id_fournisseur) REFERENCES bkec_four (id_fournisseur);


INSERT INTO bkec_factid SELECT * FROM tmp_bkec_factif;
INSERT INTO bkec_contratid SELECT * FROM tmp_bkec_contratid;
DROP TABLE tmp_bkec_factif;
DROP TABLE tmp_bkec_contratid;




-- ---------------------------------
-- Mise a jour hebdomadaire de evmod
-- ---------------------------------

        Update evmod
        set amod = '11.1.1',
        dmod = SYSDATE
        where
        cmod = 'DELTA-BANK';


-- ----------------------------------------
-- Mise a jour hebdomadaire de evhistscript
-- ----------------------------------------

       insert into evhistscript
       values ('mig_V11.1.1_ora.sql',SYSDATE);


