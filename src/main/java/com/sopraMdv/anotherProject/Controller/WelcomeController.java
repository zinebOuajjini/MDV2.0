package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.AnotherProjectApplication;
import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.dao.ServerDAO;
import com.sopraMdv.anotherProject.util.DBService;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.shape.Circle;
import javafx.stage.Stage;

@Controller
public class WelcomeController {


	@FXML
	private ImageView exit;

	@FXML
	private ImageView minimize;

	@FXML
	private ImageView logoSopra;

	@FXML
	private ImageView executebtn;

	@FXML
	private Pane imageChanger;

	@FXML
	private ImageView imageChangerIcon;

//	@FXML
//	private ImageView btnChooser;

	@FXML
	private ImageView stopBtn;
	
	@FXML
	private ImageView movingGears;

//	@FXML
//	private ImageView dbChooser;

	@FXML
	private AnchorPane ViewPane;

	@FXML
	private Circle profilePic;

	@FXML
	private Circle connectstate;

	@FXML
	private HBox controlPane;

	@FXML
	private Pane messagePane;

	@FXML
	private Label messageLabel;

	@FXML
	private Label kitlabel;
	
	@FXML
	private Pane onTopPane;

	@FXML
	private Label onTopScriptName;
	
	@FXML
	private ProgressBar onTopProgressbar;
	
	@FXML
	private Label onTopProgressLabel;

	@FXML
	private Label parametrage;

	@FXML
	private Label IdServ;

	@FXML
	private Label IdDB;

	private Session session;

	@FXML
	private AnchorPane mainpane;

	private double x, y;

	private boolean dbShow;// pour tester si il faut afficher dbLabel.

	private ExecuteFileController executefile;

	private ServerDAO serverdao;

	private DataBaseDAO dbDAO;

	@FXML
	private Label titre;


	private MainController mainController;

	public MainController getMainController() {
		return mainController;
	}

	@Autowired
	public void setMainController(MainController mainController) {
		this.mainController = mainController;
	}

	public boolean isDbShow() {
		return dbShow;
	}

	public void setDbShow(boolean dbShow) {
		this.dbShow = dbShow;
	}

	private SplitFileController splitfile;

	public SplitFileController getSplitfile() {
		return splitfile;
	}

	@Autowired
	public void setSplitfile(SplitFileController splitfile) {
		this.splitfile = splitfile;
	}

	private FileHistoryDAO fileDao;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}
	
	private HistoriqueController historiqueController;
	

	public HistoriqueController getHistoriqueController() {
		return historiqueController;
	}

	@Autowired
	public void setHistoriqueController(HistoriqueController historiqueController) {
		this.historiqueController = historiqueController;
	}

	public Label getTitre() {
		return titre;
	}

	public ImageView getStopBtn() {
		return stopBtn;
	}

	public void setStopBtn(ImageView stopBtn) {
		this.stopBtn = stopBtn;
	}
	
	public Pane getOnTopPane() {
		return onTopPane;
	}

	public void setOnTopPane(Pane onTopPane) {
		this.onTopPane = onTopPane;
	}

	public Label getOnTopScriptName() {
		return onTopScriptName;
	}

	public void setOnTopScriptName(Label onTopScriptName) {
		this.onTopScriptName = onTopScriptName;
	}

	public ProgressBar getOnTopProgressbar() {
		return onTopProgressbar;
	}

	public void setOnTopProgressbar(ProgressBar onTopProgressbar) {
		this.onTopProgressbar = onTopProgressbar;
	}

	public Label getOnTopProgressLabel() {
		return onTopProgressLabel;
	}

	public void setOnTopProgressLabel(Label onTopProgressLabel) {
		this.onTopProgressLabel = onTopProgressLabel;
	}

	public ImageView getMovingGears() {
		return movingGears;
	}

	public void setMovingGears(ImageView movingGears) {
		this.movingGears = movingGears;
	}



	public ExecuteFileController getExecutefile() {
		return executefile;
	}

	@Autowired
	public void setExecutefile(ExecuteFileController executefile) {
		this.executefile = executefile;
	}


	public Circle getConnectstate() {
		return connectstate;
	}

	public ImageView getExecutebtn() {
		return executebtn;
	}

	public void setExecutebtn(ImageView executebtn) {
		this.executebtn = executebtn;
	}

	public Pane getMessagePane() {
		return messagePane;
	}

	public Label getMessageLabel() {
		return messageLabel;
	}


	public Label getKitlabel() {
		return kitlabel;
	}


	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	public AnchorPane getMainpane() {
		return mainpane;
	}


	public ServerDAO getServerdao() {
		return serverdao;
	}

	@Autowired
	public void setServerdao(ServerDAO serverdao) {
		this.serverdao = serverdao;
	}

	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}

	private int transitionDirection;
	
	private DBService service;

	public DBService getService() {
		return service;
	}

	@Autowired
	public void setService(DBService service) {
		this.service = service;
	}

	@FXML
	private void initialize() {

		onTopPane.setVisible(false);

		executebtn.setVisible(false);
//		btnChooser.setVisible(false);
		stopBtn.setVisible(false);
//		dbChooser.setVisible(false);
		imageChanger.setVisible(false);
		session.setExePaused(2);
		executebtn.setImage(new Image("/Resources/fa-play.png", false));
//		btnChooser.setImage(new Image("/Resources/folder.png", false));
		stopBtn.setImage(new Image("/Resources/fa-stop.png", false));
//		dbChooser.setImage(new Image("/Resources/Choosedatabase.png", false));
		movingGears.setImage(new Image("/Resources/movingGears.gif", false));
		imageChangerIcon.setImage(new Image("/Resources/photo-camera.png", false));
		logoSopra.setImage(new Image("/Resources/logo.png", false));
		minimize.setImage(new Image("/Resources/mini.png", false));
		exit.setImage(new Image("/Resources/close.png", false));
		connectstate.setStyle("-fx-Fill : #ff0400");
		messagePane.setVisible(false);
		movingGears.setVisible(false);
		getCachePath();

		dbShow = false;

		transitionDirection = 0;
		session.setLine(0L);

//		if (user.getImageUrl() == null) {
//			profilePic.setFill(new ImagePattern(new Image("/Resources/profile.png", false)));
//		} else {
//			try {
//				profilePic.setFill(new ImagePattern(new Image(new File(user.getImageUrl()).toURI().toString(), false)));
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				System.out.println("erreur d'image");
//				profilePic.setFill(new ImagePattern(new Image("/Resources/profile.png", false)));
//			}
//		}

		// fire kitlabel OnMouseClick*****************
		FireAnEvent(kitlabel);
		// ************************************

	}

	public void exit() {
		if (session.getExePaused() == 2) {
			Optional<ButtonType> result = MyAlert(AlertType.CONFIRMATION, "Confirmation!!!!",
					"Voulez-vous sortire de l'application ?", null);
			if (result.get() == ButtonType.OK) {
				Stage stage = (Stage) exit.getScene().getWindow();
				stage.close();
				System.exit(1);
			}
		} else {
			MyAlert(AlertType.WARNING, "Attention!!!!", "Il faut arrêter le script !!",
					"Vous ne pouvez pas sortir parce qu'un fichier est en execution !!!");
		}

	}

	public void minimize() {
		// get a handle to the stage
		Stage stage = (Stage) minimize.getScene().getWindow();
		stage.setIconified(true);
	}

	public void moving(MouseEvent mouseEvent) {
		// move the stage
		controlPane.getScene().getWindow().setX(mouseEvent.getScreenX() + x);
		controlPane.getScene().getWindow().setY(mouseEvent.getScreenY() + y);
	}

	public void premoving(MouseEvent mouseEvent) {
		// record a delta distance for the drag and drop operation.
		x = (double) (controlPane.getScene().getWindow().getX() - mouseEvent.getScreenX());
		y = (double) (controlPane.getScene().getWindow().getY() - mouseEvent.getScreenY());
	}


	@FXML
public void press(MouseEvent event) throws IOException {
//
	String name = ((Label) event.getSource()).getText();
	mainpane.setPadding(new Insets(1000, 201.0, 0, 0));
//		 if (name.equals("Serveur")) {
//			name = verifyServer();
//		} else if (name.equals("Base de données")) {
//			name = verifyDB();
//		}
//
//		if (name.equals("Scripts")) {
//
//		} else {
//			executebtn.setVisible(false);
//			btnChooser.setVisible(false);
//			stopBtn.setVisible(false);
//			dbChooser.setVisible(false);
//
//		}
	loadInMainPane(mainpane, name);
}

//	@FXML
//	public void paramClicked(MouseEvent event) {
//		int i = 5;
//		AnimationTimer timer = new AnimationTimer() {
//			@Override
//			public void handle(long now) {
//				if (transitionDirection == 0) {
//
//					if (envlabel.getLayoutY() < 377)
//						envlabel.setLayoutY(envlabel.getLayoutY() + i - 2);
//					if (serverlabel.getLayoutY() < 430)
//						serverlabel.setLayoutY(serverlabel.getLayoutY() + i - 1);
//
//					dblabel.setLayoutY(dblabel.getLayoutY() + i);
//					if (session.getIdEnv() != null)
//						serverlabel.setVisible(true);
//					if (dbShow)
//						dblabel.setVisible(true);
//
//					envlabel.setVisible(true);
//
//					if (dblabel.getLayoutY() >= 483) {
//						transitionDirection = 1;
//						this.stop();
//					}
//				} else {
//					if (dblabel.getLayoutY() < 350)
//						dblabel.setVisible(false);
//					if (envlabel.getLayoutY() < 350)
//						envlabel.setVisible(false);
//					if (serverlabel.getLayoutY() < 350)
//						serverlabel.setVisible(false);
//					dblabel.setLayoutY(dblabel.getLayoutY() - i);
//					if (envlabel.getLayoutY() > 324)
//						envlabel.setLayoutY(envlabel.getLayoutY() - i + 2);
//					if (serverlabel.getLayoutY() > 324)
//						serverlabel.setLayoutY(serverlabel.getLayoutY() - i + 1);
//					if (dblabel.getLayoutY() <= 324) {
//						transitionDirection = 0;
//						this.stop();
//					}
//				}
//			}
//		};
//		timer.start();
//	}


	public void loadInMainPane(AnchorPane Apane, String minipane) throws IOException {
		if(minipane.equals("Kits de migration")) minipane = "Kits_de_migration";
		FXMLLoader fxmlLoader = new FXMLLoader(
				getClass().getResource("/com/sopraMdv/anotherProject/view/" + minipane + ".fxml"));
		fxmlLoader.setControllerFactory(AnotherProjectApplication.springContext::getBean);
		Node node = (Node) fxmlLoader.load();
		Apane.getChildren().setAll(node);
	}


	
	


	public void FireAnEvent(Node node) {
		// fire OnMouseClick*****************
		node.fireEvent(new MouseEvent(MouseEvent.MOUSE_CLICKED, node.getLayoutX(), node.getLayoutY(), node.getLayoutX(),
				node.getLayoutY(), MouseButton.PRIMARY, 1, true, true, true, true, true, true, true, true, true, true,
				null));
		// ***********************
	}

	@FXML
	public void showMessageScriptState(MouseEvent e) {
		if (session.getIdFile() != null)
			setAndShowMessage(e, "Script : " + fileDao.getFileById(session.getIdFile()).getFileName(), e.getX() + 40,
					e.getY() + 40);
		else {
			setAndShowMessage(e, "Aucun script selectionné", e.getX() + 40, e.getY() + 40);
			connectstate.setStyle("-fx-Fill : red");
		}
	}

	@FXML
	public void showMessageStart(MouseEvent e) {
		setAndShowMessage(e, "Executer", e.getX() + 470, e.getY() + 40);
	}

	@FXML
	public void showMessageStop(MouseEvent e) {
		setAndShowMessage(e, "Arrêter", e.getX() + 520, e.getY() + 40);
	}
	
	@FXML
	public void changeImage() {
		
	}

	@FXML
	public void hideMessage(MouseEvent event) {
		messagePane.setVisible(false);
	}

	public void setAndShowMessage(MouseEvent evn, String message, Double x, Double y) {
		messagePane.setLayoutX(x);
		messagePane.setLayoutY(y);
		messagePane.setVisible(true);
		messageLabel.setVisible(true);
		messageLabel.setText(message);
	}

	@FXML
	public void browse() throws IOException {

		mainController.showDialog();

	}

	@FXML
	public void runScript() throws IOException, SQLException {

		if (session.getKit().getDatabase().getId() != null) {
			if (session.getExePaused() == 2) {
				if (mainController.getSelectedFile() != null) {
					if (mainController.getSelectedFile().getName().endsWith(".sql")) {
						Optional<ButtonType> result = MyAlert(AlertType.CONFIRMATION, "Confirmation!!!!",
								"Voulez vous executer ce script(" + mainController.getSelectedFile().getName() + ")?",
								"Dans la BD : " + dbDAO.getDatabaseById(session.getKit().getDatabase().getId()).getSid());
						if (result.get() == ButtonType.OK) {
							session.setLine(0L);
							session.setCnx(session.getCnxNew());
							if (session.getCnx() != null) {
								loadInMainPane(mainController.getViewPane(), "ExecuteInterface");
								historiqueController.executeKit();
								//executefile.executeScript();
							}

						}
					} else {
						MyAlert(AlertType.WARNING, "Attention!!!!", null, "Script non valide (~_~) !!!");
					}
				} else {
					MyAlert(AlertType.WARNING, "Attention!!!!", "Ouuuups",
							"vous avez oubiez de selectionner le Script (°o°) !!!");
				}
			} else if (session.getExePaused() == 1) {
				session.setExePaused(0);
				executebtn.setImage(new Image("/Resources/pause.png", false));
				connectstate.setStyle("-fx-Fill : #2ffc69");
				titre.setText("En execution");
				executefile.continueScript();

			} else {
				executebtn.setImage(new Image("/Resources/fa-play.png", false));
				connectstate.setStyle("-fx-Fill : #F28400");
				titre.setText("En attante");
				session.setExePaused(1);
			}
		} else {
			MyAlert(AlertType.WARNING, "Attention!!!!", "Ouuuups", "vous avez oubiez de selectionner la DB (°o°) !!!");
		}

	}

	public void stopScript(int indecator) throws IOException, SQLException {
		if (session.getIdFile() != null) {
			Optional<ButtonType> result = null;
			if (indecator != 1) {
				result = MyAlert(AlertType.CONFIRMATION, "Confirmation!!!!", "Voulez vous arrêtter l'execution ?",
						null);
			}

			if (indecator == 1 || result.get() == ButtonType.OK) {
				////stopping movingGears
				movingGears.setVisible(false);
				onTopPane.setVisible(false);
				////
				
				loadInMainPane(mainController.getViewPane(), "home");
				session.setExePaused(2);
				mainController.setSelectedFile(null);
				mainController.setError(null);
				mainController.setLog(null);
				executebtn.setImage(new Image("/Resources/fa-play.png", false));
				executebtn.setVisible(true);
				connectstate.setStyle("-fx-Fill : #ff0400");
				titre.setText("Bienvenue");
				executebtn.setVisible(true);
				// mainController.getViewPane().getChildren().clear();
				session.setScanner(null);
				session.setIdFile(null);
				session.setCnx(null);
				session.setLine(null);
				if (mainController.getDirectory().getName().equals("Cache")) {
					mainController.setDirectory(null);
					mainController.getTreeView().setRoot(null);
				}
//				btnChooser.setVisible(false);
				stopBtn.setVisible(false);
//				dbChooser.setVisible(false);
				executebtn.setVisible(false);
				service.cancel();
				loadInMainPane(mainpane, "Historique");
			}
		}
	}

	@FXML
	public void stopScriptFxml() throws IOException, SQLException {
		stopScript(0);
	}

	public Optional<ButtonType> MyAlert(AlertType aType, String title, String header, String message) {
		Alert alert = new Alert(aType);
		alert.setTitle(title);
		alert.setHeaderText(header);
		alert.setContentText(message);

		return alert.showAndWait();
	}



	@FXML
	public void showImageChanger() throws IOException, SQLException {
		imageChanger.setVisible(true);
		imageChangerIcon.setVisible(true);
	}

	@FXML
	public void hideImageChanger() throws IOException, SQLException {
		imageChanger.setVisible(false);
		imageChangerIcon.setVisible(false);
	}

//	@FXML
//	public void changeImage(MouseEvent e) throws IOException, SQLException {
//		FileChooser chooser = new FileChooser();
//		FileChooser.ExtensionFilter imageFilter = new FileChooser.ExtensionFilter("Fichier Image", "*.jpg", "*.png",
//				"*.jpge");
//		chooser.setTitle("choisir votre Image.");
//		chooser.getExtensionFilters().add(imageFilter);
//		File ff = chooser.showOpenDialog(mainpane.getScene().getWindow());
//
//		if (ff != null) {
//			User uti = new User(userDao.getUserById(session.getIdUser()));
//			uti.setImageUrl(ff.getCanonicalPath());
//			userDao.save(uti);
//
//			try {
//				profilePic.setFill(new ImagePattern(new Image(ff.toURI().toString(), false)));
//			} catch (Exception ex) {
//
//				// System.out.println(ex.getMessage() + " \n ||erreur d'image");
//			}
//
//		}
//
//	}

	public String getCachePath() {
//		String myDocuments = null;
//
//		try {
//			Process p = Runtime.getRuntime().exec(
//					"reg query \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders\" /v personal");
//			p.waitFor();
//
//			InputStream in = p.getInputStream();
//			byte[] b = new byte[in.available()];
//			in.read(b);
//			in.close();
//
//			myDocuments = new String(b);
//			myDocuments = myDocuments.split("\\s\\s+")[4];
//			session.setAppLogPath(myDocuments);
//
//		} catch (Throwable t) {
//			t.printStackTrace();
//		}
//
//		return myDocuments;
		String path = System.getProperty("user.home");
		session.setAppLogPath(path);
		return path;
	}

}
