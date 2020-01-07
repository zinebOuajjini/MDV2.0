-- ------------
-- DIMmon_BDK170831-01_01_STR_ora.sql
-- ------------
-- ========================================================================
-- Modification de bkiso8583in
-- ========================================================================
ALTER TABLE bkiso8583in MODIFY (
  fi003  CHAR(64),
  fi039  CHAR(64)
);

-- ========================================================================
-- Modification de bkiso8583out
-- ========================================================================
ALTER TABLE bkiso8583out MODIFY (
  fi003  CHAR(64),
  fi039  CHAR(64)
);

-- ------------
-- EVOmcn_EUROPE-17-E013_01_STR_ora.sql
-- ------------
--ANTIDOTE
--DROP TABLE bkdosmcn_001;
--DROP TABLE bkdosmcn_audit_001;

CREATE TABLE bkdosmcn_001(
   modu          CHAR(3)
   ,age          CHAR(5)
   ,typ          CHAR(3)
   ,ndos         CHAR(11)
   ,nbjgra       NUMBER(2,0)
);
CREATE UNIQUE INDEX PK_BKDOSMCN_001 on bkdosmcn_001(modu,age,typ,ndos);
ALTER TABLE bkdosmcn_001 ADD CONSTRAINT PK_BKDOSMCN_001 PRIMARY KEY (modu,age,typ,ndos);

CREATE TABLE bkdosmcn_audit_001(
   numaudit      NUMBER(10,0)
   ,modu         CHAR(3)
   ,age          CHAR(5)
   ,typ          CHAR(3)
   ,ndos         CHAR(11)
   ,nbjgra       NUMBER(2,0)
);

CREATE UNIQUE INDEX PK_BKDOSMCN_AUDIT_001 on bkdosmcn_audit_001(numaudit,modu,age,typ,ndos);
ALTER TABLE bkdosmcn_audit_001 ADD CONSTRAINT PK_BKDOSMCN_AUDIT_001 PRIMARY KEY (numaudit,modu,age,typ,ndos) ;


-- ------------
-- DEF_9374_01_MAJ_ora.sql
-- ------------
--UPDATE bkitfrejcat SET lib7="ON", typcsp7="624129", typcsp6="624130"
--                   WHERE itf="SEPA" AND version="1" AND cat="SDD";

UPDATE bkitfrejcat SET lib7='624129', typcsp7='ON', lib6='624130', typcsp6='ON'
                   WHERE itf='SEPA' AND version='1' AND cat='SDD';

UPDATE bkitfrej SET csp7=csp6
                WHERE itf='SEPA' AND version='1' and cat='SDD';


-- ------------
-- EVOmcn_BGFIEUROPE-17-E006_01_STR_ora.sql
-- ------------
-- DOSSIERS DE MOBILISATIONS SUR CREANCES NEES (MCNE) bkdosmcn_001 + bkdosmcn_audit_001

-------------------------------------------------------------
--Antidote
-- ALTER TABLE bkdosmcn_001 DROP (cclit);
-- ALTER TABLE bkdosmcn_audit_001 DROP (cclit);

-------------------------------------------------------------

-- bkdosmcn_001 = ajout d'un champ
ALTER TABLE bkdosmcn_001 ADD (
	cclit	CHAR(15)
);

-- bkdosmcn_audit_001 = ajout d'un champ
ALTER TABLE bkdosmcn_audit_001 ADD (
	cclit	CHAR(15)
);

-- ------------
-- DEF_9942_01_STR_ora.sql
-- ------------
declare
v_sql LONG;
begin

v_sql:='DROP TRIGGER BKCONDVAL_WDD';
execute immediate v_sql;

EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -4080 THEN
        NULL;
      ELSE
         RAISE;
      END IF;
END;
/

declare
v_sql LONG;
begin

v_sql:='DROP TABLE BKCONDVAL_WATCHDOG';
execute immediate v_sql;

EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -942 THEN
        NULL;
      ELSE
         RAISE;
      END IF;
END;
/


-- ------------
-- DIMmon_SGBS171025-01_01_MAJ_ora.sql
-- ------------
-- Ajout de champs dans motrxtpost pour audit et décalage des mises à jour dans un traitement
-- annexe parallélisé

--ALTER TABLE motrxtpost DROP (
--,  traite_age_eve
--,  trace_id
--,  mcc
--,  rappro1
--,  rappro2
--,  rappro3
--,  traite_age_cnp
--,  maj_bkeve_cnp_tmp
--,  maj_bkeve_cnp_matching
--,  age_cnp
--,  ope_cnp
--,  eve_cnp
--,  mon1_cnp
--,  traite_age_prdcli
--,  maj_bkstopcli
--,  age_prdcli
--,  per
--,  cli
--,  ope_stopcli
--,  annee
--,  mois
--,  traite_age_serv
--,  maj_mcpdvforf
--,  age_serv
--,  id_pdv
--,  id_serv
--,  version
--,  id_ccom
--,  traite_age_pdv
--,  maj_mctpe
--,  age_pdv
--,  id_term
--,  traite_age_carte
--,  maj_mocarte_data
--,  age_carte
--,  refcar
--) ;


ALTER TABLE motrxtpost ADD (
   traite_age_eve         CHAR(1)
,  trace_id               CHAR(36)
,  mcc                    CHAR(4)
,  rappro1                CHAR(200)
,  rappro2                CHAR(200)
,  rappro3                CHAR(200)
,  traite_age_cnp         CHAR(1)
,  maj_bkeve_cnp_tmp      NUMBER(5)
,  maj_bkeve_cnp_matching NUMBER(5)
,  age_cnp                CHAR(5)
,  ope_cnp                CHAR(3)
,  eve_cnp                CHAR(6)
,  mon1_cnp               NUMBER(19,4)
,  traite_age_prdcli      CHAR(1)
,  maj_bkstopcli          NUMBER(5)
,  age_prdcli             CHAR(5)
,  per                    CHAR(1)
,  cli                    CHAR(15)
,  ope_stopcli            CHAR(3)
,  annee                  NUMBER(5)
,  mois                   NUMBER(5)
,  traite_age_serv        CHAR(1)
,  maj_mcpdvforf          NUMBER(5)
,  age_serv               CHAR(5)
,  id_pdv                 CHAR(10)
,  id_serv                CHAR(10)
,  version                NUMBER(5)
,  id_ccom                CHAR(10)
,  traite_age_pdv         CHAR(1)
,  maj_mctpe              NUMBER(5)
,  age_pdv                CHAR(5)
,  id_term                CHAR(10)
,  traite_age_carte       CHAR(1)
,  maj_mocarte_data       NUMBER(5)
,  age_carte              CHAR(5)
,  refcar                 NUMBER(10,0)
) ;

-- ------------
-- DIM_MON_SGBS171107-04_01_STR_ora.sql
-- ------------
ALTER TABLE motranf DROP CONSTRAINT fk_motranf$refcar;

-- ------------
-- DEF_8074_01_MAJ_ora.sql
-- ------------
-- Script de correction du defect 8074 pour corriger le script mig_kyc_nouv_DIMAD_cli_ora.sql

DELETE from abdomad where refdo = '379' or refdo ='380';

INSERT INTO abdomad(refdo,origine,typcli,reffct,valparefct,numaff,utilscen,nomlab,dou,dmo,uti)
   VALUES ('379','2','T',NULL,' ','379','N',NULL,TO_CHAR(SYSDATE,'DD/MM/YYYY'),NULL,'DELT');
INSERT INTO abdomad(refdo,origine,typcli,reffct,valparefct,numaff,utilscen,nomlab,dou,dmo,uti)
   VALUES ('380','2','T',NULL,' ','380','N',NULL,TO_CHAR(SYSDATE,'DD/MM/YYYY'),NULL,'DELT');

-- ------------
-- DIM_TMAIBFS171031-04_01_STR_ora.sql
-- ------------
--Antidote
--ALTER TABLE bkrecapfra DROP CONSTRAINT CK_BKRECAPFRA$orig;
--ALTER TABLE bkrecapfra ADD CONSTRAINT CK_BKRECAPFRA$orig CHECK (orig IN ('Q' /* Traitement quotidien */, 'R' /* reprise de l'historique */));

ALTER TABLE bkrecapfra DROP CONSTRAINT CK_BKRECAPFRA$orig;
ALTER TABLE bkrecapfra ADD CONSTRAINT CK_BKRECAPFRA$orig CHECK (orig IN ('Q' /* Traitement quotidien */, 'R' /* reprise de l'historique */, 'M' /* traitement manuel */));

-- ------------
-- DIMtreso_SGTOS171206-01_01_STR_ora.sql
-- ------------
/*
--	Script ORACLE
--	Modification des contraintes ck_tft_fxope_mod_hist_10, ck_tft_fxope_mod_hist_13 et ck_tft_fxope_mod_hist_37 sur la table TFT_FXOPE_MOD_HIST

--	ANTIDOTE :
	ALTER TABLE TFT_FXOPE_MOD_HIST DROP CONSTRAINT CK_FXOPE_MOD$OPERATION_SIDE;
	ALTER TABLE TFT_FXOPE_MOD_HIST ADD CONSTRAINT ck_tft_fxope_mod_hist_10 CHECK (operation_side IN ('A', 'V'));

	ALTER TABLE TFT_FXOPE_MOD_HIST DROP CONSTRAINT CK_FXOPE_MOD$FORWARD_SPOT_CODE;
	ALTER TABLE TFT_FXOPE_MOD_HIST ADD CONSTRAINT ck_tft_fxope_mod_hist_13 CHECK (forward_spot_code IN ('C', 'T'));

	ALTER TABLE TFT_FXOPE_MOD_HIST DROP CONSTRAINT CK_FXOPE_MOD$TRANS_SUB_TYPE;
	ALTER TABLE TFT_FXOPE_MOD_HIST ADD CONSTRAINT ck_tft_fxope_mod_hist_37 CHECK (transaction_sub_type IN ('TERME' ,'COMPTANT'));
*/
--/*
ALTER TABLE TFT_FXOPE_MOD_HIST DROP CONSTRAINT ck_tft_fxope_mod_hist_10;
ALTER TABLE TFT_FXOPE_MOD_HIST ADD CONSTRAINT CK_FXOPE_MOD$OPERATION_SIDE CHECK (operation_side IN (' ', 'A', 'V'));

ALTER TABLE TFT_FXOPE_MOD_HIST DROP CONSTRAINT ck_tft_fxope_mod_hist_13;
ALTER TABLE TFT_FXOPE_MOD_HIST ADD CONSTRAINT CK_FXOPE_MOD$FORWARD_SPOT_CODE CHECK (forward_spot_code IN (' ', 'C', 'T'));

ALTER TABLE TFT_FXOPE_MOD_HIST DROP CONSTRAINT ck_tft_fxope_mod_hist_37;
ALTER TABLE TFT_FXOPE_MOD_HIST ADD CONSTRAINT CK_FXOPE_MOD$TRANS_SUB_TYPE CHECK (transaction_sub_type IN (' ', 'TERME' ,'COMPTANT'));
--*/

-- ------------
-- DIM_SGA170405-01_01_MAJ_ora.sql
-- ------------
-- V101-ARR-001 : en montee de version, migration, obligation d'initialiser le
-- poids des conditions d'arretes car a partir de cette version le calcul du
-- poids est obligtaoirement different (ajout du niveau dans la valeur du poids).

CREATE OR REPLACE FUNCTION V101_ARR_01_calcul_poids(p_niveau IN NUMBER,p_age IN CHAR,p_dev IN CHAR,p_cprod IN CHAR,p_cpack IN CHAR,p_site IN VARCHAR)
   RETURN NUMBER IS

   f_poids NUMBER(7,0);

BEGIN

   f_poids := p_niveau * 10000;
   IF p_dev = '*' THEN
      f_poids := f_poids + 1000;
   END IF;
   IF p_cprod = '*' THEN
      f_poids := f_poids + 100;
   END IF;
   IF p_cpack = '*' THEN
      f_poids := f_poids + 10;
   END IF;
   IF p_cpack = ' ' THEN
      f_poids := f_poids + 20;
   END IF;
   IF p_age = p_site THEN
      f_poids := f_poids + 1;
   END IF;

   RETURN f_poids;

END;
/


UPDATE bkacodeb SET poids = V101_ARR_01_calcul_poids(bkacodeb.niveau,bkacodeb.age,bkacodeb.dev,bkacodeb.cprod,bkacodeb.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;
UPDATE bkacocre SET poids = V101_ARR_01_calcul_poids(bkacocre.niveau,bkacocre.age,bkacocre.dev,bkacocre.cprod,bkacocre.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;
UPDATE bkacoprl SET poids = V101_ARR_01_calcul_poids(bkacoprl.niveau,bkacoprl.age,bkacoprl.dev,bkacoprl.cprod,bkacoprl.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;
UPDATE bkacofra SET poids = V101_ARR_01_calcul_poids(bkacofra.niveau,bkacofra.age,bkacofra.dev,bkacofra.cprod,bkacofra.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;
UPDATE bkacocmo SET poids = V101_ARR_01_calcul_poids(bkacocmo.niveau,bkacocmo.age,bkacocmo.dev,bkacocmo.cprod,bkacocmo.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;
UPDATE bkacocde SET poids = V101_ARR_01_calcul_poids(bkacocde.niveau,bkacocde.age,bkacocde.dev,bkacocde.cprod,bkacocde.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;
UPDATE bkacoteg SET poids = V101_ARR_01_calcul_poids(bkacoteg.niveau,bkacoteg.age,bkacoteg.dev,bkacoteg.cprod,bkacoteg.cpack,(SELECT age FROM bknom WHERE ctab = '098' AND cacc = 'BANQUE')) WHERE 1=1;

DROP FUNCTION V101_ARR_01_calcul_poids;

-- ------------
-- DEF_10072_01_MAJ_ora.sql
-- ------------
UPDATE bketebac SET formatext = '0' WHERE formatext IS NULL or formatext =' ';

-- ------------
-- DIM_mdp_TMAIBFS171211-02_01_MAJ_ora.sql
-- ------------
DELETE FROM bkmoperror_code;
DELETE FROM bkmoperror_cat;
INSERT INTO bkmoperror_cat VALUES('PAIN','0','TOUT');
INSERT INTO bkmoperror_cat VALUES('TYPE','001','Parametrage');
INSERT INTO bkmoperror_cat VALUES('TYPE','002','XSD');
INSERT INTO bkmoperror_cat VALUES('TYPE','003','Identification');
INSERT INTO bkmoperror_cat VALUES('TYPE','004','MD5');
INSERT INTO bkmoperror_cat VALUES('TYPE','005','ISO');
INSERT INTO bkmoperror_cat VALUES('TYPE','006','Canal');
INSERT INTO bkmoperror_cat VALUES('TYPE','007','Flux');
INSERT INTO bkmoperror_cat VALUES('TYPE','008','Compte');
INSERT INTO bkmoperror_cat VALUES('TYPE','009','Transaction');
INSERT INTO bkmoperror_cat VALUES('PROG','01','gumoprec');
INSERT INTO bkmoperror_cat VALUES('TYPE','010','Traitement transfert');
INSERT INTO bkmoperror_cat VALUES('TYPE','011','Traitement prélèvement');
INSERT INTO bkmoperror_cat VALUES('TYPE','013','Requêtes');
INSERT INTO bkmoperror_cat VALUES('FONC','014','fct_tm_mop_genere_vir');
INSERT INTO bkmoperror_cat VALUES('FONC','015','fct_tm_mop_genere_prlaut');
INSERT INTO bkmoperror_cat VALUES('FONC','016','fct_tm_mop_genere_prlabq');
INSERT INTO bkmoperror_cat VALUES('FONC','017','fct_trf_mop_genere');
INSERT INTO bkmoperror_cat VALUES('TYPE','018','TOUT');
INSERT INTO bkmoperror_cat VALUES('TYPE','019','Emission de PSR');
INSERT INTO bkmoperror_cat VALUES('PROG','02','gumoptrt');
INSERT INTO bkmoperror_cat VALUES('TYPE','020','LOT');
INSERT INTO bkmoperror_cat VALUES('TYPE','021','routage');
INSERT INTO bkmoperror_cat VALUES('FONC','022','fct_tm_mop_sepa');
INSERT INTO bkmoperror_cat VALUES('FONC','023','CBSNOTINIT');
INSERT INTO bkmoperror_cat VALUES('FONC','024','CBSNOTPSR');
INSERT INTO bkmoperror_cat VALUES('FONC','025','CBMAJSTNOT');
INSERT INTO bkmoperror_cat VALUES('FONC','026','GUMOPREP');
INSERT INTO bkmoperror_cat VALUES('FONC','027','FCT_TM_MOP');
INSERT INTO bkmoperror_cat VALUES('FONC','028','FCT_TM_CLIENT');
INSERT INTO bkmoperror_cat VALUES('FONC','029','FCT_TM_MOP_TRT');
INSERT INTO bkmoperror_cat VALUES('PROG','03','gumoprep');
INSERT INTO bkmoperror_cat VALUES('FONC','030','FCT_TM_ABO');
INSERT INTO bkmoperror_cat VALUES('FONC','031','FCT_TM_STSNOT');
INSERT INTO bkmoperror_cat VALUES('FONC','032','FCT_TM_PSR');
INSERT INTO bkmoperror_cat VALUES('TYPE','033','GUMOPTRT');
INSERT INTO bkmoperror_cat VALUES('FONC','034','CRE_PRLAUT');
INSERT INTO bkmoperror_cat VALUES('FONC','035','CRE_PRLABQ');
INSERT INTO bkmoperror_cat VALUES('TYPE','036','CBSNOTCAMT');
INSERT INTO bkmoperror_cat VALUES('TYPE','037','???');
INSERT INTO bkmoperror_cat VALUES('TYPE','038','CBSNOTDCAM');
INSERT INTO bkmoperror_cat VALUES('FONC','039','GUMOPREC');
INSERT INTO bkmoperror_cat VALUES('PROG','04','gumopmtrf');
INSERT INTO bkmoperror_cat VALUES('FONC','040','FCT_TM_SDD');
INSERT INTO bkmoperror_cat VALUES('FONC','041','GUSEPAREC');
INSERT INTO bkmoperror_cat VALUES('FONC','042','FCT_TM_GEN_VIRSCT');
INSERT INTO bkmoperror_cat VALUES('FONC','043','GUGENSEPA');
INSERT INTO bkmoperror_cat VALUES('FONC','044','GUPRESEPA');
INSERT INTO bkmoperror_cat VALUES('FONC','045','gusepaeve');
INSERT INTO bkmoperror_cat VALUES('TYPE','046','FCT_TM_MOP_MAJ');
INSERT INTO bkmoperror_cat VALUES('TYPE','047','GUMOPLREP');
INSERT INTO bkmoperror_cat VALUES('FONC','048','CBCRSEQOPE');
INSERT INTO bkmoperror_cat VALUES('TYPE','049','gu_bl_cmp_dao');
INSERT INTO bkmoperror_cat VALUES('PROG','05','gumopmdd');
INSERT INTO bkmoperror_cat VALUES('FONC','050','gu_bl_cmp_spec_maurice');
INSERT INTO bkmoperror_cat VALUES('FONC','051','gucmppre');
INSERT INTO bkmoperror_cat VALUES('FONC','052','gu_bl_cmp');
INSERT INTO bkmoperror_cat VALUES('FONC','053','gucmpenv');
INSERT INTO bkmoperror_cat VALUES('FONC','054','GUCMPREC');
INSERT INTO bkmoperror_cat VALUES('FONC','055','GU_BL_CMPREC_SPEC_MAURIC');
INSERT INTO bkmoperror_cat VALUES('FONC','056','gu_bl_cmpenv_spec_mauric');
INSERT INTO bkmoperror_cat VALUES('TYPE','057','GU_BL_CMPMONI_PPREP');
INSERT INTO bkmoperror_cat VALUES('FONC','058','GU_BL_CMPMONI_PREC');
INSERT INTO bkmoperror_cat VALUES('FONC','059','GU_BL_CMPMONI_PSUIVI');
INSERT INTO bkmoperror_cat VALUES('TYPE','060','GU_BL_CMPMONI_PERR');
INSERT INTO bkmoperror_cat VALUES('FONC','061','GU_BL_CMPMONI_PCONS');
INSERT INTO bkmoperror_cat VALUES('FONC','062','fc_bl_tm_ctrlvisu');
INSERT INTO bkmoperror_cat VALUES('FONC','063','fc_bl_signature');
INSERT INTO bkmoperror_cat VALUES('FONC','064','cbdmsigdes');
INSERT INTO bkmoperror_cat VALUES('FONC','065','GU_BL_CMPMONI_PENV');
INSERT INTO bkmoperror_cat VALUES('FONC','066','gucmpcvisu');
INSERT INTO bkmoperror_cat VALUES('FONC','067','FCT_BKEVE');
INSERT INTO bkmoperror_cat VALUES('FONC','068','FCT_GESEVE');
INSERT INTO bkmoperror_cat VALUES('FONC','069','API_GU_CMP');
INSERT INTO bkmoperror_cat VALUES('FONC','070','API_CMP_SCREEN');
INSERT INTO bkmoperror_cat VALUES('FONC','071','GU_BL_CMPMONI_PANN');
INSERT INTO bkmoperror_cat VALUES('FONC','072','GU_BL_CMPMONI_PSAIREJ');
INSERT INTO bkmoperror_cat VALUES('FONC','073','gu_bl_ctrl_visu');
INSERT INTO bkmoperror_cat VALUES('FONC','074','gu_ctrl_visu');
INSERT INTO bkmoperror_cat VALUES('FONC','075','GU_BL_CHQ_CTRL');
INSERT INTO bkmoperror_cat VALUES('FONC','076','GUCMPEVE');
INSERT INTO bkmoperror_cat VALUES('FONC','077','API_GU_GENCHQ');
INSERT INTO bkmoperror_cat VALUES('TYPE','078','GU_BL_CMPMONI_PGESREJ');
INSERT INTO bkmoperror_cat VALUES('FONC','079','GU_BL_CMPMONI_PCOR');
INSERT INTO bkmoperror_cat VALUES('FONC','080','fc_bl_postmsg');
INSERT INTO bkmoperror_cat VALUES('FONC','081','GUCMPHISTO');
INSERT INTO bkmoperror_cat VALUES('FONC','082','API_GU_MOP');
INSERT INTO bkmoperror_cat VALUES('FONC','083','FC_BL_SEQ');
INSERT INTO bkmoperror_cat VALUES('FONC','084','fct_ope');
INSERT INTO bkmoperror_cat VALUES('FONC','085','CRE_AGEVIR');
INSERT INTO bkmoperror_cat VALUES('FONC','086','CBMAJ060');
INSERT INTO bkmoperror_cat VALUES('FONC','087','guconvxslt');
INSERT INTO bkmoperror_cat VALUES('FONC','088','API_CONVERSION_FIC');
INSERT INTO bkmoperror_cat VALUES('FONC','089','FC_BL_ITFCODE');
INSERT INTO bkmoperror_cat VALUES('FONC','090','API_GU_GENVIR');
INSERT INTO bkmoperror_cat VALUES('FONC','091','GUCMPFORC');
INSERT INTO bkmoperror_cat VALUES('TYPE','092','GUMOPMVAL');
INSERT INTO bkmoperror_cat VALUES('TYPE','093','GU_BL_CMPENV_SPEC_VIET');
INSERT INTO bkmoperror_cat VALUES('FONC','094','fc_bl_ampxml');
INSERT INTO bkmoperror_cat VALUES('TYPE','095','GU_BL_CMPREC_SPEC_VIET');
INSERT INTO bkmoperror_cat VALUES('FONC','096','API_CMP_REG');
INSERT INTO bkmoperror_cat VALUES('FONC','097','GU_CMP_REG');
INSERT INTO bkmoperror_cat VALUES('FONC','098','api_chqfac');
INSERT INTO bkmoperror_cat VALUES('FONC','099','API_GU_CHQFAC');
INSERT INTO bkmoperror_cat VALUES('PAIN','1','PAIN.001');
INSERT INTO bkmoperror_cat VALUES('FONC','100','API_GU_CHQ');
INSERT INTO bkmoperror_cat VALUES('TYPE','101','GU_BL_CMPMONI_PEXC');
INSERT INTO bkmoperror_cat VALUES('TYPE','102','gurdccvisu');
INSERT INTO bkmoperror_cat VALUES('FONC','103','API_GU_GENRES');
INSERT INTO bkmoperror_cat VALUES('FONC','104','fct_tm_mop_ebc');
INSERT INTO bkmoperror_cat VALUES('PAIN','2','PAIN.002');
INSERT INTO bkmoperror_cat VALUES('PAIN','8','PAIN.008');
--Langue : 001
INSERT INTO bkmoperror_code VALUES('T','001','0001','001','Le type de base est incorrect. Il doit être soit PROD, soit PRE-PROD soit HOMOLOGATION.','Corriger la configuration du paramètre "TYPE_BASE" en nomenclature "098"');
INSERT INTO bkmoperror_code VALUES('T','001','0002','001','Paramètre mal renseigne.',' Le paramètre cité dans le message d''erreur n''est pas correctement renseigné. Corriger la configuration du paramètre via la gestion des paramètres "cbitfparam"');
INSERT INTO bkmoperror_code VALUES('T','001','0003','001','Paramètre manquant.','Le paramètre cité n''est pas défini, cela signifie que le référentiel des paramètres n''est probablement pas à jour. Contacter la maintenance Delta-Bank');
INSERT INTO bkmoperror_code VALUES('T','001','0004','001','Problème lors de l''initialisation des interfaces.','');
INSERT INTO bkmoperror_code VALUES('T','001','0005','001','Problème lors du traitement des interfaces.','');
INSERT INTO bkmoperror_code VALUES('T','001','0006','001','problème lors de la fermeture de l''interface.','');
INSERT INTO bkmoperror_code VALUES('T','001','0007','001','Code erreur absent du référentiel!','Le référentiel des codes erreur (tables bkmoperror_cat et bkmoperror_code) n''est pas à jour. Contacter la maintenance Delta-Bank');
INSERT INTO bkmoperror_code VALUES('T','001','0008','001','Dossier temporaire de travail non trouve.','');
INSERT INTO bkmoperror_code VALUES('T','001','0009','001','Compta par défaut des transfert non renseignée','');
INSERT INTO bkmoperror_code VALUES('T','001','0010','001','Compta par défaut des prélèvements non renseignée','');
INSERT INTO bkmoperror_code VALUES('T','001','0011','001','Code BIC incorrect dans la fiche banque du site central','Corriger la fiche banque du site central');
INSERT INTO bkmoperror_code VALUES('T','001','0012','001','Longueur de l''IBAN locale mal parametree','');
INSERT INTO bkmoperror_code VALUES('T','002','0001','001','Validation XSD échouée.','Vérifier le flux, vérifier la XSD.');
INSERT INTO bkmoperror_code VALUES('T','003','0001','001','Flux de simulation intégré sur une base de production.','');
INSERT INTO bkmoperror_code VALUES('T','003','0002','001','Flux de production intégré sur une base de test (pré-prod ou homologation).','');
INSERT INTO bkmoperror_code VALUES('T','003','0003','001','Flux de pré-production intégré sur une base d''homologation.','');
INSERT INTO bkmoperror_code VALUES('T','003','0004','001','Flux d''homologation intégré sur une base de pré-production.','');
INSERT INTO bkmoperror_code VALUES('T','003','0005','001','Flux de pré-production intégré sur une base de production.','');
INSERT INTO bkmoperror_code VALUES('T','003','0006','001','Flux d''homologation intégré sur une base de production.','');
INSERT INTO bkmoperror_code VALUES('T','003','0007','001','Réception d''un flux généré par le simulateur Delta-Bank du SIOP, sur un environnement n''étant pas un environnement de test','Vérifier l''environnement et le routage des flux, si le routage des flux est correct et l''environnement est bien un environnement de test alors définir la variable d''environnement TEST_CONNECTOR à 1');
INSERT INTO bkmoperror_code VALUES('T','003','0008','001','Identification du flux non indiquée.','');
INSERT INTO bkmoperror_code VALUES('T','004','0001','001','Impossible de calculer le MD5 du flux.','');
INSERT INTO bkmoperror_code VALUES('T','004','0002','001','MD5 duplique : potentielle duplication de flux','');
INSERT INTO bkmoperror_code VALUES('T','004','0003','001','Transaction potentiellement dupliquée.','');
INSERT INTO bkmoperror_code VALUES('T','004','0004','001','Toutes les transactions du lot sont en anomalies.','');
INSERT INTO bkmoperror_code VALUES('T','005','0001','001','La règle ISO ''PaymentTypeInformationRule'' n''est pas respectée.','Le type de paiement doit être indiqué soit globalement, soit unitairement pour chaque crédit, ou être absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0002','001','La règle ISO ''ChequeInstructionRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0003','001','La règle ISO ''ChargesAccountRule'' n''est pas respectée.','Le compte de frais est manquant ou l''intitution de frais doit être absente.');
INSERT INTO bkmoperror_code VALUES('T','005','0004','001','La règle ISO ''ChargesAccountAgentRule'' n''est pas respectée.','L''agence de l''institution de frais ne correspond pas a une agence de l''institution du donneur d''ordre.');
INSERT INTO bkmoperror_code VALUES('T','005','0005','001','La règle ISO ''ChargeBearerRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0006','001','La règle ISO ''UltimateDebtorRule'' n''est pas respectée.','Le débiteur ultime doit être indiqué soit globalement, soit unitairement pour chaque crédit, ou être absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0007','001','La règle ISO ''ChequeAndCreditorAccountRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0008','001','La règle ISO ''ChequeDeliveryAndCreditorAgentRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0009','001','La règle ISO ''ChequeDeliveryAndNoCreditorAgentRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0010','001','La règle ISO ''NonChequePaymentMethodRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0011','001','La règle ISO ''ChequeNoDeliveryAndNoCreditorAgentRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0012','001','La règle ISO ''IntermediaryAgent2Rule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0013','001','La règle ISO ''IntermediaryAgent3Rule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0014','001','La règle ISO ''InstructionForCreditorAgentRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0015','001','La règle ISO ''IntermediaryAgent1AccountRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0016','001','La règle ISO ''IntermediaryAgent2AccountRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0017','001','La règle ISO ''IntermediaryAgent3AccountRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0018','001','La règle ISO ''ChequeMaturityDateRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0019','001','La règle ISO ''CreditorSchemeIdentificationRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0020','001','La règle ISO ''UltimateCreditorRule'' n''est pas respectée.','Le creancier ultime doit être indiqué soit globalement, soit unitairement pour chaque crédit, ou être absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0021','001','La règle ISO ''AmendmentIndicatorTrueRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0022','001','La règle ISO ''AmendmentIndicatorFalseRule'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0023','001','La règle ISO ''PaymentInformationStatus'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0024','001','La règle ISO ''AccountServicerReference'' n''est pas respectée.','');
INSERT INTO bkmoperror_code VALUES('T','005','0025','001','La règle ISO ''UltimateDebtor'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0026','001','La règle ISO ''Debtor'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0027','001','La règle ISO ''DebtorAccount'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0028','001','La règle ISO ''DebtorAgent'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0029','001','La règle ISO ''DebtorAgentAccount'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0030','001','La règle ISO ''CreditorAgent'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0031','001','La règle ISO ''CreditorAgentAccount'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0032','001','La règle ISO ''Creditor'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0033','001','La règle ISO ''CreditorAccount'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','005','0034','001','La règle ISO ''UltimateCreditor'' n''est pas respectée','');
INSERT INTO bkmoperror_code VALUES('T','006','0001','001','Le canal n''est pas actif','');
INSERT INTO bkmoperror_code VALUES('T','006','0002','001','La canal indique dans le flux ne correspond pas au canal en cours.','');
INSERT INTO bkmoperror_code VALUES('T','006','0003','001','Le canal ne reçoit pas de transfert.','');
INSERT INTO bkmoperror_code VALUES('T','006','0004','001','Le canal ne reçoit pas de prélèvement.','');
INSERT INTO bkmoperror_code VALUES('T','006','0005','001','Plusieurs canaux pour cette interface.','');
INSERT INTO bkmoperror_code VALUES('T','007','0001','001','Impossible de lire le flux.','');
INSERT INTO bkmoperror_code VALUES('T','007','0002','001','Flux non valide.','');
INSERT INTO bkmoperror_code VALUES('T','007','0003','001','Il y a des données privatives en double dans le flux.','');
INSERT INTO bkmoperror_code VALUES('T','008','0001','001','Compte du donneur d''ordre inexistant','');
INSERT INTO bkmoperror_code VALUES('T','008','0002','001','Compte de frais du donneur d''ordre inexistant.','');
INSERT INTO bkmoperror_code VALUES('T','008','0003','001','Compte de la transaction inexistant.','');
INSERT INTO bkmoperror_code VALUES('T','008','0004','001','Compte de frais n''appartient pas au donneur d''ordre.','');
INSERT INTO bkmoperror_code VALUES('T','008','0005','001','Compte de frais n''appartient pas à la banque.','');
INSERT INTO bkmoperror_code VALUES('T','008','0006','001','Au moins un comptes (niveau ordre ou transaction) doit être dans la devise de transaction.','');
INSERT INTO bkmoperror_code VALUES('T','008','0007','001','Format du compte du donneur d''ordre incorrect.','');
INSERT INTO bkmoperror_code VALUES('T','008','0008','001','Format du compte de frais incorrect.','');
INSERT INTO bkmoperror_code VALUES('T','008','0009','001','Format du compte de la transaction incorrect.','');
INSERT INTO bkmoperror_code VALUES('T','008','0010','001','Le code BIC de la transaction est inconnu','');
INSERT INTO bkmoperror_code VALUES('T','008','0011','001','Compte non en faveur de la TGR','');
INSERT INTO bkmoperror_code VALUES('T','008','0012','001','Virement permanent international non autorisé','');
INSERT INTO bkmoperror_code VALUES('T','008','0013','001','Date de début du virement permanent incorrecte','');
INSERT INTO bkmoperror_code VALUES('T','009','0001','001','Montant de la transaction à 0.','');
INSERT INTO bkmoperror_code VALUES('T','009','0002','001','Montant de la transaction négatif.','');
INSERT INTO bkmoperror_code VALUES('T','009','0003','001','Code virement SICA incorrect','');
INSERT INTO bkmoperror_code VALUES('T','009','0004','001','Code economique en doublon dans la transaction','');
INSERT INTO bkmoperror_code VALUES('T','009','0005','001','Au moins une des références locales est erronée','');
INSERT INTO bkmoperror_code VALUES('T','009','0006','001','Reference avis imposition incorrecte','');
INSERT INTO bkmoperror_code VALUES('T','010','0001','001','Erreur numéro évènement','');
INSERT INTO bkmoperror_code VALUES('T','010','0002','001','Erreur lecture banque bénéficiaire','');
INSERT INTO bkmoperror_code VALUES('T','010','0003','001','Incident insert bkeve','');
INSERT INTO bkmoperror_code VALUES('T','010','0004','001','Devise transaction inconnue','');
INSERT INTO bkmoperror_code VALUES('T','010','0005','001','Le type de virement ne gère pas de traitement multiple','');
INSERT INTO bkmoperror_code VALUES('T','010','0006','001','Le type de virement ne gère pas de traitement unitaire','');
INSERT INTO bkmoperror_code VALUES('T','010','0007','001','Type de virement inconnu','');
INSERT INTO bkmoperror_code VALUES('T','010','0008','001','Compte donneur d''ordre inexistant','');
INSERT INTO bkmoperror_code VALUES('T','010','0009','001','Compte de frais inexistant','');
INSERT INTO bkmoperror_code VALUES('T','010','0010','001','Compte bénéficiaire inexistant','');
INSERT INTO bkmoperror_code VALUES('T','010','0011','001','Code économique non renseigné pour la transaction','correction via le moniteur transfert');
INSERT INTO bkmoperror_code VALUES('T','010','0012','001','Code économique incorrect','correction via le moniteur transfert');
INSERT INTO bkmoperror_code VALUES('T','011','0001','001','Devise transaction inconnue','');
INSERT INTO bkmoperror_code VALUES('T','012','0001','001','Erreur lors de la sélection du message','');
INSERT INTO bkmoperror_code VALUES('T','012','0002','001','Erreur lors de la sélection du lot','');
INSERT INTO bkmoperror_code VALUES('T','012','0003','001','Erreur lors de la sélection de la transaction','');
INSERT INTO bkmoperror_code VALUES('T','012','0004','001','Erreur lors de la sélection de env pour le canal','');
INSERT INTO bkmoperror_code VALUES('T','012','0005','001','Incident insert bkmoplot_rep.eta','');
INSERT INTO bkmoperror_code VALUES('T','012','0006','001','Incident insert bkmoptx_rep.eta','');
INSERT INTO bkmoperror_code VALUES('T','012','0007','001','Incident update bkmopmsg_rep','');
INSERT INTO bkmoperror_code VALUES('T','012','0008','001','Incident update bkmoplot_rep','');
INSERT INTO bkmoperror_code VALUES('T','012','0009','001','Incident update bkmoptx_rep','');
INSERT INTO bkmoperror_code VALUES('T','013','0001','001','Erreur d''intégration du message.','');
INSERT INTO bkmoperror_code VALUES('T','013','0002','001','Erreur d''intégration du lot.','');
INSERT INTO bkmoperror_code VALUES('T','013','0003','001','Erreur d''intégration de la transaction.','');
INSERT INTO bkmoperror_code VALUES('T','013','0004','001','Erreur lors de l''alimentation de bkmopmsg_md5','');
INSERT INTO bkmoperror_code VALUES('T','013','0005','001','Erreur lors de l''alimentation de bkmoptx_md5','');
INSERT INTO bkmoperror_code VALUES('T','013','0006','001','Impossible d''insérer une réponse.','');
INSERT INTO bkmoperror_code VALUES('T','013','0007','001','Valeur non autorisée dans la donnée privative PtcInf_Sgt','Le flux est rejeté.');
INSERT INTO bkmoperror_code VALUES('T','013','0008','001','EU n''est pas une valeur autorisée pour l''élément FlwInd','Le flux est rejeté.');
INSERT INTO bkmoperror_code VALUES('T','013','0009','001','Erreur lors de la sélection du statut du message','');
INSERT INTO bkmoperror_code VALUES('T','013','0010','001','HU n''est pas une valeur autorisée pour l''élément FlwInd','Le flux est rejeté.');
INSERT INTO bkmoperror_code VALUES('T','013','0011','001','Erreur lors de la selection du code economique','');
INSERT INTO bkmoperror_code VALUES('T','013','0012','001','Erreur lors de la selection du code de la donnée privative du PSR','');
INSERT INTO bkmoperror_code VALUES('T','013','0013','001','Erreur lors de la selection du type d''opération.','');
INSERT INTO bkmoperror_code VALUES('T','013','0014','001','Erreur lors de l''insertion de bkmoplot_rev','');
INSERT INTO bkmoperror_code VALUES('T','013','0015','001','Erreur de comptage des motifs structurés ou non structurés','');
INSERT INTO bkmoperror_code VALUES('F','014','0001','001','Devise du virement inconnue.','');
INSERT INTO bkmoperror_code VALUES('F','014','0002','001','Le type de virement n''est pas autorisé.','');
INSERT INTO bkmoperror_code VALUES('F','014','0003','001','Type de virement inconnu.','');
INSERT INTO bkmoperror_code VALUES('F','014','0004','001','Agence de traitement inconnue.','');
INSERT INTO bkmoperror_code VALUES('F','014','0005','001','Erreur lors du chargement des chapitres comptable.','');
INSERT INTO bkmoperror_code VALUES('F','014','0006','001','Compte du donneur d''ordre inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','014','0007','001','Compte de frais inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','014','0008','001','Compte du bénéficiaire inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','014','0009','001','Chapitre comptable du compte du donneur d''ordre non autorise pour l''opération.','');
INSERT INTO bkmoperror_code VALUES('F','014','0010','001','Chapitre comptable du compte du bénéficiaire non autorise pour l''opération.','');
INSERT INTO bkmoperror_code VALUES('F','014','0011','001','Numéro d''évènement non trouve.','');
INSERT INTO bkmoperror_code VALUES('F','014','0012','001','Banque du bénéficiaires inconnue.','');
INSERT INTO bkmoperror_code VALUES('F','014','0013','001','Incident lors de l''insertion.','');
INSERT INTO bkmoperror_code VALUES('F','014','0014','001','Le type de virement est mal paramétré.','');
INSERT INTO bkmoperror_code VALUES('F','014','0015','001','Montant au débit à zéro interdit','');
INSERT INTO bkmoperror_code VALUES('F','014','0016','001','Impossible de modifier le VIRMUL.','');
INSERT INTO bkmoperror_code VALUES('F','014','0017','001','Impossible de modifier les évènements liés au VIRMUL.','');
INSERT INTO bkmoperror_code VALUES('F','014','0018','001','Erreur lors du calcul du numéro d''événement du VIRMUL','');
INSERT INTO bkmoperror_code VALUES('F','014','0019','001','Erreur lors du calcul du numéro de l''événement','');
INSERT INTO bkmoperror_code VALUES('F','014','0020','001','Erreur lors du calcul des frais au beneficiaire','');
INSERT INTO bkmoperror_code VALUES('F','014','0021','001','Erreur lors du calcul du numéro de dossier du VRTPER','');
INSERT INTO bkmoperror_code VALUES('F','014','0022','001','Erreur lors du calcul du numéro d''événement du VRTPER','');
INSERT INTO bkmoperror_code VALUES('F','014','0023','001','Erreur lors du calcul du numéro d''événement du VRMPER','');
INSERT INTO bkmoperror_code VALUES('F','014','0024','001','Erreur lors du calcul du numéro d''événement du VRTANU','');
INSERT INTO bkmoperror_code VALUES('F','014','0025','001','Code agence non renseigné en nomenclature 310','');
INSERT INTO bkmoperror_code VALUES('F','014','0026','001','Mauvais paramétrage pour la nomenclature 310','');
INSERT INTO bkmoperror_code VALUES('F','014','0027','001','Erreur lors de la mise à jour de l''évènement','');
INSERT INTO bkmoperror_code VALUES('F','014','0028','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0029','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0030','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0031','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0032','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0033','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0034','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0035','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0036','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0037','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0038','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0039','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0040','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0041','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0042','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0043','001','..','');
INSERT INTO bkmoperror_code VALUES('F','014','0044','001','Le montant des frais au bénéficiaire sont plus élevés que le montant du virement','');
INSERT INTO bkmoperror_code VALUES('F','014','0045','001','Le montant des frais au bénéficiaire sont plus élevés que le montant du virement','');
INSERT INTO bkmoperror_code VALUES('F','015','0001','001','Devise du virement inconnue.','');
INSERT INTO bkmoperror_code VALUES('F','015','0002','001','Compte du donneur d''ordre inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','015','0003','001','Compte de frais inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','015','0004','001','Compte du bénéficiaire inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','015','0005','001','Chapitre comptable du compte du donneur d''ordre non autorise pour l''opération.','');
INSERT INTO bkmoperror_code VALUES('F','015','0006','001','Chapitre comptable du compte du bénéficiaire non autorise pour l''opération.','');
INSERT INTO bkmoperror_code VALUES('F','015','0007','001','Numéro d''évènement non trouve.','');
INSERT INTO bkmoperror_code VALUES('F','015','0008','001','Incident lors de l''insertion.','');
INSERT INTO bkmoperror_code VALUES('F','015','0009','001','Le type de virement est mal paramétré.','');
INSERT INTO bkmoperror_code VALUES('T','015','0010','001','Paramètre mal renseigné.','');
INSERT INTO bkmoperror_code VALUES('T','015','0011','001','Organisme inconnu.','');
INSERT INTO bkmoperror_code VALUES('T','015','0012','001','Le compte du créancier ne correspond pas au compte de l''organisme renseigné.','');
INSERT INTO bkmoperror_code VALUES('T','015','0013','001','Pas de code operation associe au PRLAUT (Entre parenthèses sont indiqués les champs vides pouvant être à l''origine de l''erreur)','');
INSERT INTO bkmoperror_code VALUES('T','015','0014','001','PRLAUT non autorisé','');
INSERT INTO bkmoperror_code VALUES('F','015','0015','001','Montant au débit à zéro interdit','');
INSERT INTO bkmoperror_code VALUES('F','015','0016','001','Montant au crédit à zéro interdit','');
INSERT INTO bkmoperror_code VALUES('F','016','0001','001','Devise du virement inconnue.','');
INSERT INTO bkmoperror_code VALUES('F','016','0002','001','Compte du donneur d''ordre inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','016','0003','001','Compte de frais inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','016','0004','001','Chapitre comptable du compte du donneur d''ordre non autorise pour l''opération.','');
INSERT INTO bkmoperror_code VALUES('F','016','0005','001','Numéro d''évènement non trouve.','');
INSERT INTO bkmoperror_code VALUES('F','016','0006','001','Incident lors de l''insertion.','');
INSERT INTO bkmoperror_code VALUES('F','016','0007','001','Incident sélection de banque.','');
INSERT INTO bkmoperror_code VALUES('F','016','0008','001','Le type de virement est mal paramétré.','');
INSERT INTO bkmoperror_code VALUES('T','016','0009','001','Paramètre mal renseigné.','');
INSERT INTO bkmoperror_code VALUES('T','016','0010','001','Organisme inconnu.','');
INSERT INTO bkmoperror_code VALUES('T','016','0011','001','Le compte du créancier ne correspond pas au compte de l''organisme renseigné.','');
INSERT INTO bkmoperror_code VALUES('T','016','0012','001','Pas de code operation associe au PRLABQ (Entre parenthèses sont indiqués les champs vides pouvant être à l''origine de l''erreur)','');
INSERT INTO bkmoperror_code VALUES('T','016','0013','001','PRLABQ non autorisé','');
INSERT INTO bkmoperror_code VALUES('F','016','0014','001','Montant au crédit à zéro interdit','');
INSERT INTO bkmoperror_code VALUES('F','017','0001','001','Correspondant incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0002','001','Devise du transfert inconnue','');
INSERT INTO bkmoperror_code VALUES('F','017','0003','001','Code opération transfert inexistant','');
INSERT INTO bkmoperror_code VALUES('F','017','0004','001','Devise du compte donneur d''ordre inexistante','');
INSERT INTO bkmoperror_code VALUES('F','017','0005','001','Devise du compte de frais inexistante','');
INSERT INTO bkmoperror_code VALUES('F','017','0006','001','Incident compte de frais','');
INSERT INTO bkmoperror_code VALUES('F','017','0007','001','Paramétrage compte de passage incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0008','001','Compte de passage incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0009','001','Paramétrage compte de passage frais incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0010','001','Compte de passage frais incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0011','001','Type de transfert inconnu','');
INSERT INTO bkmoperror_code VALUES('F','017','0012','001','Compte de banque non client incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0013','001','Registre inexistant','');
INSERT INTO bkmoperror_code VALUES('F','017','0014','001','Compte de banque transfert multiple non client incorrect','');
INSERT INTO bkmoperror_code VALUES('F','017','0015','001','Nature ORDMIX non Définie','');
INSERT INTO bkmoperror_code VALUES('F','017','0016','001','Code opération ordre mixte inexistant','');
INSERT INTO bkmoperror_code VALUES('F','017','0017','001','Correspondant pas en relation de compte','');
INSERT INTO bkmoperror_code VALUES('F','017','0018','001','BIC et IBAN bénéficiaire incohérent','');
INSERT INTO bkmoperror_code VALUES('F','017','0019','001','Correspondant inconnu','');
INSERT INTO bkmoperror_code VALUES('F','017','0020','001','Informations donneur d''ordre incorrectes','');
INSERT INTO bkmoperror_code VALUES('F','017','0021','001','Problème lors de la génération de transfert multiple','');
INSERT INTO bkmoperror_code VALUES('F','017','0022','001','Problème lors de la génération de l''évenement mixte','');
INSERT INTO bkmoperror_code VALUES('T','018','0001','001','Programme déjà lancé','');
INSERT INTO bkmoperror_code VALUES('T','018','0002','001','Crash du programme de traitement','');
INSERT INTO bkmoperror_code VALUES('T','018','0003','001','Erreurs trouvées lors de la génération du PSR.','');
INSERT INTO bkmoperror_code VALUES('F','019','0001','001','Lot valide, changement de l''état a NC','');
INSERT INTO bkmoperror_code VALUES('F','019','0002','001','Transaction valide, changement de l''état a NC','');
INSERT INTO bkmoperror_code VALUES('F','019','0003','001','La version du flux d''entré est incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','019','0004','001','La version du PSR d''entré est incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','019','0005','001','L''origine du message est incorrect','');
INSERT INTO bkmoperror_code VALUES('T','020','0001','001','La somme totale des transactions ne correspond pas au montant du lot.','');
INSERT INTO bkmoperror_code VALUES('T','020','0002','001','Le nombre de transaction ne correspond pas à celui indiqué au niveau lot.','');
INSERT INTO bkmoperror_code VALUES('T','020','0003','001','Les transactions ne sont pas toutes de la même devise.','');
INSERT INTO bkmoperror_code VALUES('T','020','0004','001','Le compte du créancier ne correspond pas au compte de l''organisme renseigné.','');
INSERT INTO bkmoperror_code VALUES('T','021','0001','001','Cohérence entre le service détermine et le service reçu','');
INSERT INTO bkmoperror_code VALUES('T','021','0002','001','Banque bénéficiaire non reliée à SEPA','');
INSERT INTO bkmoperror_code VALUES('F','022','0001','001','Catégorie inexistante.','');
INSERT INTO bkmoperror_code VALUES('F','022','0002','001','La banque du bénéficiaire doit être au format BIC.','');
INSERT INTO bkmoperror_code VALUES('F','022','0003','001','Le compte du bénéficiaire doit être au format IBAN.','');
INSERT INTO bkmoperror_code VALUES('F','022','0004','001','Incohérence entre le code BIC et l''IBAN du bénéficiaire.','');
INSERT INTO bkmoperror_code VALUES('F','022','0005','001','Incident SQL.','');
INSERT INTO bkmoperror_code VALUES('F','022','0006','001','Le contrôle de cohérence entre le code BIC et l''IBAN n''est pas définit pour le paramétre SEPA.','');
INSERT INTO bkmoperror_code VALUES('F','022','0007','001','Paramétre SEPA non trouvé.','');
INSERT INTO bkmoperror_code VALUES('F','022','0008','001','Le nombre de motif structuré et le nombre de motif non structuré sont différent de 0','');
INSERT INTO bkmoperror_code VALUES('F','022','0009','001','Le nombre de motif non structuré est strictement supérieur à 1','');
INSERT INTO bkmoperror_code VALUES('F','022','0010','001','Le nombre de motif structuré est strictement supérieur à 1','');
INSERT INTO bkmoperror_code VALUES('F','022','0011','001','La longueur des informations sur la transaction est supérieur à 140 caractères','');
INSERT INTO bkmoperror_code VALUES('F','022','0012','001','Les frais peuvent uniquement être partagés ou selon le servie level','');
INSERT INTO bkmoperror_code VALUES('F','022','0013','001','Virement uniquement','');
INSERT INTO bkmoperror_code VALUES('F','023','0001','001','La version du flux d''entrée est incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','023','0002','001','Flux d''entrée inconnu bkmopmsg.typmsg','');
INSERT INTO bkmoperror_code VALUES('F','024','0001','001','Anomalie lors de la lecture du mode debug au niveau de la définition du canal abonnement','Contacter la maintenance');
INSERT INTO bkmoperror_code VALUES('F','024','0002','001','Génération des PSR en cours pour le canal','Relancer le traitement ultérieurement');
INSERT INTO bkmoperror_code VALUES('F','024','0003','001','Anomalie lors de la lecture du canal abonnement','Contacter la maintenance');
INSERT INTO bkmoperror_code VALUES('F','024','0004','001','Anomalie bloquante lors du traitement des PSR','Contacter la maintenance');
INSERT INTO bkmoperror_code VALUES('F','024','0005','001','Anomalie bloquante lors de la génération des flux PSR','Contacter la maintenance');
INSERT INTO bkmoperror_code VALUES('F','024','0006','001','Anomalie de configuration de l''interface ABO : aucune version de PSR/CAMT autorisée','Corriger la configuration');
INSERT INTO bkmoperror_code VALUES('F','024','0007','001','Anomalie bloquante au niveau base de donnée','Contacter la maintenance');
INSERT INTO bkmoperror_code VALUES('F','027','0001','001','Anomalie lors de l''enregistrement sur le module de restitution "ABO" d''un statut niveau LOT','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','027','0002','001','Anomalie lors de l''enregistrement sur le module de restitution "ABO" d''un statut niveau Transaction','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','027','0003','001','Le service n''est pas activé','');
INSERT INTO bkmoperror_code VALUES('F','027','0004','001','Impossible de détérminer le code BIC de la banque','');
INSERT INTO bkmoperror_code VALUES('F','027','0005','001','Absence de type de transfert défini au niveau de la définition du canal (gumopcanal) pour un service','Corriger la définition du canal');
INSERT INTO bkmoperror_code VALUES('F','027','0006','001','Impossible de mettre le statut du lot en annulé','');
INSERT INTO bkmoperror_code VALUES('F','027','0007','001','Données manquantes pour généré le PSR d''annulation niveau lot','');
INSERT INTO bkmoperror_code VALUES('F','027','0008','001','Erreur lors de la génération du PSR d''annulation niveau lot','');
INSERT INTO bkmoperror_code VALUES('F','028','0001','001','Erreur lors de la lecture du client','');
INSERT INTO bkmoperror_code VALUES('F','029','0001','001','Un désaccord n''est pas défini en nomenclature "058"','Créer le désaccord en nomencalture 058');
INSERT INTO bkmoperror_code VALUES('F','029','0002','001','Paramètre LTRF_RFND_OPE mal renseigné','Modifier le paramètre via cbitfparam');
INSERT INTO bkmoperror_code VALUES('F','029','0003','001','Impossible de calculer le numéro d''évènement pour la réservation de fond','');
INSERT INTO bkmoperror_code VALUES('F','029','0004','001','Anomalie lors de la création d''une réservation de fond','');
INSERT INTO bkmoperror_code VALUES('F','029','0005','001','Paramètre TIME_WAIT mal renseigné','Modifier le paramètre via cbitfparam');
INSERT INTO bkmoperror_code VALUES('F','029','0006','001','Anomalie lors de la création des codes de paiement','');
INSERT INTO bkmoperror_code VALUES('F','029','0007','001','Le compte de la transaction n''est pas renseigné','Corriger le compte de la transaction via le moniteur métier');
INSERT INTO bkmoperror_code VALUES('F','029','0008','001','Impossible de déterminer la comptabilisation','');
INSERT INTO bkmoperror_code VALUES('F','029','0009','001','Impossible de retrouver le canal','');
INSERT INTO bkmoperror_code VALUES('F','029','0010','001','Impossible de retrouver le message','');
INSERT INTO bkmoperror_code VALUES('F','029','0011','001','Le code BIC de la transaction est incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0012','001','Toutes les transactions du lot sont en erreur','');
INSERT INTO bkmoperror_code VALUES('F','029','0013','001','Au moins une des transactions du lot est en erreur','');
INSERT INTO bkmoperror_code VALUES('F','029','0014','001','Impossible de déterminer l''opération pour un PRLAUT','');
INSERT INTO bkmoperror_code VALUES('F','029','0015','001','Impossible de déterminer l''opération pour un PRLABQ','');
INSERT INTO bkmoperror_code VALUES('F','029','0016','001','Impossible de déterminer le numéro d''événement pour un PRLAUT','');
INSERT INTO bkmoperror_code VALUES('F','029','0017','001','Impossible de déterminer le numéro d''événement pour un PRLABQ','');
INSERT INTO bkmoperror_code VALUES('F','029','0018','001','Impossible de déterminer le mode d''encaissement','Déterminer un mode d''encaissement par défault via le paramétre DEFAULT_INCOMING_COLLECTION_MODE');
INSERT INTO bkmoperror_code VALUES('F','029','0019','001','Impossible de déterminer l''agence de compensation pour les prélèvements','');
INSERT INTO bkmoperror_code VALUES('F','029','0020','001','Référence(s) locale(s) incorrecte(s) :','');
INSERT INTO bkmoperror_code VALUES('F','029','0021','001','Anomalie lors de la recherche de la transaction d''origine','');
INSERT INTO bkmoperror_code VALUES('F','029','0022','001','Anomalie lors de la recherche de la transaction d''origine','');
INSERT INTO bkmoperror_code VALUES('F','029','0023','001','Anomalie lors de la recherche de la transaction d''origine','');
INSERT INTO bkmoperror_code VALUES('F','029','0024','001','Anomalie lors de la recherche de la transaction d''origine','');
INSERT INTO bkmoperror_code VALUES('F','029','0025','001','Anomalie de parametrage','');
INSERT INTO bkmoperror_code VALUES('F','029','0026','001','Anomalie sur la date de règlement','');
INSERT INTO bkmoperror_code VALUES('F','029','0027','001','Anomalie sur le blocage des enregistrements','');
INSERT INTO bkmoperror_code VALUES('F','029','0028','001','Anomalie sur le blocage des enregistrements','');
INSERT INTO bkmoperror_code VALUES('F','029','0029','001','Anomalie sur la génération de l''évènement d''annulation','');
INSERT INTO bkmoperror_code VALUES('F','029','0030','001','Anomalie sur la génération de l''évènement d''annulation','');
INSERT INTO bkmoperror_code VALUES('F','029','0031','001','Anomalie sur la génération de l''évènement d''annulation','');
INSERT INTO bkmoperror_code VALUES('F','029','0032','001','Anomalie sur la génération de l''évènement de réception du prélèvement','');
INSERT INTO bkmoperror_code VALUES('F','029','0033','001','Anomalie sur la génération de l''évènement de réception du prélèvement','');
INSERT INTO bkmoperror_code VALUES('F','029','0034','001','Montant de l''ordre incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0035','001','Compte noscaisse incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0036','001','Compte autre banque (RIB_FR) incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0037','001','Compte autre banque (RIB_SICA) incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0038','001','Compte NBS incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0039','001','Impossible de trouver le référentiel du pays du compte NBS','');
INSERT INTO bkmoperror_code VALUES('F','029','0040','001','Compte IBAN non valide','');
INSERT INTO bkmoperror_code VALUES('F','029','0041','001','Compte IBAN non cohérent avec le code BIC','');
INSERT INTO bkmoperror_code VALUES('F','029','0042','001','Compte autre banque (RIB_MA) incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0043','001','Etablissement non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','029','0044','001','Etablissement du donneur d''ordre différent de celui de la banque','');
INSERT INTO bkmoperror_code VALUES('F','029','0045','001','Code BIC du donneur d''ordre différent de celui de la banque','');
INSERT INTO bkmoperror_code VALUES('F','029','0046','001','Erreur au niveau du virement TGR','');
INSERT INTO bkmoperror_code VALUES('F','029','0047','001','Erreur lors de l''insertion d''un VIRMUL','');
INSERT INTO bkmoperror_code VALUES('F','029','0048','001','Erreur lors de la mise à jour d''un VIMxxx','');
INSERT INTO bkmoperror_code VALUES('F','029','0049','001','Erreur lors de la mise en desaccord d''une transaction d''un lot en compta cumulée.','');
INSERT INTO bkmoperror_code VALUES('F','029','0050','001','Code peach non renseigné pour le paramètre SEPA2','');
INSERT INTO bkmoperror_code VALUES('F','029','0051','001','Impossible de retrouver le BIC correspondant à l''IBAN de la tranaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0052','001','Erreur survenue lors de la mise à jour du compte','');
INSERT INTO bkmoperror_code VALUES('F','029','0053','001','Nom du bénéficiaire non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','029','0054','001','Motif non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','029','0055','001','Impossible de mettre à jour les VIMxxx du VIRMUL','');
INSERT INTO bkmoperror_code VALUES('F','029','0056','001','Impossible de mettre à jour les soldes indicatifs des comptes','');
INSERT INTO bkmoperror_code VALUES('F','029','0057','001','Impossible de mettre à jour les soldes indicatifs des comptes pour les virements multiple','');
INSERT INTO bkmoperror_code VALUES('F','029','0058','001','Impossible de supprimer les frais d''un AGEVIR pour les virements multiple','');
INSERT INTO bkmoperror_code VALUES('F','029','0059','001','Impossible de supprimer l''AGEVIR pour les virements multiple','');
INSERT INTO bkmoperror_code VALUES('F','029','0060','001','Erreur lors de la recherche du client donneur d''ordre pour le contrôle du chapitre comptable','');
INSERT INTO bkmoperror_code VALUES('F','029','0061','001','Erreur lors de la recherche du profil du client donneur d''ordre pour le contrôle du chapitre comptable','');
INSERT INTO bkmoperror_code VALUES('F','029','0062','001','Transaction dupliquée','');
INSERT INTO bkmoperror_code VALUES('F','029','0063','001','Erreur lors du contrôle de duplicuté d''une transaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0064','001','Impossible de déterminer le format du compte de la transaction.','');
INSERT INTO bkmoperror_code VALUES('F','029','0065','001','Format du compte donneur d''ordre non autorisé','');
INSERT INTO bkmoperror_code VALUES('F','029','0066','001','Format du compte de frais non autorisé','');
INSERT INTO bkmoperror_code VALUES('F','029','0067','001','Le format ''BBAN'' n''est pas autorisé pour le compte donneur d''ordre','');
INSERT INTO bkmoperror_code VALUES('F','029','0068','001','Le format ''BBAN'' n''est pas autorisé pour le compte de frais','');
INSERT INTO bkmoperror_code VALUES('F','029','0069','001','Le compte du donneur d''ordre est incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0070','001','Le compte de frais est incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0071','001','Le compte de frais n''appartient pas au donneur d''ordre.','');
INSERT INTO bkmoperror_code VALUES('F','029','0072','001','Le compte de frais n''appartient pas à l''agence du compte du donneur d''ordre.','');
INSERT INTO bkmoperror_code VALUES('F','029','0073','001','Impossible de mettre à jour le lot','');
INSERT INTO bkmoperror_code VALUES('F','029','0074','001','Impossible de mettre à jour le lot, suite à une erreur detectée sur une transaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0075','001','Impossible de trouver le numéro de dossier pour un PRLABQ','');
INSERT INTO bkmoperror_code VALUES('F','029','0076','001','Impossible de trouver le numéro de dossier pour un PRLAUT','');
INSERT INTO bkmoperror_code VALUES('F','029','0077','001','Aucun organisme n''a été renseigné dans le flux','');
INSERT INTO bkmoperror_code VALUES('F','029','0078','001','Le type de virement ne gére pas la périodicité recue','');
INSERT INTO bkmoperror_code VALUES('F','029','0079','001','Unicitée de la référence de l''ordre incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0080','001','Identifiant créancier invalide','');
INSERT INTO bkmoperror_code VALUES('F','029','0081','001','Type de frais non autorisé','');
INSERT INTO bkmoperror_code VALUES('F','029','0082','001','Format de la reference Amplitude de reservation de fond incorrecte','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0083','001','Format de la reference Amplitude de reservation de fond incorrecte','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0084','001','Anomalie lors de la levée d''une reservation de fond (à partir d''une référence externe)','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0085','001','Anomalie lors de la levée d''une reservation de fond (à partir d''une référence Amplitude)','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0086','001','Anomalie lors du contrôle d''une reservation de fond (à partir d''une référence Amplitude)','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0087','001','Anomalie lors du contrôle d''une reservation de fond (à partir d''une référence externe)','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0088','001','Incohérence des références externes et Amplitude d''une réservation de fond','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0089','001','Reservation de fond non valide','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0090','001','Incoherence du numéro de compte entre la reservation de fond et l''ordre reçu par SIOP','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0091','001','Incohérence de devise : la devise du compte débité est différente de la devise de transaction','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0092','001','Devise non définie','Hors scope Amplitude, l''ordre est rejeté');
INSERT INTO bkmoperror_code VALUES('F','029','0093','001','anomalie lors de la lecture du profil d''un client','contacter le support');
INSERT INTO bkmoperror_code VALUES('F','029','0094','001','Desaccord PLAF non defini en nomenclature 058','Verifier le paramétrage');
INSERT INTO bkmoperror_code VALUES('F','029','0095','001','Desaccord PMIN non defini en nomenclature 058','Verifier le paramétrage');
INSERT INTO bkmoperror_code VALUES('F','029','0096','001','Type d''opération non autorisée','');
INSERT INTO bkmoperror_code VALUES('F','029','0097','001','Code Profil inexistant','Créer le profil du client');
INSERT INTO bkmoperror_code VALUES('F','029','0098','001','Compte autre banque (RIB_ALG) incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0099','001','Le compte doit être un compte autre banque','');
INSERT INTO bkmoperror_code VALUES('F','029','0100','001','Le format du compte est incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0101','001','Anomalie lors de la recherche du profil client','');
INSERT INTO bkmoperror_code VALUES('F','029','0102','001','Montant du virement suppérieur au plafond PMAVIM','');
INSERT INTO bkmoperror_code VALUES('F','029','0103','001','Le montant du virement fait dépasser la limite MAXLIV pour le compte à créditer','');
INSERT INTO bkmoperror_code VALUES('F','029','0104','001','Une erreur est survenue lors du calcul des frais au donneur d''ordre','');
INSERT INTO bkmoperror_code VALUES('F','029','0105','001','Erreur lors de l''insertion de données privatives pour un virement unitaire','');
INSERT INTO bkmoperror_code VALUES('F','029','0106','001','Erreur lors de l''insertion de données privatives pour un virement cumulé','');
INSERT INTO bkmoperror_code VALUES('F','029','0107','001','Le code BIC de la transaction est inconnu','');
INSERT INTO bkmoperror_code VALUES('F','029','0108','001','Format du compte de la transaction incorrect.','');
INSERT INTO bkmoperror_code VALUES('F','029','0109','001','Compte autre banque (RIB_MG) incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0110','001','Compte de la transaction inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','029','0111','001','Compte de la transaction inexistant.','');
INSERT INTO bkmoperror_code VALUES('F','029','0112','001','Au moins un comptes (niveau ordre ou transaction) doit être dans la devise de transaction.','');
INSERT INTO bkmoperror_code VALUES('F','029','0113','001','Devise incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','029','0114','001','Devise incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','030','0001','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0002','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0003','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0004','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0005','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0006','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0007','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0008','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0009','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0010','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0011','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0012','001','.','');
INSERT INTO bkmoperror_code VALUES('F','030','0013','001','Erreur PREPARE calcul identifiant "stsnot"','Appeler la hotline');
INSERT INTO bkmoperror_code VALUES('F','032','0001','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0002','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0003','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0004','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0005','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0006','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0007','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0008','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0009','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0010','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0011','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0012','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0013','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0014','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0015','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0016','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0017','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0018','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0019','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0020','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0021','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0022','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0023','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0024','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0025','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0026','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0027','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0028','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0029','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0030','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0031','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0032','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0033','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0034','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0035','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0036','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0037','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0038','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0039','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0040','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0041','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0042','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0043','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0044','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0045','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0046','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0047','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0048','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0049','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0050','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0051','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0052','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0053','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0054','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0055','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0056','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0057','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0058','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0059','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0060','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0061','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0062','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0063','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0064','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0065','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0066','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0067','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0068','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0069','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0070','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0071','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0072','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0073','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0074','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0075','001',',','');
INSERT INTO bkmoperror_code VALUES('F','032','0076','001','Incident lors de la mise a jour de la table bkmoptx_rep','');
INSERT INTO bkmoperror_code VALUES('T','033','0001','001','BIC de l''implantation mal configuré sur la fiche banque du site central','Corriger la configuration de la fiche banque du site central via le cbgesbanq');
INSERT INTO bkmoperror_code VALUES('T','033','0002','001','Virement permanent international non autorisé','');
INSERT INTO bkmoperror_code VALUES('T','033','0003','001','Date de début du virement permanent incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','034','0001','001','La condition DVACAI n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','034','0002','001','La condition DVAAGE n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','034','0003','001','La condition DINCAI n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','034','0004','001','La condition DINAGE n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','034','0005','001','La condition DATVAL n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','034','0006','001','La condition EXOCOM n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','034','0007','001','Compte incorrect','');
INSERT INTO bkmoperror_code VALUES('F','034','0008','001','Insertion dans bkeve echouée','');
INSERT INTO bkmoperror_code VALUES('F','034','0009','001','Selection du compte echouée 1','');
INSERT INTO bkmoperror_code VALUES('F','034','0010','001','Selection du compte echouée 2','');
INSERT INTO bkmoperror_code VALUES('F','034','0011','001','Selection du compte echouée 3','');
INSERT INTO bkmoperror_code VALUES('F','034','0012','001','Selection du compte echouée 4','');
INSERT INTO bkmoperror_code VALUES('F','034','0013','001','Selection du compte echouée 5','');
INSERT INTO bkmoperror_code VALUES('F','034','0014','001','Selection du compte echouée 6','');
INSERT INTO bkmoperror_code VALUES('F','034','0015','001','Selection du compte echouée 7','');
INSERT INTO bkmoperror_code VALUES('F','034','0016','001','Selection du compte echouée 8','');
INSERT INTO bkmoperror_code VALUES('F','034','0017','001','Selection du compte echouée 9','');
INSERT INTO bkmoperror_code VALUES('F','034','0018','001','Selection du compte echouée 10','');
INSERT INTO bkmoperror_code VALUES('F','034','0019','001','Selection du compte echouée 11','');
INSERT INTO bkmoperror_code VALUES('F','034','0020','001','Selection du compte echouée 12','');
INSERT INTO bkmoperror_code VALUES('F','034','0021','001','Selection bkicprl echouée','');
INSERT INTO bkmoperror_code VALUES('F','034','0022','001','Mise a jour bkicprl echouée (MAJ4)','');
INSERT INTO bkmoperror_code VALUES('F','034','0023','001','Mise a jour bkicprld echouée (MAJ4)','');
INSERT INTO bkmoperror_code VALUES('F','034','0024','001','Mise a jour bkicprl echouée 1 (MAJ2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0025','001','Mise a jour bkicprld echouée 1 (MAJ2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0026','001','Mise a jour bkicprl echouée 2 (MAJ2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0027','001','Mise a jour bkicprld echouée 2 (MAJ2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0028','001','Insertion bkicprl echouée (MAJ1)','');
INSERT INTO bkmoperror_code VALUES('F','034','0029','001','Insertion bkicprld echouée (MAJ1)','');
INSERT INTO bkmoperror_code VALUES('F','034','0030','001','Devise inexistante.','');
INSERT INTO bkmoperror_code VALUES('F','034','0031','001','Insertion bkevec échouée','');
INSERT INTO bkmoperror_code VALUES('F','034','0032','001','Mise à jour des soldes échouée (crédit org)','');
INSERT INTO bkmoperror_code VALUES('F','034','0033','001','Mise à jour des soldes échouée (débit client)','');
INSERT INTO bkmoperror_code VALUES('F','034','0034','001','Insertion bkeve échouée (SIOP)','');
INSERT INTO bkmoperror_code VALUES('F','034','0035','001','Insertion bkevec échouée (SIOP)','');
INSERT INTO bkmoperror_code VALUES('F','035','0001','001','La condition DATVAL n''existe pas.','');
INSERT INTO bkmoperror_code VALUES('F','035','0002','001','Selection de la banque 1','');
INSERT INTO bkmoperror_code VALUES('F','035','0003','001','Selection de la banque 2','');
INSERT INTO bkmoperror_code VALUES('F','035','0004','001','Date de valeur nulle','');
INSERT INTO bkmoperror_code VALUES('F','035','0005','001','Compte non trouvé','');
INSERT INTO bkmoperror_code VALUES('F','035','0006','001','Selection du compte','');
INSERT INTO bkmoperror_code VALUES('F','035','0007','001','Devise inexistante','');
INSERT INTO bkmoperror_code VALUES('F','035','0008','001','Insertion bkevec échouée','');
INSERT INTO bkmoperror_code VALUES('F','035','0009','001','Insertion bkevec échouée (SIOP)','');
INSERT INTO bkmoperror_code VALUES('F','035','0010','001','Mise à jour des soldes échouée (crédit org)','');
INSERT INTO bkmoperror_code VALUES('F','035','0011','001','Insertion bkeve échouée','');
INSERT INTO bkmoperror_code VALUES('F','035','0012','001','Insertion bkeve échouée (SIOP)','');
INSERT INTO bkmoperror_code VALUES('T','036','0001','001','???','');
INSERT INTO bkmoperror_code VALUES('T','037','0001','001','Evenement inexistant','');
INSERT INTO bkmoperror_code VALUES('T','037','0002','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0003','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0004','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0005','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0006','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0007','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0008','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0009','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0010','001','Erreur SQL','');
INSERT INTO bkmoperror_code VALUES('T','037','0011','001','??','');
INSERT INTO bkmoperror_code VALUES('T','037','0012','001','Erreur init flux','');
INSERT INTO bkmoperror_code VALUES('T','037','0013','001','Erreur flux bloc compte','');
INSERT INTO bkmoperror_code VALUES('T','038','0001','001','Le programme est deja en cours de traitement.','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0002','001','Interface ABO inexistante','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0003','001','Interface ABO inactive en version @','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0004','001','Fonction de tm_itfparam_get(...)','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0005','001','Fonction de tm_itfparam_get(...)','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0006','001','Fonction de tm_itfparam_get(...)','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0007','001','Fonction de tm_itfparam_get(...)','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0008','001','Fonction de tm_itfparam_get(...)','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0009','001','Incident @ Table @ Status @','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0010','001','Incident @ Table @ Status @','Interruption du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0011','001','Fonction de tm_abo_insert_bkstsnot(...)','Poursuite du programme.');
INSERT INTO bkmoperror_code VALUES('T','038','0012','001','Incident @ Table @ Status @','Poursuite du programme.');
INSERT INTO bkmoperror_code VALUES('F','039','0001','001','Erreur au niveau du virement TGR','veuillez corriger via les moniteurs métiers');
INSERT INTO bkmoperror_code VALUES('F','039','0002','001','Erreur lors d''un virement NANTI','Veuillez corriger via les moniteurs métiers');
INSERT INTO bkmoperror_code VALUES('F','039','0003','001','Erreur sur la lecture d''un canal non actif','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','039','0004','001','Erreur ModifyCancelModeRule','');
INSERT INTO bkmoperror_code VALUES('F','039','0005','001','Erreur ChangeReasonInformationRule','');
INSERT INTO bkmoperror_code VALUES('F','039','0006','001','Erreur StandingOrderInformationRule','');
INSERT INTO bkmoperror_code VALUES('F','039','0007','001','Erreur StandingOrderNbCdtRule','');
INSERT INTO bkmoperror_code VALUES('F','039','0008','001','DBMONEY mal ou non positionné','Positionner DBMONEY dans le script de mise en place du profile');
INSERT INTO bkmoperror_code VALUES('F','039','0009','001','Règles ISO Amplitude non respectées','');
INSERT INTO bkmoperror_code VALUES('F','039','0010','001','Probléme d''écriture fichier','');
INSERT INTO bkmoperror_code VALUES('F','039','0011','001','Canal non autorisé','');
INSERT INTO bkmoperror_code VALUES('F','039','0012','001','Valeur non autorisée pour la donnée privative VALIDATION','Rejet du flux');
INSERT INTO bkmoperror_code VALUES('F','039','0013','001','Valeur non autorisée pour la donnée privative COMPLETION','Rejet du flux');
INSERT INTO bkmoperror_code VALUES('F','040','0001','001','Le type du compte débiteur est incorrect','');
INSERT INTO bkmoperror_code VALUES('F','040','0002','001','Type de prélèvement incorrect','');
INSERT INTO bkmoperror_code VALUES('F','040','0003','001','Devise de transaction incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','040','0004','001','Identifiant du créancier non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','040','0005','001','Identifiant du mandat non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','040','0006','001','Etiquette comptable ENCAISSDD0 inexistante','');
INSERT INTO bkmoperror_code VALUES('F','040','0007','001','Paramétre SEPA-SDD- inexistant','');
INSERT INTO bkmoperror_code VALUES('F','040','0008','001','Date de réglement incorrect','');
INSERT INTO bkmoperror_code VALUES('F','040','0009','001','Agence de compensation pour SEPA mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','040','0010','001','Paramétre SEPA inexistant','');
INSERT INTO bkmoperror_code VALUES('F','040','0011','001','Paramétre SEPA2 inexistant','');
INSERT INTO bkmoperror_code VALUES('F','040','0012','001','Nature de transaction PAISDD inexistant','');
INSERT INTO bkmoperror_code VALUES('F','040','0013','001','Incident lors de la mise a jour de la table des oppositions SDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0014','001','Une opposition existe déjà','');
INSERT INTO bkmoperror_code VALUES('F','040','0015','001','Desaccord présent pour le compte à créditer','');
INSERT INTO bkmoperror_code VALUES('F','040','0016','001','Impossible de récuperer la devise numérique de la transaction','');
INSERT INTO bkmoperror_code VALUES('F','040','0017','001','Impossible d''identifier le client du compte à créditer','');
INSERT INTO bkmoperror_code VALUES('F','040','0018','001','Compte d''encaissement inexistant','');
INSERT INTO bkmoperror_code VALUES('F','040','0019','001','Erreur lors de la génération de l''événement REASDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0020','001','Erreur lors de la génération de l''événement REISDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0021','001','Erreur lors de la génération de l''événement REPSDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0022','001','Impossible de selectionner le mandat','');
INSERT INTO bkmoperror_code VALUES('F','040','0023','001','Incident lors de la mise a jour de la table des mandats','');
INSERT INTO bkmoperror_code VALUES('F','040','0024','001','Incident lors de l''insertion dans la table des mandats','');
INSERT INTO bkmoperror_code VALUES('F','040','0025','001','Incident lors de la selection du mandat','');
INSERT INTO bkmoperror_code VALUES('F','040','0026','001','Incident lors de l''insertion dans la table bksepacreancier','');
INSERT INTO bkmoperror_code VALUES('F','040','0027','001','Incident lors de l''insertion dans la table bksepacreancier','');
INSERT INTO bkmoperror_code VALUES('F','040','0028','001','Probléme lors de la lecture des paramétres','');
INSERT INTO bkmoperror_code VALUES('F','040','0029','001','Probléme lors des contrôles','');
INSERT INTO bkmoperror_code VALUES('F','040','0030','001','Incident lors de la selection du créancier','');
INSERT INTO bkmoperror_code VALUES('F','040','0031','001','Incident lors de l''insertion dans la table bksepasdd','');
INSERT INTO bkmoperror_code VALUES('F','040','0032','001','Incident lors de l''insertion dans la table bksepacplsdd','');
INSERT INTO bkmoperror_code VALUES('F','040','0033','001','Incident lors de l''insertion du prélèvement','');
INSERT INTO bkmoperror_code VALUES('F','041','0001','001','Programme déjà lancé','');
INSERT INTO bkmoperror_code VALUES('F','041','0002','001','Agence de compensation incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','041','0003','001','Paramétre SEPA inexistant','');
INSERT INTO bkmoperror_code VALUES('F','041','0004','001','Paramétre BANQUE inexistant','');
INSERT INTO bkmoperror_code VALUES('F','041','0005','001','Agence du site centrale fermée','');
INSERT INTO bkmoperror_code VALUES('F','041','0006','001','Agence du site centrale inexistante','');
INSERT INTO bkmoperror_code VALUES('F','041','0007','001','Devise EUR inexistante en nomenclature 002','');
INSERT INTO bkmoperror_code VALUES('F','041','0008','001','Repertoire mal configuré','');
INSERT INTO bkmoperror_code VALUES('F','041','0009','001','Paramétre SEPAINCXML non défini dans bkintfic','');
INSERT INTO bkmoperror_code VALUES('F','041','0010','001','Erreur lors de la lecture des répertoires','');
INSERT INTO bkmoperror_code VALUES('F','041','0011','001','Incident de requete','');
INSERT INTO bkmoperror_code VALUES('F','041','0012','001','Erreur lors de la lecture du flux','');
INSERT INTO bkmoperror_code VALUES('F','041','0013','001','Montant de contrôle différent du montant total des transactions (pacs 004)','');
INSERT INTO bkmoperror_code VALUES('F','041','0014','001','Erreur lors de l''éxecution du shell TraiteFichierRecu','');
INSERT INTO bkmoperror_code VALUES('F','041','0015','001','Devise de la balise IntrBkSttlmAmt mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','041','0016','001','Devise de la balise RtrdIntrBkSttlmAmt mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','041','0017','001','Devise de la balise OrgnlIntrBkSttlmAmt mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','041','0018','001','Devise différente de EUR','');
INSERT INTO bkmoperror_code VALUES('F','041','0019','001','BIC destinataire erroné','');
INSERT INTO bkmoperror_code VALUES('F','041','0020','001','Erreur lors de la recherche du PEACH','');
INSERT INTO bkmoperror_code VALUES('F','041','0021','001','Incident FLUSH bkseparv','');
INSERT INTO bkmoperror_code VALUES('F','041','0022','001','Incident UPDATE bksepahav','');
INSERT INTO bkmoperror_code VALUES('F','041','0023','001','Incident PUT bksepaavmrejet','');
INSERT INTO bkmoperror_code VALUES('F','041','0024','001','Donnée déjà en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','041','0025','001','Incident SELECT bksepahav','');
INSERT INTO bkmoperror_code VALUES('F','041','0026','001','Donnée déjà en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','041','0027','001','Incident SELECT bksepahav','');
INSERT INTO bkmoperror_code VALUES('F','041','0028','001','Incident PUT bkseparv','');
INSERT INTO bkmoperror_code VALUES('F','041','0029','001','Incident PUT bksepacpltr','');
INSERT INTO bkmoperror_code VALUES('F','041','0030','001','Erreur lorsqe l''on verifie si le fichier a déjà été intégré','');
INSERT INTO bkmoperror_code VALUES('F','041','0031','001','Fichier déjà integré','');
INSERT INTO bkmoperror_code VALUES('F','041','0032','001','Montant de contrôle différent du montant total des transactions (pacs 008)','');
INSERT INTO bkmoperror_code VALUES('F','041','0033','001','Nombre du contrôle de transaction différent du nombre de transaction (pacs 008)','');
INSERT INTO bkmoperror_code VALUES('F','041','0034','001','Libellé 2 de la devise EUR mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','041','0035','001','Devise de la balise RvsdIntrBkSttlmAmt mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','041','0036','001','Devise de la balise CtrlSum mal renseignée','');
INSERT INTO bkmoperror_code VALUES('F','041','0037','001','Valeur d''origine déjà en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','041','0038','001','Incident SELECT valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','041','0039','001','Valeur d''origine déjà en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','041','0040','001','Incident SELECT valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','041','0041','001','Incident lors de la recherche de la valeur d''origine pour un camt029','');
INSERT INTO bkmoperror_code VALUES('F','041','0042','001','Mandat déjà en cousr de traitement','');
INSERT INTO bkmoperror_code VALUES('F','041','0043','001','Incident lors de l''insertion du mandat','');
INSERT INTO bkmoperror_code VALUES('F','041','0044','001','Incident lors de la validation de l''insertion du mandat','');
INSERT INTO bkmoperror_code VALUES('F','041','0045','001','Incident SELECT sur le mandat','');
INSERT INTO bkmoperror_code VALUES('F','041','0046','001','Mandat déjà en cousr de traitement','');
INSERT INTO bkmoperror_code VALUES('F','041','0047','001','Incident SELECT sur le mandat','');
INSERT INTO bkmoperror_code VALUES('F','041','0048','001','Incident lors de l''insertion du motif de l''annulation','');
INSERT INTO bkmoperror_code VALUES('F','041','0049','001','Incident lors de la validation de l''insertion du motif de l''annulation','');
INSERT INTO bkmoperror_code VALUES('F','041','0050','001','Le fichier contient des epaces dans son nom','');
INSERT INTO bkmoperror_code VALUES('F','041','0051','001','Nombre du contrôle de transaction différent du nombre de transaction (pacs 004)','');
INSERT INTO bkmoperror_code VALUES('F','041','0052','001','Incident lors de l''insertion du créancier','');
INSERT INTO bkmoperror_code VALUES('F','041','0053','001','Incident lors de la validation de l''insertion du créancier','');
INSERT INTO bkmoperror_code VALUES('F','041','0054','001','Incident lors de la mise à jour de la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','041','0055','001','Montant de contrôle différent du montant total des transactions (pacs 003 - pacs 006 - camt 56)','');
INSERT INTO bkmoperror_code VALUES('F','041','0056','001','Nombre du contrôle de transaction différent du nombre de transaction (pacs 003 - pacs 006 - camt 56)','');
INSERT INTO bkmoperror_code VALUES('F','041','0057','001','Montant de contrôle différent du montant total des transactions (pacs 003 - pacs 007)','');
INSERT INTO bkmoperror_code VALUES('F','041','0058','001','Nombre du contrôle de transaction différent du nombre de transaction (pacs 003 - pacs 007)','');
INSERT INTO bkmoperror_code VALUES('F','041','0059','001','Valeur d''origine pour un camt029 non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','041','0060','001','Incident lors de la mise à jour du mandat','');
INSERT INTO bkmoperror_code VALUES('F','041','0061','001','Incident lors de la recherche du créancier','');
INSERT INTO bkmoperror_code VALUES('F','041','0062','001','Nombre du contrôle de transaction différent du nombre de transaction (pacs 004)','');
INSERT INTO bkmoperror_code VALUES('F','041','0063','001','Incident lors de l''alimentation de la table des flux retour (bkseparf)','');
INSERT INTO bkmoperror_code VALUES('F','041','0064','001','Incident lors de la validation de l''alimentation de la table des flux retour (bkseparf)','');
INSERT INTO bkmoperror_code VALUES('F','041','0065','001','Incident FLUSH bksepaavmrejet','');
INSERT INTO bkmoperror_code VALUES('F','041','0066','001','Incident FLUSH bksepacpltr','');
INSERT INTO bkmoperror_code VALUES('F','041','0067','001','Valeur d''origine pour un camt056 non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','041','0068','001',',','');
INSERT INTO bkmoperror_code VALUES('F','041','0069','001',',','');
INSERT INTO bkmoperror_code VALUES('F','041','0070','001','Repertoire de travail inexistant','');
INSERT INTO bkmoperror_code VALUES('F','041','0071','001','Repertoire d''archive inexistant','');
INSERT INTO bkmoperror_code VALUES('F','041','0072','001','Repertoire de réponse inexistant','');
INSERT INTO bkmoperror_code VALUES('F','041','0073','001','Incident SELECT bksepahrv - bksepahav','');
INSERT INTO bkmoperror_code VALUES('F','041','0074','001','Valeur SEPA déjà traitée','');
INSERT INTO bkmoperror_code VALUES('F','041','0075','001','La date de règlement est dépassée','');
INSERT INTO bkmoperror_code VALUES('F','041','0076','001','Le prélévement est inexistant','');
INSERT INTO bkmoperror_code VALUES('F','041','0077','001','Incident select lors de la recherche du prélévement','');
INSERT INTO bkmoperror_code VALUES('F','041','0078','001',',','');
INSERT INTO bkmoperror_code VALUES('F','041','0079','001',',','');
INSERT INTO bkmoperror_code VALUES('F','041','0080','001','Données déjà traitée','');
INSERT INTO bkmoperror_code VALUES('F','041','0081','001',',','');
INSERT INTO bkmoperror_code VALUES('F','041','0082','001','Le code peach n''a pas ete trouve','');
INSERT INTO bkmoperror_code VALUES('F','041','0083','001','Le nombre de modification ne correspond pas au nombre de transaction a modifier','');
INSERT INTO bkmoperror_code VALUES('F','041','0084','001','Impossible de calculer la référence du CAI','');
INSERT INTO bkmoperror_code VALUES('F','041','0085','001','Mandat verouillé','');
INSERT INTO bkmoperror_code VALUES('F','042','0001','001','Référence de dossier non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','042','0002','001','Opération non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','042','0003','001','Opération non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','042','0004','001','Client du compte non trouvé','');
INSERT INTO bkmoperror_code VALUES('F','042','0005','001','Calcul des frais échoué','');
INSERT INTO bkmoperror_code VALUES('F','042','0006','001','Calcul des commission échoué','');
INSERT INTO bkmoperror_code VALUES('F','042','0007','001','Calcul des frais de gestion échoué','');
INSERT INTO bkmoperror_code VALUES('F','042','0008','001','Calcul des taxes échoué','');
INSERT INTO bkmoperror_code VALUES('F','042','0009','001','Condition DATVAL mal paramétrée','');
INSERT INTO bkmoperror_code VALUES('F','042','0010','001','Banque inconnue','');
INSERT INTO bkmoperror_code VALUES('F','042','0011','001','Compte inconnu','');
INSERT INTO bkmoperror_code VALUES('F','042','0012','001','Devise du compte inconnue','');
INSERT INTO bkmoperror_code VALUES('F','042','0013','001','Vérification des désaccords échouée','');
INSERT INTO bkmoperror_code VALUES('F','042','0014','001','Compte inconnu','');
INSERT INTO bkmoperror_code VALUES('F','042','0015','001','Suppression des compléments échouée','');
INSERT INTO bkmoperror_code VALUES('F','042','0016','001','Suppression de l''événement échouée','');
INSERT INTO bkmoperror_code VALUES('F','042','0017','001','DELETE bksemsta échoué','');
INSERT INTO bkmoperror_code VALUES('F','042','0018','001','INSERT bkebcavic échoué','');
INSERT INTO bkmoperror_code VALUES('F','042','0019','001','Erreur lors de l''insertion des compléments','');
INSERT INTO bkmoperror_code VALUES('F','042','0020','001','Erreur lors de l''alimentation spécifique Égypte de l''évènement','');
INSERT INTO bkmoperror_code VALUES('F','042','0021','001','.','');
INSERT INTO bkmoperror_code VALUES('F','043','0001','001','Programme déjà lancé','');
INSERT INTO bkmoperror_code VALUES('F','043','0002','001','Paramétre BANQUE inexistant','');
INSERT INTO bkmoperror_code VALUES('F','043','0003','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0004','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0005','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0006','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0007','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0008','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0009','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0010','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0011','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0012','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0013','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0014','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0015','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0016','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0017','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0018','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0019','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0020','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0021','001',',','');
INSERT INTO bkmoperror_code VALUES('F','043','0022','001','Incident DELETE table bksepacplta','');
INSERT INTO bkmoperror_code VALUES('F','044','0001','001','Programme déjà lancé','');
INSERT INTO bkmoperror_code VALUES('F','044','0002','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0003','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0004','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0005','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0006','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0007','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0008','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0009','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0010','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0011','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0012','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0013','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0014','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0015','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0016','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0017','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0018','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0019','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0020','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0021','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0022','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0023','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0024','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0025','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0026','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0027','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0028','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0029','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0030','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0031','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0032','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0033','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0034','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0035','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0036','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0037','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0038','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0039','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0040','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0041','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0042','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0043','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0044','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0045','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0046','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0047','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0048','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0049','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0050','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0051','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0052','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0053','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0054','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0055','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0056','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0057','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0058','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0059','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0060','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0061','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0062','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0063','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0064','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0065','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0066','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0067','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0068','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0069','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0070','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0071','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0072','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0073','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0074','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0075','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0076','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0077','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0078','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0079','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0080','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0081','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0082','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0083','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0084','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0085','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0086','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0087','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0088','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0089','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0090','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0091','001','Impossible de rechercher le COMSDD à partir d''un REFSDD dans bkeve','');
INSERT INTO bkmoperror_code VALUES('F','044','0092','001','Impossible de rechercher le COMSDD à partir d''un REFSDD dans bkheve','');
INSERT INTO bkmoperror_code VALUES('F','044','0093','001',',','');
INSERT INTO bkmoperror_code VALUES('F','044','0094','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0001','001','Programme déjà lancé','');
INSERT INTO bkmoperror_code VALUES('F','045','0002','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0003','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0004','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0005','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0006','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0007','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0008','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0009','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0010','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0011','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0012','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0013','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0014','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0015','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0016','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0017','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0018','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0019','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0020','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0021','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0022','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0023','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0024','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0025','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0026','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0027','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0028','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0029','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0030','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0031','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0032','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0033','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0034','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0035','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0036','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0037','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0038','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0039','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0040','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0041','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0042','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0043','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0044','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0045','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0046','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0047','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0048','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0049','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0050','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0051','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0052','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0053','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0054','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0055','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0056','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0057','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0058','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0059','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0060','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0061','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0062','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0063','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0064','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0065','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0066','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0067','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0068','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0069','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0070','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0071','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0072','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0073','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0074','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0075','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0076','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0077','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0078','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0079','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0080','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0081','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0082','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0083','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0084','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0085','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0086','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0087','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0088','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0089','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0090','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0091','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0092','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0093','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0094','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0095','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0096','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0097','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0098','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0099','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0100','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0101','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0102','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0103','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0104','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0105','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0106','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0107','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0108','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0109','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0110','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0111','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0112','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0113','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0114','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0115','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0116','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0117','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0118','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0119','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0120','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0121','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0122','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0123','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0124','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0125','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0126','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0127','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0128','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0129','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0130','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0131','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0132','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0133','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0134','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0135','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0136','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0137','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0138','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0139','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0140','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0141','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0142','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0143','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0144','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0145','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0146','001',',','');
INSERT INTO bkmoperror_code VALUES('F','045','0147','001','Impossible de trouver l''identifient du RECSDD dans les valeurs retour','');
INSERT INTO bkmoperror_code VALUES('T','046','0001','001','Probléme survenu lors de la sauvegarde de la transaction','');
INSERT INTO bkmoperror_code VALUES('T','046','0002','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0003','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0004','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0005','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0006','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0007','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0008','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0009','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0010','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0011','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0012','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0013','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0014','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0015','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0016','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0017','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0018','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0019','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0020','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0021','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0022','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0023','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0024','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0025','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0026','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0027','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0028','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0029','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0030','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0031','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0032','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0033','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0034','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0035','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0036','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0037','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0038','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0039','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0040','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0041','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0042','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0043','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0044','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0045','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0046','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0047','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0048','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0049','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0050','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0051','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0052','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0053','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0054','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0055','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0056','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0057','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0058','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0059','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0060','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0061','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0062','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0063','001',',','');
INSERT INTO bkmoperror_code VALUES('T','046','0064','001',',','');
INSERT INTO bkmoperror_code VALUES('T','047','0001','001','La classe de l''interface (itfinterf) est inconnue','Vérifier la configuration de l''interface d''émission des PSR via le programme cbgdispitf');
INSERT INTO bkmoperror_code VALUES('F','048','0001','001','Nature non trouvée en nomenclature 052','');
INSERT INTO bkmoperror_code VALUES('F','048','0002','001','Code opération inconnue pour une nature','');
INSERT INTO bkmoperror_code VALUES('F','048','0003','001','Impossible de creer la séquence','');
INSERT INTO bkmoperror_code VALUES('T','049','0001','001','Erreur lors de l''insertion dans bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0002','001','Erreur lors de la récupération de la date de compensation (paramètre inexistant)','');
INSERT INTO bkmoperror_code VALUES('T','049','0003','001','Erreur lors de la récupération du numéro d''ordre de bkcompens_af_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0004','001','Erreur lors de l''insertion dans bkcompens_af_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0005','001','Erreur lors de l''insertion dans bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0006','001','Erreur lors de la récupération du numéro d''ordre de bkcompens_rf_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0007','001','Erreur lors de l''insertion dans bkcompens_rf_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0008','001','Erreur lors de l''insertion dans bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0009','001','Erreur lors de l''insertion dans bkcompens_av_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0010','001','Erreur lors de la récupération du numéro d''ordre de bkcompens_av_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0011','001','Erreur lors de l''insertion dans bkcompens_av_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0012','001','Erreur lors de l''insertion dans bkcompens_av_ieve','');
INSERT INTO bkmoperror_code VALUES('T','049','0013','001','Erreur lors de l''insertion dans bkcompens_av_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0014','001','Erreur lors de la récupération du numéro d''ordre de bkcompens_av_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0015','001','Erreur lors de l''insertion dans bkcompens_av_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0016','001','Erreur lors de l''insertion dans bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0017','001','Erreur lors de l''insertion dans bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0018','001','Erreur lors de la récupération du numéro d''ordre de bkcompens_rv_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0019','001','Erreur lors de l''insertion dans bkcompens_rv_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0020','001','Erreur lors de l''insertion dans bkcompens_rv_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0021','001','Erreur lors de la récupération du numéro d''ordre de bkcompens_rv_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0022','001','Erreur lors de l''insertion dans bkcompens_rv_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0023','001','Valeur émise non trouvée','');
INSERT INTO bkmoperror_code VALUES('T','049','0024','001','Erreur lors de la sélection d''une valeur émise','');
INSERT INTO bkmoperror_code VALUES('T','049','0025','001','Erreur lors de l''insertion dans bkcompens_av_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0026','001','Erreur lors de l''insertion dans bkcompens_rv_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0027','001','Erreur lors de la mise à jour de la valeur aller','');
INSERT INTO bkmoperror_code VALUES('T','049','0028','001','Erreur lors de la mise à jour de la valeur retour','');
INSERT INTO bkmoperror_code VALUES('T','049','0029','001','gu_bl_cmp_dao_insert_fichier_emis','');
INSERT INTO bkmoperror_code VALUES('T','049','0030','001','gu_bl_cmp_dao_insert_fichier_recu','');
INSERT INTO bkmoperror_code VALUES('T','049','0031','001','gu_bl_cmp_dao_insert_valeur_emise','');
INSERT INTO bkmoperror_code VALUES('T','049','0032','001','gu_bl_cmp_dao_insert_valeur_emise_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0033','001','gu_bl_cmp_dao_insert_valeur_recue','');
INSERT INTO bkmoperror_code VALUES('T','049','0034','001','gu_bl_cmp_dao_insert_valeur_recue_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0035','001','Erreur lors de la mise à jour de l''identifiant du fichier de la valeur aller','');
INSERT INTO bkmoperror_code VALUES('T','049','0036','001','Erreur lors de l''insertion dans bkcompens_haf','');
INSERT INTO bkmoperror_code VALUES('T','049','0037','001','Erreur lors de l''insertion dans bkcompens_haf_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0038','001','Erreur lors de l''insertion dans bkcompens_hav','');
INSERT INTO bkmoperror_code VALUES('T','049','0039','001','Erreur lors de l''insertion dans bkcompens_hav_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0040','001','Erreur lors de l''insertion dans bkcompens_hav_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0041','001','Erreur lors de l''insertion dans bkcompens_hav_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0042','001','Erreur lors de l''insertion dans bkcompens_hav_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0043','001','Erreur lors de l''insertion dans bkcompens_hav_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0044','001','Erreur lors de l''insertion dans bkcompens_hav_ieve','');
INSERT INTO bkmoperror_code VALUES('T','049','0045','001','Erreur lors de l''insertion dans bkcompens_hrf','');
INSERT INTO bkmoperror_code VALUES('T','049','0046','001','Erreur lors de l''insertion dans bkcompens_hrf_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0047','001','Erreur lors de l''insertion dans bkcompens_hrv','');
INSERT INTO bkmoperror_code VALUES('T','049','0048','001','Erreur lors de l''insertion dans bkcompens_hrv_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0049','001','Erreur lors de l''insertion dans bkcompens_hrv_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0050','001','Erreur lors de l''insertion dans bkcompens_hrv_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0051','001','Erreur lors de l''insertion dans bkcompens_hrv_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0052','001','Erreur lors de l''insertion dans bkcompens_hrv_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0053','001','Erreur lors de la suppression de bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0054','001','Erreur lors de la suppression de bkcompens_av_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0055','001','Erreur lors de la suppression de bkcompens_av_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0056','001','Erreur lors de la suppression de bkcompens_av_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0057','001','Erreur lors de la suppression de bkcompens_av_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0058','001','Erreur lors de la suppression de bkcompens_av_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0059','001','Erreur lors de la suppression de bkcompens_av_ieve','');
INSERT INTO bkmoperror_code VALUES('T','049','0060','001','Erreur lors de la suppression de bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0061','001','Erreur lors de la suppression de bkcompens_af_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0062','001','Erreur lors de la suppression de bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0063','001','Erreur lors de la suppression de bkcompens_rv_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0064','001','Erreur lors de la suppression de bkcompens_rv_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0065','001','Erreur lors de la suppression de bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0066','001','Erreur lors de la suppression de bkcompens_rv_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0067','001','Erreur lors de la suppression de bkcompens_rv_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0068','001','Erreur lors de la suppression de bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0069','001','Erreur lors de la suppression de bkcompens_rf_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0070','001','Erreur lors de l''insertion dans bkcompens_rv_chq_img','');
INSERT INTO bkmoperror_code VALUES('T','049','0071','001','Erreur lors de la mise à jour de bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0072','001','Erreur lors de la mise à jour du fichier emis','');
INSERT INTO bkmoperror_code VALUES('T','049','0073','001','Erreur lors de la mise à jour de bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0074','001','Erreur lors de la mise à jour de la valeur emise','');
INSERT INTO bkmoperror_code VALUES('T','049','0075','001','Erreur lors de l''insertion de bkcompens_hrv_chq_img','');
INSERT INTO bkmoperror_code VALUES('T','049','0076','001','Erreur lors de la selection de la bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0077','001','Erreur lors de la selection de la bkcompens_av_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0078','001','Erreur lors de la selection de la bkcompens_av_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0079','001','Erreur lors de la selection de la bkcompens_av_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0080','001','Erreur lors de la selection de la bkcompens_av_ieve','');
INSERT INTO bkmoperror_code VALUES('T','049','0081','001','Erreur lors de la selection de la bkcompens_av_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0082','001','Erreur lors de la selection de la bkcompens_av_ieve','');
INSERT INTO bkmoperror_code VALUES('T','049','0083','001','Erreur lors de la selection de la bkcompens_av_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0084','001','Erreur lors de la selection de la bkcompens_av_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0085','001','Erreur lors de la selection de la bkcompens_av_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0086','001','Erreur lors de la selection de la bkcompens_afd_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0087','001','Erreur lors de la selection de la bkcompens_afd_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0088','001','Erreur lors de la selection de la bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0089','001','Erreur lors de la selection de la bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0090','001','Erreur lors de la selection de la bkcompens_af_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0091','001','Erreur lors de la selection de la bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0092','001','Erreur lors de la selection de la bkcompens_haf','');
INSERT INTO bkmoperror_code VALUES('T','049','0093','001','Erreur lors de la selection de la bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0094','001','Erreur lors de la selection de la bkcompens_arv_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0095','001','Erreur lors de la selection de la bkcompens_rv_eve','');
INSERT INTO bkmoperror_code VALUES('T','049','0096','001','Erreur lors de la selection de la bkcompens_rv_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0097','001','Erreur lors de la selection de la bkcompens_rv_evec','');
INSERT INTO bkmoperror_code VALUES('T','049','0098','001','Erreur lors de la selection de la bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0099','001','Erreur lors de la selection de la bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('T','049','0100','001','Erreur lors de la selection de la bkcompens_rv_chq_img','');
INSERT INTO bkmoperror_code VALUES('T','049','0101','001','Erreur lors de la selection de la bkcompens_rv_chq_img','');
INSERT INTO bkmoperror_code VALUES('T','049','0102','001','Erreur lors de la selection de la bkcompens_rv_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0103','001','Erreur lors de la selection de la bkcompens_rv_trf','');
INSERT INTO bkmoperror_code VALUES('T','049','0104','001','Erreur lors de la selection de la bkcompens_rfd','');
INSERT INTO bkmoperror_code VALUES('T','049','0105','001','Erreur lors de la selection de la bkcompens_rfd','');
INSERT INTO bkmoperror_code VALUES('T','049','0106','001','Erreur lors de la selection de la bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0107','001','Erreur lors de la selection de la bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0108','001','Erreur lors de la selection de la bkcompens_rf_eta','');
INSERT INTO bkmoperror_code VALUES('T','049','0109','001','Erreur lors de la selection de la bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0110','001','Erreur lors de la selection de la bkcompens_hrf','');
INSERT INTO bkmoperror_code VALUES('T','049','0111','001','Erreur lors de l''OPEN de la bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0112','001','Erreur lors de la selection de la bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0113','001','Erreur lors du FETCH de la bkcompens_af','');
INSERT INTO bkmoperror_code VALUES('T','049','0114','001','Erreur lors de l''OPEN de la bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0115','001','Erreur lors de la selection de la bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0116','001','Erreur lors du FETCH de la bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','049','0117','001','Erreur lors de l''OPEN de la bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0118','001','Erreur lors de la selection de la bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0119','001','Erreur lors du FETCH de la bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','049','0120','001','Erreur lors de l''OPEN de la bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0121','001','Erreur lors de la selection de la bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0122','001','Erreur lors du FETCH de la bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('T','049','0123','001','Erreur lors de la mise a jour de la valeur recue','');
INSERT INTO bkmoperror_code VALUES('T','049','0124','001','Erreur lors de l''insertion de l''etat de la valeur recue','');
INSERT INTO bkmoperror_code VALUES('T','049','0125','001','Incident lors de la recherche de la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('T','049','0126','001','Valeur d''origine inconnue','');
INSERT INTO bkmoperror_code VALUES('T','049','0127','001','Incident lors de la recherche de la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('T','049','0128','001','Erreur lors de la selection de la bkcompens_afdco','');
INSERT INTO bkmoperror_code VALUES('T','049','0129','001','Impossible de trouvé le fichier','');
INSERT INTO bkmoperror_code VALUES('T','049','0130','001','Erreur lors de la récuperation de la date de compensation','');
INSERT INTO bkmoperror_code VALUES('T','049','0131','001','Erreur lors de suppression dans bkcompens pa','');
INSERT INTO bkmoperror_code VALUES('T','049','0132','001','Erreur lors de mise a jour dans bkcompens pa','');
INSERT INTO bkmoperror_code VALUES('T','049','0133','001','Erreur lors d''insertion dans bkcompens pa','');
INSERT INTO bkmoperror_code VALUES('T','049','0134','001','Chèque d''origine en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('T','049','0135','001','Erreur lors de la PREPARATION de la bkcompens_af_file','');
INSERT INTO bkmoperror_code VALUES('T','049','0136','001','Erreur lors de la SELECT de la bkcompens_af_file','');
INSERT INTO bkmoperror_code VALUES('T','049','0137','001','Erreur lors de la PREPARATION de la bkcompens_rf_file','');
INSERT INTO bkmoperror_code VALUES('T','049','0138','001','Erreur lors de la SELECT de la bkcompens_rf_file','');
INSERT INTO bkmoperror_code VALUES('T','049','0139','001','Erreur lors de l''insertion dans bkcompens_haf_file','');
INSERT INTO bkmoperror_code VALUES('T','049','0140','001','Erreur lors de l''insertion dans bkcompens_hrf_file','');
INSERT INTO bkmoperror_code VALUES('T','049','0141','001','Incident select','');
INSERT INTO bkmoperror_code VALUES('T','049','0142','001','Valeur d''origine non trouvée','');
INSERT INTO bkmoperror_code VALUES('T','049','0143','001','Incident select','');
INSERT INTO bkmoperror_code VALUES('T','049','0144','001','Impossible ed verouiller la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','050','0001','001','Paramètre DIRECTORY_INCOMING mal paramétré','');
INSERT INTO bkmoperror_code VALUES('F','050','0002','001','Paramètre DIRECTORY_INCOMING inexistant','');
INSERT INTO bkmoperror_code VALUES('F','050','0003','001','Erreur lors de la lecture du paramètre de l''interface','');
INSERT INTO bkmoperror_code VALUES('F','050','0004','001','Erreur lors de la lecture du paramétre des operations','');
INSERT INTO bkmoperror_code VALUES('F','051','0001','001','Erreur lors du dénombrement des évènements à traiter','');
INSERT INTO bkmoperror_code VALUES('F','051','0002','001','Enregistrement en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','051','0003','001','Erreur OPEN cur_lock_eve','');
INSERT INTO bkmoperror_code VALUES('F','051','0004','001','Erreur FETCH cur_lock_eve','');
INSERT INTO bkmoperror_code VALUES('F','051','0005','001','Paramètre d''interface mal paramétré','');
INSERT INTO bkmoperror_code VALUES('F','051','0006','001','Paramètre d''interface inexistant','');
INSERT INTO bkmoperror_code VALUES('F','051','0007','001','Erreur lors de la lecture des paramètres de l''interface','');
INSERT INTO bkmoperror_code VALUES('F','051','0008','001','Le paramètre PREPARATION_MODE a été modifié durant le traitement des évènements','');
INSERT INTO bkmoperror_code VALUES('F','051','0009','001','Erreur lors de la lecture de la table bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('F','051','0010','001','Erreur lors de la lecture de la table bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('F','051','0011','001','Erreur lors de la récupération du code de rejet de chèque','');
INSERT INTO bkmoperror_code VALUES('F','051','0012','001','Erreur lors de la mise à jour de l''évènement','');
INSERT INTO bkmoperror_code VALUES('F','051','0013','001','gucmppre_traitement','');
INSERT INTO bkmoperror_code VALUES('F','051','0014','001','gucmppre_alim_bkcompens','');
INSERT INTO bkmoperror_code VALUES('F','051','0015','001','gucmppre_alim_bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('F','051','0016','001','Erreur lors de la récupération de l''identifiant d''une valeur reçue','');
INSERT INTO bkmoperror_code VALUES('F','051','0017','001','Code rejet inexistant','');
INSERT INTO bkmoperror_code VALUES('F','051','0018','001','gucmppre_lec_param','');
INSERT INTO bkmoperror_code VALUES('F','051','0019','001','Programme déjà actif','');
INSERT INTO bkmoperror_code VALUES('F','051','0020','001','main_fonc','');
INSERT INTO bkmoperror_code VALUES('F','052','0001','001','Erreur lors de la récupération du numéro de séquence S_CMP_ID','');
INSERT INTO bkmoperror_code VALUES('F','052','0002','001','Erreur lors de la récupération du chrono','');
INSERT INTO bkmoperror_code VALUES('F','052','0003','001','gu_bl_cmp_get_id','');
INSERT INTO bkmoperror_code VALUES('F','052','0004','001','Paramètre itfparam mal paramétré','');
INSERT INTO bkmoperror_code VALUES('F','052','0005','001','Paramètre itfparam inexistant','');
INSERT INTO bkmoperror_code VALUES('F','052','0006','001','Erreur liée à la fonction tm_itfparam_get','');
INSERT INTO bkmoperror_code VALUES('F','052','0007','001','Erreur lors de la récuperation dans la table bkcompens_suivi_trf','');
INSERT INTO bkmoperror_code VALUES('F','052','0008','001','Erreur lors de la récuperation dans la table bkcompens_suivi_chq','');
INSERT INTO bkmoperror_code VALUES('F','052','0009','001','Erreur lors de la insertion dans la table bkcompens_suivi','');
INSERT INTO bkmoperror_code VALUES('F','052','0010','001','Incoherence des heures debut et fin cycle CHEQUES','');
INSERT INTO bkmoperror_code VALUES('F','052','0011','001','Incoherence des heures debut et fin cycle TRANSFERT','');
INSERT INTO bkmoperror_code VALUES('F','052','0012','001','Incoherence controle dernier cycle CHEQUES','');
INSERT INTO bkmoperror_code VALUES('F','052','0013','001','Incoherence controle dernier cycle TRANSFERT','');
INSERT INTO bkmoperror_code VALUES('F','052','0014','001','Incident lors de la recherche de la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','052','0015','001','Plusieurs valeurs d''origines trouvées','');
INSERT INTO bkmoperror_code VALUES('F','052','0016','001','Valeur d''origine non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','052','0017','001','Incoherence des heures debut et fin cycle CHEQUES','');
INSERT INTO bkmoperror_code VALUES('F','052','0018','001','Incoherence des heures debut et fin cycle CHEQUES','');
INSERT INTO bkmoperror_code VALUES('F','052','0019','001','Incoherence des heures debut et fin cycle TRANSFERT','');
INSERT INTO bkmoperror_code VALUES('F','052','0020','001','Incoherence des heures debut et fin cycle TRANSFERT','');
INSERT INTO bkmoperror_code VALUES('F','052','0021','001','Incoherence des heures debut et fin cycle TRANSFERT','');
INSERT INTO bkmoperror_code VALUES('F','052','0022','001','.','');
INSERT INTO bkmoperror_code VALUES('F','052','0023','001','.','');
INSERT INTO bkmoperror_code VALUES('F','052','0024','001','.','');
INSERT INTO bkmoperror_code VALUES('F','052','0025','001','Systeme de compensation non déterminé','');
INSERT INTO bkmoperror_code VALUES('F','052','0026','001','Type de valeur non gerée par la banque','');
INSERT INTO bkmoperror_code VALUES('F','052','0027','001','Erreur lors de la recherche du systeme de compensation d''un fichier','');
INSERT INTO bkmoperror_code VALUES('F','052','0028','001','Erreur lors de la récuperation dans la table bkcompens_suivi','');
INSERT INTO bkmoperror_code VALUES('F','052','0029','001','.','');
INSERT INTO bkmoperror_code VALUES('F','052','0030','001','Incident lecture bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('F','052','0031','001','Incident update bknom lors du passage à la date de compensation suivante','');
INSERT INTO bkmoperror_code VALUES('F','052','0032','001','Incident lors de la recherche d''un cycle','');
INSERT INTO bkmoperror_code VALUES('F','052','0033','001','Nature d''opération de réglement mal paramétré','');
INSERT INTO bkmoperror_code VALUES('F','053','0001','001','Programme déjà en cours d''exécution','');
INSERT INTO bkmoperror_code VALUES('F','053','0002','001','Erreur lors de l''initialisation de l''interface des messages','');
INSERT INTO bkmoperror_code VALUES('F','053','0003','001','Erreur lors de la clôture de l''interface des messages','');
INSERT INTO bkmoperror_code VALUES('F','053','0004','001','gucmpenv_create_table_temp','');
INSERT INTO bkmoperror_code VALUES('F','053','0005','001','gucmpenv_drop_table_temp','');
INSERT INTO bkmoperror_code VALUES('F','053','0006','001','gucmpenv_traite_chq','');
INSERT INTO bkmoperror_code VALUES('F','053','0007','001','gucmpenv_traite_chq_rej','');
INSERT INTO bkmoperror_code VALUES('F','053','0008','001','gucmpenv_traite_chq_rep','');
INSERT INTO bkmoperror_code VALUES('F','053','0009','001','gucmpenv_traite_vir','');
INSERT INTO bkmoperror_code VALUES('F','053','0010','001','gucmpenv_charge_param','');
INSERT INTO bkmoperror_code VALUES('F','054','0001','001','Programme deja actif','Stoper le programme actif puis relancer');
INSERT INTO bkmoperror_code VALUES('F','054','0002','001','Erreur lors du traitement de la file d''attente','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','054','0003','001','Erreur lors de l''initialisation de la file d''attente','Verifier le parametrage de l''interface');
INSERT INTO bkmoperror_code VALUES('F','054','0004','001','Erreur a la fermeture de la file d''attente','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','054','0005','001','Erreur lors de la fermeture du fichier','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','054','0006','001','gucmprec_trt_fic','');
INSERT INTO bkmoperror_code VALUES('F','055','0001','001','Erreur lors du chargement du fichier','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','055','0002','001','Erreur lors de la creation de la table temporaire','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','055','0003','001','Format du nom de fichier incorrect','Renommer le fichier');
INSERT INTO bkmoperror_code VALUES('F','055','0004','001','Type d''operation inexistant','Renommer le fichier avec le bon type');
INSERT INTO bkmoperror_code VALUES('F','055','0005','001','Nombre de transac.entete <> nombre de transac.calculé','Modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0006','001','Montant entete <> montant calculé','Modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0007','001','Date incorrecte dans le nom du fichier','Renommer le fichier');
INSERT INTO bkmoperror_code VALUES('F','055','0008','001','Montant entete <> montant calculé (VIR)','Modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0009','001','Nombre de transac.entete <> nombre de transac.calculé (VIR)','Modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0010','001','Erreur lors de la recherche du fichier','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','055','0011','001','Fichier deja integré','Renommer le fichier');
INSERT INTO bkmoperror_code VALUES('F','055','0012','001','Numero de cycle incorrect','Modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0013','001','Numero de sous-cycle incorrect','Modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0014','001','Code bqe emetteur entete <> code bqe titre (CHQ)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0015','001','Code bqe destinataire entete <> code bqe titre (CHQ)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0016','001','Type de val entete <> type de val fichier (CHQ)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0017','001','Code établissement incorrect (CHQ)','Modifier la ligne de detail ou l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0018','001','Code etablissement destinataire incorrect (CHQ)','Modifier la ligne de detail ou l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0019','001','Nombre d''images <> nombre de cheques * 2','Ajouter des images cheques');
INSERT INTO bkmoperror_code VALUES('F','055','0020','001','Structure du fichier incorrect (VIR)','Modifier la ligne d''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0021','001','Code bqe destinataire <> code bqe titre (VIR)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0022','001','Code bqe emetteur <> code bqe titre (VIR)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0023','001','Date de generation <> titre (VIR)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0024','001','Numero de fichier <> titre (VIR)','Renommer le fichier ou modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0025','001','Devise doit etre devise nat (VIR)','Modifier la ligne d''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0026','001','Date de generation <> entete','Modifier la ligne de detail et modifier l''entete');
INSERT INTO bkmoperror_code VALUES('F','055','0027','001','gu_bl_cmprec_spec_maurice_alim_valeur','');
INSERT INTO bkmoperror_code VALUES('F','055','0028','001','Impossible de determiner le cycle de reception','');
INSERT INTO bkmoperror_code VALUES('F','055','0029','001','En dehors des heure de cycle de presentation chèque','');
INSERT INTO bkmoperror_code VALUES('F','056','0001','001','Erreur lors de la récupération du numéro de chèque de la valeur à émettre','');
INSERT INTO bkmoperror_code VALUES('F','056','0002','001','Erreur lors de la création de la table temporaire d''entête','');
INSERT INTO bkmoperror_code VALUES('F','056','0003','001','Erreur lors de la création de la table temporaire de détail','');
INSERT INTO bkmoperror_code VALUES('F','056','0004','001','Erreur lors de l''insertion dans la table temporaire d''entête','');
INSERT INTO bkmoperror_code VALUES('F','056','0005','001','Erreur lors de l''insertion dans la table temporaire de détail','');
INSERT INTO bkmoperror_code VALUES('F','056','0006','001','Erreur lors du vidage de la table temporaire d''entête','');
INSERT INTO bkmoperror_code VALUES('F','056','0007','001','Erreur lors du vidage de la table temporaire de détail','');
INSERT INTO bkmoperror_code VALUES('F','056','0008','001','gu_bl_cmpenv_spec_maurice_alim_zone_det_vir','');
INSERT INTO bkmoperror_code VALUES('F','056','0009','001','gu_bl_cmpenv_spec_maurice_get_dcom_cur','');
INSERT INTO bkmoperror_code VALUES('F','056','0010','001','gu_bl_cmpenv_spec_maurice_get_num_chq','');
INSERT INTO bkmoperror_code VALUES('F','056','0011','001','gu_bl_cmpenv_spec_maurice_get_motif_vir','');
INSERT INTO bkmoperror_code VALUES('F','056','0012','001','Erreur lors de la récupération du répertoire de sortie','');
INSERT INTO bkmoperror_code VALUES('F','056','0013','001','gu_bl_cmpenv_spec_maurice_alim_bkcompens','');
INSERT INTO bkmoperror_code VALUES('F','056','0014','001','gu_bl_cmpenv_spec_maurice_traite_chq','');
INSERT INTO bkmoperror_code VALUES('F','056','0015','001','gu_bl_cmpenv_spec_maurice_traite_chq_rej','');
INSERT INTO bkmoperror_code VALUES('F','056','0016','001','gu_bl_cmpenv_spec_maurice_traite_chq_rep','');
INSERT INTO bkmoperror_code VALUES('F','056','0017','001','gu_bl_cmpenv_spec_maurice_traite_vir','');
INSERT INTO bkmoperror_code VALUES('F','056','0018','001','Erreur lors de la récupération du sous-cycle','');
INSERT INTO bkmoperror_code VALUES('F','056','0019','001','gu_bl_cmpenv_spec_maurice_alim_zone_ent_chq','');
INSERT INTO bkmoperror_code VALUES('F','056','0020','001','gu_bl_cmpenv_spec_maurice_alim_zone_det_chq','');
INSERT INTO bkmoperror_code VALUES('F','056','0021','001','gu_bl_cmpenv_spec_maurice_alim_zone_det_vir','');
INSERT INTO bkmoperror_code VALUES('F','056','0022','001','Erreur lors de la récupération du motif de rejet d''une chèque','');
INSERT INTO bkmoperror_code VALUES('F','056','0023','001','gu_bl_cmpenv_spec_maurice_charge_param','');
INSERT INTO bkmoperror_code VALUES('F','056','0024','001','Erreur lors du déplacement du fichier vers le répertoire d''envoi','');
INSERT INTO bkmoperror_code VALUES('F','056','0025','001','gu_bl_cmpenv_spec_maurice_gen_fic','');
INSERT INTO bkmoperror_code VALUES('F','056','0026','001','Erreur lors de la récupération du nombre de valeurs de chèques à émettre','');
INSERT INTO bkmoperror_code VALUES('F','056','0027','001','Erreur lors de la récupération du nombre de valeurs de chèques à rejetés à émettre','');
INSERT INTO bkmoperror_code VALUES('F','056','0028','001','Erreur lors de la récupération du nombre de valeurs de chèques représentés à émettre','');
INSERT INTO bkmoperror_code VALUES('F','056','0029','001','Erreur lors de la récupération du nombre de valeurs de virements à émettre','');
INSERT INTO bkmoperror_code VALUES('F','056','0030','001','gu_bl_cmpenv_spec_maurice_get_num_chq','');
INSERT INTO bkmoperror_code VALUES('F','056','0031','001','gu_bl_cmpenv_spec_maurice_get_motif_vir','');
INSERT INTO bkmoperror_code VALUES('F','056','0032','001','Erreur lors de la recherche du cycle actuel','');
INSERT INTO bkmoperror_code VALUES('T','057','0001','001','Valeur émise non trouvée','Continuer');
INSERT INTO bkmoperror_code VALUES('T','057','0002','001','Erreur lors de la récuperation dans la table bkeve','');
INSERT INTO bkmoperror_code VALUES('T','057','0003','001','Erreur lors de mis a jour Dans la tableau bkeve','');
INSERT INTO bkmoperror_code VALUES('T','057','0004','001','Valeur émise deja existant','');
INSERT INTO bkmoperror_code VALUES('T','057','0005','001','Impossible de determiner le nom de la banque','');
INSERT INTO bkmoperror_code VALUES('F','058','0001','001','Valeur émise non trouveé','Continue');
INSERT INTO bkmoperror_code VALUES('F','058','0002','001','Erreur lors de la récuperation dans la table bknom','');
INSERT INTO bkmoperror_code VALUES('F','058','0003','001','Erreur lors de la récupreation dans la table bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('F','058','0004','001','Erreur lors de la récuperation dans la table bkcompens_rf_eta','');
INSERT INTO bkmoperror_code VALUES('F','058','0005','001','Erreur lors de la récuperation dans la table bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('F','058','0006','001','Erreur lors de l''insertion de un nouvelle enregistraient dans la table bkcompens_rf_eta','');
INSERT INTO bkmoperror_code VALUES('F','058','0007','001','Erreur lors de la récuperation des fichiers pré-intégré','');
INSERT INTO bkmoperror_code VALUES('F','058','0008','001','gu_bl_cmpmoni_prec_lance_integration','');
INSERT INTO bkmoperror_code VALUES('F','059','0001','001','Valeur émise non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','059','0002','001','Erreur lors de la récuperation dans la table bkeve','');
INSERT INTO bkmoperror_code VALUES('F','059','0003','001','Erreur lors de la récuperation dans la table bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('F','059','0004','001','Erreur lors de la récuperation dans la table bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('F','059','0005','001','Erreur lors de la récuperation dans la table bkeve_comche','');
INSERT INTO bkmoperror_code VALUES('F','059','0006','001','Impossible de fermer la compensation chèque, il reste des erreurs sur lesquelles il faut prendre une décision','');
INSERT INTO bkmoperror_code VALUES('F','059','0007','001','Erreur lors de la récuperation dans la table bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('F','059','0008','001','Erreur lors de la récuperation dans la table bkcompens_suivi','');
INSERT INTO bkmoperror_code VALUES('F','059','0009','001','Impossible de fermer la compensation, il reste des erreurs','');
INSERT INTO bkmoperror_code VALUES('F','059','0010','001','Erreur lors de la récuperation dans la table bkcompens_pa','');
INSERT INTO bkmoperror_code VALUES('F','059','0011','001','Le système ne gère aucun type de valeur (gucmpparam)','');
INSERT INTO bkmoperror_code VALUES('T','060','0001','001','Valeur émise non trouvée','Continuer');
INSERT INTO bkmoperror_code VALUES('T','060','0002','001','Erreur lors de la récuperation dans la table bkcompens_error','');
INSERT INTO bkmoperror_code VALUES('T','060','0003','001','Erreur lors de l''insertion dans la table bkcompens_error','');
INSERT INTO bkmoperror_code VALUES('F','061','0001','001','Valeur émise non trouvée','');
INSERT INTO bkmoperror_code VALUES('F','061','0002','001','Erreur lors de la récuperation dans la table bkcompens_av_hav','');
INSERT INTO bkmoperror_code VALUES('F','061','0003','001','Erreur lors de la récuperation dans la table bkcompens_rv_hrf','');
INSERT INTO bkmoperror_code VALUES('F','061','0004','001','Erreur lors de la récuperation dans la table bkeve','');
INSERT INTO bkmoperror_code VALUES('F','061','0005','001','Erreur lors de la récuperation dans la table bkchqxmlimg','');
INSERT INTO bkmoperror_code VALUES('F','061','0006','001','Erreur lors de la récuperation dans la table bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('F','061','0007','001','Erreur lors de la récuperation dans la table bkcom','');
INSERT INTO bkmoperror_code VALUES('F','061','0008','001','Erreur lors de la récuperation dans la table bkbqeb','');
INSERT INTO bkmoperror_code VALUES('F','061','0009','001','Erreur lors de la récuperation dans la table bkcli','');
INSERT INTO bkmoperror_code VALUES('F','062','0001','001','fc_bl_ctrlvisu_set','');
INSERT INTO bkmoperror_code VALUES('F','063','0001','001','Parametre 098.SIGNATURES inexistant','');
INSERT INTO bkmoperror_code VALUES('F','063','0002','001','098.SIGNATURES - Numéro de version incorrect','');
INSERT INTO bkmoperror_code VALUES('F','063','0003','001','Erreur lors de la récupération de l''interface du programme cbdmsigdes','');
INSERT INTO bkmoperror_code VALUES('F','063','0004','001','L''interface du programme cbdmsigdes n''utilise pas de WebService','');
INSERT INTO bkmoperror_code VALUES('F','063','0005','001','fc_bl_signature_ges_acqsig','');
INSERT INTO bkmoperror_code VALUES('F','063','0006','001','Problème lors de la sélection de la date courante','');
INSERT INTO bkmoperror_code VALUES('F','063','0007','001','Erreur lors de l''insertion dans bksiga','');
INSERT INTO bkmoperror_code VALUES('F','063','0008','001','Erreur lors de la demande au serveur de signatures (début de session). Veuillez vérifier les logs','');
INSERT INTO bkmoperror_code VALUES('F','063','0009','001','Erreur lors de la lecture de evlanc','');
INSERT INTO bkmoperror_code VALUES('F','063','0010','001','Erreur lors de la suppresion de l''enregistrement de evlanc','');
INSERT INTO bkmoperror_code VALUES('F','063','0011','001','Erreur lors de l''instanciation de démarrage d''une session de demande de signatures','');
INSERT INTO bkmoperror_code VALUES('F','063','0012','001','Erreur lors de la récupération de l''interface du programme cbdmsigcpt','');
INSERT INTO bkmoperror_code VALUES('F','063','0013','001','fc_bl_signature_fin_session','');
INSERT INTO bkmoperror_code VALUES('F','063','0014','001','Erreur lors de l ''exécution du script SupprimeTousFichier','');
INSERT INTO bkmoperror_code VALUES('F','063','0015','001','fc_bl_signature_ins_bksiga','');
INSERT INTO bkmoperror_code VALUES('F','063','0016','001','Erreur lors de la récupération de l''interface du programme cbdmsigcli','');
INSERT INTO bkmoperror_code VALUES('F','063','0017','001','Erreur lors de la récupération de l''interface du programme cbdmsigfes','');
INSERT INTO bkmoperror_code VALUES('F','063','0018','001','fc_bl_signature_init_session','');
INSERT INTO bkmoperror_code VALUES('F','063','0019','001','fc_bl_signature_init_session','');
INSERT INTO bkmoperror_code VALUES('F','063','0020','001','fc_bl_signature_demande','');
INSERT INTO bkmoperror_code VALUES('F','063','0021','001','fc_bl_signature_demande','');
INSERT INTO bkmoperror_code VALUES('F','063','0022','001','fc_bl_signature_demande','');
INSERT INTO bkmoperror_code VALUES('F','063','0023','001','L''interface du programme cbdmsigcpt n''utilise pas de WebService','');
INSERT INTO bkmoperror_code VALUES('F','063','0024','001','L''interface du programme cbdmsigcli n''utilise pas de WebService','');
INSERT INTO bkmoperror_code VALUES('F','063','0025','001','L''interface du programme cbdmsigfes n''utilise pas de WebService','');
INSERT INTO bkmoperror_code VALUES('F','063','0026','001','Problème lors de la sélection de la date courante','');
INSERT INTO bkmoperror_code VALUES('F','064','0001','001','Erreur lors de l''initialisation de l''interface des messages','');
INSERT INTO bkmoperror_code VALUES('F','064','0002','001','Erreur lors de la déconnexion à l''interface des messages','');
INSERT INTO bkmoperror_code VALUES('F','065','0001','001','Impossible de determiner le nom de la banque (trf)','');
INSERT INTO bkmoperror_code VALUES('F','065','0002','001','Impossible de determiner le nom de la banque (chq)','');
INSERT INTO bkmoperror_code VALUES('F','065','0003','001','Erreur lors de la mise a jour de l''etat de bkcompens_av (chq)','');
INSERT INTO bkmoperror_code VALUES('F','065','0004','001','Erreur lors de la mise a jour de l''etat de bkcompens_av (trf)','');
INSERT INTO bkmoperror_code VALUES('F','065','0005','001','Erreur lors de la récuperation du cycle des chèques','');
INSERT INTO bkmoperror_code VALUES('F','065','0006','001','Erreur lors dela récuperation du cycle des virements','');
INSERT INTO bkmoperror_code VALUES('F','065','0007','001','gu_bl_cmpmoni_penv_lance_emission','');
INSERT INTO bkmoperror_code VALUES('F','065','0008','001','Erreur lors de la récuperation du cycle','');
INSERT INTO bkmoperror_code VALUES('F','065','0009','001','Erreur lors de la mise a jour de l''etat de bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('F','065','0010','001','Paramètre ISSUING_ITF catégorie GENEREAL inexistant','');
INSERT INTO bkmoperror_code VALUES('F','066','0001','001','Paramétrage de la devise nationale incorrect ou inexistant','');
INSERT INTO bkmoperror_code VALUES('F','066','0002','001','Paramètre COMPTE inexistant en T999','');
INSERT INTO bkmoperror_code VALUES('F','066','0003','001','La saisie de l''agence est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0004','001','L''agence saisie est incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','066','0005','001','Le code banque saisi doit être différent de la banque locale','');
INSERT INTO bkmoperror_code VALUES('F','066','0006','001','Le numéro de compte doit être numérique','');
INSERT INTO bkmoperror_code VALUES('F','066','0007','001','La longueur du numéro de compte est incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','066','0008','001','Erreur lors du contrôle du compte','');
INSERT INTO bkmoperror_code VALUES('F','066','0009','001','La clé de compte est erronée','');
INSERT INTO bkmoperror_code VALUES('F','066','0010','001','Le numéro de chèque doit être numérique','');
INSERT INTO bkmoperror_code VALUES('F','066','0011','001','Paramétrage de la devise saisie incorrect ou inexistant','');
INSERT INTO bkmoperror_code VALUES('F','066','0012','001','Le montant saisi doit être numérique','');
INSERT INTO bkmoperror_code VALUES('F','066','0013','001','Le second montant saisi doit être supérieur ou égal au premier montant saisi','');
INSERT INTO bkmoperror_code VALUES('F','066','0014','001','Erreur technique lors de la récupération du compte','');
INSERT INTO bkmoperror_code VALUES('F','066','0015','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('F','066','0016','001','La banque saisie est inexistante','');
INSERT INTO bkmoperror_code VALUES('F','066','0017','001','gucmpcvisu_controle_saisie','');
INSERT INTO bkmoperror_code VALUES('F','066','0018','001','Le suffixe saisi doit être numérique','');
INSERT INTO bkmoperror_code VALUES('F','066','0019','001','gucmpcvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('F','066','0020','001','Aucune donnée sélectionnée','');
INSERT INTO bkmoperror_code VALUES('F','066','0021','001','Erreur lors de la récupération des images chèques','');
INSERT INTO bkmoperror_code VALUES('F','066','0022','001','Erreur technique lors de la récupération du nom du client','');
INSERT INTO bkmoperror_code VALUES('F','066','0023','001','Le client n''existe pas','');
INSERT INTO bkmoperror_code VALUES('F','066','0024','001','Erreur lors du verrouillage d''un enregistrement de bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('F','066','0025','001','gucmpcvisu_traitement','');
INSERT INTO bkmoperror_code VALUES('F','066','0026','001','gucmpcvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('F','066','0027','001','Erreur lors de la mise à jour de la table bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('F','066','0028','001','Erreur lors de la mise à jour de la table bkcompens_rv_chq','');
INSERT INTO bkmoperror_code VALUES('F','066','0029','001','La saisie de la banque est obigatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0030','001','La saisie du compte est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0031','001','La saisie de l''agence est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0032','001','La saisie du suffixe est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0033','001','La saisie du compte est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0034','001','La saisie de la clé du compte est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0035','001','La saisie de la devise est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','066','0036','001','Paramétrage de la devise nationale incorrect ou inexistant','');
INSERT INTO bkmoperror_code VALUES('F','066','0037','001','gucmpcvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('F','066','0038','001','gucmpcvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('F','066','0039','001','gucmpcvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('F','066','0040','001','Erreur technique lors de la récupération du compte','');
INSERT INTO bkmoperror_code VALUES('F','066','0041','001','Erreur technique lors de la récupération du compte','');
INSERT INTO bkmoperror_code VALUES('F','066','0042','001','gucmpcvisu_traitement','');
INSERT INTO bkmoperror_code VALUES('F','066','0043','001','gucmpcvisu_traitement','');
INSERT INTO bkmoperror_code VALUES('F','066','0044','001','L''agence saisie est incorrecte','');
INSERT INTO bkmoperror_code VALUES('F','066','0045','001','gucmpcvisu_controle_saisie','');
INSERT INTO bkmoperror_code VALUES('F','066','0046','001','gucmpcvisu_controle_saisie','');
INSERT INTO bkmoperror_code VALUES('F','066','0047','001','Erreur lors du contrôle du compte','');
INSERT INTO bkmoperror_code VALUES('F','066','0048','001','Le montant saisi doit être numérique','');
INSERT INTO bkmoperror_code VALUES('F','066','0049','001','La banque saisie est inexistante','');
INSERT INTO bkmoperror_code VALUES('F','066','0050','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('F','066','0051','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('F','066','0052','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('F','066','0053','001','Erreur lors du verrouillage d''un enregistrement de bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('F','066','0054','001','gucmpcvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('F','066','0055','001','gucmpcvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('F','067','0001','001','Donnees en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','067','0002','001','Incident @ TABLE @ SQLCODE @','');
INSERT INTO bkmoperror_code VALUES('F','067','0003','001','Donnees en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','067','0004','001','Incident @ TABLE @ SQLCODE @','');
INSERT INTO bkmoperror_code VALUES('F','068','0001','001','Erreur lors de l''insertion dans bkeve','');
INSERT INTO bkmoperror_code VALUES('F','068','0002','001','Erreur lors de l''insertion dans bkevec','');
INSERT INTO bkmoperror_code VALUES('F','069','0001','001','Erreur lors de l''update du statut de bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('F','069','0002','001','Code banque emetteur incorrect','');
INSERT INTO bkmoperror_code VALUES('F','069','0003','001','Erreur lors de la recherche du code banque dans bkbqe','');
INSERT INTO bkmoperror_code VALUES('F','069','0004','001','Erreur lors de la recherche du compte dans bkcom','');
INSERT INTO bkmoperror_code VALUES('F','069','0005','001','Code banque destinataire incorrect','');
INSERT INTO bkmoperror_code VALUES('F','069','0006','001','Erreur lors de l''update du sort dans bkchr','');
INSERT INTO bkmoperror_code VALUES('F','069','0007','001','Type d''operation incorrect','');
INSERT INTO bkmoperror_code VALUES('F','069','0008','001','Erreur lors de l''insertion dans bkcompens_rv_eve et tables complementaires','');
INSERT INTO bkmoperror_code VALUES('F','069','0009','001','.','');
INSERT INTO bkmoperror_code VALUES('F','069','0010','001','Probléme lors de la recherche des information du chèque','');
INSERT INTO bkmoperror_code VALUES('F','069','0011','001','Aucun événement n''est associé à la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','069','0012','001','Probléme lors de la recherche du chèque en recouvrement','');
INSERT INTO bkmoperror_code VALUES('F','069','0013','001','Sort du chèque déjà positionné','');
INSERT INTO bkmoperror_code VALUES('F','069','0014','001','Montant du chèque différent','');
INSERT INTO bkmoperror_code VALUES('F','069','0015','001','.','');
INSERT INTO bkmoperror_code VALUES('F','069','0016','001','.','');
INSERT INTO bkmoperror_code VALUES('F','069','0017','001','Probléme lors de la recherche de la correspondance du code rejet','');
INSERT INTO bkmoperror_code VALUES('F','069','0018','001','Code rejet inconnu','');
INSERT INTO bkmoperror_code VALUES('F','069','0019','001','Incident lors de la mise à jour du chèque de recouvrement','');
INSERT INTO bkmoperror_code VALUES('F','069','0020','001','.','');
INSERT INTO bkmoperror_code VALUES('F','069','0021','001','Chèque déjà en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','069','0022','001','Valeur d''origine du chèque déjà en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','069','0023','001','Erreur lors de l''insertion de données complémentaires','');
INSERT INTO bkmoperror_code VALUES('F','069','0024','001','Erreur lors de la lecture dans bkcompens_pa','');
INSERT INTO bkmoperror_code VALUES('F','069','0025','001','Erreur lors de la lecture dans bkcli','');
INSERT INTO bkmoperror_code VALUES('F','069','0026','001','Incident lors de la création de la réservation de fond','');
INSERT INTO bkmoperror_code VALUES('F','069','0027','001','Incident lors de l''insertion dans bkcompens_rv_eve','');
INSERT INTO bkmoperror_code VALUES('F','069','0028','001','.','');
INSERT INTO bkmoperror_code VALUES('F','069','0029','001','Etat de la valeur d''origine incorrect','');
INSERT INTO bkmoperror_code VALUES('F','069','0030','001','Erreur lors de la recherche de la valeur d''origine','');
INSERT INTO bkmoperror_code VALUES('F','069','0031','001','Compte en instance de fermeture pour un chèque reçu','');
INSERT INTO bkmoperror_code VALUES('F','069','0032','001','Compte fermé pour un chèque reçu','');
INSERT INTO bkmoperror_code VALUES('F','069','0033','001','.','');
INSERT INTO bkmoperror_code VALUES('F','069','0034','001','.','');
INSERT INTO bkmoperror_code VALUES('F','070','0001','001','Pas de cheques correspondants aux selections','');
INSERT INTO bkmoperror_code VALUES('F','070','0002','001','Code compte est erroné','');
INSERT INTO bkmoperror_code VALUES('F','070','0003','001','Cle erroné','');
INSERT INTO bkmoperror_code VALUES('F','070','0004','001','Informations du cheque non trouvees','');
INSERT INTO bkmoperror_code VALUES('F','070','0005','001','Enregistrement @ inexistant dans la table @','');
INSERT INTO bkmoperror_code VALUES('F','070','0006','001','Incident @ Table @ Status @','');
INSERT INTO bkmoperror_code VALUES('F','071','0001','001','La table bkcompens_af ne peut pas etre verrouillee','');
INSERT INTO bkmoperror_code VALUES('F','071','0002','001','Il n''est pas possible de fair la MAJ du fichier émis','');
INSERT INTO bkmoperror_code VALUES('F','071','0003','001','l n''y a pas de valeur liée au fichier en cours','');
INSERT INTO bkmoperror_code VALUES('F','071','0004','001','La table bkcompens_av ne peut pas etre verrouillee','');
INSERT INTO bkmoperror_code VALUES('F','071','0005','001','Il n''est pas possible de fair la MAJ des valeurs liées au fichier émis','');
INSERT INTO bkmoperror_code VALUES('F','071','0006','001','La table bkcompens_av ne peut pas etre verrouillee','');
INSERT INTO bkmoperror_code VALUES('F','071','0007','001','Il n''y a pas d''événement lié à la valeur em cours','');
INSERT INTO bkmoperror_code VALUES('F','071','0008','001','Il n''est pas possible de fair la MAJ des valeurs liées au fichier émis','');
INSERT INTO bkmoperror_code VALUES('F','071','0009','001','La table bkeve ne peut pas etre verrouillee','');
INSERT INTO bkmoperror_code VALUES('F','071','0010','001','Il n''est pas possible de fair la MAJ de la table bkeve','');
INSERT INTO bkmoperror_code VALUES('F','072','0001','001','La table bkcompens_af ne peut pas etre verrouillee','');
INSERT INTO bkmoperror_code VALUES('F','072','0002','001','Il n''est pas possible de fair la MAJ du fichier émis','');
INSERT INTO bkmoperror_code VALUES('F','072','0003','001','Il n''y a pas de valeur liée au fichier en cours','');
INSERT INTO bkmoperror_code VALUES('F','072','0004','001','La table bkcompens_av ne peut pas etre verrouillee','');
INSERT INTO bkmoperror_code VALUES('F','072','0005','001','Il n''y a pas d''événement lié à la valeur em cours','');
INSERT INTO bkmoperror_code VALUES('F','072','0006','001','Il n''est pas possible de fair la MAJ des valeurs liées au fichier émis','');
INSERT INTO bkmoperror_code VALUES('F','073','0001','001','Paramètre COMPTE inexistant en table 999','');
INSERT INTO bkmoperror_code VALUES('F','073','0002','001','gu_bl_ctrl_visu_lec_param','');
INSERT INTO bkmoperror_code VALUES('F','073','0003','001','gu_bl_ctrl_visu_init','');
INSERT INTO bkmoperror_code VALUES('F','073','0004','001','gu_bl_ctrl_visu_aff','');
INSERT INTO bkmoperror_code VALUES('F','073','0005','001','gu_bl_ctrl_visu_nav_chq','');
INSERT INTO bkmoperror_code VALUES('F','073','0006','001','gu_bl_ctrl_visu_get_sig','');
INSERT INTO bkmoperror_code VALUES('F','073','0007','001','Erreur lors de la récupération du code client du compte','');
INSERT INTO bkmoperror_code VALUES('F','073','0008','001','Erreur lors de la récupération du code numérique de la devise','');
INSERT INTO bkmoperror_code VALUES('F','073','0009','001','gu_bl_ctrl_visu_chg_side','');
INSERT INTO bkmoperror_code VALUES('F','073','0010','001','gu_bl_ctrl_visu_aff_chq','');
INSERT INTO bkmoperror_code VALUES('F','073','0011','001','Aucune image chèque trouvée','');
INSERT INTO bkmoperror_code VALUES('F','073','0012','001','Erreur lors de la récupération de l''image chèque','');
INSERT INTO bkmoperror_code VALUES('F','073','0013','001','Erreur lors de la création de la table temporaire','');
INSERT INTO bkmoperror_code VALUES('F','073','0014','001','Erreur lors du chargement du fichier dans la table temporaire','');
INSERT INTO bkmoperror_code VALUES('F','073','0015','001','gu_bl_ctrl_visu_aff_com','');
INSERT INTO bkmoperror_code VALUES('F','073','0016','001','gu_bl_ctrl_visu_aff_chq_qry','');
INSERT INTO bkmoperror_code VALUES('F','073','0017','001','La saisie d''au moins un désaccord bénéficiaire est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','073','0018','001','La saisie d''au moins un désaccord émetteur est obligatoire','');
INSERT INTO bkmoperror_code VALUES('F','073','0019','001','gu_bl_ctrl_visu_validate','');
INSERT INTO bkmoperror_code VALUES('F','073','0020','001','gu_bl_ctrl_visu_abandon','');
INSERT INTO bkmoperror_code VALUES('F','073','0021','001','Erreur lors de la conversion de l''image recto du chèque','');
INSERT INTO bkmoperror_code VALUES('F','073','0022','001','Erreur lors de la conversion de l''image verso du chèque','');
INSERT INTO bkmoperror_code VALUES('F','073','0023','001','gu_bl_ctrl_visu_fin_prog','');
INSERT INTO bkmoperror_code VALUES('F','074','0001','001','Erreur lors de l''initialisation du contrôle visuel','');
INSERT INTO bkmoperror_code VALUES('F','074','0002','001','Erreur lors de la validation du contrôle visuel','');
INSERT INTO bkmoperror_code VALUES('F','074','0003','001','Problème lors du contrôle du combo','');
INSERT INTO bkmoperror_code VALUES('F','074','0004','001','Problème lors du contrôle du combo','');
INSERT INTO bkmoperror_code VALUES('F','074','0005','001','Problème lors du contrôle du combo','');
INSERT INTO bkmoperror_code VALUES('F','074','0006','001','Problème lors du contrôle du combo','');
INSERT INTO bkmoperror_code VALUES('F','074','0007','001','Problème lors du contrôle du combo','');
INSERT INTO bkmoperror_code VALUES('F','074','0008','001','Problème lors du contrôle du combo','');
INSERT INTO bkmoperror_code VALUES('F','074','0009','001','Erreur lors de la fin de session de signatures','');
INSERT INTO bkmoperror_code VALUES('F','074','0010','001','Sortie du traitement de l''écran de détail du contrôle visuel','');
INSERT INTO bkmoperror_code VALUES('F','075','0001','001','Chèque deja emis','');
INSERT INTO bkmoperror_code VALUES('F','075','0002','001','Erreur lors de la recherche d''un cheque dans bkeve','');
INSERT INTO bkmoperror_code VALUES('F','075','0003','001','Erreur lors de la recherche du cheque dans bkchq','');
INSERT INTO bkmoperror_code VALUES('F','075','0004','001','Cheque en doublon','');
INSERT INTO bkmoperror_code VALUES('F','075','0005','001','Cheque inconnu','');
INSERT INTO bkmoperror_code VALUES('F','075','0006','001','Montant different du cheque de banque','');
INSERT INTO bkmoperror_code VALUES('F','075','0007','001','Montant différent du cheque certifié','');
INSERT INTO bkmoperror_code VALUES('F','075','0008','001','Cheque non distribué','');
INSERT INTO bkmoperror_code VALUES('F','075','0009','001','Cheque soldé','');
INSERT INTO bkmoperror_code VALUES('F','075','0010','001','Erreur lors de la rechercher du chèques en recouvrement','');
INSERT INTO bkmoperror_code VALUES('F','075','0011','001','Chèque en recouvrement non trouvé','');
INSERT INTO bkmoperror_code VALUES('F','075','0012','001','Erreur lors de la rechercher du chèques en recouvrement','');
INSERT INTO bkmoperror_code VALUES('F','076','0001','001','Erreur lors du traitement du fichier','');
INSERT INTO bkmoperror_code VALUES('F','077','0001','001','Erreur lors de la validation','');
INSERT INTO bkmoperror_code VALUES('F','077','0002','001','Erreur lors de la recherche du compte','');
INSERT INTO bkmoperror_code VALUES('F','077','0003','001','Erreur lors de la recherche du code opération','');
INSERT INTO bkmoperror_code VALUES('F','077','0004','001','Erreur lors de la recherche du paramétre GES-INCO','');
INSERT INTO bkmoperror_code VALUES('F','077','0005','001','Paramétre GES-INCO non renseigné','');
INSERT INTO bkmoperror_code VALUES('T','078','0001','001','Enregistrement Age, Ope, Eve inexistant dans la table bkchr','');
INSERT INTO bkmoperror_code VALUES('T','078','0002','001','Erreur dans les tables bkchr, bkcompens_av_eve, bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','078','0003','001','Erreur update table bkchr','');
INSERT INTO bkmoperror_code VALUES('T','078','0004','001','Incident table bkcompens_av_chq','');
INSERT INTO bkmoperror_code VALUES('T','078','0005','001','Incident UPDATE tables des valeurs émises','');
INSERT INTO bkmoperror_code VALUES('T','078','0006','001','Erreur lors de fonction api_gu_genvir_abrvir','');
INSERT INTO bkmoperror_code VALUES('T','078','0007','001','Erreur lors de fonction gu_bl_cmp_dao_lock_bkcompens_av','');
INSERT INTO bkmoperror_code VALUES('T','078','0008','001','Erreur lors de fonction api_gu_genvir_anuvir','');
INSERT INTO bkmoperror_code VALUES('T','078','0009','001','Erreur lors de fonction api_gu_genvir_resvir','');
INSERT INTO bkmoperror_code VALUES('F','079','0001','001','Erreur lors du lock d''une valeur sur bkcompens_rv','');
INSERT INTO bkmoperror_code VALUES('F','079','0002','001','Erreur lors de l''appel a api_gu_genchq_COMCHE','');
INSERT INTO bkmoperror_code VALUES('F','079','0003','001','Erreur lors du select cheques','');
INSERT INTO bkmoperror_code VALUES('F','079','0004','001','Erreur lors de l''appel a api_gu_genvir_COMVIR','');
INSERT INTO bkmoperror_code VALUES('F','079','0005','001','Erreur lors de l''appel a resolve erreur','');
INSERT INTO bkmoperror_code VALUES('F','079','0006','001','Erreur lors de l''appel a update valeur recue','');
INSERT INTO bkmoperror_code VALUES('F','079','0007','001','Erreur lors de l''appel a genvir_abcvir','');
INSERT INTO bkmoperror_code VALUES('F','079','0008','001','Erreur lors de l''appel a genvir_retvir','');
INSERT INTO bkmoperror_code VALUES('F','079','0009','001','Erreur lors de l''appel a VIRBQE','');
INSERT INTO bkmoperror_code VALUES('F','080','0001','001','Incident lors de l''insertion d''un message à poster','Revoir la structure de la table bkpostmsg ou contacter la Hotline.');
INSERT INTO bkmoperror_code VALUES('F','081','0001','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0002','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0003','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0004','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0005','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0006','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0007','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0008','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0009','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0010','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0011','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0012','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0013','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0014','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0015','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0016','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0017','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0018','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0019','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0020','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0021','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0022','001','.','');
INSERT INTO bkmoperror_code VALUES('F','081','0023','001','.','');
INSERT INTO bkmoperror_code VALUES('F','082','0001','001','Impossible de charger le fichier PSR','');
INSERT INTO bkmoperror_code VALUES('F','082','0002','001','Chemin du PSR non renseigne','');
INSERT INTO bkmoperror_code VALUES('F','082','0003','001','Alimentation erronee table PSR message','');
INSERT INTO bkmoperror_code VALUES('F','082','0004','001','Alimentation erronee table PSR Lot','');
INSERT INTO bkmoperror_code VALUES('F','082','0005','001','Alimentation erronee table PSR Transactions','');
INSERT INTO bkmoperror_code VALUES('F','082','0006','001','Rupture Fin Lot en erreur','');
INSERT INTO bkmoperror_code VALUES('F','082','0007','001','Creation PSR erronee','');
INSERT INTO bkmoperror_code VALUES('F','082','0008','001','Aucun Message à traiter pour l''identifiant','');
INSERT INTO bkmoperror_code VALUES('F','082','0009','001','Creation table temporaire tmppsr erronee','');
INSERT INTO bkmoperror_code VALUES('F','082','0010','001','.','');
INSERT INTO bkmoperror_code VALUES('F','082','0011','001','.','');
INSERT INTO bkmoperror_code VALUES('F','082','0012','001','Canal non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','082','0013','001','Contenu du PAIN non renseigné','');
INSERT INTO bkmoperror_code VALUES('F','083','0001','001','Incident sur creation de sequence de base de donnees','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','083','0002','001','Incident sur selection de sequence de base de donnees','Contacter la hotline');
INSERT INTO bkmoperror_code VALUES('F','083','0003','001','Incident lors de la suppression d''une séquence','');
INSERT INTO bkmoperror_code VALUES('F','084','0001','001','Données déjà en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('F','084','0002','001','Erreur SQL','');
INSERT INTO bkmoperror_code VALUES('F','084','0003','001','Données déjà en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('F','084','0004','001','Erreur SQL','');
INSERT INTO bkmoperror_code VALUES('F','084','0005','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0006','001','Code opération non trouvé','');
INSERT INTO bkmoperror_code VALUES('F','084','0007','001','Opération de nuit déjà en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('F','084','0008','001','Erreur SQL','');
INSERT INTO bkmoperror_code VALUES('F','084','0009','001','Opération de nuit déjà en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('F','084','0010','001','Erreur SQL','');
INSERT INTO bkmoperror_code VALUES('F','084','0011','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0012','001','Code opération de nuit non trouvé','');
INSERT INTO bkmoperror_code VALUES('F','084','0013','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0014','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0015','001','Table d''operation inconnue','');
INSERT INTO bkmoperror_code VALUES('F','084','0016','001','Impossible de mettre à jour le num de l''opération','');
INSERT INTO bkmoperror_code VALUES('F','084','0017','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0018','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0019','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0020','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0021','001','Méthode de calcul de numéro d''événement inconnue','');
INSERT INTO bkmoperror_code VALUES('F','084','0022','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0023','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0024','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0025','001','Impossible de determiner la situation des soldes','');
INSERT INTO bkmoperror_code VALUES('F','084','0026','001','Soldes indisponibles','');
INSERT INTO bkmoperror_code VALUES('F','084','0027','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0028','001','.','');
INSERT INTO bkmoperror_code VALUES('F','084','0029','001','Opération de nuit déjà en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('F','084','0030','001','Opération de jour déjà en cours d''utilisation','');
INSERT INTO bkmoperror_code VALUES('F','085','0001','001','.','');
INSERT INTO bkmoperror_code VALUES('F','085','0002','001','.','');
INSERT INTO bkmoperror_code VALUES('F','086','0001','001','.','');
INSERT INTO bkmoperror_code VALUES('F','086','0002','001','.','');
INSERT INTO bkmoperror_code VALUES('F','087','0001','001','Probléme d''initialisation de l''interface','');
INSERT INTO bkmoperror_code VALUES('F','087','0002','001','Probléme lors du traitement de l''interface','');
INSERT INTO bkmoperror_code VALUES('F','087','0003','001','.','');
INSERT INTO bkmoperror_code VALUES('F','087','0004','001','Probléme lors de la fermeture du message','');
INSERT INTO bkmoperror_code VALUES('F','087','0005','001','Probléme lors de l''envoi du flux converti','');
INSERT INTO bkmoperror_code VALUES('F','087','0006','001','Probléme lors de la sauvegarde du flux converti','');
INSERT INTO bkmoperror_code VALUES('F','087','0007','001','Probléme lors de la fermeture de l''interface','');
INSERT INTO bkmoperror_code VALUES('F','087','0008','001','Répertoire des rapports mal configuré','');
INSERT INTO bkmoperror_code VALUES('F','088','0001','001','Probléme d''initialisation du flux XML avec le contenu reçu','');
INSERT INTO bkmoperror_code VALUES('F','088','0002','001','Probléme d''initialisation du flux XML avec le chemin reçu','');
INSERT INTO bkmoperror_code VALUES('F','088','0003','001','Type de flux indétérminé','');
INSERT INTO bkmoperror_code VALUES('F','088','0004','001','Type de flux incorrect','');
INSERT INTO bkmoperror_code VALUES('F','088','0005','001','Erreur lors de la conversion','');
INSERT INTO bkmoperror_code VALUES('F','088','0006','001','répertoire XSLT mal configuré','');
INSERT INTO bkmoperror_code VALUES('F','088','0007','001','.','');
INSERT INTO bkmoperror_code VALUES('F','088','0008','001','.','');
INSERT INTO bkmoperror_code VALUES('F','089','0001','001','Code composé non trouvé','');
INSERT INTO bkmoperror_code VALUES('F','089','0002','001','Plusieurs codes composé trouvée','');
INSERT INTO bkmoperror_code VALUES('F','089','0003','001','Probléme lors de la recherche de code composé','');
INSERT INTO bkmoperror_code VALUES('F','090','0001','001','Compte CMPINCTRF0 inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0002','001','Compte CMPSUSPENS inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0003','001','Compte CMPRETURN0 inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0004','001','Compte CMPCANCELC inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0005','001','Compte CMPOUTTRF0 inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0006','001','Compte CMPREJECT0 inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0007','001','Compte CMPCANCELR inexistant en table 094','');
INSERT INTO bkmoperror_code VALUES('F','090','0008','001','Problème lors de la lecture de la nature d''opération ISAVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0009','001','Problème lors de la lecture de l''opération liée à ISAVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0010','001','Problème lors de la lecture de la nature d''opération RETVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0011','001','Problème lors de la lecture de l''opération liée à RETVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0012','001','Problème lors de la lecture de la nature d''opération ABCVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0013','001','Problème lors de la lecture de l''opération liée à ABCVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0014','001','Problème lors de la lecture de la nature d''opération REJVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0015','001','Problème lors de la lecture de l''opération liée à REJVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0016','001','Problème lors de la lecture de la nature d''opération RESVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0017','001','Problème lors de la lecture de l''opération liée à RESVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0018','001','Problème lors de la lecture de la nature d''opération ABRVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0019','001','Problème lors de la lecture de l''opération liée à ABRVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0020','001','Problème lors de la lecture de la nature d''opération ANUVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0021','001','Problème lors de la lecture de l''opération liée à ANUVIR','');
INSERT INTO bkmoperror_code VALUES('F','090','0022','001','Erreur lors de la lecture du compte client','');
INSERT INTO bkmoperror_code VALUES('F','090','0023','001','Erreur lors de la lecture des informations client','');
INSERT INTO bkmoperror_code VALUES('F','090','0024','001','Erreur lors du contrôle de désaccords sur le compte','');
INSERT INTO bkmoperror_code VALUES('F','090','0025','001','Erreur lors du second contrôle de désaccords sur le compte','');
INSERT INTO bkmoperror_code VALUES('F','090','0026','001','Erreur lors de la mise à jours des données','');
INSERT INTO bkmoperror_code VALUES('F','091','0001','001','Erreur lors de la lecture de l''évènement','');
INSERT INTO bkmoperror_code VALUES('F','091','0002','001','Evènement inexistant','');
INSERT INTO bkmoperror_code VALUES('F','091','0003','001','Erreur lors de la lecture du compte','');
INSERT INTO bkmoperror_code VALUES('F','091','0004','001','Compte inexistant','');
INSERT INTO bkmoperror_code VALUES('F','091','0005','001','Erreur lors de la mise à jour du compte lié à l''évènement COMVIR','');
INSERT INTO bkmoperror_code VALUES('F','091','0006','001','Erreur lors de la mise à jour du compte lié à l''évènement COMCHE','');
INSERT INTO bkmoperror_code VALUES('F','091','0007','001','Erreur lors de la mise à jour du compte','');
INSERT INTO bkmoperror_code VALUES('F','091','0008','001','Erreur lors de la mise à jour de l''évènement','');
INSERT INTO bkmoperror_code VALUES('T','093','0001','001','Date de compensation non trouvée','');
INSERT INTO bkmoperror_code VALUES('T','093','0002','001','Erreur lors de la mise à jour de bkcompens_av (zone et eta)','');
INSERT INTO bkmoperror_code VALUES('T','093','0003','001','Erreur lors de l''alimentation de bkcompens_af et bkcompens_af_eta','');
INSERT INTO bkmoperror_code VALUES('T','093','0004','001','Erreur lors de la génération du fichier','');
INSERT INTO bkmoperror_code VALUES('T','093','0005','001','Erreur lors de la recherche de VALA dans bkcompens_av_ieve','');
INSERT INTO bkmoperror_code VALUES('T','093','0006','001','Erreur lors de la recherche de VALA dans bkibqe','');
INSERT INTO bkmoperror_code VALUES('T','093','0007','001','Erreur lors de la recherche des motifs dans bkcompens_av_trf','');
INSERT INTO bkmoperror_code VALUES('T','093','0008','001','Erreir lors de l''update de bkcompens_av pendant la generation de fichier','');
INSERT INTO bkmoperror_code VALUES('F','094','0001','001','compte et ncp non renseigné','Modifier les parametres');
INSERT INTO bkmoperror_code VALUES('F','094','0002','001','client non trouvé','Relancer un programme');
INSERT INTO bkmoperror_code VALUES('T','095','0001','001','Erreur SEL_COUNT bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','095','0002','001','Le fichier a déjà été intégré','');
INSERT INTO bkmoperror_code VALUES('T','095','0003','001','Erreur lors de la lecture du paramètre 098.BANQUE','');
INSERT INTO bkmoperror_code VALUES('T','095','0004','001','Paramètre CLEARING_BRANCH inexistant dans la catégorie GENERAL','');
INSERT INTO bkmoperror_code VALUES('T','095','0005','001','Format de fichier reçu incorrect','');
INSERT INTO bkmoperror_code VALUES('T','095','0006','001','Format détail/pied incorrect','');
INSERT INTO bkmoperror_code VALUES('T','095','0007','001','Nombre de transactions différent du nombre de transactions calculé','');
INSERT INTO bkmoperror_code VALUES('T','095','0008','001','Format entête incorrect','');
INSERT INTO bkmoperror_code VALUES('T','095','0009','001','Structure entête incorrecte','');
INSERT INTO bkmoperror_code VALUES('T','095','0010','001','Date entête incohérente avec celle du nom de fichier','');
INSERT INTO bkmoperror_code VALUES('T','095','0011','001','Type de transaction incorrect','');
INSERT INTO bkmoperror_code VALUES('T','095','0012','001','Code destinataire du détail différent de celui de l''entête','');
INSERT INTO bkmoperror_code VALUES('T','095','0013','001','Paramètre CLEARING_CURRENCY inexistant dans la catégorie GENERAL','');
INSERT INTO bkmoperror_code VALUES('T','095','0014','001','Devise différente de la devise de compensation','');
INSERT INTO bkmoperror_code VALUES('T','095','0015','001','Le montant n''est pas numérique','');
INSERT INTO bkmoperror_code VALUES('T','095','0016','001','Le code émetteur CITAD est inexistant dans les données complémentaires de la fiche banque','');
INSERT INTO bkmoperror_code VALUES('T','095','0017','001','Code destinataire du pied différent de celui de l''entête','');
INSERT INTO bkmoperror_code VALUES('T','095','0018','001','Date de transaction du pied différent de celle de l''entête','');
INSERT INTO bkmoperror_code VALUES('T','095','0019','001','Incident SELECT_vala bkibqe','');
INSERT INTO bkmoperror_code VALUES('T','095','0020','001','Incident SELECT_etab_guib bkibqe','');
INSERT INTO bkmoperror_code VALUES('T','095','0021','001','Erreur lors de la création de la table temporaire','');
INSERT INTO bkmoperror_code VALUES('T','095','0022','001','Erreur lors du chargement de la table temporaire','');
INSERT INTO bkmoperror_code VALUES('T','095','0023','001','Lecture d''un fichier vide','');
INSERT INTO bkmoperror_code VALUES('T','095','0024','001','gu_bl_cmprec_spec_vietnam_controle_detail_vir','');
INSERT INTO bkmoperror_code VALUES('T','095','0025','001','gu_bl_cmprec_spec_vietnam_alim_valeur','');
INSERT INTO bkmoperror_code VALUES('T','095','0026','001','Incident EXECUTE bkcompens_rf','');
INSERT INTO bkmoperror_code VALUES('T','095','0027','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0028','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0029','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0030','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0031','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0032','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0033','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('T','095','0034','001','gu_bl_cmprec_spec_vietnam_maj_tables','');
INSERT INTO bkmoperror_code VALUES('F','096','0001','001','Parametre manquant','');
INSERT INTO bkmoperror_code VALUES('F','096','0002','001','Parametre inexistant en table','');
INSERT INTO bkmoperror_code VALUES('F','096','0003','001','Agence de compensation non paramétrée','');
INSERT INTO bkmoperror_code VALUES('F','096','0004','001','Probleme de lecture des donnees en table','');
INSERT INTO bkmoperror_code VALUES('F','096','0005','001','Probléme de lecture du paramétre CHEQUE_TRIGGERING_FATE','');
INSERT INTO bkmoperror_code VALUES('F','096','0006','001','Impossible de récupéret le délai de réglement','');
INSERT INTO bkmoperror_code VALUES('F','096','0007','001','Impossible de récupéret le délai de réglement','');
INSERT INTO bkmoperror_code VALUES('F','096','0008','001','.','');
INSERT INTO bkmoperror_code VALUES('F','097','0001','001','Parametre manquant','');
INSERT INTO bkmoperror_code VALUES('F','098','0001','001','test','');
INSERT INTO bkmoperror_code VALUES('F','098','0002','001','Aucune valeur à traiter','');
INSERT INTO bkmoperror_code VALUES('F','099','0001','001','Erreur de paramétrage','Vérifier le paramétrage');
INSERT INTO bkmoperror_code VALUES('F','100','0001','001','Parametre CHEQUE_TRIGGERING_FATE mal parametre','');
INSERT INTO bkmoperror_code VALUES('F','100','0002','001','Parametre CHEQUE_REASON_REJECT  mal parametre','');
INSERT INTO bkmoperror_code VALUES('F','100','0003','001','Erreur lors de la recuperation des informations de la table ''bkchr''','');
INSERT INTO bkmoperror_code VALUES('F','100','0004','001','Donnee(s) en cours de traitement','');
INSERT INTO bkmoperror_code VALUES('F','100','0005','001','Cheque deja paye','');
INSERT INTO bkmoperror_code VALUES('F','100','0006','001','Cheque deja impaye','');
INSERT INTO bkmoperror_code VALUES('F','100','0007','001','Sort du cheque deja positionne.','');
INSERT INTO bkmoperror_code VALUES('F','100','0008','001','Erreur lors de la mise à jour de ''bkchr''','');
INSERT INTO bkmoperror_code VALUES('F','100','0009','001','Erreur lors de la recherche du compte à débiter pour le sort impayé','');
INSERT INTO bkmoperror_code VALUES('F','100','0010','001','Erreur lors de la recherche du client à débiter pour le sort impayé','');
INSERT INTO bkmoperror_code VALUES('T','101','0001','001','Erreur lors de la suppression des exceptions aller','');
INSERT INTO bkmoperror_code VALUES('T','101','0002','001','Erreur lors de la suppression des exceptions retour','');
INSERT INTO bkmoperror_code VALUES('T','101','0003','001','Erreur lors de l''insertion de l''exception aller','');
INSERT INTO bkmoperror_code VALUES('T','101','0004','001','Erreur lors de l''insertion de l''exception retour','');
INSERT INTO bkmoperror_code VALUES('T','101','0005','001','Probleme de mise à jour des exception pour un systeme de compensation','');
INSERT INTO bkmoperror_code VALUES('T','102','0001','001','Paramétrage de la devise nationale incorrect ou inexistant','');
INSERT INTO bkmoperror_code VALUES('T','102','0002','001','Paramètre COMPTE inexistant en T999','');
INSERT INTO bkmoperror_code VALUES('T','102','0003','001','La saisie de l''''agence est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0004','001','L''''agence saisie est incorrecte','');
INSERT INTO bkmoperror_code VALUES('T','102','0005','001','Le code banque saisi doit être différent de la banque locale','');
INSERT INTO bkmoperror_code VALUES('T','102','0006','001','Le numéro de compte doit être numérique','');
INSERT INTO bkmoperror_code VALUES('T','102','0007','001','La longueur du numéro de compte est incorrecte','');
INSERT INTO bkmoperror_code VALUES('T','102','0008','001','Erreur lors du contrôle du compte','');
INSERT INTO bkmoperror_code VALUES('T','102','0009','001','La clé de compte est erronée','');
INSERT INTO bkmoperror_code VALUES('T','102','0010','001','Le numéro de chèque doit être numérique','');
INSERT INTO bkmoperror_code VALUES('T','102','0011','001','Paramétrage de la devise saisie incorrect ou inexistant','');
INSERT INTO bkmoperror_code VALUES('T','102','0012','001','Le montant saisi doit être numérique','');
INSERT INTO bkmoperror_code VALUES('T','102','0013','001','Le second montant saisi doit être supérieur ou égal au premier montant saisi','');
INSERT INTO bkmoperror_code VALUES('T','102','0014','001','Erreur technique lors de la récupération du compte','');
INSERT INTO bkmoperror_code VALUES('T','102','0015','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('T','102','0016','001','La banque saisie est inexistante','');
INSERT INTO bkmoperror_code VALUES('T','102','0017','001','gurdccvisu_controle_saisie','');
INSERT INTO bkmoperror_code VALUES('T','102','0018','001','Le suffixe saisi doit être numérique','');
INSERT INTO bkmoperror_code VALUES('T','102','0019','001','gurdccvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('T','102','0020','001','Aucune donnée sélectionnée','');
INSERT INTO bkmoperror_code VALUES('T','102','0021','001','Erreur lors de la récupération des images chèques','');
INSERT INTO bkmoperror_code VALUES('T','102','0022','001','Erreur technique lors de la récupération du nom du client','');
INSERT INTO bkmoperror_code VALUES('T','102','0023','001','Le client n''''existe pas','');
INSERT INTO bkmoperror_code VALUES('T','102','0024','001','Erreur lors du verrouillage d''''un enregistrement de bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('T','102','0025','001','gurdccvisu_traitement','');
INSERT INTO bkmoperror_code VALUES('T','102','0026','001','gurdccvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('T','102','0027','001','Erreur lors de la mise à jour de la table bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('T','102','0028','001','Erreur lors de la mise à jour de la table bkrdcrv','');
INSERT INTO bkmoperror_code VALUES('T','102','0029','001','La saisie de la banque est obigatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0030','001','La saisie du compte est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0031','001','La saisie de l''''agence est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0032','001','La saisie du suffixe est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0033','001','La saisie du compte est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0034','001','La saisie de la clé du compte est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0035','001','La saisie de la devise est obligatoire','');
INSERT INTO bkmoperror_code VALUES('T','102','0036','001','Paramétrage de la devise nationale incorrect ou inexistant','');
INSERT INTO bkmoperror_code VALUES('T','102','0037','001','gurdccvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('T','102','0038','001','gurdccvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('T','102','0039','001','gurdccvisu_lec_param','');
INSERT INTO bkmoperror_code VALUES('T','102','0040','001','Erreur technique lors de la récupération du compte','');
INSERT INTO bkmoperror_code VALUES('T','102','0041','001','Erreur technique lors de la récupération du compte','');
INSERT INTO bkmoperror_code VALUES('T','102','0042','001','gurdccvisu_traitement','');
INSERT INTO bkmoperror_code VALUES('T','102','0043','001','gurdccvisu_traitement','');
INSERT INTO bkmoperror_code VALUES('T','102','0044','001','L''''agence saisie est incorrecte','');
INSERT INTO bkmoperror_code VALUES('T','102','0045','001','gurdccvisu_controle_saisie','');
INSERT INTO bkmoperror_code VALUES('T','102','0046','001','gurdccvisu_controle_saisie','');
INSERT INTO bkmoperror_code VALUES('T','102','0047','001','Erreur lors du contrôle du compte','');
INSERT INTO bkmoperror_code VALUES('T','102','0048','001','Le montant saisi doit être numérique','');
INSERT INTO bkmoperror_code VALUES('T','102','0049','001','La banque saisie est inexistante','');
INSERT INTO bkmoperror_code VALUES('T','102','0050','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('T','102','0051','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('T','102','0052','001','Erreur technique lors de la récupération de la banque','');
INSERT INTO bkmoperror_code VALUES('T','102','0053','001','Erreur lors du verrouillage d''''un enregistrement de bkdetchqd','');
INSERT INTO bkmoperror_code VALUES('T','102','0054','001','gurdccvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('T','102','0055','001','gurdccvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('T','102','0056','001','gurdccvisu_maj_val','');
INSERT INTO bkmoperror_code VALUES('F','103','0001','001','Impossible de determiner le code opération de l''événement de creation de reservation de fonds','');
INSERT INTO bkmoperror_code VALUES('F','103','0002','001','Code opération mal paramétré pour RESERV','');
INSERT INTO bkmoperror_code VALUES('F','103','0003','001','Compte de la reservation inconnu','');
INSERT INTO bkmoperror_code VALUES('F','103','0004','001','Impossible de calculer le numéro d''événement d''une réservation de fonds','');
INSERT INTO bkmoperror_code VALUES('F','103','0005','001','Erreur lors de l''alimentation de la table bkidenreserv','');
INSERT INTO bkmoperror_code VALUES('F','103','0006','001','Code opération mal paramétré pour RESCRE','');
INSERT INTO bkmoperror_code VALUES('F','103','0007','001','Impossible de determiner le code opération de l''événement de creation de reservation de fonds','');
INSERT INTO bkmoperror_code VALUES('F','103','0008','001','Impossible de calculer le numéro d''événement d''une réservation de fonds','');
INSERT INTO bkmoperror_code VALUES('F','103','0009','001','Compte de la reservation inconnu','');
INSERT INTO bkmoperror_code VALUES('F','104','0001','001','Catégorie inexistante.','');
INSERT INTO bkmoperror_code VALUES('F','104','0002','001','La banque du bénéficiaire doit être au format BIC et l''agence renseignée.','');
INSERT INTO bkmoperror_code VALUES('F','104','0003','001','Le compte du bénéficiaire doit être au format BBAN.','');
INSERT INTO bkmoperror_code VALUES('F','104','0004','001','Le BIC de la banque bénéficiaire n''est pas membre à EBC.','');
INSERT INTO bkmoperror_code VALUES('F','104','0005','001','Incident SQL.','');
INSERT INTO bkmoperror_code VALUES('F','104','0006','001','Le BIC / agence de la banque bénéficiaire n''est pas membre à EBC.','');
INSERT INTO bkmoperror_code VALUES('F','104','0007','001','Instruction pour le créditeur inexistante.','');
INSERT INTO bkmoperror_code VALUES('F','104','0008','001','Le nombre de motif structuré et le nombre de motif non structuré sont différent de 0.','');
INSERT INTO bkmoperror_code VALUES('F','104','0009','001','Le nombre de motif non structuré est strictement supérieur à 1.','');
INSERT INTO bkmoperror_code VALUES('F','104','0010','001','Le nombre de motif structuré est strictement supérieur à 1.','');
INSERT INTO bkmoperror_code VALUES('F','104','0011','001','La longueur des informations sur la transaction est supérieur à 140 caractères.','');
INSERT INTO bkmoperror_code VALUES('F','104','0012','001','Les frais peuvent uniquement être partagés ou selon le servie level.','');
INSERT INTO bkmoperror_code VALUES('F','104','0013','001','Virement uniquement.','');
INSERT INTO bkmoperror_code VALUES('F','104','0014','001','Objet inexistant.','');
--Langue : 002
INSERT INTO bkmoperror_code VALUES('T','001','0001','002','Wrong database type. It must either be PROD, or PRE-PROD, or HOMOLOGATION.','Correct the settings of parameter "TYPE_BASE" in table of codes "098".');
INSERT INTO bkmoperror_code VALUES('T','001','0002','002','Parameter not set properly.','The parameter mentioned in the error message is not properly set. Correct the settings of the parameter using parameter management program "cbitfparam".');
INSERT INTO bkmoperror_code VALUES('T','001','0003','002','Missing parameter.','The mentioned parameter is not set, which implies that the coding system of parameters might not be up-to-date. Contact the Delta-Bank Support.');
INSERT INTO bkmoperror_code VALUES('T','001','0004','002','Problem while setting interfaces.','');
INSERT INTO bkmoperror_code VALUES('T','001','0005','002','Problem while processing interfaces.','');
INSERT INTO bkmoperror_code VALUES('T','001','0006','002','Problem while closing the interface.','');
INSERT INTO bkmoperror_code VALUES('T','001','0007','002','Error code missing from coding system!','The coding system of error codes (tables "bkmoperror_cat" and "bkmoperror_code") is not up-to-date. Contact the Delta-Bank Support.');
INSERT INTO bkmoperror_code VALUES('T','001','0008','002','Temporary work folder not found.','');
INSERT INTO bkmoperror_code VALUES('T','001','0009','002','Default accounting of transfers not set','');
INSERT INTO bkmoperror_code VALUES('T','001','0010','002','Default accounting of debits not set','');
INSERT INTO bkmoperror_code VALUES('T','001','0011','002','Incorrect BIC code in the central site bank definition','Modify the central site bank definition');
INSERT INTO bkmoperror_code VALUES('T','001','0012','002','Local IBAN size not set properly','');
INSERT INTO bkmoperror_code VALUES('T','002','0001','002','XSD validation failed.','Verify the stream, verify the XSD.');
INSERT INTO bkmoperror_code VALUES('T','003','0001','002','Simulation stream integrated into a production database.','');
INSERT INTO bkmoperror_code VALUES('T','003','0002','002','Production stream integrated into a test database (pre-prod or homologation).','');
INSERT INTO bkmoperror_code VALUES('T','003','0003','002','Pre-production stream integrated into a homologation database.','');
INSERT INTO bkmoperror_code VALUES('T','003','0004','002','Homologation stream integrated into a pre-production database.','');
INSERT INTO bkmoperror_code VALUES('T','003','0005','002','Pre-production stream integrated into a production database.','');
INSERT INTO bkmoperror_code VALUES('T','003','0006','002','Homologation stream integrated into a production database.','');
INSERT INTO bkmoperror_code VALUES('T','003','0007','002','Receipt of a stream generated by the Delta-Bank simulator of the payment order initiation service, on an environment that is not a test environment.','Verify the environment and routing of streams; if stream routing is correct and if the environment is a test environment, then set the environment variable TEST_CONNECTOR to 1.');
INSERT INTO bkmoperror_code VALUES('T','003','0008','002','Stream identifier not specified.','');
INSERT INTO bkmoperror_code VALUES('T','004','0001','002','Impossible to calculate the stream MD5 key.','');
INSERT INTO bkmoperror_code VALUES('T','004','0002','002','MD5 key duplicated: potential stream duplication.','');
INSERT INTO bkmoperror_code VALUES('T','004','0003','002','Transaction potentially duplicated.','');
INSERT INTO bkmoperror_code VALUES('T','004','0004','002','All transactions in the batch in error.','');
INSERT INTO bkmoperror_code VALUES('T','005','0001','002','ISO rule ''PaymentTypeInformationRule'' not respected.','The payment type must be indicated either in total, or unitarily per loan, or it must be absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0002','002','ISO rule ''ChequeInstructionRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0003','002','ISO rule ''ChargesAccountRule'' not respected.','The expense account is missing or the charges institution must be absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0004','002','ISO rule ''ChargesAccountAgentRule'' not respected.','The charges institution branch does not match a branch of the ordering customer.s institution.');
INSERT INTO bkmoperror_code VALUES('T','005','0005','002','ISO rule ''ChargeBearerRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0006','002','ISO rule ''UltimateDebtorRule'' not respected.','The ultimate debtor must be indicated either in total, or unitarily per loan, or it must be absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0007','002','ISO rule ''ChequeAndCreditorAccountRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0008','002','ISO rule ''ChequeDeliveryAndCreditorAgentRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0009','002','ISO rule ''ChequeDeliveryAndNoCreditorAgentRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0010','002','ISO rule ''NonChequePaymentMethodRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0011','002','ISO rule ''ChequeNoDeliveryAndNoCreditorAgentRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0012','002','ISO rule ''IntermediaryAgent2Rule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0013','002','ISO rule ''IntermediaryAgent3Rule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0014','002','ISO rule ''InstructionForCreditorAgentRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0015','002','ISO rule ''IntermediaryAgent1AccountRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0016','002','ISO rule ''IntermediaryAgent2AccountRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0017','002','ISO rule ''IntermediaryAgent3AccountRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0018','002','ISO rule ''ChequeMaturityDateRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0019','002','ISO rule ''CreditorSchemeIdentificationRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0020','002','ISO rule ''UltimateCreditorRule'' not respected.','The ultimate creditor must be indicated either in total, or unitarily per loan, or it must be absent.');
INSERT INTO bkmoperror_code VALUES('T','005','0021','002','ISO rule ''AmendmentIndicatorTrueRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0022','002','ISO rule ''AmendmentIndicatorFalseRule'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0023','002','ISO rule ''PaymentInformationStatus'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0024','002','ISO rule ''AccountServicerReference'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0025','002','ISO rule ''UltimateDebtor'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0026','002','ISO rule ''Debtor'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0027','002','ISO rule ''DebtorAccount'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0028','002','ISO rule ''DebtorAgent'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0029','002','ISO rule ''DebtorAgentAccount'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0030','002','ISO rule ''CreditorAgent'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0031','002','ISO rule ''CreditorAgentAccount'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0032','002','ISO rule ''Creditor'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0033','002','ISO rule ''CreditorAccount'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','005','0034','002','ISO rule ''UltimateCreditor'' not respected.','');
INSERT INTO bkmoperror_code VALUES('T','006','0001','002','The channel is not active.','');
INSERT INTO bkmoperror_code VALUES('T','006','0002','002','The channel specified in the stream does not match the current channel.','');
INSERT INTO bkmoperror_code VALUES('T','006','0003','002','The channel does not receive any transfer.','');
INSERT INTO bkmoperror_code VALUES('T','006','0004','002','The channel does not receive any direct debit.','');
INSERT INTO bkmoperror_code VALUES('T','006','0005','002','Several channels for this interface.','');
INSERT INTO bkmoperror_code VALUES('T','007','0001','002','Impossible to read the stream.','');
INSERT INTO bkmoperror_code VALUES('T','007','0002','002','Invalid stream.','');
INSERT INTO bkmoperror_code VALUES('T','007','0003','002','There are some private data in duplicate in the stream.','');
INSERT INTO bkmoperror_code VALUES('T','008','0001','002','Ordering customer.s account not found.','');
INSERT INTO bkmoperror_code VALUES('T','008','0002','002','Ordering customer.s expense account not found.','');
INSERT INTO bkmoperror_code VALUES('T','008','0003','002','Transaction account not found.','');
INSERT INTO bkmoperror_code VALUES('T','008','0004','002','The expense account is not held by the ordering customer.','');
INSERT INTO bkmoperror_code VALUES('T','008','0005','002','The expense account is not held by the bank.','');
INSERT INTO bkmoperror_code VALUES('T','008','0006','002','At least one account (order or transaction level) must be in the transaction currency','');
INSERT INTO bkmoperror_code VALUES('T','008','0007','002','Ordering customer account . wrong format','');
INSERT INTO bkmoperror_code VALUES('T','008','0008','002','Charges account . wrong format','');
INSERT INTO bkmoperror_code VALUES('T','008','0009','002','Transaction account . wrong format','');
INSERT INTO bkmoperror_code VALUES('F','008','0010','002','The BIC code of the transaction is unknown','');
INSERT INTO bkmoperror_code VALUES('T','008','0011','002','Account not in favour of the TGR','');
INSERT INTO bkmoperror_code VALUES('T','009','0001','002','Transaction amount equals .0..','');
INSERT INTO bkmoperror_code VALUES('T','009','0002','002','Transaction amount is negative.','');
INSERT INTO bkmoperror_code VALUES('T','009','0003','002','Wrong SICA transfer code','');
INSERT INTO bkmoperror_code VALUES('T','009','0004','002','Economic code must be unique in the transaction','');
INSERT INTO bkmoperror_code VALUES('T','009','0005','002','At least one of the local references is wrong','');
INSERT INTO bkmoperror_code VALUES('T','009','0006','002','Wrong reference of notice of tax assessment','');
INSERT INTO bkmoperror_code VALUES('T','010','0001','002','Error in the event number.','');
INSERT INTO bkmoperror_code VALUES('T','010','0002','002','Error reading the beneficiary.s bank.','');
INSERT INTO bkmoperror_code VALUES('T','010','0003','002','Incident .insert bkeve.','');
INSERT INTO bkmoperror_code VALUES('T','010','0004','002','Unknown transaction currency.','');
INSERT INTO bkmoperror_code VALUES('T','010','0005','002','The local transfer type does not manage any multiple processing.','');
INSERT INTO bkmoperror_code VALUES('T','010','0006','002','The local transfer type does not manage any unit processing.','');
INSERT INTO bkmoperror_code VALUES('T','010','0007','002','Unknown local transfer type.','');
INSERT INTO bkmoperror_code VALUES('T','010','0008','002','Ordering customer.s account not found.','');
INSERT INTO bkmoperror_code VALUES('T','010','0009','002','Expense account not found.','');
INSERT INTO bkmoperror_code VALUES('T','010','0010','002','Beneficiary.s account not found.','');
INSERT INTO bkmoperror_code VALUES('T','010','0011','002','Economic code not found in the transaction.','');
INSERT INTO bkmoperror_code VALUES('T','010','0012','002','Economic code doesn''t match.','');
INSERT INTO bkmoperror_code VALUES('T','011','0001','002','Unknown transaction currency.','');
INSERT INTO bkmoperror_code VALUES('T','012','0001','002','Error while selecting the message.','');
INSERT INTO bkmoperror_code VALUES('T','012','0002','002','Error while selecting the batch.','');
INSERT INTO bkmoperror_code VALUES('T','012','0003','002','Error while selecting the transaction.','');
INSERT INTO bkmoperror_code VALUES('T','012','0004','002','Error while selecting the environment for the channel.','');
INSERT INTO bkmoperror_code VALUES('T','012','0005','002','Incident .insert bkmopbatch_rep.eta.','');
INSERT INTO bkmoperror_code VALUES('T','012','0006','002','Incident .insert bkmoptx_rep.eta.','');
INSERT INTO bkmoperror_code VALUES('T','012','0007','002','Incident .update bkmopmsg_rep.','');
INSERT INTO bkmoperror_code VALUES('T','012','0008','002','Incident .update bkmopbatch_rep.','');
INSERT INTO bkmoperror_code VALUES('T','012','0009','002','Incident .update bkmoptx_rep.','');
INSERT INTO bkmoperror_code VALUES('T','013','0001','002','Error integrating the message.','');
INSERT INTO bkmoperror_code VALUES('T','013','0002','002','Error integrating the batch.','');
INSERT INTO bkmoperror_code VALUES('T','013','0003','002','Error integrating the transaction.','');
INSERT INTO bkmoperror_code VALUES('T','013','0004','002','Error while loading bkmopmsg_md5','');
INSERT INTO bkmoperror_code VALUES('T','013','0005','002','Error while loading bkmoptx_md5','');
INSERT INTO bkmoperror_code VALUES('T','013','0006','002','Impossible to insert a response.','');
INSERT INTO bkmoperror_code VALUES('T','013','0007','002','Value not allowed in private data PtcInf_Sgt','The flow is rejected');
INSERT INTO bkmoperror_code VALUES('T','013','0008','002','EU is not a value allowed for item FlwInd','The flow is rejected');
INSERT INTO bkmoperror_code VALUES('T','013','0009','002','Error during the selection of the message status','');
INSERT INTO bkmoperror_code VALUES('T','013','0010','002','HU is not a value allowed for item FlwInd','The flow is rejected');
INSERT INTO bkmoperror_code VALUES('T','013','0011','002','Error during the selection of the economic code','');
INSERT INTO bkmoperror_code VALUES('T','013','0012','002','Error during the selection of the private data''s code of PSR','');
INSERT INTO bkmoperror_code VALUES('T','013','0013','002','Error while selecting the operation type','');
INSERT INTO bkmoperror_code VALUES('T','013','0014','002','Error while inserting bkmoplot_rev','');
INSERT INTO bkmoperror_code VALUES('T','013','0015','002','Error counting the structured or non-structured reasons','');
INSERT INTO bkmoperror_code VALUES('F','014','0001','002','Unknown local transfer currency.','');
INSERT INTO bkmoperror_code VALUES('F','014','0002','002','Local transfer type not allowed.','');
INSERT INTO bkmoperror_code VALUES('F','014','0003','002','Unknown local transfer type.','');
INSERT INTO bkmoperror_code VALUES('F','014','0004','002','Unknown processing branch.','');
INSERT INTO bkmoperror_code VALUES('F','014','0005','002','Error while loading account classes.','');
INSERT INTO bkmoperror_code VALUES('F','014','0006','002','Ordering customer.s account not found.','');
INSERT INTO bkmoperror_code VALUES('F','014','0007','002','Expense account not found.','');
INSERT INTO bkmoperror_code VALUES('F','014','0008','002','Beneficiary.s account not found.','');
INSERT INTO bkmoperror_code VALUES('F','014','0009','002','Account class of the ordering customer.s account not allowed for the operation.','');
INSERT INTO bkmoperror_code VALUES('F','014','0010','002','Account class of the beneficiary.s account not allowed for the operation.','');
INSERT INTO bkmoperror_code VALUES('F','014','0011','002','Event number not found.','');
INSERT INTO bkmoperror_code VALUES('F','014','0012','002','Unknown beneficiary bank.','');
INSERT INTO bkmoperror_code VALUES('F','014','0013','002','Incident during insertion.','');
INSERT INTO bkmoperror_code VALUES('F','014','0014','002','Local transfer type not set properly.','');
INSERT INTO bkmoperror_code VALUES('F','014','0015','002','Zero amount on the debit side forbidden','');
INSERT INTO bkmoperror_code VALUES('F','014','0016','002','Impossible to modify the ''VIRMUL''','');
INSERT INTO bkmoperror_code VALUES('F','014','0017','002','Impossible to modify events linked to the ''VIRMUL''','');
INSERT INTO bkmoperror_code VALUES('F','015','0001','002','Unknown local transfer currency.','');
INSERT INTO bkmoperror_code VALUES('F','015','0002','002','Ordering customer.s account not found.','');
INSERT INTO bkmoperror_code VALUES('F','015','0003','002','Expense account not found.','');
INSERT INTO bkmoperror_code VALUES('F','015','0004','002','Beneficiary.s account not found.','');
INSERT INTO bkmoperror_code VALUES('F','015','0005','002','Account class of the ordering customer.s account not allowed for the operation.','');
INSERT INTO bkmoperror_code VALUES('F','015','0006','002','Account class of the beneficiary.s account not allowed for the operation.','');
INSERT INTO bkmoperror_code VALUES('F','015','0007','002','Event number not found.','');
INSERT INTO bkmoperror_code VALUES('F','015','0008','002','Incident during insertion.','');
INSERT INTO bkmoperror_code VALUES('F','015','0009','002','Local transfer type not set properly.','');
INSERT INTO bkmoperror_code VALUES('T','015','0010','002','Parameter not set properly.','');
INSERT INTO bkmoperror_code VALUES('T','015','0011','002','Unknown organisation.','');
INSERT INTO bkmoperror_code VALUES('T','015','0012','002','The creditor.s account does not match the organisation account set.','');
INSERT INTO bkmoperror_code VALUES('T','015','0013','002','No operation code linked to PRLAUT (Between bracket are indicated the empty fields that can be the origine of the error)','');
INSERT INTO bkmoperror_code VALUES('T','015','0014','002','PRLAUT not allowed','');
INSERT INTO bkmoperror_code VALUES('F','015','0015','002','Zero amount on the debit side forbidden','');
INSERT INTO bkmoperror_code VALUES('F','015','0016','002','Zero amount on the credit side forbidden','');
INSERT INTO bkmoperror_code VALUES('F','016','0001','002','Unknown local transfer currency.','');
INSERT INTO bkmoperror_code VALUES('F','016','0002','002','Ordering customer.s account not found.','');
INSERT INTO bkmoperror_code VALUES('F','016','0003','002','Expense account not found.','');
INSERT INTO bkmoperror_code VALUES('F','016','0004','002','Account class of the ordering customer.s account not allowed for the operation.','');
INSERT INTO bkmoperror_code VALUES('F','016','0005','002','Event number not found.','');
INSERT INTO bkmoperror_code VALUES('F','016','0006','002','Incident during insertion.','');
INSERT INTO bkmoperror_code VALUES('F','016','0007','002','Incident during bank selection.','');
INSERT INTO bkmoperror_code VALUES('F','016','0008','002','Local transfer type not set properly.','');
INSERT INTO bkmoperror_code VALUES('T','016','0009','002','Parameter not set properly.','');
INSERT INTO bkmoperror_code VALUES('T','016','0010','002','Unknown organisation.','');
INSERT INTO bkmoperror_code VALUES('T','016','0011','002','The creditor.s account does not match the organisation account set.','');
INSERT INTO bkmoperror_code VALUES('T','016','0012','002','No operation code linked to PRLABQ (Between bracket are indicated the empty fields that can be the origine of the error)','');
INSERT INTO bkmoperror_code VALUES('T','016','0013','002','PRLABQ not allowed','');
INSERT INTO bkmoperror_code VALUES('F','016','0014','002','Zero amount on the credit side forbidden','');
INSERT INTO bkmoperror_code VALUES('F','017','0001','002','Wrong correspondent.','');
INSERT INTO bkmoperror_code VALUES('F','017','0002','002','Unknown international transfer currency.','');
INSERT INTO bkmoperror_code VALUES('F','017','0003','002','International transfer operation code not found.','');
INSERT INTO bkmoperror_code VALUES('F','017','0004','002','Ordering customer.s account currency not found.','');
INSERT INTO bkmoperror_code VALUES('F','017','0005','002','Expense account currency not found.','');
INSERT INTO bkmoperror_code VALUES('F','017','0006','002','Incident with the expense account.','');
INSERT INTO bkmoperror_code VALUES('F','017','0007','002','Wrong transit account configuration.','');
INSERT INTO bkmoperror_code VALUES('F','017','0008','002','Wrong transit account.','');
INSERT INTO bkmoperror_code VALUES('F','017','0009','002','Wrong transit account configuration . charges.','');
INSERT INTO bkmoperror_code VALUES('F','017','0010','002','Wrong transit account . charges.','');
INSERT INTO bkmoperror_code VALUES('F','017','0011','002','Unknown international transfer type.','');
INSERT INTO bkmoperror_code VALUES('F','017','0012','002','Wrong external customer.s bank account.','');
INSERT INTO bkmoperror_code VALUES('F','017','0013','002','Register not found.','');
INSERT INTO bkmoperror_code VALUES('F','017','0014','002','Wrong external customer.s bank account . multiple international transfer.','');
INSERT INTO bkmoperror_code VALUES('F','017','0015','002','Nature .ORDMIX. not set.','');
INSERT INTO bkmoperror_code VALUES('F','017','0016','002','Mixed order operation code not found.','');
INSERT INTO bkmoperror_code VALUES('F','017','0017','002','Correspondant not in account relationship','');
INSERT INTO bkmoperror_code VALUES('F','017','0018','002','Beneficiary''s BIC and IBAN are inconsistent','');
INSERT INTO bkmoperror_code VALUES('F','017','0019','002','Unknown correspondent','');
INSERT INTO bkmoperror_code VALUES('F','017','0020','002','Wrong ordering customer information','');
INSERT INTO bkmoperror_code VALUES('F','017','0021','002','Problem generating multiple transfers','');
INSERT INTO bkmoperror_code VALUES('F','017','0022','002','Problem generating the mixed event','');
INSERT INTO bkmoperror_code VALUES('T','018','0001','002','Program already launched.','');
INSERT INTO bkmoperror_code VALUES('T','018','0002','002','Processing program crash','');
INSERT INTO bkmoperror_code VALUES('T','018','0003','002','Errors found during the generation of the PSR.','');
INSERT INTO bkmoperror_code VALUES('F','019','0001','002','Batch valid, change of status to .NC..','');
INSERT INTO bkmoperror_code VALUES('F','019','0002','002','Transaction valid, change of status to .NC..','');
INSERT INTO bkmoperror_code VALUES('F','019','0003','002','The stream''s version is incorrect.','');
INSERT INTO bkmoperror_code VALUES('F','019','0004','002','The PSR''s version is incorrect.','');
INSERT INTO bkmoperror_code VALUES('F','019','0005','002','The message''s origin is incorrect','');
INSERT INTO bkmoperror_code VALUES('T','020','0001','002','The total sum of transactions does not match the batch amount.','');
INSERT INTO bkmoperror_code VALUES('T','020','0002','002','The number of transactions does not match that set at batch level.','');
INSERT INTO bkmoperror_code VALUES('T','020','0003','002','Transactions are not all in the same currency.','');
INSERT INTO bkmoperror_code VALUES('T','020','0004','002','The creditor.s account does not match the organisation account set.','');
INSERT INTO bkmoperror_code VALUES('T','021','0001','002','Coherence between the service determine and the received service','');
INSERT INTO bkmoperror_code VALUES('F','021','0002','002','Beneficiary bank not linked to SEPA','');
INSERT INTO bkmoperror_code VALUES('F','022','0001','002','Category not found','');
INSERT INTO bkmoperror_code VALUES('F','022','0002','002','The beneficiary.s bank must be in BIC format','');
INSERT INTO bkmoperror_code VALUES('F','022','0003','002','The beneficiary.s account must be in IBAN format','');
INSERT INTO bkmoperror_code VALUES('F','022','0004','002','Inconsistency between the BIC and IBAN of the beneficiary','');
INSERT INTO bkmoperror_code VALUES('F','022','0005','002','SQL incident','');
INSERT INTO bkmoperror_code VALUES('F','022','0006','002','The inconsistency check between BIC and IBAN is not set for parameter .SEPA.','');
INSERT INTO bkmoperror_code VALUES('F','022','0007','002','Parameter .SEPA. not found','');
INSERT INTO bkmoperror_code VALUES('F','022','0008','002','The number of structured reasons and the number of non-structured reasons are different from 0','');
INSERT INTO bkmoperror_code VALUES('F','022','0009','002','The number of non-structured reasons is strictly above 1','');
INSERT INTO bkmoperror_code VALUES('F','022','0010','002','The number of structured reasons is strictly above 1','');
INSERT INTO bkmoperror_code VALUES('F','022','0011','002','The size of transaction details exceeds 140 characters','');
INSERT INTO bkmoperror_code VALUES('F','022','0012','002','Charges can only be shared or according to the service level','');
INSERT INTO bkmoperror_code VALUES('F','022','0013','002','Local transfer only','');
INSERT INTO bkmoperror_code VALUES('F','023','0001','002','The input stream version is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','023','0002','002','Unknown input stream: bkmopmsg.typmsg','');
INSERT INTO bkmoperror_code VALUES('F','024','0001','002','Error when reading the debug mode at the channel level','Contact the hotline');
INSERT INTO bkmoperror_code VALUES('F','024','0002','002','PSR generation in progress for the channel','Relaunch the process later');
INSERT INTO bkmoperror_code VALUES('F','024','0003','002','Error when reading the channel','Contact the hotline');
INSERT INTO bkmoperror_code VALUES('F','024','0004','002','Blocking error during PSR processing','Contact the hotline');
INSERT INTO bkmoperror_code VALUES('F','024','0005','002','Blocking error during PSR generation','Contact the hotline');
INSERT INTO bkmoperror_code VALUES('F','024','0006','002','Configuration error on the ABO interface : no authorized PSR/CAMT version','Correct the configuration');
INSERT INTO bkmoperror_code VALUES('F','024','0007','002','Blocking error on the database level','Contact the hotline');
INSERT INTO bkmoperror_code VALUES('F','027','0001','002','Error while recording a batch-level status in the display module .ABO.','');
INSERT INTO bkmoperror_code VALUES('F','027','0002','002','Error while recording a transaction-level status in the display module .ABO.','');
INSERT INTO bkmoperror_code VALUES('F','027','0003','002','The service is not activated','');
INSERT INTO bkmoperror_code VALUES('F','027','0004','002','Cannot identify the bank''s BIC code','');
INSERT INTO bkmoperror_code VALUES('F','027','0005','002','Missing type of transfer in channel definition (gumopcanal) for a service','Correct the channel definition');
INSERT INTO bkmoperror_code VALUES('F','028','0001','002','Error while reading the customer','');
INSERT INTO bkmoperror_code VALUES('F','029','0001','002','A disapproval is not set in table of codes .058.','');
INSERT INTO bkmoperror_code VALUES('F','029','0002','002','Parameter LTRF_RFND_OPE not set properly','');
INSERT INTO bkmoperror_code VALUES('F','029','0003','002','Impossible to calculate the event number for the reservation of funds','');
INSERT INTO bkmoperror_code VALUES('F','029','0004','002','Error while creating a reservation of funds','');
INSERT INTO bkmoperror_code VALUES('F','029','0005','002','Parameter TIME_WAIT not set properly','');
INSERT INTO bkmoperror_code VALUES('F','029','0006','002','Error while creating payment codes','');
INSERT INTO bkmoperror_code VALUES('F','029','0007','002','The transaction account is missing','');
INSERT INTO bkmoperror_code VALUES('F','029','0008','002','Impossible to work out the accounting','');
INSERT INTO bkmoperror_code VALUES('F','029','0009','002','Impossible to find the channel','');
INSERT INTO bkmoperror_code VALUES('F','029','0010','002','Impossible to find the message','');
INSERT INTO bkmoperror_code VALUES('F','029','0011','002','The transaction BIC is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0012','002','All transactions from the batch are in error','');
INSERT INTO bkmoperror_code VALUES('F','029','0013','002','At least one of the transactions from the batch is in error','');
INSERT INTO bkmoperror_code VALUES('F','029','0014','002','Impossible to work out the operation for a PRLAUT','');
INSERT INTO bkmoperror_code VALUES('F','029','0015','002','Impossible to work out the operation for a PRLABQ','');
INSERT INTO bkmoperror_code VALUES('F','029','0016','002','Impossible to work out the event number for a PRLAUT','');
INSERT INTO bkmoperror_code VALUES('F','029','0017','002','Impossible to work out the event number for a PRLABQ','');
INSERT INTO bkmoperror_code VALUES('F','029','0018','002','Impossible to work out the collection method','');
INSERT INTO bkmoperror_code VALUES('F','029','0019','002','Impossible to work out the clearing branch for direct debits','');
INSERT INTO bkmoperror_code VALUES('F','029','0020','002','Wrong local reference(s):','');
INSERT INTO bkmoperror_code VALUES('F','029','0021','002','Error while searching for the original transaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0022','002','Error while searching for the original transaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0023','002','Error while searching for the original transaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0024','002','Error while searching for the original transaction','');
INSERT INTO bkmoperror_code VALUES('F','029','0025','002','Configuration error','');
INSERT INTO bkmoperror_code VALUES('F','029','0026','002','Error in the payment date','');
INSERT INTO bkmoperror_code VALUES('F','029','0027','002','Error in the blocking of records','');
INSERT INTO bkmoperror_code VALUES('F','029','0028','002','Error in the blocking of records','');
INSERT INTO bkmoperror_code VALUES('F','029','0029','002','Error in the generation of the cancellation event','');
INSERT INTO bkmoperror_code VALUES('F','029','0030','002','Error in the generation of the cancellation event','');
INSERT INTO bkmoperror_code VALUES('F','029','0031','002','Error in the generation of the cancellation event','');
INSERT INTO bkmoperror_code VALUES('F','029','0032','002','Error in the generation of the direct debit receipt event','');
INSERT INTO bkmoperror_code VALUES('F','029','0033','002','Error in the generation of the direct debit receipt event','');
INSERT INTO bkmoperror_code VALUES('F','029','0034','002','Amount of the incorrect order','');
INSERT INTO bkmoperror_code VALUES('F','029','0035','002','Our branch account is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0036','002','Other bank account (RIB_FR) is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0037','002','Other bank account (RIB_SICA) is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0038','002','NBS account is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0039','002','Cannot find the coding system of the NBS account country','');
INSERT INTO bkmoperror_code VALUES('F','029','0040','002','Invalid IBAN account','');
INSERT INTO bkmoperror_code VALUES('F','029','0041','002','IBAN account is inconsistent with the BIC code','');
INSERT INTO bkmoperror_code VALUES('F','029','0042','002','Other bank account (RIB_MA) is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','029','0043','002','Institution not specified','');
INSERT INTO bkmoperror_code VALUES('F','029','0044','002','Ordering customer?s institution is different from the bank?s','');
INSERT INTO bkmoperror_code VALUES('F','029','0045','002','Ordering customer?s BIC is different from the bank?s','');
INSERT INTO bkmoperror_code VALUES('F','029','0046','002','Error in the TGR transfer','');
INSERT INTO bkmoperror_code VALUES('F','029','0047','002','Error while inserting a VIRMUL','');
INSERT INTO bkmoperror_code VALUES('F','029','0048','002','Error while updating a VIMxxx','');
INSERT INTO bkmoperror_code VALUES('F','029','0049','002','Error while setting a disapproval on a transaction for a batch in cumulative accounting','');
INSERT INTO bkmoperror_code VALUES('F','029','0053','002','Beneficiary''s named not defined','');
INSERT INTO bkmoperror_code VALUES('F','029','0054','002','Reason not defined','');
INSERT INTO bkmoperror_code VALUES('F','029','0077','002','No organization in the stream','');
INSERT INTO bkmoperror_code VALUES('F','029','0082','002','Format of the Amplitude funds reservation is incorrect','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0083','002','Format of the Amplitude funds reservation is incorrect','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0084','002','Anomaly during cancellation of the funds reservation (from external reference)','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0085','002','Anomaly during cancellation of the funds reservation (from Amplitude reference)','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0086','002','Anomaly during the verification of the funds reservation (from Amplitude reference)','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0087','002','Anomaly during the verification of the funds reservation (from external reference)','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0088','002','Inconsistency between external and Amplitude reference of a funds reservation','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0089','002','Invalid funds reservation','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0090','002','Inconsystency of the debtor account between funds reservation and order received by SIOP','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0091','002','Inconsystency of the debtor account between funds reservation and order received by SIOP','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0092','002','Currency not defined','Out of Amplitude scope, order rejected');
INSERT INTO bkmoperror_code VALUES('F','029','0093','002','Anomaly during reading the customer profile','Contact the hotline');
INSERT INTO bkmoperror_code VALUES('F','029','0094','002','PLAT disapproval is not configured in table of code ''058''','Check the configuration');
INSERT INTO bkmoperror_code VALUES('F','029','0095','002','PMIN disapproval is not configured in table of code ''058''','');
INSERT INTO bkmoperror_code VALUES('F','032','0076','002','Incident while updating the table bkmoptx_rep','');
INSERT INTO bkmoperror_code VALUES('F','033','0001','002','Subsidiary''s BIC badly configured on the bank data sheet of the central site','Fix the configuration of the bank data sheet of the central site via cbgesban');
INSERT INTO bkmoperror_code VALUES('F','034','0001','002','Condition DVACAI does not exist','');
INSERT INTO bkmoperror_code VALUES('F','034','0002','002','Condition DVAAGE does not exist','');
INSERT INTO bkmoperror_code VALUES('F','034','0003','002','Condition DINCAI does not exist','');
INSERT INTO bkmoperror_code VALUES('F','034','0004','002','Condition DINAGE does not exist','');
INSERT INTO bkmoperror_code VALUES('F','034','0005','002','Condition DATVAL does not exist','');
INSERT INTO bkmoperror_code VALUES('F','034','0006','002','Condition EXOCOM does not exist','');
INSERT INTO bkmoperror_code VALUES('F','034','0007','002','Account is incorrect','');
INSERT INTO bkmoperror_code VALUES('F','034','0008','002','Insert into bkeve failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0009','002','Account selection 1 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0010','002','Account selection 2 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0011','002','Account selection 3 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0012','002','Account selection 4 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0013','002','Account selection 5 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0014','002','Account selection 6 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0015','002','Account selection 7 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0016','002','Account selection 8 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0017','002','Account selection 9 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0018','002','Account selection 10 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0019','002','Account selection 11 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0020','002','Account selection 12 failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0021','002','bkicprl selection failed','');
INSERT INTO bkmoperror_code VALUES('F','034','0022','002','bkicprl update failed (UPD4)','');
INSERT INTO bkmoperror_code VALUES('F','034','0023','002','bkicprld update failed (UPD4)','');
INSERT INTO bkmoperror_code VALUES('F','034','0024','002','bkicprl update 1 failed (UPD2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0025','002','bkicprld update 1 failed (UPD2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0026','002','bkicprl update 2 failed (UPD2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0027','002','bkicprld update 2 failed (UPD2)','');
INSERT INTO bkmoperror_code VALUES('F','034','0028','002','Insert into bkicprl failed (UPD1)','');
INSERT INTO bkmoperror_code VALUES('F','034','0029','002','Insert into bkicprld failed (UPD1)','');
INSERT INTO bkmoperror_code VALUES('F','034','0030','002','Currency does not exist','');
INSERT INTO bkmoperror_code VALUES('F','035','0001','002','Condition DATVAL does not exist','');
INSERT INTO bkmoperror_code VALUES('F','035','0002','002','Bank selection 1','');
INSERT INTO bkmoperror_code VALUES('F','035','0003','002','Bank selection 2','');
INSERT INTO bkmoperror_code VALUES('F','035','0004','002','Null value date','');
INSERT INTO bkmoperror_code VALUES('F','035','0005','002','Account not found','');
INSERT INTO bkmoperror_code VALUES('F','035','0006','002','Account selection','');
INSERT INTO bkmoperror_code VALUES('F','035','0007','002','Currency does not exist','');
INSERT INTO bkmoperror_code VALUES('F','039','0001','002','Error in TGR transfer','Please fix it through the business monitors');
INSERT INTO bkmoperror_code VALUES('F','039','0002','002','Error in a pledged transfer','Please fix it through the business monitors');
INSERT INTO bkmoperror_code VALUES('F','039','0003','002','Error while reading a non active channel','Call the hotline');
INSERT INTO bkmoperror_code VALUES('F','039','0008','002','DBMONEY wrong or not set','Set DBMONEY in the profile setting');
INSERT INTO bkmoperror_code VALUES('F','040','0001','002','The type of debit-balance account is wrong','');
INSERT INTO bkmoperror_code VALUES('F','040','0002','002','Wrong direct debit type','');
INSERT INTO bkmoperror_code VALUES('F','040','0003','002','Wrong transaction currency','');
INSERT INTO bkmoperror_code VALUES('F','040','0004','002','Creditor''s identifier not set','');
INSERT INTO bkmoperror_code VALUES('F','040','0005','002','Payment order identifier not set','');
INSERT INTO bkmoperror_code VALUES('F','040','0006','002','Accounting label ENCAISSDD0 not found','');
INSERT INTO bkmoperror_code VALUES('F','040','0007','002','Parameter SEPA-SDD not found','');
INSERT INTO bkmoperror_code VALUES('F','040','0008','002','Wrong payment date','');
INSERT INTO bkmoperror_code VALUES('F','040','0009','002','Clearing branch for SEPA not set properly','');
INSERT INTO bkmoperror_code VALUES('F','040','0010','002','Parameter SEPA not found','');
INSERT INTO bkmoperror_code VALUES('F','040','0011','002','Parameter SEPA2 not found','');
INSERT INTO bkmoperror_code VALUES('F','040','0012','002','Transaction nature PAISDD not found','');
INSERT INTO bkmoperror_code VALUES('F','040','0013','002','Incident while updating the table of SDD stop orders','');
INSERT INTO bkmoperror_code VALUES('F','040','0014','002','A stop order has already been set','');
INSERT INTO bkmoperror_code VALUES('F','040','0015','002','Disapproval set on the account to be credited','');
INSERT INTO bkmoperror_code VALUES('F','040','0016','002','Impossible to retrieve the digital currency of the transaction','');
INSERT INTO bkmoperror_code VALUES('F','040','0017','002','Impossible to identify the customer holding the account to be credited','');
INSERT INTO bkmoperror_code VALUES('F','040','0018','002','Collection account not found','');
INSERT INTO bkmoperror_code VALUES('F','040','0019','002','Error while generating event REASDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0020','002','Error while generating event REISDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0021','002','Error while generating event REPSDD','');
INSERT INTO bkmoperror_code VALUES('F','040','0022','002','Impossible to select the payment order','');
INSERT INTO bkmoperror_code VALUES('F','040','0023','002','Incident while updating the table of payment orders','');
INSERT INTO bkmoperror_code VALUES('F','040','0024','002','Incident while inserting into the table of payment orders','');
INSERT INTO bkmoperror_code VALUES('F','040','0025','002','Incident while selecting the payment order','');
INSERT INTO bkmoperror_code VALUES('F','040','0026','002','Incident while inserting into table bksepacreancier','');
INSERT INTO bkmoperror_code VALUES('F','040','0027','002','Incident while inserting into table bksepacreancier','');
INSERT INTO bkmoperror_code VALUES('F','040','0028','002','Problem while reading parameters','');
INSERT INTO bkmoperror_code VALUES('F','040','0029','002','Problem during checks','');
INSERT INTO bkmoperror_code VALUES('F','040','0030','002','Incident while selecting the creditor','');
INSERT INTO bkmoperror_code VALUES('F','040','0031','002','Incident while inserting into table bksepasdd','');
INSERT INTO bkmoperror_code VALUES('F','040','0032','002','Incident while inserting into table bksepacplsdd','');
INSERT INTO bkmoperror_code VALUES('F','040','0033','002','Incident while inserting the direct debit','');
INSERT INTO bkmoperror_code VALUES('F','042','0001','002','File reference not found','');
INSERT INTO bkmoperror_code VALUES('F','042','0002','002','Operation not found','');
INSERT INTO bkmoperror_code VALUES('F','042','0003','002','Operation not found','');
INSERT INTO bkmoperror_code VALUES('F','042','0004','002','Account holder not found','');
INSERT INTO bkmoperror_code VALUES('F','042','0005','002','Charges calculation failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0006','002','Commission calculation failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0007','002','Management charges calculation failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0008','002','Tax calculation failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0009','002','DATVAL condition not properly set','');
INSERT INTO bkmoperror_code VALUES('F','042','0010','002','Bank unknown','');
INSERT INTO bkmoperror_code VALUES('F','042','0011','002','Account unknown','');
INSERT INTO bkmoperror_code VALUES('F','042','0012','002','Account currency unknown','');
INSERT INTO bkmoperror_code VALUES('F','042','0013','002','Disapproval check failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0014','002','Account unknown','');
INSERT INTO bkmoperror_code VALUES('F','042','0015','002','Complement deletion failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0016','002','Event deletion failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0017','002','''DELETE bksemsta'' failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0018','002','''INSERT bkebcavic'' failed','');
INSERT INTO bkmoperror_code VALUES('F','042','0019','002','Error while inserting complements','');
INSERT INTO bkmoperror_code VALUES('T','047','0001','002','Class of the interface (itfinterf) is unknown','Check the configuration of the PSR issuing interface with the program cbgdispitf');
INSERT INTO bkmoperror_code VALUES('F','104','0001','002','Category not found.','');
INSERT INTO bkmoperror_code VALUES('F','104','0002','002','The beneficiary.s bank must be in BIC format and branch defined.','');
INSERT INTO bkmoperror_code VALUES('F','104','0003','002','The beneficiary.s account must be in BBAN format.','');
INSERT INTO bkmoperror_code VALUES('F','104','0004','002','The beneficiary.s bank BIC isn.t EBC member.','');
INSERT INTO bkmoperror_code VALUES('F','104','0005','002','SQL incident.','');
INSERT INTO bkmoperror_code VALUES('F','104','0006','002','The BIC and branch of beneficiary.s bank isn.t EBC member.','');
INSERT INTO bkmoperror_code VALUES('F','104','0007','002','Instruction for creditor agent','');
INSERT INTO bkmoperror_code VALUES('F','104','0008','002','The number of structured reasons and the number of non-structured reasons are different from 0.','');
INSERT INTO bkmoperror_code VALUES('F','104','0009','002','The number of non-structured reasons is strictly above 1.','');
INSERT INTO bkmoperror_code VALUES('F','104','0010','002','The number of structured reasons is strictly above 1.','');
INSERT INTO bkmoperror_code VALUES('F','104','0011','002','The size of transaction details exceeds 140 characters.','');
INSERT INTO bkmoperror_code VALUES('F','104','0012','002','Charges can only be shared or according to the service level.','');
INSERT INTO bkmoperror_code VALUES('F','104','0013','002','Local transfer only.','');
INSERT INTO bkmoperror_code VALUES('F','104','0014','002','Purpose not found.','');










-- ------------
-- EVOmdp_BGFIFR161011-02_01_STR_ora.sql
-- ------------
--DROP TABLE bkseparf_001;
--DROP TABLE bkseparfd;
--DROP SEQUENCE BKSEPARFD_ID_S;
--DROP SEQUENCE BKSEPARFD_MSGID_S;
--DROP SEQUENCE BKSEPAROUTING_V2_ID_KEY_S;
--DROP SEQUENCE seq_sepafent_idfic;
--DROP SEQUENCE BKSEPARF_001_ID_S;

ALTER TABLE bkseparf ADD CONSTRAINT i0_bkseparf PRIMARY KEY (idfic);

CREATE TABLE bkseparfd
   (
    id_bkseparfd  NUMBER(15,0) CONSTRAINT NL_BKSEPARFD$ID_BKSEPARFD NOT NULL
   ,idfic         CHAR(15)
   ,msgid         CHAR(35)
   ,nbtx          NUMBER
   ,mtot          NUMBER(19,4)
   ,pacs          CHAR(10)
   ,dreg          DATE
   ,cre_date_time VARCHAR2(50)
   );
CREATE UNIQUE INDEX PK_BKSEPARFD ON bkseparfd (id_bkseparfd);
ALTER TABLE bkseparfd ADD CONSTRAINT PK_BKSEPARFD PRIMARY KEY (id_bkseparfd);

CREATE SEQUENCE seq_sepafent_idfic
   INCREMENT BY 1
   START WITH   1
   NOCACHE;

CREATE SEQUENCE BKSEPARFD_ID_S
   INCREMENT BY 1
   START WITH   1
   MINVALUE     1
   MAXVALUE     999999999999999
   CYCLE;

CREATE SEQUENCE BKSEPARFD_MSGID_S
   INCREMENT BY 1
   START WITH   1
   MINVALUE     1
   MAXVALUE     99999999
   CYCLE;

CREATE SEQUENCE BKSEPAROUTING_V2_ID_KEY_S
   INCREMENT BY 1
   START WITH 5000
   MINVALUE  1
   MAXVALUE 999999999999999
   NOCACHE
   CYCLE;

CREATE TABLE bkseparf_001
   (
    id_bkseparfd_001  NUMBER(15,0)  CONSTRAINT NL_BKSEPARF_001$IDBKSEPARF001 NOT NULL
   ,idfic             CHAR(15)      CONSTRAINT NL_BKSEPARF_001$IDFIC NOT NULL
   ,peach             CHAR(10)
   ,cra_status        CHAR(2)       CONSTRAINT CK_BKSEPARF_001$CRA_STATUS CHECK (cra_status IN ('NC', 'AT', 'TR'))
   );
CREATE UNIQUE INDEX PK_BKSEPARF_001 ON bkseparf_001 (id_bkseparfd_001);
ALTER TABLE bkseparf_001 ADD CONSTRAINT PK_BKSEPARF_001 PRIMARY KEY (id_bkseparfd_001);
CREATE INDEX FK_BKSEPARF_001$BKSEPARF ON bkseparf_001 (idfic);
ALTER TABLE bkseparf_001 ADD CONSTRAINT FK_BKSEPARF_001$BKSEPARF FOREIGN KEY (idfic) REFERENCES bkseparf (idfic);

CREATE SEQUENCE BKSEPARF_001_ID_S
   INCREMENT BY 1
   START WITH   1
   MINVALUE     1
   MAXVALUE     999999999999999
   NOCACHE
   CYCLE;

-- ------------
-- DEF_8666_01_STR_ora.sql
-- ------------
-- Renommage de la table bkmopdbtx pour recréation
RENAME bkmopdbtx TO tmp_bkmopdbtx;

-- Recréation de la table bkmopdbtx
CREATE TABLE bkmopdbtx AS
SELECT idtx, idlot, etab, guib, bic, cpte, typcpte, nom, dev, ncp, suf, typtx, mnt, devtx, charge, ref, lib1, lib2, lib3, lib4, lib5, lib6, lib7, lib8, lib9, lib10, purpose_tp, purpose_val, category_tp, category_val, srvlvl_tp, srvlvl_val, mndt_id, mndt_comp, market_info, locality_code
FROM tmp_bkmopdbtx;

-- Suppression des contraintes et index
ALTER TABLE tmp_bkmopdbtx DROP CONSTRAINT fk_bkmopdbtx_1;
ALTER TABLE tmp_bkmopdbtx DROP CONSTRAINT pk_bkmopdbtx CASCADE;
DROP INDEX u1_bkmopdbtx;

-- Recréation de l'index unique et des contraintes pour la table bkmopdbtx et les sous-tables
CREATE UNIQUE INDEX u1_bkmopdbtx ON bkmopdbtx (idtx);
ALTER TABLE bkmopdbtx ADD CONSTRAINT pk_bkmopdbtx PRIMARY KEY (idtx);
ALTER TABLE bkmopdbtx ADD CONSTRAINT fk_bkmopdbtx_1 FOREIGN KEY (idlot) REFERENCES bkmopdblot(idlot);

ALTER TABLE bkmopdbtx_etr ADD CONSTRAINT fk_bkmopdbtx_etr_1 FOREIGN KEY (idtx) REFERENCES bkmopdbtx(idtx);
ALTER TABLE bkmopdbtxrptg ADD CONSTRAINT fk_bkmopdbtxrptg_1 FOREIGN KEY (idtx) REFERENCES bkmopdbtx(idtx);
ALTER TABLE bkmopdbtxstrd ADD CONSTRAINT fk_bkmopdbtxstrd_1 FOREIGN KEY (idtx) REFERENCES bkmopdbtx(idtx);
ALTER TABLE bkmopdbtx_lref ADD CONSTRAINT fk_bkmopdbtx_lref_1 FOREIGN KEY (idtx) REFERENCES bkmopdbtx(idtx);

-- Suppresion de la table temporaire
DROP TABLE tmp_bkmopdbtx;

-- ------------
-- DIM_BCBF180109-01_01_STR_ora.sql
-- ------------
--ANTIDOTE :
    --DROP TABLE bkerrbic;
    --DROP SEQUENCE bkerrbic_id_s;
--Creation de la table des erreurs bkerrbic
CREATE TABLE bkerrbic (
  err_id   NUMBER(15,0)    /*Identifiant unique*/   		CONSTRAINT NL_BKERRBIC$ERR_ID NOT NULL,
  age      CHAR(5)          /*agence*/                      CONSTRAINT NL_BKERRBIC$AGE NOT NULL,
  objet    VARCHAR2(50)      /*Objet (Client/Dossier)*/     	CONSTRAINT NL_BKERRBIC$OBJET NOT NULL,
  erreur   VARCHAR2(100)		/*Description de l'erreur*/		CONSTRAINT NL_BKERRBIC$ERREUR NOT NULL
);

CREATE UNIQUE INDEX PK_BKERRBIC ON bkerrbic(err_id);
ALTER TABLE bkerrbic ADD CONSTRAINT PK_BKERRBIC PRIMARY KEY (err_id);
CREATE SEQUENCE BKERRBIC_ID_S START WITH 1 MAXVALUE 9999999999 CYCLE;


-- ------------
-- DIM_BCBF180109-01_02_MAJ_ora.sql
-- ------------
--Suppression de toutes les valeurs de bkconvbic
TRUNCATE TABLE bkconvbic;

--Insertion des nouvelles valeurs dans bkconvbic
--D01 - Rôle du client
INSERT INTO bkconvbic VALUES('D01','Rôle du client',1,'MainDebtor','Débiteur principal, Principal demandeur');
INSERT INTO bkconvbic VALUES('D01','Rôle du client',2,'CoDebtor','Co-débiteur, Co-demandeur');
INSERT INTO bkconvbic VALUES('D01','Rôle du client',3,'Guarantor','Garant');

--D02 - Classification de la personne
INSERT INTO bkconvbic VALUES('D02','Classification de la personne',0,'NotSpecified','Non Spécifié');
INSERT INTO bkconvbic VALUES('D02','Classification de la personne',1,'Individual','Personne');
INSERT INTO bkconvbic VALUES('D02','Classification de la personne',2,'SoleTrader','Commerçant, entrepreneur');

--D03 - Sexe
INSERT INTO bkconvbic VALUES('D03','Sexe',1,'Male','Homme');
INSERT INTO bkconvbic VALUES('D03','Sexe',2,'Female','Femme');

--D04 Code des pays
INSERT INTO bkconvbic VALUES('D04','Code des pays',1,'AD','ANDORRE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',2,'AE','ÉMIRATS ARABES UNIS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',3,'AF','AFGHANISTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',4,'AG','ANTIGUA-ET-BARBUDA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',5,'AI','ANGUILLA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',6,'AL','ALBANIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',7,'AM','ARMÉNIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',8,'AN','ANTILLES NEERLANDAISES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',9,'AO','ANGOLA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',10,'AQ','ANTARCTIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',11,'AR','ARGENTINE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',12,'AS','SAMOA AMÉRICAINES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',13,'AT','AUTRICHE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',14,'AU','AUSTRALIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',15,'AW','ARUBA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',16,'AZ','AZERBAÏDJAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',17,'BA','BOSNIE-HERZÉGOVINE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',18,'BB','BARBADE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',19,'BD','BANGLADESH');
INSERT INTO bkconvbic VALUES('D04','Code des pays',20,'BE','BELGIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',21,'BF','BURKINA FASO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',22,'BG','BULGARIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',23,'BH','BAHREÏN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',24,'BI','BURUNDI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',25,'BJ','BÉNIN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',26,'BM','BERMUDES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',27,'BN','BRUNEI DARUSSALAM');
INSERT INTO bkconvbic VALUES('D04','Code des pays',28,'BO','BOLIVIE, l`ÉTAT PLURINATIONAL DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',29,'BR','BRÉSIL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',30,'BS','BAHAMAS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',31,'BT','BHOUTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',32,'BV','BOUVET, ÎLE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',33,'BW','BOTSWANA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',34,'BY','BÉLARUS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',35,'BZ','BELIZE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',36,'CA','CANADA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',37,'CC','COCOS (KEELING), ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',38,'CD','CONGO, LA RÉPUBLIQUE DÉMOCRATIQUE DU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',39,'CF','CENTRAFRICAINE, RÉPUBLIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',40,'CG','CONGO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',41,'CI','CÔTE D`IVOIRE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',42,'CK','COOK, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',43,'CL','CHILI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',44,'CM','CAMEROUN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',45,'CN','CHINE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',46,'CO','COLOMBIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',47,'CR','COSTA RICA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',48,'CU','CUBA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',49,'CV','CAP-VERT');
INSERT INTO bkconvbic VALUES('D04','Code des pays',50,'CX','CHRISTMAS, ÎLE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',51,'CY','CHYPRE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',52,'CZ','TCHÈQUE, RÉPUBLIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',53,'DE','ALLEMAGNE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',54,'DJ','DJIBOUTI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',55,'DK','DANEMARK');
INSERT INTO bkconvbic VALUES('D04','Code des pays',56,'DM','DOMINIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',57,'DO','DOMINICAINE, RÉPUBLIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',58,'DZ','ALGÉRIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',59,'EC','ÉQUATEUR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',60,'EE','ESTONIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',61,'EG','ÉGYPTE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',62,'EH','SAHARA OCCIDENTAL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',63,'ER','ÉRYTHRÉE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',64,'ES','ESPAGNE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',65,'ET','ÉTHIOPIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',66,'FI','FINLANDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',67,'FJ','FIDJI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',68,'FK','FALKLAND, ÎLES (MALVINAS)');
INSERT INTO bkconvbic VALUES('D04','Code des pays',69,'FM','MICRONÉSIE, ÉTATS FÉDÉRÉS DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',70,'FO','FÉROÉ, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',71,'FR','FRANCE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',72,'GA','GABON');
INSERT INTO bkconvbic VALUES('D04','Code des pays',73,'GB','ROYAUME-UNI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',74,'GD','GRENADE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',75,'GE','GÉORGIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',76,'GF','GUYANE FRANÇAISE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',77,'GH','GHANA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',78,'GI','GIBRALTAR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',79,'GL','GROENLAND');
INSERT INTO bkconvbic VALUES('D04','Code des pays',80,'GM','GAMBIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',81,'GN','GUINÉE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',82,'GP','GUADELOUPE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',83,'GQ','GUINÉE ÉQUATORIALE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',84,'GR','GRÈCE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',85,'GS','GÉORGIE DU SUD-ET-LES ÎLES SANDWICH DU SUD');
INSERT INTO bkconvbic VALUES('D04','Code des pays',86,'GT','GUATEMALA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',87,'GU','GUAM');
INSERT INTO bkconvbic VALUES('D04','Code des pays',88,'GW','GUINÉE-BISSAU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',89,'GY','GUYANA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',90,'HK','HONG KONG');
INSERT INTO bkconvbic VALUES('D04','Code des pays',91,'HM','HEARD-ET-ÎLES MACDONALD, ÎLE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',92,'HN','HONDURAS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',93,'HR','CROATIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',94,'HT','HAÏTI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',95,'HU','HONGRIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',96,'CH','SUISSE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',97,'ID','INDONÉSIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',98,'IE','IRLANDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',99,'IL','ISRAËL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',100,'IN','INDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',101,'IO','OCÉAN INDIEN, TERRITOIRE BRITANNIQUE DE L`');
INSERT INTO bkconvbic VALUES('D04','Code des pays',102,'IQ','IRAQ');
INSERT INTO bkconvbic VALUES('D04','Code des pays',103,'IR','IRAN, RÉPUBLIQUE ISLAMIQUE D`');
INSERT INTO bkconvbic VALUES('D04','Code des pays',104,'IS','ISLANDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',105,'IT','ITALIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',106,'JM','JAMAÏQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',107,'JO','JORDANIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',108,'JP','JAPON');
INSERT INTO bkconvbic VALUES('D04','Code des pays',109,'KE','KENYA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',110,'KG','KIRGHIZISTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',111,'KH','CAMBODGE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',112,'KI','KIRIBATI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',113,'KM','COMORES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',114,'KN','SAINT-KITTS-ET-NEVIS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',115,'KP','CORÉE, RÉPUBLIQUE POPULAIRE DÉMOCRATIQUE DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',116,'KR','CORÉE, RÉPUBLIQUE DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',117,'KW','KOWEÏT');
INSERT INTO bkconvbic VALUES('D04','Code des pays',118,'KY','CAÏMANS, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',119,'KZ','KAZAKHSTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',120,'LA','LAO, RÉPUBLIQUE DÉMOCRATIQUE POPULAIRE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',121,'LB','LIBAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',122,'LC','SAINTE-LUCIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',123,'LI','LIECHTENSTEIN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',124,'LK','SRI LANKA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',125,'LR','LIBÉRIA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',126,'LS','LESOTHO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',127,'LT','LITUANIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',128,'LU','LUXEMBOURG');
INSERT INTO bkconvbic VALUES('D04','Code des pays',129,'LV','LETTONIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',130,'LY','LIBYE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',131,'MA','MAROC');
INSERT INTO bkconvbic VALUES('D04','Code des pays',132,'MC','MONACO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',133,'MD','MOLDOVA, RÉPUBLIQUE DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',134,'MG','MADAGASCAR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',135,'MH','MARSHALL, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',136,'MK','MACÉDOINE, L`EX-RÉPUBLIQUE YOUGOSLAVE DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',137,'ML','MALI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',138,'MM','MYANMAR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',139,'MN','MONGOLIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',140,'MO','MACAO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',141,'MP','MARIANNES DU NORD, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',142,'MQ','MARTINIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',143,'MR','MAURITANIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',144,'MS','MONTSERRAT');
INSERT INTO bkconvbic VALUES('D04','Code des pays',145,'MT','MALTE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',146,'MU','MAURICE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',147,'MV','MALDIVES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',148,'MW','MALAWI');
INSERT INTO bkconvbic VALUES('D04','Code des pays',149,'MX','MEXIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',150,'MY','MALAISIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',151,'MZ','MOZAMBIQUE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',152,'NA','NAMIBIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',153,'NC','NOUVELLE-CALÉDONIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',154,'NE','NIGER');
INSERT INTO bkconvbic VALUES('D04','Code des pays',155,'NF','NORFOLK, ÎLE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',156,'NG','NIGÉRIA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',157,'NI','NICARAGUA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',158,'NL','PAYS-BAS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',159,'NO','NORVÈGE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',160,'NP','NÉPAL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',161,'NR','NAURU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',162,'NU','NIUÉ');
INSERT INTO bkconvbic VALUES('D04','Code des pays',163,'NZ','NOUVELLE-ZÉLANDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',164,'OM','OMAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',165,'PA','PANAMA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',166,'PE','PÉROU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',167,'PF','POLYNÉSIE FRANÇAISE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',168,'PG','PAPOUASIE-NOUVELLE-GUINÉE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',169,'PH','PHILIPPINES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',170,'PK','PAKISTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',171,'PL','POLOGNE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',172,'PM','SAINT-PIERRE-ET-MIQUELON');
INSERT INTO bkconvbic VALUES('D04','Code des pays',173,'PN','PITCAIRN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',174,'PR','PORTO RICO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',175,'PS','PALESTINIEN OCCUPÉ, TERRITOIRE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',176,'PT','PORTUGAL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',177,'PW','PALAOS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',178,'PY','PARAGUAY');
INSERT INTO bkconvbic VALUES('D04','Code des pays',179,'QA','QATAR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',180,'RE','RÉUNION');
INSERT INTO bkconvbic VALUES('D04','Code des pays',181,'RO','ROUMANIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',182,'RU','RUSSIE, FÉDÉRATION DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',183,'RW','RWANDA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',184,'SA','ARABIE SAOUDITE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',185,'SB','SALOMON, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',186,'SC','SEYCHELLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',187,'SD','SOUDAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',188,'SE','SUÈDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',189,'SG','SINGAPOUR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',190,'SH','SAINTE-HÉLÈNE, ASCENSION ET TRISTAN DA CUNHA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',191,'SI','SLOVÉNIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',192,'SJ','SVALBARD ET ÎLE JAN MAYEN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',193,'SK','SLOVAQUIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',194,'SL','SIERRA LEONE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',195,'SM','SAINT-MARIN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',196,'SN','SÉNÉGAL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',197,'SO','SOMALIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',198,'SR','SURINAME');
INSERT INTO bkconvbic VALUES('D04','Code des pays',199,'ST','SAO TOMÉ-ET-PRINCIPE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',200,'SV','EL SALVADOR');
INSERT INTO bkconvbic VALUES('D04','Code des pays',201,'SY','SYRIENNE, RÉPUBLIQUE ARABE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',202,'SZ','SWAZILAND');
INSERT INTO bkconvbic VALUES('D04','Code des pays',203,'TC','TURKS-ET-CAÏCOS, ÎLES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',204,'TD','TCHAD');
INSERT INTO bkconvbic VALUES('D04','Code des pays',205,'TF','TERRES AUSTRALES FRANÇAISES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',206,'TG','TOGO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',207,'TH','THAÏLANDE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',208,'TJ','TADJIKISTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',209,'TK','TOKELAU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',210,'TM','TURKMÉNISTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',211,'TN','TUNISIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',212,'TO','TONGA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',213,'TP','TIMOR ORIENTAL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',214,'TR','TURQUIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',215,'TT','TRINITÉ-ET-TOBAGO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',216,'TV','TUVALU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',217,'TW','TAÏWAN, PROVINCE DE CHINE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',218,'TZ','TANZANIE, RÉPUBLIQUE-UNIE DE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',219,'UA','UKRAINE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',220,'UG','OUGANDA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',221,'UM','ÎLES MINEURES ÉLOIGNÉES DES ÉTATS-UNIS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',222,'US','ÉTATS-UNIS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',223,'UY','URUGUAY');
INSERT INTO bkconvbic VALUES('D04','Code des pays',224,'UZ','OUZBÉKISTAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',225,'VA','SAINT-SIÈGE (ÉTAT DE LA CITÉ DU VATICAN)');
INSERT INTO bkconvbic VALUES('D04','Code des pays',226,'VC','SAINT-VINCENT-ET-LES GRENADINES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',227,'VE','VENEZUELA, RÉPUBLIQUE BOLIVARIENNE DU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',228,'VG','ÎLES VIERGES BRITANNIQUES');
INSERT INTO bkconvbic VALUES('D04','Code des pays',229,'VI','ÎLES VIERGES DES ÉTATS-UNIS');
INSERT INTO bkconvbic VALUES('D04','Code des pays',230,'VN','VIETNAM');
INSERT INTO bkconvbic VALUES('D04','Code des pays',231,'VU','VANUATU');
INSERT INTO bkconvbic VALUES('D04','Code des pays',232,'WF','WALLIS ET FUTUNA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',233,'WS','SAMOA');
INSERT INTO bkconvbic VALUES('D04','Code des pays',234,'YE','YÉMEN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',235,'YT','MAYOTTE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',236,'YU','YOUGOSLAVIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',237,'ZA','AFRIQUE DU SUD');
INSERT INTO bkconvbic VALUES('D04','Code des pays',238,'ZM','ZAMBIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',239,'ZW','ZIMBABWE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',240,'MF','SAINT MARTIN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',241,'IM','ISLE OF MAN');
INSERT INTO bkconvbic VALUES('D04','Code des pays',242,'AX','ILES ÅLAND');
INSERT INTO bkconvbic VALUES('D04','Code des pays',243,'GG','GUERNSEY');
INSERT INTO bkconvbic VALUES('D04','Code des pays',244,'JE','JERSEY');
INSERT INTO bkconvbic VALUES('D04','Code des pays',245,'ME','MONTÉNÉGRO');
INSERT INTO bkconvbic VALUES('D04','Code des pays',246,'BL','SAINT BARTHÉLEMY');
INSERT INTO bkconvbic VALUES('D04','Code des pays',247,'RS','SERBIE');
INSERT INTO bkconvbic VALUES('D04','Code des pays',248,'TL','TIMOR-ORIENTAL');
INSERT INTO bkconvbic VALUES('D04','Code des pays',249,'SS','SOUDAN DU SUD');

--D05 - Situation Familiale
INSERT INTO bkconvbic VALUES('D05','Situation Familiale',1,'Single','Célibataire');
INSERT INTO bkconvbic VALUES('D05','Situation Familiale',2,'Married','Marié');
INSERT INTO bkconvbic VALUES('D05','Situation Familiale',3,'Divorced','Divorcé');
INSERT INTO bkconvbic VALUES('D05','Situation Familiale',5,'Widowed','Veuf');
INSERT INTO bkconvbic VALUES('D05','Situation Familiale',7,'Separated','Séparé');
INSERT INTO bkconvbic VALUES('D05','Situation Familiale',99,'Other','Autre');

--D07- Situation sociale
INSERT INTO bkconvbic VALUES('D07','Situation sociale',0,'NotSpecified','Non précisé');
INSERT INTO bkconvbic VALUES('D07','Situation sociale',1,'Student','Etudiant');
INSERT INTO bkconvbic VALUES('D07','Situation sociale',2,'Employed','Employé ou travailleur indépendant (commerçant)');
INSERT INTO bkconvbic VALUES('D07','Situation sociale',3,'Unemployed','Sans emploi');
INSERT INTO bkconvbic VALUES('D07','Situation sociale',4,'Retired','Retraité');
INSERT INTO bkconvbic VALUES('D07','Situation sociale',5,'HomeMaker','Personne d`intérieur');

--D08 - Résidence
INSERT INTO bkconvbic VALUES('D08','Résidence',1,'Yes','Résident du pays avec la citoyenneté du pays, ou citoyen d`un autre pays au sein du même marché (avec la même situation légale qu`un Résident)');
INSERT INTO bkconvbic VALUES('D08','Résidence',2,'No','Citoyen d`un autre pays');

--D09 - Emploi
INSERT INTO bkconvbic VALUES('D09','Emploi',0,'NotSpecified','Non précisé');
INSERT INTO bkconvbic VALUES('D09','Emploi',1,'Farmer','Agriculteur');
INSERT INTO bkconvbic VALUES('D09','Emploi',4,'Accountant','Comptable');
INSERT INTO bkconvbic VALUES('D09','Emploi',7,'Lawyer','Avocat');
INSERT INTO bkconvbic VALUES('D09','Emploi',10,'Engineer','Ingénieur');
INSERT INTO bkconvbic VALUES('D09','Emploi',22,'AdministrativeOfficer','Responsable Administratif');
INSERT INTO bkconvbic VALUES('D09','Emploi',23,'Artisan','Artisan');
INSERT INTO bkconvbic VALUES('D09','Emploi',24,'AssistantManager','Assistant Cadre');
INSERT INTO bkconvbic VALUES('D09','Emploi',25,'Auditor','Contrôleur');
INSERT INTO bkconvbic VALUES('D09','Emploi',26,'BankAssistant','Assistant Banque');
INSERT INTO bkconvbic VALUES('D09','Emploi',27,'BankOfficer','Cadre Banque');
INSERT INTO bkconvbic VALUES('D09','Emploi',28,'Banker','Banquier');
INSERT INTO bkconvbic VALUES('D09','Emploi',29,'BranchManager','Cadre agence');
INSERT INTO bkconvbic VALUES('D09','Emploi',30,'BusinessAnalyst','Analyste des ventes');
INSERT INTO bkconvbic VALUES('D09','Emploi',31,'CEO_ChiefExecutiveOfficer','PDG - Président Directeur Général');
INSERT INTO bkconvbic VALUES('D09','Emploi',32,'ChiefMedicalExecutive','Chef Médical');
INSERT INTO bkconvbic VALUES('D09','Emploi',33,'CIO_ChiefInformationOfficer','DSI - Directeur Système d`Information');
INSERT INTO bkconvbic VALUES('D09','Emploi',34,'CivilEngineer','Ingénieur Civil');
INSERT INTO bkconvbic VALUES('D09','Emploi',35,'ClericalOfficer','Commis Principal');
INSERT INTO bkconvbic VALUES('D09','Emploi',36,'ComputerAnalystProgrammer','Analyste Programmeur');
INSERT INTO bkconvbic VALUES('D09','Emploi',37,'ComputerSystemsEngineer','Ingénieur Informatique');
INSERT INTO bkconvbic VALUES('D09','Emploi',38,'ControlRoomOperator','Opérateur de Salle de Contrôle');
INSERT INTO bkconvbic VALUES('D09','Emploi',39,'COO_ChiefOperatingOfficer','DO - Directeur des Opérations');
INSERT INTO bkconvbic VALUES('D09','Emploi',40,'DatabaseAdministrator','Administrateur de Base de Données');
INSERT INTO bkconvbic VALUES('D09','Emploi',41,'Director','Directeur');
INSERT INTO bkconvbic VALUES('D09','Emploi',42,'Driver','Chauffeur');
INSERT INTO bkconvbic VALUES('D09','Emploi',43,'Economist','Economiste');
INSERT INTO bkconvbic VALUES('D09','Emploi',44,'ElectricalEngineer','Ingénieur électricien');
INSERT INTO bkconvbic VALUES('D09','Emploi',45,'EstateOfficer','Fonctionnaire');
INSERT INTO bkconvbic VALUES('D09','Emploi',46,'FinancialAnalyst','Analyste financier');
INSERT INTO bkconvbic VALUES('D09','Emploi',47,'FinancialManager','Cadre financier');
INSERT INTO bkconvbic VALUES('D09','Emploi',48,'Foreman','Contremaître');
INSERT INTO bkconvbic VALUES('D09','Emploi',49,'HeadOfCorporateDivision','Chef de Division Groupe');
INSERT INTO bkconvbic VALUES('D09','Emploi',50,'HeadOfDailyOperations','Directeur des Opérations');
INSERT INTO bkconvbic VALUES('D09','Emploi',51,'HumanResourceOfficer','Directeur des Ressources Humaines');
INSERT INTO bkconvbic VALUES('D09','Emploi',52,'InsuranceOfficer','Directeur Assurance');
INSERT INTO bkconvbic VALUES('D09','Emploi',53,'InternalAuditor','Contrôleur Interne');
INSERT INTO bkconvbic VALUES('D09','Emploi',54,'InvestmentAdvisor','Conseiller en placements');
INSERT INTO bkconvbic VALUES('D09','Emploi',55,'ITSecurityAdministrator','Administrateur de sécurité informatique');
INSERT INTO bkconvbic VALUES('D09','Emploi',56,'ITTechnician','Technicien informatique');
INSERT INTO bkconvbic VALUES('D09','Emploi',57,'KitchenAttendant','Employé de cuisine');
INSERT INTO bkconvbic VALUES('D09','Emploi',58,'LaboratoryTechnician','Technicien de laboratoire');
INSERT INTO bkconvbic VALUES('D09','Emploi',59,'LegalOfficer','Directeur juridique');
INSERT INTO bkconvbic VALUES('D09','Emploi',60,'Librarian','Libraire');
INSERT INTO bkconvbic VALUES('D09','Emploi',61,'Liquidator','Liquidateur');
INSERT INTO bkconvbic VALUES('D09','Emploi',62,'Manager','Cadre');
INSERT INTO bkconvbic VALUES('D09','Emploi',63,'MarketingManager','Cadre marketing');
INSERT INTO bkconvbic VALUES('D09','Emploi',64,'MedicalDoctor','Docteur en médecine');
INSERT INTO bkconvbic VALUES('D09','Emploi',65,'MedicalOfficer','Médecin du travail');
INSERT INTO bkconvbic VALUES('D09','Emploi',66,'Messenger','Coursier');
INSERT INTO bkconvbic VALUES('D09','Emploi',68,'Nurse','Infirmière');
INSERT INTO bkconvbic VALUES('D09','Emploi',69,'OfficeManager','Cadre de bureau');
INSERT INTO bkconvbic VALUES('D09','Emploi',70,'OperationManager','Cadre des opérations');
INSERT INTO bkconvbic VALUES('D09','Emploi',71,'OrganizationalAnalyst','Analyste organisation');
INSERT INTO bkconvbic VALUES('D09','Emploi',72,'PersonalSecretary','Secrétaire');
INSERT INTO bkconvbic VALUES('D09','Emploi',73,'PersonnelManager','Cadre personnel');
INSERT INTO bkconvbic VALUES('D09','Emploi',74,'PharmaceuticalAssistant','Assistant pharmacie');
INSERT INTO bkconvbic VALUES('D09','Emploi',75,'PlanningOfficer','Responsable planning');
INSERT INTO bkconvbic VALUES('D09','Emploi',76,'ProductionManager','Cadre de production');
INSERT INTO bkconvbic VALUES('D09','Emploi',77,'Professor','Professeur');
INSERT INTO bkconvbic VALUES('D09','Emploi',78,'ProgrammeCoordinator','Coordinateur de programme');
INSERT INTO bkconvbic VALUES('D09','Emploi',79,'ProjectManager','Ched de projet');
INSERT INTO bkconvbic VALUES('D09','Emploi',80,'PublicRelationsAssistant','Assistant relations publiques');
INSERT INTO bkconvbic VALUES('D09','Emploi',81,'PublicRelationsManager','Cadre en relations publiques');
INSERT INTO bkconvbic VALUES('D09','Emploi',82,'PublicRelationsOfficer','Officier en relations publiques');
INSERT INTO bkconvbic VALUES('D09','Emploi',83,'PurchasingManager','Cadre achats');
INSERT INTO bkconvbic VALUES('D09','Emploi',84,'Receptionist','Réceptionniste');
INSERT INTO bkconvbic VALUES('D09','Emploi',85,'RecordsManagementOfficer','Responsable de gestion des dossiers');
INSERT INTO bkconvbic VALUES('D09','Emploi',86,'RegistryAssistant','Assistant registre');
INSERT INTO bkconvbic VALUES('D09','Emploi',87,'SalesManager','Directeur des ventes');
INSERT INTO bkconvbic VALUES('D09','Emploi',88,'SecurityGuard','Gardien de sécurité');
INSERT INTO bkconvbic VALUES('D09','Emploi',89,'SecurityOfficer','Officier de sécurité');
INSERT INTO bkconvbic VALUES('D09','Emploi',90,'ServiceManager','Gestionnaire de services');
INSERT INTO bkconvbic VALUES('D09','Emploi',91,'SocialAffairs','Affaires sociales');
INSERT INTO bkconvbic VALUES('D09','Emploi',92,'SpecialAssignments','Mission spéciale');
INSERT INTO bkconvbic VALUES('D09','Emploi',93,'Statistician','Statisticien');
INSERT INTO bkconvbic VALUES('D09','Emploi',94,'StoreManager','Directeur de magasin');
INSERT INTO bkconvbic VALUES('D09','Emploi',95,'Supervisor','Superviseur');
INSERT INTO bkconvbic VALUES('D09','Emploi',96,'SuppliesOfficer','Charge de l`Approvisionnement');
INSERT INTO bkconvbic VALUES('D09','Emploi',97,'TechnicalSupervisor','Superviseur Technique');
INSERT INTO bkconvbic VALUES('D09','Emploi',98,'TechnicianEngineer','Ingénieur tehnique');
INSERT INTO bkconvbic VALUES('D09','Emploi',99,'TelephoneOperator','Opérateur téléphonique');
INSERT INTO bkconvbic VALUES('D09','Emploi',100,'TransportOfficer','Officier de transport');
INSERT INTO bkconvbic VALUES('D09','Emploi',101,'TransportationManager','Cadre de transport');
INSERT INTO bkconvbic VALUES('D09','Emploi',102,'ViceCEO','PDG Adjoint / Directeur Général');
INSERT INTO bkconvbic VALUES('D09','Emploi',103,'WardAttendant','Préposé de salle');
INSERT INTO bkconvbic VALUES('D09','Emploi',9999,'Other','Autre');

--D10 - Niveau de formation
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',0,'NotSpecified','Non précisé');
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',1,'NoEducation','Pas de formation');
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',2,'Primary','Primaire, de base');
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',3,'Secondary','Secondaire');
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',4,'HigherEducation','Education supérieure');
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',5,'AcademicDegree','Diplôme université');
INSERT INTO bkconvbic VALUES('D10','Niveau de formation',99,'Other','Autre');

--D12 - Forme Légale
INSERT INTO bkconvbic VALUES('D12','Forme Légale',1,'JointLiabilityCompany','Société Anonyme');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',2,'SpecialPartnershipCompany','Société Partenariat Spéciale / Partenariat Limité');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',3,'LimitedLiabilityCompanyPublic','Société à Responsabilité Limitée Publique');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',4,'LimitedLiabilityCompanyPrivate','Société Anonyme à Responsabilité Limitée');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',5,'JointStockCompany','Société côtée');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',6,'Cooperative','Coopérative');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',7,'Foundations','Fondation');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',8,'Association','Association');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',9,'Audit','Audit');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',10,'Notary','Notaire');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',11,'CoPartnership','Co-partenariat');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',12,'NonRegisteredAssociation','Association non déclarée');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',13,'ReligiousOrganization','Organisation religieuse');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',14,'GovernmentalInstitution','Institution gouvernementale');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',15,'Political','Parti politique, syndicat');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',16,'PublicInstitution','Institution Publique');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',17,'Branch','Agence');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',18,'LegalPersonUnderPublicLaw','Personne morale de droit public');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',24,'SoleOwnershipLimitedLiabilityCo','Société Unipersonnelle à Responsabilité Limité (SURL)');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',25,'GeneralPartnership','Société en Nom Collectif (SNC)');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',26,'LimitedPartnership','Société en Commandite Simple (SCS)');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',27,'SimplifiedJointStockCompany','Société par Actions Simplifiées (SAS)');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',28,'EconomicInterestGrouping','Groupement d`Intérêt Economique (GIE)');
INSERT INTO bkconvbic VALUES('D12','Forme Légale',99,'Other','Autre');

--D13 - Etat de l'entreprise
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',1,'Active','Active');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',2,'Closed','Fermée');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',3,'InBankrupcy','Pas fermé, mais sous procédure de faillite');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',4,'SupervisoryCrisisAdministration','Sous tutelle de l`administration');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',5,'OtherCourtActionByBank','Autre action en justice par la banque');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',6,'BankruptcyPetitionByBank','Demande de mise en liquidation par la banque');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',7,'Liquidation','Liquidation');
INSERT INTO bkconvbic VALUES('D13','Etat de l`entreprise',8,'AssetsFrozenOrSeized','Actifs gelés ou saisis');

--D14 - Secteur d'activité
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',2,'FinancialIntermediaries','Etablissements financiers');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',3,'Fishing','Pêche');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',8,'BuildingAndConstruction','Bâtiment et travaux publics');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',17,'RealEstate','Affaires immobilières et services fournis aux entreprises');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',29,'AgricultureAndHunting','Agriculture et chasse');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',30,'Forestry','Sylviculture et  exploitation forestière');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',31,'CoalMining','Extraction du charbon');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',32,'CrudeOilAndNaturalGasProduction','Production de pétrole brut et de gaz naturel');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',33,'Mining','Extraction de minerais métalliques');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',34,'OtherMining','Extraction d`autres minéraux');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',35,'ManufactureOfFoodProductsBeveragesAndTobacco','Fabrication de produits alimentaires, boissons et tabac');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',36,'TextilesIndustriesClothingAndLeather','Industries des textiles, de l`habillement et du cuir');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',37,'WoodIndustryAndandManufacturing','Industrie du bois et fabrication d`ouvrages en bois y compris les meubles');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',38,'PaperManufacturingPrintingAndPublishing','Fabrication du papier, imprimerie et édition');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',39,'ChemicalIndustryAndChemicalManufacturing','Industrie chimique et fabrication de produits chimiques');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',40,'NonMetallicMineral','Produits minéraux non métalliques');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',41,'BasicMetalIndustries','Industrie métallurgique de base');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',42,'MetalManufacturingProductMachineryAndEquipment','Fabrication d`ouvrages en métaux, de machines, de matériel');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',43,'OtherManufacturingIndustries','Autres industries manufacturières');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',44,'ElectricityGasAndSteam','Electricité, gaz et vapeur');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',45,'WaterDistributionFacilitiesAndPublicWaterSupplyOtherThanForAgriculture','Installations de distribution d`eau et distribution publique de l`eau (autres que pour l`agriculture');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',46,'Wholesale','Commerce de gros');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',47,'Retail','Commerce de détail');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',48,'HotelsRestaurantsAndTourism','Restaurants, Hôtels et installations touristiques');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',49,'TransportWarehousingAndStorage','Transports et entrepôts');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',50,'Communication','Communication');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',51,'Insurances','Assurances');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',52,'PublicAdministrationAndNationalDefence','Administration publique et défense nationale');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',53,'HealthAndSimilarServices','Services sanitaires et services analogues');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',54,'SocialAndRelatedServicesProvidedToTheCommunity','services sociaux et services connexes fournis à la collectivité');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',55,'RecreationAndCultureServices','Services récréatifs et services culturels');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',56,'ServicesProvidedToHouseholdsAndIndividuals','Services fournis aux ménages et aux particuliers');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',57,'InternationalAndOtherExtraTerritorialOrganizations','Organisations internationales et autres organismes extra-territoriaux');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',58,'CommitmentToBeTheSubjectOfSubsequentCharging','Engagement devant faire l`objet d`imputation ultérieure');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',59,'Individuals','Particuliers');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',60,'Agriculture','Métiers de l`agriculture');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',61,'InformationTechnologies','Métiers de l`informatique');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',62,'Education','Métiers de l`enseignement');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',63,'MedicalServices','Services médicaux');
INSERT INTO bkconvbic VALUES('D14','Secteur d`activité',64,'Other','Autre');

--D15 - Situation négative de la personne
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',0,'NotSpecified','Non précisé');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',1,'NoNegativeStatus','Pas de situation négative');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',2,'SupervisoryOrCrisisAdministration','Sous tutelle ou contrôle de l`administration');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',3,'OtherCourtActionByBank','Autre action de justice par la banque');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',4,'BankruptcyPetitionByBank','Demande de liquidation par la banque');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',5,'BankruptcyPetition','Demande de liquidation');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',6,'CourtDeclaredBankruptcy','Faillite déclarée');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',7,'Receivership','Redressement judiciaire');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',8,'Liquidation','Liquidation');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',9,'AssetsFrozenOrSeized','Actifs gelés ou saisis');
INSERT INTO bkconvbic VALUES('D15.1','Situation négative de la personne',10,'CustomerUntraceableOrDeceased','Client introuvable ou mort');

--D15 - Type de relation (entre sujets)
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',1,'Spouse','Conjoint');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',2,'Soleowner','Actionnaire unique');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',3,'Shareholder','Actionnaire');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',4,'CEO','PDG');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',5,'COO','Directeur des opérations');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',6,'FinancialDirector','Directeur financier');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',7,'MainAccountant','Chef comptable');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',8,'TopManager','Cadre supérieur');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',9,'MiddleManager','Cadre moyen');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',10,'Representative','Autre représentant de l`entreprise');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',11,'Employee','Employé');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',12,'Employer','Employé');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',13,'CompanyFullyOwned','Entreprise en propriété exclusive');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',14,'CompanyPartlyOwned','Entreprise détenue en partie');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',15,'Branch','Succursale');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',16,'Affiliate','Filiale');
INSERT INTO bkconvbic VALUES('D15.2','Type de relation',99,'Other','Autre');

--D16 - Type du sujet
INSERT INTO bkconvbic VALUES('D16','Type du sujet',1,'Individual','Aucun statut négatif');
INSERT INTO bkconvbic VALUES('D16','Type du sujet',2,'Company','Supervisory or crisis administration');

--D16.1 - Phase du contrat
INSERT INTO bkconvbic VALUES('D16.1','Phase du contrat',1,'Open','Le contrat est ouvert. Voir D16.2');
INSERT INTO bkconvbic VALUES('D16.1','Phase du contrat',2,'Closed','Le contrat est fermé. Voir D16.3');

--D16.2 - Situation de contrat ouvert
INSERT INTO bkconvbic VALUES('D16.2','Situation du contrat ouvert',1,'GrantedButNotActivated','Le contrat est octroyé, mais les fonds n`ont pas encore été versés (par exemple, en attente de certaines conditions)');
INSERT INTO bkconvbic VALUES('D16.2','Situation du contrat ouvert',2,'GrantedAndActivated','Le contrat est actif et ouvert. Les fonds ont été versés au principal débiteur');
INSERT INTO bkconvbic VALUES('D16.2','Situation du contrat ouvert',3,'Rescheduled','Le contrat est Actif et Ouvert, les conditions principales du contrat ont été modifées, changées et acceptées (portant par exemple sur le Montant Total, la Date Prévue de Fin de Contrat, etc.)');

--D16.3 -  Situation de contrat fermé
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',4,'SettledOnTime','Le contrat est entièrement Réglé et Fermé, entièrement remboursé, selon les conditions du contrat et l`échéancier.');
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',5,'SettledInAdvance','Le contrat est entièrement Réglé et Fermé, entièrement remboursé en avance - avant la date acceptée de fin de contrat.');
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',6,'WithArrearsNoRepossession','Le Contrat est Fermé avec des paiements en retard, et aucune procédure de reprise n`a eu lieu.');
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',7,'WithArrearsAndRepossession','Le Contrat est Fermé avec des paiements en retard, et une procédure de reprise a eu lieu.');
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',8,'Cancelled','Le Contrat est Fermé et Annulé à cause d`une usurpation d`identité (le principal créancier est une autre personne que le fraudeur) ou à cause d`une autre personne, dont la responsabilité n`incombe pas au principal débiteur d`origine.');
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',9,'SoldToThirdParty','Vendu à une partie Tierce pour recouvrement');
INSERT INTO bkconvbic VALUES('D16.3','Situation du contrat fermé',10,'WrittenOff','Créance Abandonnée');

--D17 -  Situation de transfert
INSERT INTO bkconvbic VALUES('D17','Situation du transfert',0,'NotSpecified','Non précisé');
INSERT INTO bkconvbic VALUES('D17','Situation du transfert',1,'NoTransfer','Le débiteur principal est l`original. Il n`y a pas eu de transfert.');
INSERT INTO bkconvbic VALUES('D17','Situation du transfert',2,'TransferredFromAnotherMainDebtor','Le contrat a été transféré au débiteur principal actuel par une autre personne. Dédié aux Contrats Ouverts et Fermés.');
INSERT INTO bkconvbic VALUES('D17','Situation du transfert',3,'TransferredToAnotherMainDebtor','Le contrat a été transféré du débiteur principal actuel à une autre personne, qui devient le créancier principal. Dédié uniquement aux Contrats Ouverts et Fermés.');

--D18 -  Type de contrat
INSERT INTO bkconvbic VALUES('D18','Type de contrat',1,'Installment','Contrat des versements');
INSERT INTO bkconvbic VALUES('D18','Type de contrat',2,'NonInstallment','Pas de contrat des versements');
INSERT INTO bkconvbic VALUES('D18','Type de contrat',3,'CreditCard','Carte de crédit');
INSERT INTO bkconvbic VALUES('D18','Type de contrat',4,'RevolvingCredit','Crédit Renouvelable');
INSERT INTO bkconvbic VALUES('D18','Type de contrat',5,'Invoice','Facture impayée ou non réglée');

--D19 - Objet du financement
INSERT INTO bkconvbic VALUES('D19','Objet du financement',1,'PersonalLoan','Prêt personnel - non relié à un achat spécifique. Achats de biens de consommation à usage personnel');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',2,'PersonalLoanForExactPurpose','Crédit personnel - pour acheter un bien spécifique, avec accord de l`institution financière');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',3,'Mortgage','Prêt pour acheter un appartement ou un immeuble');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',4,'Leasing','Leasing');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',5,'Overdraft','Limite de crédit sur le compte courant');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',6,'Development','Développement');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',7,'WorkingCapital','Fonds de roulement');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',8,'Repair','Dépannage');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',9,'TelecomServices','Services de téléphoniqe mobile, etc.');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',10,'Construct','Construction');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',11,'PurchaseOfBuilding','Acquisition de bâtiment');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',12,'PurchaseOfPersonalConsumingProducts','Achat de biens de consommation');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',13,'SyndicatedLoan','Prêt syndiqué');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',14,'StudentLoan','Prêt étudiant');
INSERT INTO bkconvbic VALUES('D19','Objet du financement',99,'Other','Autre');

--D20 Liste des devises
INSERT INTO bkconvbic VALUES('D20','Liste des devises',0,'NotSpecified','Non spécifié');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',1,'AED','Dirham des émirats arabes unis');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',2,'AFN','Afghani');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',3,'ALL','Lek');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',4,'AMD','Dram arménien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',5,'ANG','Florin des Antilles');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',6,'AOA','Kwanza');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',7,'ARS','Peso argentin');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',8,'AUD','Dollar australien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',9,'AWG','Florin d`Aruba');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',10,'AZN','Manat');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',11,'BAM','Mark convertible');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',12,'BBD','Dollar de Barbade');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',13,'BDT','Taka');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',14,'BGN','Lev de Bulgarie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',15,'BHD','Dinar de Bahreïn');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',16,'BIF','Franc du Burundi');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',17,'BMD','Dollar des Bermudes');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',18,'BND','Dollar de Brunei');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',19,'BOB','Boliviano (Mvdol)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',20,'BOV','Bolivian Mvdol (funds code)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',21,'BRL','Real de Brésil');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',22,'BSD','Dollar des Bahamas');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',23,'BTN','Bhutan Ngultrum');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',24,'BWP','Pula');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',25,'BYR','Rouble bélorusse');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',26,'BZD','Dollar de Belize');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',27,'CAD','Dollar canadien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',28,'CDF','Franc Congolais');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',29,'CHE','WIR Bank (complementary currency) (Switzerland)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',30,'CHF','Franc Suisse');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',31,'CHW','WIR Bank (complementary currency) (Switzerland)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',32,'CLF','Unidad de Fomento (funds code) Chile');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',33,'CLP','Peso chilien (Unité d`investissement)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',34,'CNY','Yuan Ren-Min-Bi');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',35,'COP','Peso colombien (Unidad de Valor Real)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',36,'COU','Colombian Unidad de Valor Real');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',37,'CRC','Colon de Costa Rica');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',38,'CUC','Peso cubain convertible');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',39,'CUP','Peso cubain');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',40,'CVE','Escudo du Cap-Vert');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',41,'CZK','Couronne tchèque');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',42,'DJF','Franc de Djibouti');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',43,'DKK','Couronne danoise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',44,'DOP','Peso dominicain');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',45,'DZD','Dinar algérien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',46,'EEK','Couronne estonienne');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',47,'EGP','Livre égyptienne');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',48,'ERN','Nakfa');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',49,'ETB','Birr éthiopien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',50,'EUR','Euro');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',51,'FJD','Dollar de Fidji');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',52,'FKP','Livre de Falkland');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',53,'GBP','Livre Sterling');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',54,'GEL','Lari');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',55,'GHS','Ghana Cedi');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',56,'GIP','Livre de Gibraltar');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',57,'GMD','Dalasi');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',58,'GNF','Franc guinéen');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',59,'GTQ','Quetzal');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',60,'GYD','Dollar de Guyane');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',61,'HKD','Dollar de Hong-Kong');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',62,'HNL','Lempira');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',63,'HRK','Kuna');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',64,'HTG','Gourde (Dollar des États-Unis)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',65,'HUF','Forint');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',66,'IDR','Rupiah');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',67,'ILS','Nouvel israëli sheqel');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',68,'INR','Roupie indienne');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',69,'IQD','Dinar iraquien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',70,'IRR','Rial iranien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',71,'ISK','Couronne islandaise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',72,'JMD','Dollar jamaïcain');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',73,'JOD','Dinar jordanien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',74,'JPY','Yen');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',75,'KES','Shilling du Kenya');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',76,'KGS','Som');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',77,'KHR','Riel');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',78,'KMF','Franc des Comores');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',79,'KPW','Won de la Corée du Nord');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',80,'KRW','Won');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',81,'KWD','Dinar koweïtien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',82,'KYD','Dollar des Iles Caïmanes');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',83,'KZT','Tenge');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',84,'LAK','Kip');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',85,'LBP','Livre libanaise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',86,'LKR','Roupie de Sri Lanka');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',87,'LRD','Dollar libérien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',88,'LSL','Lesotho loti');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',89,'LTL','Litas lituanien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',90,'LVL','Lats letton');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',91,'LYD','Dinar libyen');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',92,'MAD','Dirham marocain');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',93,'MDL','Leu de Moldovie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',94,'MGA','Malagasy Ariary');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',95,'MKD','Denar');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',96,'MMK','Kyat');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',97,'MNT','Tugrik');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',98,'MOP','Pataca');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',99,'MRO','Ouguija');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',100,'MUR','Roupie de Maurice');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',101,'MVR','Rufiyaa');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',102,'MWK','Kwacha de Malawi');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',103,'MXN','Peso mexicain');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',104,'MXV','Peso mexicain (Mexican Unidad de Inversion - UDI)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',105,'MYR','Ringgit de Malaisie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',106,'MZN','Metical');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',107,'NAD','Dollar Namibien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',108,'NGN','Naira');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',109,'NIO','Cordoba Oro');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',110,'NOK','Couronne norvégienne');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',111,'NPR','Roupie du Népal');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',112,'NZD','Dollar néo-zélandais');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',113,'OMR','Rial Omani');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',114,'PAB','Balboa (Dollar des États-Unis)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',115,'PEN','Nouveau Sol');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',116,'PGK','Kina');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',117,'PHP','Peso philippin');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',118,'PKR','Roupie du Pakistan');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',119,'PLN','Zloty');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',120,'PYG','Guarani');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',121,'QAR','Riyal du Qatar');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',122,'RON','Nouveau Leu');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',123,'RSD','Dinar de Serbie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',124,'RUB','Rouble russe');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',125,'RWF','Franc du Rwanda');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',126,'SAR','Riyal saoudien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',127,'SBD','Dollar de Salomon');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',179,'SSP','Livre Sud Soudanaise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',128,'SCR','Roupie des Seychelles');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',129,'SDG','Livre soudanaise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',130,'SEK','Couronne suédoise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',131,'SGD','Dollar de Singapour');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',132,'SHP','Livre de Sainte-Hélène');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',133,'SLL','Leone');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',134,'SOS','Shilling de Somalie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',135,'SRD','Dollar de Suriname');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',136,'STD','Dobra');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',137,'SYP','Livre syrienne');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',138,'SZL','Lilangeni');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',139,'THB','Baht');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',140,'TJS','Somoni');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',141,'TMT','Manat Turkmenistan');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',142,'TND','Dinar tunisien');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',143,'TOP','Pa`anga');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',144,'TRY','Nouvelle Livre');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',145,'TTD','Dollar de la Trinité et de Tobago');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',146,'TWD','Nouveau dollar de Taïwan');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',147,'TZS','Shilling de Tanzanie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',148,'UAH','Hryvnia');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',149,'UGX','Nouveau Shilling ougandais');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',150,'USD','Dollar des États-Unis');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',151,'USN','Dollar des États-Unis (prochain jour) (funds code)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',152,'USS','Dollar des États-Unis (même jour) (funds code)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',153,'UYU','Peso uruguayen');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',154,'UZS','Soum d`Ouzbékistan');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',155,'VEF','Bolivar Fuerte');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',156,'VND','Dong');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',157,'VUV','Vatu');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',158,'WST','Tala');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',159,'XAF','Franc CFA - BEAC  ');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',160,'XAG','Argent');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',161,'XAU','Or');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',162,'XBA','Unité européenne composée (EURCO)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',163,'XBB','Unité monétaire européenne (U.M.E.-6 monnaie)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',164,'XBC','Unité de compte 9 (U.E.C.-9 monnaie)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',165,'XBD','Unité de compte 17(U.E.C.-17 monnaie)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',166,'XCD','Dollar des Caraïbes orientales');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',167,'XDR','Droit de tirage spécial (D.T.S.)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',168,'XFU','Franc UIC (special settlement currency) (International Union of Railways)');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',169,'XOF','Franc CFA - BCEAO');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',170,'XPD','Palladium');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',171,'XPF','Franc CFP');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',172,'XPT','Platine');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',173,'XTS','Riyal du Yémen');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',174,'XXX','Pas de devise');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',175,'YER','Yemeni rial');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',176,'ZAR','Rand Sud Africain');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',177,'ZMK','Kwacha de Zambie');
INSERT INTO bkconvbic VALUES('D20','Liste des devises',178,'ZWL','Dollar du Zimbabwe');

--D21 - Périodicité des types de paiement
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',1,'FinalDay','Dernier jour de la période de contrat');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',2,'Days7','Périodicité de 7 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',3,'Days15','Versements bimensuels');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',4,'Days30','Versements mensuels - tous les 30 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',5,'Days60','Versements bimestriels - tous les 60 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',6,'Days90','Versements trimestriels - tous les 90 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',7,'Days120','Versements tous les quatre mois - tous les 120 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',8,'Days150','Versements tous les cinq mois - tous les 150 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',9,'Days180','Versements biannuels - tous les 180 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',10,'Days360','Versements annuels - tous les 360 jours');
INSERT INTO bkconvbic VALUES('D21','Périodicité des types de paiement',11,'Irregular','Versement irréguliers');

--D22 - Type de garantie
INSERT INTO bkconvbic VALUES('D22','Type de garantie',1,'Land','Terrain');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',2,'RealEstate','Immobilier');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',3,'MotorVehicle','Véhicule à moteur');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',4,'CashSecurity','Valeur de Sûreté');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',5,'Shares','Actions');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',6,'SavingsDeposits','Dépôts d`épargne');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',7,'Machinery','Machines');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',8,'InsurancePolicy','Assurance');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',9,'OtherIndividualProperty','Autre propriété individuelle');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',10,'PersonalGuarantees','Garantie personnelle - seulement dans le cas où le garant ne peut pas être déclaré au niveau de l`enregistrement personnel standard et lié au contrat dans le rôle de "garant"');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',11,'StateGuarantees','Garanties publiques');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',12,'Financial','Toute garantie financière non précisée');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',13,'NonFinancial','Toute garantie non financière non précisée');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',14,'Stocks','Actions');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',15,'Deposit','Dépôts');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',16,'SalaryDeposit','Salaire Dépôts');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',17,'TerminalBenefits','Bénéfice final');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',18,'Equipment','Equipement');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',19,'GovernmentSecurities','Titres d`état');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',20,'Gold','Or');
INSERT INTO bkconvbic VALUES('D22','Type de garantie',99,'Other','Autre');

--D23 - Situation négative de contrat
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',0,'NotSpecified','Non précisé');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',1,'NoNegativeStatus','Pas de situation négative');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',2,'UnauthorizedDebitBalanceOnCurrentAccount','Solde négatif non autorisé sur compte courant');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',3,'Blocked','Bloqué');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',4,'CancelledDueToDelayedPayments','Annulé pour cause de paiements en retard');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',5,'InsuranceFraud','Fraude assurance');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',6,'FraudTowardsBank','Fraude envers la banque');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',7,'CreditReassignedToNewDebtor','Crédit réalloué à nouveau débiteur');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',8,'AssignmentOfCreditToThirdParty','Allocation de crédit à une tierce partie (sans remise)');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',9,'LoanWrittenOff','Prêt radié au compte hors-bilan');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',10,'IncreasedRisk','Risque accru');
INSERT INTO bkconvbic VALUES('D23','Situation négative de contrat',11,'LoanTransferredToLosses','Prêt passé en pertes, 100% non liquide, sur les postes du bilan');

--D25 - Moyen de paiement
INSERT INTO bkconvbic VALUES('D25','Moyen de paiement',1,'CurrentAccount','Compte courant');
INSERT INTO bkconvbic VALUES('D25','Moyen de paiement',2,'BillOfExchange','Lettre de change');
INSERT INTO bkconvbic VALUES('D25','Moyen de paiement',3,'BankingReceipt','Avis bancaire');
INSERT INTO bkconvbic VALUES('D25','Moyen de paiement',4,'DirectRemittance','Collecte directe');
INSERT INTO bkconvbic VALUES('D25','Moyen de paiement',5,'AuthorizationToDirectCurrentAccountDebit','Autorisation de débit sur compte courant');


-- ------------
-- DIMlab_UTB180122-01_01_STR_ora.sql
-- ------------
--DROP INDEX FK_ABPPE$EVUTI;
--DROP INDEX FK_ABLIENSPPE$BKCLI;
--DROP INDEX FK_ABLIENSPPE$EVUTI;
--DROP INDEX FK_ABHISPPE$EVUTI;
--DROP INDEX FK_ABHISPPE$EVUTI2;
--DROP INDEX FK_ABTRACFINPPE$EVUTI;
--DROP INDEX FK_ABHISACT$EVUTI;
--DROP INDEX FK_ABHISACT$BKCLI;

--table abppe
ALTER TABLE abppe   DROP CONSTRAINT FK_ABPPE$EVUTI;
DROP INDEX FK_ABPPE$EVUTI;
CREATE INDEX FK_ABPPE$EVUTI ON abppe (cuti);
ALTER TABLE abppe ADD CONSTRAINT FK_ABPPE$EVUTI FOREIGN KEY (cuti) REFERENCES evuti (cuti) ;

--table abliensppe
ALTER TABLE abliensppe   DROP CONSTRAINT FK_ABPPE$BKCLI;
DROP INDEX FK_ABLIENSPPE$BKCLI;

CREATE INDEX FK_ABLIENSPPE$BKCLI ON abliensppe (cli);
ALTER TABLE abliensppe ADD CONSTRAINT FK_ABLIENSPPE$BKCLI FOREIGN KEY (cli) REFERENCES bkcli (cli);

--table abliensppe
ALTER TABLE abliensppe   DROP CONSTRAINT FK_ABLIENSPPE$EVUTI;
DROP INDEX FK_ABLIENSPPE$EVUTI;

CREATE INDEX FK_ABLIENSPPE$EVUTI ON abliensppe (cuti);
ALTER TABLE abliensppe ADD CONSTRAINT FK_ABLIENSPPE$EVUTI FOREIGN KEY (cuti) REFERENCES evuti (cuti);

--table abhisppe
ALTER TABLE abhisppe   DROP CONSTRAINT FK_ABHISPPE$EVUTI;
DROP INDEX FK_ABHISPPE$EVUTI;

CREATE INDEX FK_ABHISPPE$EVUTI ON abhisppe (cuti);
ALTER TABLE abhisppe ADD CONSTRAINT FK_ABHISPPE$EVUTI  FOREIGN KEY (cuti) REFERENCES evuti (cuti);

--table abhisppe
ALTER TABLE abhisppe   DROP CONSTRAINT FK_ABHISPPE$EVUTI2;
DROP INDEX FK_ABHISPPE$EVUTI2;

CREATE INDEX FK_ABHISPPE$EVUTI2 ON abhisppe (cutim);
ALTER TABLE abhisppe ADD CONSTRAINT FK_ABHISPPE$EVUTI2 FOREIGN KEY (cutim) REFERENCES evuti (cuti);

--table abtracfinppe
ALTER TABLE abtracfinppe   DROP CONSTRAINT FK_ABTRACFINPPE$EVUTI;
DROP INDEX FK_ABTRACFINPPE$EVUTI;

CREATE INDEX FK_ABTRACFINPPE$EVUTI ON abtracfinppe (cuti);
ALTER TABLE abtracfinppe ADD CONSTRAINT FK_ABTRACFINPPE$EVUTI FOREIGN KEY (cuti) REFERENCES evuti (cuti);

--table abhisact
ALTER TABLE abhisact   DROP CONSTRAINT FK_ABHISACT$EVUTI;
DROP INDEX FK_ABHISACT$EVUTI;

CREATE INDEX FK_ABHISACT$EVUTI ON abhisact (cuti);
ALTER TABLE abhisact ADD CONSTRAINT FK_ABHISACT$EVUTI FOREIGN KEY (cuti) REFERENCES evuti (cuti);

--table abhisact
ALTER TABLE abhisact   DROP CONSTRAINT FK_ABTRACFINPPE$BKCLI;
DROP INDEX FK_ABHISACT$BKCLI;
CREATE INDEX FK_ABHISACT$BKCLI ON abhisact (cli);
ALTER TABLE abhisact ADD CONSTRAINT FK_ABHISACT$BKCLI FOREIGN KEY (cli) REFERENCES bkcli (cli);


-- ---------------------------------
-- Mise a jour hebdomadaire de evmod
-- ---------------------------------
UPDATE evmod  SET amod = '11.1.4', dmod = SYSDATE WHERE cmod = 'DELTA-BANK';

-- ----------------------------------------
-- Mise a jour hebdomadaire de evhistscript
-- ----------------------------------------
INSERT INTO evhistscript VALUES ('mig_11.1.4_ora.sql',SYSDATE);

