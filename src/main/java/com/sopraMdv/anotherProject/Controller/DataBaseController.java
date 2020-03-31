package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.DataBase;

import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

@Controller
public class DataBaseController {

	private ObservableList<String> types = FXCollections.observableArrayList("Oracle", "Informix");

	private DataBaseDAO databaseDao;

	
	private KitDAO kitDAO;

	private Validator validator;

	private DataBase db ;

	private DataBaseConnexion dbconnexion;

	

	@FXML
	private TextField hostDB;

	@FXML
	private TextField portDB;

	@FXML
	private TextField sidDB;

	String schemamsg, pwmsg, pnmsg, typemsg, hostmsg, portmsg, sidmsg, dn4umsg;

	@FXML
	private VBox DBform;

	@FXML
	private Label errorLabel;

	TextField dbName4Url = new TextField();

	HBox hbox = new HBox(dbName4Url);

	@Autowired
	DataBaseConnexion dbConnection;

	
	
	

	public KitDAO getKitDAO() {
		return kitDAO;
	}

	@Autowired
	public void setKitDAO(KitDAO kitDAO) {
		this.kitDAO = kitDAO;
	}
	Collection<Node> informixCollection = new ArrayList<>();
	Collection<Node> oracleCollection = new ArrayList<>();

	public DataBaseConnexion getDbconnection() {
		return dbConnection;
	}

	public void setDbconnection(DataBaseConnexion dbConnection) {
		this.dbConnection = dbConnection;
	}
	@FXML
	private TextField schemaDB;

	@FXML
	private PasswordField passwordDB;

	@FXML
	private ComboBox<String> typeDB;

	public DataBaseDAO getDatabaseDao() {
		return databaseDao;
	}

	@Autowired
	public void setDatabaseDao(DataBaseDAO databaseDao) {
		this.databaseDao = databaseDao;
	}

	public DataBase getDb() {
		return db;
	}

	public void setDb(DataBase db) {
		this.db = db;
	}

	public DataBaseConnexion getDbconnexion() {
		return dbconnexion;
	}

	@Autowired
	public void setDbconnexion(DataBaseConnexion dbconnexion) {
		this.dbconnexion = dbconnexion;
	}

	

	private Session session;

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	private WelcomeController welcomecontroller;

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	@FXML
	private void initialize() {
		errorLabel.setWrapText(true);
		dbName4Url.setPromptText("Database Name (for url)");
		dbName4Url.setAlignment(Pos.CENTER);
		dbName4Url.setPrefHeight(40.0);
		typeDB.getItems().addAll(types);
		typeDB.getSelectionModel().select(0); // oracle by default
//		typeDB.getSelectionModel().selectedItemProperty().addListener((options, oldValue, newValue) -> {
//			if (newValue.equals("Informix")) {
//				sidDB.setPromptText("Informix Instance");
//				DBform.getChildren().remove(4, 6);
//				DBform.getChildren().addAll(4, informixCollection);
//			} else if (newValue.equals("Oracle")) {
//				sidDB.setVisible(true);
//				sidDB.setPromptText("Oracle SID");
//				DBform.getChildren().remove(4, 7);
//				DBform.getChildren().addAll(4, oracleCollection);
//			}
//
//		});
		validator = Validation.buildDefaultValidatorFactory().getValidator();
		Platform.runLater(() -> ((VBox) passwordDB.getParent()).requestFocus());
		//
		oracleCollection.add( schemaDB);
		oracleCollection.add( passwordDB);

		informixCollection.add(dbName4Url);
		informixCollection.add( schemaDB);
		informixCollection.add( passwordDB);
	}

	public void createDB(MouseEvent event) throws IOException {
		sidmsg = schemamsg = hostmsg = portmsg = pwmsg = typemsg = dn4umsg = "";
		errorLabel.setText("");
		db= new DataBase();
		db.setSid(sidDB.getText());
		db.setHote(hostDB.getText());
		db.setPasswordDb(passwordDB.getText());
		db.setTypeDB(typeDB.getValue());
		db.setSchemaDB(schemaDB.getText());
		System.out.println("hhhhhhhhh"+session.getKit());
//		db.setKit(session.getKit());
//		db.setServer(serverdao.getServerByEnvid(session.getIdEnv()));

		if (!portDB.getText().isEmpty()) {
			db.setPort(Integer.parseInt(portDB.getText()));
		} else {
			db.setPort(100000);
		}

		Set<ConstraintViolation<DataBase>> DBViolations = validator.validate(db);

		if (DBViolations.isEmpty()) {
			try {
				Connection conn = dbConnection.connectDB(db);
				if (conn != null) {
			
					databaseDao.save(db);
					System.out.println("database"+db);
					
					session.getKit().setDatabase(db);
					System.out.println("       "+session.getKit());
					kitDAO.save(session.getKit());
					
					welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kit_info");
					//conn.close();
				} else {
					errorLabel.setText("Cannot connect to this Database.\n\tPlease verify this info given.");
				}
			} catch (Exception e) {
				System.out.println("controller problem"+e.getMessage());
			}
		} else {
			System.out.println("data is Invalid");
			System.out.println("------------------------------------");
			for (ConstraintViolation<DataBase> DBViolation : DBViolations) {
				if (DBViolation.getPropertyPath().toString().equals("sid")) {
					sidDB.getStyleClass().add("error");
					sidmsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("TypeDB")) {
					typeDB.getStyleClass().add("error");
					typemsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("hote")) {
					hostDB.getStyleClass().add("error");
					hostmsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("port")) {
					portDB.getStyleClass().add("error");
					portmsg = DBViolation.getMessage();
				}  else if (DBViolation.getPropertyPath().toString().equals("schemaDB")) {
					schemaDB.getStyleClass().add("error");
					pnmsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("passwordDb")) {
					passwordDB.getStyleClass().add("error");
					pwmsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("dbName4Url")) {
					dbName4Url.getStyleClass().add("error");
					dn4umsg = DBViolation.getMessage();
				} else {
					System.out.println(
							"LOGINFO : " + DBViolation.getPropertyPath() + " " + DBViolation.getMessageTemplate());
				}
			}

			if (!sidmsg.isEmpty()) {
				sidDB.getStyleClass().add("error");

			} else {
				sidDB.getStyleClass().removeAll("error");
			}

			if (!typemsg.isEmpty()) {
				typeDB.getStyleClass().add("error");
			} else {
				typeDB.getStyleClass().removeAll("error");
			}

			if (!hostmsg.isEmpty()) {
				hostDB.getStyleClass().add("error");
			} else {
				hostDB.getStyleClass().removeAll("error");
			}

			if (!portmsg.isEmpty()) {
				portDB.getStyleClass().add("error");
			} else {
				portDB.getStyleClass().removeAll("error");
			}


			if (!schemamsg.isEmpty()) {
				schemaDB.getStyleClass().add("error");
			} else {
				schemaDB.getStyleClass().removeAll("error");
			}

			if (!pwmsg.isEmpty()) {
				passwordDB.getStyleClass().add("error");
			} else {
				passwordDB.getStyleClass().removeAll("error");
			}

			if (!dn4umsg.isEmpty()) {
				dbName4Url.getStyleClass().add("error");
			} else {
				dbName4Url.getStyleClass().removeAll("error");
			}

			errorLabel.setText("Ouuups!! les champs en rouge sont invalides.");

		}

	}
	
	@FXML
	public void cancel(MouseEvent event) throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "kit_info");
	}
}
