package com.sopraMdv.anotherProject.Controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Optional;
import java.util.Scanner;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;

import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.FileHistory;

import antlr.debug.Event;
import ch.qos.logback.core.net.SyslogOutputStream;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.stage.DirectoryChooser;

@Controller
public class HistoriqueController {

	private static final String PathSeparator = System.getProperty("file.separator");

	private File directory = Paths.get(System.getProperty("user.home")).toFile();

	@FXML
	private Pane listelements;

	@FXML
	private ImageView img;

	@FXML
	private ImageView goBackImg;

	@FXML
	private ImageView startImg;

	@FXML
	private Label nomdbLabel;

	@FXML
	private Label nomKitLabel;

	private DataBaseDAO dbDAO;

	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}

	private Session session;

	private FileHistoryDAO fileDao;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}

	private KitDAO kitdao;

	public KitDAO getKitdao() {
		return kitdao;
	}

	@Autowired
	public void setKitdao(KitDAO kitdao) {
		this.kitdao = kitdao;
	}

	private WelcomeController welcomecontroller;

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	public Session getSession() {
		return session;
	}

	private MainController mainController;

	public MainController getMainController() {
		return mainController;
	}

	@Autowired
	public void setMainController(MainController mainController) {
		this.mainController = mainController;
	}

	private ExecuteFileController executefile;

	public ExecuteFileController getExecutefile() {
		return executefile;
	}

	@Autowired
	public void setExecutefile(ExecuteFileController executefile) {
		this.executefile = executefile;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	@FXML
	private void initialize() {
		img.setImage(new Image("/Resources/gear1.png", false));
		goBackImg.setImage(new Image("/Resources/back-arrow.png", false));
		startImg.setImage(new Image("/Resources/fa-play.png", false));
		nomKitLabel.setText(session.getKit().getNomKit());
		if (session.getKit().getDatabase() != null)
			nomdbLabel.setText("Base de données : " + session.getKit().getDatabase().getSid());

		loadScripts();
	}

	public void loadScripts() {
		try {
			for (FileHistory element : fileDao.getAllFiles(session.getKit().getId())) {
				AddElemnt(element);
			}
			String[] scriptsUnExecuted = session.getKit().getScripts().split(";");
			FileHistory tmpFile = new FileHistory();
			for (String element : scriptsUnExecuted) {
				if (!element.equals("")) {
					tmpFile.setFileName(element);
					AddElemnt(tmpFile);
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void AddElemnt(FileHistory file) throws IOException {

		double progressVal;
		AnchorPane element = new AnchorPane();
		element.setPrefHeight(50);
		element.setPrefWidth(880);

		welcomecontroller.loadInMainPane(element, "Historique_element");
		Label nom = (Label) element.lookup("#nomLabel");
		Label idh = (Label) element.lookup("#idlabel");
		Label statusLabel = (Label) element.lookup("#label");
		Label chosebtn = (Label) element.lookup("#chosebtn");
		ImageView deletebtn = (ImageView) element.lookup("#deletebtn");
		ImageView fileimg = (ImageView) element.lookup("#img");
		ProgressBar progress = (ProgressBar) element.lookup("#progress");
		Label progressLabel = (Label) element.lookup("#progressLabel");

		if (file.getId() != null) {

			nom.setText(file.getFileName());

			idh.setText(file.getId().toString());

			if (session.getKit().getDatabase() != null)
				statusLabel.setText(session.getKit().getDatabase().getSid());

			progress.setProgress((float) file.getCurrentline() / file.getLines());

			progressVal = ((double) file.getCurrentline() / file.getLines()) * 100;
			if (progressVal > 100)
				progressVal = 100;
			progressLabel.setText((new DecimalFormat("##.##")).format(progressVal) + "%");

			if (file.getCurrentline() >= file.getLines()) {
				fileimg.setImage(new Image("/Resources/check-mark.png", false));
				statusLabel.setText("Terminé");
				chosebtn.setVisible(false);
			} else {
				fileimg.setImage(new Image("/Resources/working.png", false));
				statusLabel.setText("En cours");
			}

			fileimg.setOnMousePressed((MouseEvent t) -> {
				String dateFin = "";
				if (file.getDateFin() != null) {
					dateFin = "\nDate Fin : " + file.getDateFin();
				}
//				String envnom = dbDAO.getDatabaseById(file.getDatabase().getId()).getServer().getEnvi().getNomEnv();
				welcomecontroller.setAndShowMessage(t,
						"Fichier : " + file.getFileName() + "\nLog path : " + file.getLogpath()
								+ "\nnombre de lignes : " + file.getLines() + "\nligne atteinte : "
								+ file.getCurrentline() + "\nDate debut : " + file.getDateDebut() + dateFin,
						t.getSceneX() - 150, t.getSceneY() - 70);
			});
			fileimg.setOnMouseReleased((MouseEvent t) -> {
				welcomecontroller.hideMessage(t);
			});
			chosebtn.setOnMouseClicked((MouseEvent t) -> {

				// continue executing file
				try {
//					session.getKit().setDatabase(file.getDatabase());
					session.setCnx(session.getCnxNew());
					if (session.getCnx() != null) {
						session.setIdFile(Long.parseLong(idh.getText()));
						session.setExePaused(0);
						mainController.setSelectedFile(new java.io.File(file.getPath()));
						session.setScanner(getScanner(file));
						session.setLine(file.getCurrentline());
						welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Scripts");
						welcomecontroller.loadInMainPane(mainController.getViewPane(), "ExecuteInterface");
						mainController.showDialog();
						//////////////
						///// Showing movingGears
						welcomecontroller.getMovingGears().setVisible(true);
						welcomecontroller.getOnTopPane().setVisible(true);
						/////
						welcomecontroller.getOnTopScriptName().setText(file.getFileName());

						executefile.continueScript();
					} else
						System.out.println("verifier la connection a la BD");
					////////////////
				} catch (IOException | NumberFormatException | SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			});
			deletebtn.setVisible(false);
			deletebtn.setOnMouseClicked((MouseEvent t) -> {
				Alert alert = new Alert(AlertType.CONFIRMATION);
				alert.setTitle("Confirmation!!!!");
				alert.setHeaderText("Voulez vous Supprimer ce fichier ?");

				Optional<ButtonType> result = alert.showAndWait();
				if (result.get() == ButtonType.OK) {
					com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
							fileDao.getFileById(Long.parseLong(idh.getText())));
					fileDao.delete(fichier);
					//// delete fichier from kit(filesexecutes)
					Set<FileHistory> tmp = new HashSet<FileHistory>();
					for (FileHistory tmpelement : session.getKit().getFilesExecutes()) {
						//System.out.println("|" + tmpelement.getId() + "||" + fichier.getId() + "|");
						if (!tmpelement.getId().equals(fichier.getId())) {
							tmp.add(tmpelement);
						}
					}
					session.getKit().setFilesExecutes(tmp);
					//////////////////////
					try {
						welcomecontroller.getMessagePane().setVisible(false);
						welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Historique");
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			});
			deletebtn.setOnMouseEntered((MouseEvent t) -> {
				welcomecontroller.setAndShowMessage(t, "supprimer", t.getSceneX() - 180, t.getSceneY() - 70);
			});
			deletebtn.setOnMouseExited((MouseEvent t) -> {
				welcomecontroller.hideMessage(t);
			});
			statusLabel.setOnMouseClicked((MouseEvent e) -> {
				if (e.getClickCount() == 3) {
					if (deletebtn.isVisible())
						deletebtn.setVisible(false);
					else
						deletebtn.setVisible(true);
				}
			});
		} else {
			chosebtn.setVisible(false);
			deletebtn.setVisible(false);
			progress.setVisible(false);
			progressLabel.setVisible(false);

			nom.setText(file.getFileName());
			fileimg.setImage(new Image("/Resources/progress-arrows.png", false));
		}

		listelements.getChildren().add(element);

	}

	public Scanner getScanner(FileHistory fichier) throws FileNotFoundException, IOException {
		int a = 0;
		FileReader file = null;
		try {
			file = new FileReader(mainController.getSelectedFile().getCanonicalPath());
		} catch (Exception ex) {
			Alert alert = new Alert(AlertType.ERROR);
			alert.setTitle("erreur ");
			alert.setHeaderText("fichier non trouvé");
			alert.setContentText(ex.getMessage());
			alert.showAndWait();
			session.setExePaused(2);
		}
		Scanner sc = new Scanner(file);
		if (fichier.getCurrentline() == 0)
			return sc;
		while (sc.hasNext()) {
			sc.nextLine();
			a++;
			if (a == fichier.getCurrentline())
				break;
		}
		return sc;
	}

	@FXML
	public void executeKit() throws IOException, SQLException {
		session.setFileDone(false);
		for (FileHistory element : fileDao.getAllFiles(session.getKit().getId())) {
			File file;
			// System.out.println(element);
			if (element.getCurrentline() < element.getLines()) {
				file = new File(element.getPath());

				session.setExePaused(0);
				session.setIdFile(element.getId());
				session.setLine(element.getCurrentline());
				mainController.setSelectedFile(file);
				welcomecontroller.getOnTopScriptName().setText(element.getFileName());
				///// Showing movingGears
				welcomecontroller.getMovingGears().setVisible(true);
				welcomecontroller.getOnTopPane().setVisible(true);
				/////

				session.setScanner(getScanner(element));
				executefile.continueScript_Sequential();
				if (!session.isFileDone()) {
					return;
				}
			}
		}

		String[] scriptsUnExecuted = session.getKit().getScripts().split(";");
		File file;
		String Cashpath = welcomecontroller.getCachePath() + "" + PathSeparator + "MDVApp" + PathSeparator + "Cache"
				+ PathSeparator + "";
		// System.out.println(scriptsUnExecuted);
		if (session.getKit().getDatabase() == null) {
			Alert alert = new Alert(AlertType.ERROR);
			alert.setContentText("vous avez oublié de choisir une base de données!!");
			alert.showAndWait();
		} else {
			for (String element : scriptsUnExecuted) {
				if (!element.equals("")) {

					session.setExePaused(0);
					session.setLine(0L);
					file = new File(Cashpath + "" + PathSeparator + "" + session.getKit().getNomKit() + ""
							+ PathSeparator + "" + "scripts" + PathSeparator + "" + element);
					mainController.setSelectedFile(file);
					welcomecontroller.getOnTopScriptName().setText(element);
					///// Showing movingGears
					welcomecontroller.getMovingGears().setVisible(true);
					welcomecontroller.getOnTopPane().setVisible(true);
					/////

					executefile.executeScript_Sequential(file);
					if (!session.isFileDone()) {
						return;
					}
				}
			}
		}
		welcomecontroller.stopScript(1);
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Historique");
	}

	@FXML
	public void getDirectory() throws IOException {

		String Cashpath = welcomecontroller.getCachePath() + "" + PathSeparator + "MDVApp" + PathSeparator + "Cache"
				+ PathSeparator + "";
//		String cmd = "CMD /C mkdir " + Cashpath + ""+PathSeparator+"" + session.getKit().getNomKit();
//		Runtime.getRuntime().exec(cmd);
		new File(Cashpath + "" + PathSeparator + "" + session.getKit().getNomKit()).mkdirs();
//		cmd = "CMD /C mkdir " + Cashpath + ""+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"" + "scripts";
//		Runtime.getRuntime().exec(cmd);
		new File(
				Cashpath + "" + PathSeparator + "" + session.getKit().getNomKit() + "" + PathSeparator + "" + "scripts")
						.mkdirs();
//		cmd = "CMD /C mkdir " + Cashpath + ""+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"" + "logs";
//		Runtime.getRuntime().exec(cmd);
		new File(Cashpath + "" + PathSeparator + "" + session.getKit().getNomKit() + "" + PathSeparator + "" + "logs")
				.mkdirs();
//		cmd = "CMD /C mkdir " + Cashpath + ""+PathSeparator+"" + session.getKit().getNomKit() + ""+PathSeparator+"" + "resultats";
//		Runtime.getRuntime().exec(cmd);
		new File(Cashpath + "" + PathSeparator + "" + session.getKit().getNomKit() + "" + PathSeparator + ""
				+ "resultats").mkdirs();

		DirectoryChooser chooser = new DirectoryChooser();
		directory = chooser.showDialog(null);
		File[] files = directory.listFiles();
		//trier les fichiers
		Arrays.sort(files, (f1, f2) -> f1.compareTo(f2));
		if (directory != null) {
			session.getKit().setScripts("");
			// System.out.println("2 |"+directory);
			for (File element : files) {
				if (element.isFile() && element.getName().endsWith(".sql")) {
					session.getKit().setScripts(session.getKit().getScripts() + ";" + element.getName());
					kitdao.save(session.getKit());
					Files.copy(Paths.get(element.getCanonicalPath()),
							Paths.get(Cashpath + "" + PathSeparator + "" + session.getKit().getNomKit() + ""
									+ PathSeparator + "scripts" + PathSeparator + "" + element.getName()),
							StandardCopyOption.REPLACE_EXISTING);
//					cmd = "CMD /C COPY /Y " + "\"" + element.getCanonicalPath() + "\" \"" + Cashpath + ""+PathSeparator+""
//							+ session.getKit().getNomKit() + ""+PathSeparator+"scripts"+PathSeparator+"" + element.getName() + "\"";
//					Runtime.getRuntime().exec(cmd);
				}
			}
			listelements.getChildren().setAll();
			loadScripts();

			if (session.getKit().getScripts().startsWith(";")) {
				// System.out.println("3 |"+directory);
				session.getKit().setScripts(session.getKit().getScripts().substring(1));
				kitdao.save(session.getKit());
			}
		}

	}

	@FXML
	public void goBack() throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kit_info");
	}
}
