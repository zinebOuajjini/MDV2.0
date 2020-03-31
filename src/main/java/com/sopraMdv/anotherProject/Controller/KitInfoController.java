package com.sopraMdv.anotherProject.Controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.Kit;
import com.sopraMdv.anotherProject.util.DataExportService;

import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;

@Controller
public class KitInfoController {
	
	private static final String PathSeparator = System.getProperty("file.separator");

	@FXML
	private ImageView regulImg;

	@FXML
	private ImageView infoAvantImg;

	@FXML
	private ImageView infoApresImg;

	@FXML
	private ImageView prgRepImg;

	@FXML
	private ImageView refImg;

	@FXML
	private ImageView img1;

	@FXML
	private ImageView img2;

	@FXML
	private ImageView img3;

	@FXML
	private ImageView deleteDBImg;

	@FXML
	private ImageView goBackImg;

	@FXML
	private ImageView delete;

	@FXML
	private Label nomKit;

	@FXML
	private Label descriptionKit;

	@FXML
	private Label databaseNom;

	private Kit kit;

	@FXML
	private Label dataBaseBtn;

	private Session session;

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	private WelcomeController welcomecontroller;

	public WelcomeController getWelcomecontroller() {
		return welcomecontroller;
	}

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	private KitDAO kitDAO;

	public KitDAO getKitDAO() {
		return kitDAO;
	}

	@Autowired
	public void setKitDAO(KitDAO kitDAO) {
		this.kitDAO = kitDAO;
	}

	private DataBaseDAO dbDAO;

	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}

	private DataExportService dataExportService;

	public DataExportService getDataExportService() {
		return dataExportService;
	}

	@Autowired
	public void setDataExportService(DataExportService dataExportService) {
		this.dataExportService = dataExportService;
	}

	@FXML
	private void initialize() {

		kit = new Kit(session.getKit());

		img1.setImage(new Image("/Resources/progress-arrows.png", false));
		img2.setImage(new Image("/Resources/db1.png", false));
		img3.setImage(new Image("/Resources/code.png", false));
		regulImg.setImage(new Image("/Resources/bugFix.png", false));
		infoApresImg.setImage(new Image("/Resources/data-collecting.png", false));
		infoAvantImg.setImage(new Image("/Resources/data-collecting.png", false));
		prgRepImg.setImage(new Image("/Resources/code-file.png", false));
		refImg.setImage(new Image("/Resources/uploading.png", false));
		goBackImg.setImage(new Image("/Resources/back-arrow.png", false));
		delete.setImage(new Image("/Resources/rubbish.png", false));
		deleteDBImg.setImage(new Image("/Resources/rubbish.png", false));
		nomKit.setText(kit.getNomKit());
		descriptionKit.setText(kit.getDescriptionKit());
		if (session.getKit().getDatabase() != null)
			databaseNom.setText(session.getKit().getDatabase().getSid());
		if (kitDAO.getDbByKit(session.getKit().getId()) != null) {
			dataBaseBtn.setText("Modifier");
		} else {
			deleteDBImg.setVisible(false);
			dataBaseBtn.setText("Créer");
		}
	}

	@FXML
	public void modifierKit(MouseEvent e) throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Modification_Kit");
	}

	@FXML
	public void showMessageScriptState(MouseEvent e) {
		welcomecontroller.setAndShowMessage(e, "Modifer", e.getX() + 440, e.getY() + 50);
	}

	@FXML
	public void hideMessage(MouseEvent event) {
		welcomecontroller.getMessagePane().setVisible(false);
	}

	@FXML
	private void loadReferentielRemotely() {
		long startTime = System.currentTimeMillis();
		Kit kit = session.getKit();
		DataBase db = kit.getDatabase();

		String ORA_USER = db.getSchemaDB();
		String ORA_PASS = db.getPasswordDb();
		String IP = db.getHote();
		String PORT = String.valueOf(db.getPort());
		String INSTANCE = db.getSid();
		String REF_DIR = kit.getRepertoireDeTravail();
		com.jcraft.jsch.Session jcraftSession;
		String CommandOutput = null;
		try {
			java.util.Properties config = new java.util.Properties();
			config.put("StrictHostKeyChecking", "no");
			JSch jsch = new JSch();
			String repTravail = kit.getRepertoireDeTravail();
//			System.out.println(kit.getUtilisateurServeur() + "|||||" + kit.getAdressIpServeur() + "|||"
//					+ kit.getMotDePassUtilisateurServeur());

			jcraftSession = jsch.getSession(kit.getUtilisateurServeur(), kit.getAdressIpServeur(), 22);
			jcraftSession.setPassword(kit.getMotDePassUtilisateurServeur());
			jcraftSession.setConfig(config);
			jcraftSession.connect();
			System.out.println("connect");

			Channel channel = jcraftSession.openChannel("sftp");
			channel.connect();
			ChannelSftp sftp = (ChannelSftp) channel;

			System.out.println("Upload referentiel.zip...");
			FileChooser chooser = new FileChooser();
			File file = chooser.showOpenDialog(null);
			if (file != null) {
				sftp.cd(repTravail);
				sftp.put(file.getAbsolutePath(), "Referentiel.zip");
			} else {
				return;
			}

			System.out.println("The file has been uploaded succesfully");

			Channel channel2 = jcraftSession.openChannel("exec");
			String command = "cd " + repTravail + "; unzip -o " + repTravail + "/Referentiel.zip;chmod -R 777 Referentiel";
			((ChannelExec) channel2).setPty(true);
			InputStream in = channel2.getInputStream();
			channel2.setInputStream(null);
			((ChannelExec) channel2).setErrStream(System.err);

			System.out.println("commande :: " + command);
			((ChannelExec) channel2).setErrStream(System.err);
			((ChannelExec) channel2).setCommand(command);

			channel2.connect();
			byte[] tmp = new byte[1024];
			while (true) {
				while (in.available() > 0) {
					int i = in.read(tmp, 0, 1024);

					if (i < 0)
						break;
					System.out.print(new String(tmp, 0, i));
					CommandOutput = new String(tmp, 0, i);
				}

				if (channel2.isClosed()) {
					break;
				}
			}

			System.out.println(CommandOutput);

			// LANCEMENT DU SCRIPT SHELL

			Channel channel3 = jcraftSession.openChannel("exec");
			command = "sh " + repTravail + "/Referentiel/ampVerInstall_all_JAVA.sh " + ORA_USER + " " + ORA_PASS + " "
					+ IP + " " + PORT + " " + INSTANCE + " " + REF_DIR + "/Referentiel";
			((ChannelExec) channel3).setPty(true);
			in = channel3.getInputStream();
			channel3.setInputStream(null);
			((ChannelExec) channel3).setErrStream(System.err);

			System.out.println("commande :: " + command);
			((ChannelExec) channel3).setErrStream(System.err);
			((ChannelExec) channel3).setCommand(command);

			channel3.connect();
			tmp = new byte[1024];
			while (true) {
				while (in.available() > 0) {
					int i = in.read(tmp, 0, 1024);

					if (i < 0)
						break;
					System.out.print(new String(tmp, 0, i));
					CommandOutput = new String(tmp, 0, i);
				}

				if (channel3.isClosed()) {
					break;
				}
			}

			System.out.println(CommandOutput);
			long endRefTime = System.currentTimeMillis() - startTime;
			System.out.println("Referentiel charge en : " + endRefTime + "ms.");

		} catch (Exception e) {
			System.out.println("Non Connecté");
		}

	}

	@FXML
	public void execScriptDirect(MouseEvent event) throws IOException, SQLException, InterruptedException {
		String nomScript = "", scriptPath = "";
		String boutonId = event.getSource().toString().replaceAll(".*id=", "").replaceAll(",.*", "");
		String appPath = welcomecontroller.getCachePath() + ""+PathSeparator+"MDVApp";
		if (boutonId.equals("execInfoAvant")) {
			nomScript = "infos_avant";
			scriptPath = appPath + ""+PathSeparator+"info"+PathSeparator+"" + nomScript + ".sql";
		} else if (boutonId.equals("execInfoApres")) {
			nomScript = "infos_apres";
			scriptPath = appPath + ""+PathSeparator+"info"+PathSeparator+"" + nomScript + ".sql";
		} else if (boutonId.equals("execRegul")) {
			nomScript = "regul";
			scriptPath = appPath + ""+PathSeparator+"Cache"+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"" + nomScript + ".sql";
		}
		Optional<ButtonType> result = welcomecontroller.MyAlert(AlertType.CONFIRMATION, "Confirmation!!!!",
				"Voulez vous executer " + nomScript + "?",
				"Base de données : " + dbDAO.getDatabaseById(session.getKit().getDatabase().getId()).getSchemaDB());
		if (result.get() == ButtonType.OK) {
			welcomecontroller.getOnTopPane().setVisible(true);
			String logflPath = appPath + ""+PathSeparator+"Cache"+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"logs"+PathSeparator+"" + nomScript
					+ "_log.txt";
//			String cmd = "CMD /C mkdir " + appPath + ""+PathSeparator+"Cache"+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"" + "logs";
//			Runtime.getRuntime().exec(cmd);
			new File(appPath + ""+PathSeparator+"Cache" + ""+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"" + "logs").mkdirs();
			File logfile = null;

			List<String> flines = null;
			try {
				logfile = new File(logflPath);
				logfile.createNewFile();
				flines = FileUtils.readLines(new File(scriptPath), "UTF-8");
			} catch (IOException e) {
				welcomecontroller.MyAlert(AlertType.WARNING, "Erreur",
						"Verifier si le chemin '" + scriptPath + "' exist!!",
						"Verifier si le fichier  : '" + nomScript + ".sql' exist dans le chemin!!");
				welcomecontroller.getOnTopPane().setVisible(false);
				return;
			}

			List<String> loglines = new LinkedList<String>();

			Connection cnx = session.getCnxNew();
			Statement ps = cnx.createStatement();
			int step = 1;
			double progressVal = 0;
			for (String line : flines) {
				progressVal = ((double) step / flines.size()) * 100;
				welcomecontroller.getOnTopProgressbar().setProgress(progressVal);
				welcomecontroller.getOnTopProgressLabel().setText(new DecimalFormat("##.##").format(progressVal) + "%");
				if (!line.isEmpty()) {
					try {
						ps.executeQuery(line);
						// System.out.println("bien : "+line);
						loglines.add("succes : -----\n" + line + "\n----------\n");
					} catch (SQLException e) {
						loglines.add("erreur à la ligne :" + step + "-----\n" + line + ";\n" + e.getMessage()
								+ "\n----------\n");
						// System.out.println("erreur Ã  : "+line);
						// e.printStackTrace();
					}
				}
				step++;
			}

			welcomecontroller.getOnTopPane().setVisible(false);
			FileUtils.writeLines(logfile, "UTF-8", loglines);
			if (boutonId.equals("execInfoAvant")) {
				try {
					dataExportService.exportData(cnx, "SELECT * FROM MDV11_DATA_CONTROL_ORIG", nomScript);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else if (boutonId.equals("execInfoApres")) {
				try {
					dataExportService.exportData(cnx, "SELECT * FROM MDV11_DATA_CONTROL_TARGET", nomScript);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			cnx.close();
			welcomecontroller.MyAlert(AlertType.INFORMATION, "Execution terminée", "Fin d'execution",
					"Fichier log : " + logflPath);
		}
	}

	@FXML
	public void showScripts() throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Historique");
	}

	@FXML
	public void createDB() throws IOException { // modify DB
//		DbShooser.setVisible(true);
		if (dataBaseBtn.getText().equals("Créer")) {

			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "creation_base_de_donnee");
		}

		if (dataBaseBtn.getText().equals("Modifier")) {
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "modification_base_de_donnee");

//			System.out.println("before  "+session.getKit());
//			dbDAO.delete(session.getKit().getDatabase());
//			session.setKit(kitDAO.findById(1L).get());
//			System.out.println("after  "+session.getKit());

		}
	}

	@FXML
	public void goBack() throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kits de migration");
	}

	@FXML
	public void delete() throws IOException {

		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Confirmation!!!!");
		alert.setHeaderText("Voulez vous Supprimer ce kit ?");
		alert.setContentText("tous les données liées vont être supprimées!!!!");

		Optional<ButtonType> result = alert.showAndWait();
		if (result.get() == ButtonType.OK) {
			kitDAO.delete(kit);
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kits de migration");
		}
	}

	@FXML
	public void deleteDB() throws IOException {
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Confirmation!!!!");
		alert.setHeaderText("Voulez vous Supprimer cette base de données ?");

		Optional<ButtonType> result = alert.showAndWait();
		if (result.get() == ButtonType.OK) {
			Long tmpDBId = session.getKit().getDatabase().getId();
			session.getKit().setDatabase(null);
			kitDAO.save(session.getKit());
			dbDAO.deleteById(tmpDBId);
			System.out.println("after delete " + session.getKit().getId());
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "kit_info");
		}
	}

	@FXML
	public void showDBInfo(MouseEvent t) {
		welcomecontroller.setAndShowMessage(t, "IP : " + session.getKit().getDatabase().getHote() + "\nSID : "
				+ session.getKit().getDatabase().getSid() + "\nPort : " + session.getKit().getDatabase().getPort()
				+ "\nSchema : " + session.getKit().getDatabase().getSchemaDB() + "\nType : "
				+ session.getKit().getDatabase().getTypeDB(), t.getSceneX() - 150, t.getSceneY() - 70);
	}

	public void hideDBInfo(MouseEvent t) {
		welcomecontroller.hideMessage(t);
		;
	}

}
