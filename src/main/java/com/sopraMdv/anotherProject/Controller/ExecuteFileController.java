package com.sopraMdv.anotherProject.Controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.FileHistory;
import com.sopraMdv.anotherProject.util.DBService;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.image.Image;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;

@Controller
public class ExecuteFileController {

	private static final String PathSeparator = System.getProperty("file.separator");

	@FXML
	private AnchorPane ViewPane;

	private DataBaseDAO dbDAO;

	private ExecuteFileController executefile;

	private ScriptManagerController scriptMangerController;

	private DataBaseConnexion dbconnexion;

	private MainController mainController;

	private SplitFileController splitfile;

	@FXML
	private TextArea consoleLog;

	@FXML
	private Pane executionPane;

	public Pane getExecutionPane() {
		return executionPane;
	}

	public void setExecutionPane(Pane executionPane) {
		this.executionPane = executionPane;
	}

	@FXML
	private TextArea queryProblem;

	private int i = 0;

	@FXML
	private Label addLabel;

	@FXML
	private Label editLabel;

	@FXML
	private Label commentLabel;

	@FXML
	private Label cancelLabel;

	private HistoriqueController historiqueController;

	public HistoriqueController getHistoriqueController() {
		return historiqueController;
	}

	@Autowired
	public void setHistoriqueController(HistoriqueController historiqueController) {
		this.historiqueController = historiqueController;
	}

	public ScriptManagerController getScriptMangerController() {
		return scriptMangerController;
	}

	@Autowired
	public void setScriptMangerController(ScriptManagerController scriptMangerController) {
		this.scriptMangerController = scriptMangerController;
	}

	public ExecuteFileController getExecutefile() {
		return executefile;
	}

	@Autowired
	public void setExecutefile(ExecuteFileController executefile) {
		this.executefile = executefile;
	}

	private DBService service;

	public DBService getService() {
		return service;
	}

	@Autowired
	public void setService(DBService service) {
		this.service = service;
	}

	public TextArea getQueryProblem() {
		return queryProblem;
	}

	public void setQueryProblem(TextArea queryProblem) {
		this.queryProblem = queryProblem;
	}

	public TextArea getConsoleLog() {
		return consoleLog;
	}

	public void setConsoleLog(TextArea consoleLog) {
		this.consoleLog = consoleLog;
	}

	public SplitFileController getSplitfile() {
		return splitfile;
	}

	@Autowired
	public void setSplitfile(SplitFileController splitfile) {
		this.splitfile = splitfile;
	}

	public MainController getMainController() {
		return mainController;
	}

	@Autowired
	public void setMainController(MainController mainController) {
		this.mainController = mainController;
	}

	@Autowired
	public void setDbconnexion(DataBaseConnexion dbconnexion) {
		this.dbconnexion = dbconnexion;
	}

	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}

	private KitDAO kitDAO;

	public KitDAO getKitDAO() {
		return kitDAO;
	}

	@Autowired
	public void setKitDAO(KitDAO kitDAO) {
		this.kitDAO = kitDAO;
	}

	private FileHistoryDAO fileDao;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}

	private WelcomeController welcomecontroller;

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	private Session session;

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	@FXML
	private void initialize() {
		consoleLog.setOnMouseClicked((MouseEvent t) -> {
			if (t.getButton().equals(MouseButton.PRIMARY)) {
				if (t.getClickCount() == 2) {
					try {
						openFilewith();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}

		});
	}

	public void openFilewith() throws IOException {

		if (System.getProperty("os.name").toLowerCase().contains("win")) {
			String filePath = "";
			if (session.getFileopenerPath() == null) {
				FileChooser chooser = new FileChooser();
				File fileopener = chooser.showOpenDialog(consoleLog.getScene().getWindow());
				filePath = fileopener.getCanonicalPath();
				session.setFileopenerPath(filePath);
			} else {
				filePath = session.getFileopenerPath();
			}
			FileHistory fh = new FileHistory(fileDao.getFileById(session.getIdFile()));
			try {
				if (filePath != null) {
					String cmd = "\"" + filePath + "\" " + fh.getPath() + " -n" + fh.getCurrentline();
					Runtime.getRuntime().exec(cmd);
				}
			} catch (IOException e) {
				Alert alert = new Alert(AlertType.WARNING);
				alert.setTitle("Problème!!");
				alert.setHeaderText("Problème d'ouverture du fichier");
				alert.setContentText("programme non valide!");

				alert.showAndWait();
			}
		}
	}

	public void startdbThread(Scanner sc, Connection cnx) {
		session.setScanner(sc);
		session.setFileDone(false);

		welcomecontroller.getOnTopProgressLabel().textProperty().bind(service.messageProperty());
		welcomecontroller.getOnTopProgressbar().progressProperty().bind(service.progressProperty());

		service.messageProperty().addListener(new ChangeListener<String>() {
			@Override
			public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
				// System.out.println("changer messageProperty :: " + oldValue + "|" +
				// newValue);
			}
		});
//		service.runningProperty().addListener(e -> {
//			if (session.isFileDone()) {
//				System.out.println("exiting file");
//				try {
//					System.out.println("starting next file");
//					historiqueController.executeKit();
//				} catch (IOException | SQLException e1) {
//					// TODO Auto-generated catch block
//					e1.printStackTrace();
//				}
//			}
//			System.out.println("changing stat : " + service.isRunning());
//			System.out.println("changing stat : " + service.getState());
//		});
		service.setOnFailed(e -> {
			System.out.println("failed");
			welcomecontroller.getOnTopProgressLabel().textProperty().unbind();
			welcomecontroller.getOnTopProgressbar().progressProperty().unbind();
		});
		service.setOnSucceeded(e -> {
			System.out.println("succeded");
			welcomecontroller.getOnTopProgressLabel().textProperty().unbind();
			welcomecontroller.getOnTopProgressbar().progressProperty().unbind();
			if (session.isFileDone()) {
				try {
					historiqueController.executeKit();
					// service.cancel();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		service.setOnCancelled(e -> {
			System.out.println("cancelled");
			welcomecontroller.getOnTopProgressLabel().textProperty().unbind();
			welcomecontroller.getOnTopProgressbar().progressProperty().unbind();
		});
		if (!service.getState().equals("RUNNING")) {// run service(test if its already running, in this case we do
													// noting)

			service.reset();
			service.start();
		}

	}

	// old
	public void executeScript() throws IOException, SQLException {

		i++;
		DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
		Date date = new Date();
		Scanner sc1 = new Scanner(new FileReader(mainController.getSelectedFile()));
		Long lines = 0L;
		while (sc1.hasNext()) {
			sc1.nextLine();
			lines++;
		}
		String fileName = null;
		String fileInCashpath = System.getProperty("user.dir") + "" + PathSeparator + "src" + PathSeparator + "main"
				+ PathSeparator + "java" + PathSeparator + "Cache" + PathSeparator + "";
		String dateDebut = dateFormat.format(date);
//		String cmd = "CMD /C COPY /Y " + "\"" + mainController.getSelectedFile().getCanonicalPath() + "\" \""
//				+ fileInCashpath + dateDebut + "_" + mainController.getSelectedFile().getName() + "\"";

		DirectoryChooser chooser = new DirectoryChooser();
		chooser.setTitle("choisir votre repertoire des Logs");
		File ff = chooser.showDialog(consoleLog.getScene().getWindow());
		if (ff != null) {
			fileName = mainController.getSelectedFile().getName();
			String cleanFile = ff.getCanonicalPath() + "" + PathSeparator + "" + dateDebut + "_"
					+ fileName.substring(0, fileName.length() - 4) + "_Corr.txt";
			File f = new File(cleanFile);
			String logFile = ff.getCanonicalPath() + "" + PathSeparator + "" + dateDebut + "_"
					+ fileName.substring(0, fileName.length() - 4) + "_Log.txt";

			File f1 = new File(logFile);

			f.createNewFile();
			f1.createNewFile();

//			System.out.println(cmd + "||" + Runtime.getRuntime().exec(cmd));

			com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory();
			fichier.setCurrentline(0L);
			fichier.setDateDebut(dateDebut);
			fichier.setFileName(fileName.substring(0, fileName.length() - 4));
			fichier.setLines(lines);
			fichier.setPath(fileInCashpath + dateDebut + "_" + mainController.getSelectedFile().getName());
			fichier.setLogpath(ff.getCanonicalPath());
			// fichier.setDatabase(dbDAO.getDatabaseById(session.getKit().getDatabase().getId()));
			session.setIdFile(fileDao.save(fichier).getId());
			System.out.println(session.getIdFile());

			FileReader file = new FileReader(mainController.getSelectedFile().getCanonicalPath());
			Scanner sc = new Scanner(file);

			// Connection cnx = connectDB(session.getIdDB());

			welcomecontroller.getExecutebtn().setImage(new Image("/Resources/pause.png", false));
			session.setExePaused(0);
			welcomecontroller.getExecutebtn().setImage(new Image("/Resources/pause.png", false));
			welcomecontroller.getConnectstate().setStyle("-fx-Fill : #2ffc69");
			welcomecontroller.getTitre().setText("En execution");

			splitfile.ExtractQuery(sc, session.getCnx());
		}
		sc1.close();

	}

	public void continueScript() throws FileNotFoundException, SQLException {

		System.out.println(session.getScanner());
		// Connection cnx = connectDB(session.getIdDB());
		if (session.getCnx() == null || session.getCnx().isClosed()) {

			session.setCnx(session.getCnxNew());
		}

		/// mise à jour de la table File (currentLine)
		com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
				fileDao.getFileById(session.getIdFile()));
		fichier.setCurrentline(session.getLine());
		if (session.getLine() != null) {
			fileDao.save(fichier);
		}
		///////////////////// fin mise à jour
		welcomecontroller.getExecutebtn().setImage(new Image("/Resources/pause.png", false));
		welcomecontroller.getConnectstate().setStyle("-fx-Fill : #2ffc69");
		welcomecontroller.getTitre().setText("En execution");

		executefile.getQueryProblem().setText("");
		executefile.getConsoleLog().setText("");

		session.setExePaused(0);

		// splitfile.ExtractQuery(session.getScanner(), session.getCnx());
		startdbThread(session.getScanner(), session.getCnx());

	}

	public void executeScript_Sequential(File scriptfile) throws IOException, SQLException {

		i++;
		DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
		Date date = new Date();
		String dateDebut = dateFormat.format(date);
		Long lines = 0L;
		try {
			Scanner sc1 = new Scanner(new FileReader(scriptfile));
			while (sc1.hasNext()) {
				sc1.nextLine();
				lines++;
			}
			sc1.close();
		} catch (Exception e) {
			Alert alert = new Alert(AlertType.ERROR);
			alert.setTitle("erreur : fichier ");
			alert.setHeaderText("erreur :  fichier non trouvé");
			alert.setContentText(e.getMessage());
			alert.showAndWait().get();
			welcomecontroller.getMovingGears().setVisible(false);
			welcomecontroller.getOnTopPane().setVisible(false);
			session.setExePaused(2);
			return;
		}
		String fileName = null;
		String Cashpath = welcomecontroller.getCachePath() + "" + PathSeparator + "MDVApp" + PathSeparator + "Cache"
				+ PathSeparator + "";

		String filesInCashpath = Cashpath + session.getKit().getNomKit() + "" + PathSeparator + "" + "scripts"
				+ PathSeparator + "";

		String logPath = Cashpath + session.getKit().getNomKit() + "" + PathSeparator + "" + "logs" + PathSeparator
				+ "";

		String resPath = Cashpath + session.getKit().getNomKit() + "" + PathSeparator + "" + "resultats" + PathSeparator
				+ "";

		fileName = scriptfile.getName();
		String cleanFile = resPath + fileName;
		File f = new File(cleanFile);
		String logFile = logPath + "" + PathSeparator + "" + fileName.substring(0, fileName.length() - 4) + "_Log.txt";
		File f1 = new File(logFile);

		f.createNewFile();
		f1.createNewFile();

		com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory();
		fichier.setKit(session.getKit());
		fichier.setCurrentline(0L);
		fichier.setDateDebut(dateDebut);
		fichier.setFileName(fileName);
		fichier.setLines(lines);
		fichier.setPath(filesInCashpath + fileName);
		fichier.setLogpath(logPath);
		// fichier.setDatabase(session.getKit().getDatabase());
		session.setIdFile(fileDao.save(fichier).getId());

		// remove the script from field'kit.scripts)
		String str = session.getKit().getScripts();
		str = str.replace(scriptfile.getName(), "");
		str = str.replaceAll(";;", ";");
		session.getKit().setScripts(str);
		kitDAO.save(session.getKit());
		//////////////////////////

		// System.out.println(session.getIdFile());

		FileReader file = new FileReader(scriptfile.getCanonicalFile());
		Scanner sc = new Scanner(file);

		// Connection cnx = connectDB(session.getIdDB());

		session.setExePaused(0);
		welcomecontroller.getExecutebtn().setImage(new Image("/Resources/pause.png", false));
		welcomecontroller.getConnectstate().setStyle("-fx-Fill : #2ffc69");
		welcomecontroller.getTitre().setText("En execution");
		// load executeInterface
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Scripts");
		welcomecontroller.loadInMainPane(mainController.getViewPane(), "ExecuteInterface");
		mainController.showDialog();
		if (session.getCnx() == null) {
			session.setCnx(session.getCnxNew());
		}

		// splitfile.ExtractQuery(sc, session.getCnx());
		startdbThread(sc, session.getCnx());

	}

	public void continueScript_Sequential() throws SQLException, IOException {

		// Connection cnx = connectDB(session.getIdDB());
		if (session.getCnx() == null || session.getCnx().isClosed()) {

			session.setCnx(session.getCnxNew());
		}

		/// mise à jour de la table File (currentLine)
		// com.sopraMdv.anotherProject.entities.FileHistory fichier = new
		// com.sopraMdv.anotherProject.entities.FileHistory(
		// fileDao.getFileById(session.getIdFile()));
		// fichier.setCurrentline(session.getLine());
		// fileDao.save(fichier);
		///////////////////// fin mise à jour
		welcomecontroller.getExecutebtn().setImage(new Image("/Resources/pause.png", false));
		welcomecontroller.getConnectstate().setStyle("-fx-Fill : #2ffc69");
		welcomecontroller.getTitre().setText("En execution");

		session.setExePaused(0);

		// load executeInterface
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Scripts");
		welcomecontroller.loadInMainPane(mainController.getViewPane(), "ExecuteInterface");
		mainController.showDialog();
		executefile.getQueryProblem().setText("");
		executefile.getConsoleLog().setText("");

		// splitfile.ExtractQuery(session.getScanner(), session.getCnx());
		startdbThread(session.getScanner(), session.getCnx());
	}

	public Connection connectDB(Long id) throws SQLException {

		DataBase database = dbDAO.getDatabaseById(id);
		return dbconnexion.connectDB(database);

	}

	/* OnMouseClicked Handlers */
	@FXML
	public void addScript() throws SQLException, IOException {
		String str = queryProblem.getText();
		if (session.getCnx().isClosed()) {
			session.setCnx(session.getCnxNew());
		}
		///// Showing movingGears
		welcomecontroller.getMovingGears().setVisible(true);
		welcomecontroller.getOnTopPane().setVisible(true);
		/////

//		if (str.endsWith(";")) {
//			str = str.replace(str.substring(str.length() - 1), "");
//		}
		try {

			dbconnexion.executeQuery(str, session.getCnx());

//			/// mise à jour de la table File (currentLine)
//			com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
//					fileDao.getFileById(session.getIdFile()));
//			fichier.setCurrentline(session.getLine());
//			fileDao.save(fichier);
//			///////////////////// fin mise à jour
//			welcomecontroller.getExecutebtn().setVisible(false);
//			// continuer l'execution
//			continueScript_Sequential();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			if (session.getCnx() == null || session.getCnx().isClosed()) {
				return;
			}
			System.out.println("a warning occurred;");
		}
		com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
				fileDao.getFileById(session.getIdFile()));
		fichier.setCurrentline(session.getLine());
		if (session.getLine() != null) {
			fileDao.save(fichier);
		}
		///////////////////// fin mise à jour
		welcomecontroller.getExecutebtn().setVisible(false);
		continueScript_Sequential();
	}

	public void editScript() {
		System.out.println("Editing script loading ... ");
	}

	@FXML
	public void IgnoreScript() throws IOException, SQLException, InterruptedException {

		///// Showing movingGears
		welcomecontroller.getMovingGears().setVisible(true);
		welcomecontroller.getOnTopPane().setVisible(true);
		/////

		String joinString1 = "/* ****************** ignoré !!!!! *****************\n" + queryProblem.getText()
				+ "\n***********************!!!!!********************* */\n";
		// System.out.println(joinString1);
		com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
				fileDao.getFileById(session.getIdFile()));
		String Cashpath = welcomecontroller.getCachePath() + "" + PathSeparator + "MDVApp" + PathSeparator + "Cache"
				+ PathSeparator + "";
		String resPath = Cashpath + fichier.getKit().getNomKit() + "" + PathSeparator + "" + "resultats" + PathSeparator
				+ "";
		String cleanFile = resPath + fichier.getFileName();
		String logFile = fichier.getLogpath() + "" + PathSeparator + ""
				+ fichier.getFileName().substring(0, fichier.getFileName().length() - 4) + "_Log.txt";
		// Files.write(Paths.get(cleanFile), joinString1.getBytes(),
		// StandardOpenOption.APPEND);
		Files.write(Paths.get(logFile), joinString1.getBytes(), StandardOpenOption.APPEND);
		continueScript();
	}

	public void cancel() {
		System.out.println("Closing the PopUp.");
		Stage stage = (Stage) queryProblem.getScene().getWindow();
		stage.close();
	}

	// public void ContinueScript() throws SQLException {
	// welcomecontroller.getExecutebtn().setVisible(false);
	// // TODO Auto-generated method stub
	// Connection cnx = connectDB(session.getIdDB());
	// /// mise à jour de la table File (currentLine)
	// com.sopraMdv.anotherProject.entities.File fichier = new
	// com.sopraMdv.anotherProject.entities.File(
	// fileDao.getFileById(session.getIdFile()));
	// fichier.setCurrentline((long) splitfile.getA());
	// fileDao.save(fichier);
	// ///////////////////// fin mise à jour
	// splitfile.ExtractQuery(session.getScanner(), cnx);
	// }

	@FXML
	public void stopScript() throws SQLException, IOException {
		welcomecontroller.getExecutebtn().setVisible(false);
		welcomecontroller.stopScript(0);
	}

	@FXML
	public void launchPopUp() throws IOException {

		Stage popUp = PopUp.ScriptManagerPopUp();
		popUp.show();
		popUp.setOnCloseRequest(new EventHandler<WindowEvent>() {

			@Override
			public void handle(WindowEvent event) {
				scriptMangerController.setPopUpActive(false);
			}

		});
	}

}
