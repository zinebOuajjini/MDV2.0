package com.sopraMdv.anotherProject.Controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.util.FilePathTreeItem;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.Label;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TabPane;
import javafx.scene.control.TreeCell;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeView;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyCodeCombination;
import javafx.scene.input.KeyCombination;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;

@Controller
public class MainController {

	String initFolder = System.getProperty("user.home") + "\\Desktop";

	private File directory = Paths.get(initFolder).toFile();

	private FileOutputStream fos = null;

	private String data;

	@FXML
	private Label filenameLabel;

	@FXML
	private Label directoryLabel;

	@FXML
	private AnchorPane ViewPane;

	@FXML
	private TabPane tabPane;

	@FXML
	private VBox dirArchitecture;

	private ArrayList<String> openedfiles = new ArrayList<>();

	// private TabPane openedTabPane;

	Queue<Integer> findedNumberLine = new PriorityQueue<>();

	private Session session;

	private final ContextMenu contextMenu = new ContextMenu();

	public AnchorPane getViewPane() {
		return ViewPane;
	}

	public void setViewPane(AnchorPane viewPane) {
		ViewPane = viewPane;
	}

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	public File getDirectory() {
		return directory;
	}

	public void setDirectory(File directory) {
		this.directory = directory;
	}

	private DataBaseConnexion dbconnexion;

	private WelcomeController welcomecontroller;

	KeyCodeCombination saveKcc = new KeyCodeCombination(KeyCode.S, KeyCombination.CONTROL_DOWN);

	KeyCodeCombination findKcc = new KeyCodeCombination(KeyCode.F, KeyCombination.CONTROL_DOWN);

	Scanner scanner = null;

	private String log = null, error = null;

	public String getLog() {
		return log;
	}

	public void setLog(String log) {
		this.log = log;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	private TreeView<String> treeView = null;

	public TreeView<String> getTreeView() {
		return treeView;
	}

	public void setTreeView(TreeView<String> treeView) {
		this.treeView = treeView;
	}

	private ExecuteFileController executefile;

	public ExecuteFileController getExecutefile() {
		return executefile;
	}

	@Autowired
	public void setExecutefile(ExecuteFileController executefile) {
		this.executefile = executefile;
	}


	@FXML
	private ComboBox<DataBase> DBs;

	@FXML
	private Label errorLabel;

	@FXML
	private Pane EnvPopUp;

	public Pane getEnvPopUp() {
		return EnvPopUp;
	}

	public void setEnvPopUp(Pane envPopUp) {
		EnvPopUp = envPopUp;
	}

	private TabPane openedTabPane;

	private File selectedFile;

	public File getSelectedFile() {
		return selectedFile;
	}

	public void setSelectedFile(File selectedFile) {
		this.selectedFile = selectedFile;
	}

	@Autowired
	public void setDbconnexion(DataBaseConnexion dbconnexion) {
		this.dbconnexion = dbconnexion;
	}

	private DataBaseDAO dbDAO;

	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}

	public void setOpenedfiles(ArrayList<String> openedfiles) {
		this.openedfiles = openedfiles;
	}

	public ArrayList<String> getOpenedfiles() {
		return openedfiles;
	}

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	@FXML
	private void initialize() throws IOException, SQLException {
		
//		if (session.getKit().getDatabase() != null) {
//		EnvPopUp.setVisible(false);
//		}
		// welcomecontroller.loadInMainPane(ViewPane, "home");
		if (session.getExePaused() != 1) {
			welcomecontroller.getExecutebtn().setVisible(true);
		}
//		welcomecontroller.getBtnChooser().setVisible(true);
		welcomecontroller.getStopBtn().setVisible(true);
		//welcomecontroller.getDbChooser().setVisible(true);


		/////////////// ouvrir un fichier
		if (contextMenu.getItems().isEmpty()) {
			MenuItem open = new MenuItem("Ouvrir");
			MenuItem openwith = new MenuItem("Ouvrir avec ...");
			contextMenu.getItems().addAll(open);
			contextMenu.getItems().addAll(openwith);
			open.setOnAction(new EventHandler<ActionEvent>() {
				@Override
				public void handle(ActionEvent event) {
					openFile();
				}
			});
			openwith.setOnAction(new EventHandler<ActionEvent>() {

				@Override
				public void handle(ActionEvent event) {
					openFilewith();
				}

			});
		}
		///////////////////////////////////
		openedfiles.clear();

		if (log != null && error != null) {
			executeFile();
			executefile.getConsoleLog().setText(error);
			executefile.getQueryProblem().setText(log);
		}
		if (treeView != null) {
			dirArchitecture.getChildren().clear();
			dirArchitecture.getChildren().addAll(directoryLabel, treeView);
		}

	}


	@FXML
	private void EnvOk(MouseEvent e) throws IOException {
		DataBase selectedDB = DBs.getValue();

		if (selectedDB != null) {

			session.getKit().setDatabase(selectedDB);
			EnvPopUp.setVisible(false);

		} else {
			errorLabel.setText("Aucune Base de données selectionnée !!!!");
		}
	}

	@FXML
	private void EnvCancel(MouseEvent e) throws IOException {
		EnvPopUp.setVisible(false);
		// welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "home");
	}

	@FXML
	public void showDialog() throws IOException {

		if (session.getExePaused() == 0) {
			directory = selectedFile.getParentFile();
		} else {
			DirectoryChooser chooser = new DirectoryChooser();
			chooser.setInitialDirectory(new File(initFolder));
			directory = chooser.showDialog(null);
		}

		if (directory != null) {
			TreeItem<String> treeItem = new TreeItem<String>(directory.getName(),
					new ImageView(new Image(getClass().getResource("/Resources/computer.png").toExternalForm())));

			for (File name : directory.listFiles()) {

				if (name.exists()) {
					listChildren(name, treeItem);
				} else {

					System.out.println("Alert : Le dossier n'existe pas!!");

				}
			}
			treeView = new TreeView<String>(treeItem);
			treeView.setPrefHeight(1500);
			treeItem.setExpanded(true);
			EventHandler<MouseEvent> mouseEventHandle = (MouseEvent event) -> {
				if (event.getButton() == MouseButton.SECONDARY) {
					handleMouseClicked(event);
				}
				if (event.getButton().equals(MouseButton.PRIMARY)) {
					contextMenu.hide();
					if (event.getClickCount() == 2 && selectedFile != null && selectedFile.isFile()) {
						openFile();
					}
				}

			};
			treeView.addEventHandler(MouseEvent.MOUSE_CLICKED, mouseEventHandle);
			treeView.setStyle("-fx-border-color: #048FD8;-fx-border-width : 0 0 0 1;");

			treeView.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> {

				if (newValue instanceof FilePathTreeItem) {
					// handle((FilePathTreeItem) newValue);

					selectedFile = new File(((FilePathTreeItem) newValue).getFullPath());

				} else
					selectedFile = null;
			});

			dirArchitecture.getChildren().clear();

			dirArchitecture.getChildren().addAll(directoryLabel, treeView);

		}

	}

	public void openFile() {
		try {
			if (System.getProperty("os.name").toLowerCase().contains("windows")) {
				String cmd = "rundll32 url.dll,FileProtocolHandler " + selectedFile.getCanonicalPath();
				Runtime.getRuntime().exec(cmd);
			} else {
				java.awt.Desktop.getDesktop().edit(selectedFile);
			}
		} catch (Exception e) {

			e.printStackTrace();
		}
	}

	public void openFilewith() {
		FileChooser chooser = new FileChooser();
		File fileopener = chooser.showOpenDialog(contextMenu);
		try {
			if (fileopener != null) {
				String cmd = "\"" + fileopener.getCanonicalPath() + "\" " + selectedFile.getCanonicalPath() + " -n76";
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

	private void handleMouseClicked(MouseEvent event) {
		contextMenu.hide();
		Node node = event.getPickResult().getIntersectedNode();
		// Accept clicks only on node cells, and not on empty spaces of the TreeView
		if (node instanceof Text || (node instanceof TreeCell && ((TreeCell) node).getText() != null)) {

			if (selectedFile != null && selectedFile.isFile())
				contextMenu.show(treeView, event.getScreenX(), event.getScreenY());
			else
				setSelectedFile(null);
		}
	}

	

	// close button creator function

	private Button createTabButton() {
		Button button = new Button();
		button.setStyle("-fx-background-color: transparent");
		ImageView imageView = new ImageView(
				new Image(getClass().getResource("/Resources/close2.png").toExternalForm(), 16, 16, false, true));
		button.setGraphic(imageView);
		button.getStyleClass().add("tab-button");
		return button;
	}

	/// help to dir architecture
	private void listChildren(File file, TreeItem<String> treeItem) {

		FilePathTreeItem treeNode = new FilePathTreeItem(file.toPath());
		if (file.isDirectory()) {
			treeItem.getChildren().add(treeNode);

			for (File file1 : file.listFiles()) {
				listChildren(file1, treeNode);

			}
		} else {
			// Adding event Filter
			treeNode.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {

				@Override
				public void handle(MouseEvent event) {
					System.out.println("ensa");
				}
			});
			treeItem.getChildren().add(treeNode);

		}

	}



	@FXML
	private void executeFile() throws IOException, SQLException {
		welcomecontroller.loadInMainPane(ViewPane, "ExecuteInterface");
	}

	@FXML
	private void modify() throws IOException, SQLException {
		ViewPane.getChildren().clear();
		ViewPane.getChildren().addAll(tabPane);
	}
}
