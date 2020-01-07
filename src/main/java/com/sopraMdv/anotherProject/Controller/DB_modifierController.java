package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.ServerDAO;
import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.Oracle;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;

@Controller
public class DB_modifierController {

	Validator validator;

	private ObservableList<String> types = FXCollections.observableArrayList("Oracle");

	private DataBaseDAO databaseDao;

	@Autowired
	DataBaseConnexion dbConnection;

	private DataBase db;

	@FXML
	private TextField schemaDB;

	@FXML
	private TextField hostDB;

	@FXML
	private TextField portDB;

	@FXML
	private TextField sidDB;

	@FXML
	private PasswordField passwordDB;

	@FXML
	private ComboBox<String> typeDB;

	@FXML
	private Label errorLabel;

	String schemamsg, pwmsg, typemsg, hostmsg, portmsg, sidmsg, dn4umsg;

	TextField dbName4Url = new TextField();

	private DataBaseConnexion dbconnexion;

	public DataBaseConnexion getDbconnexion() {
		return dbconnexion;
	}

	@Autowired
	public void setDbconnexion(DataBaseConnexion dbconnexion) {
		this.dbconnexion = dbconnexion;
	}

	public DataBaseDAO getDtaabaseDao() {
		return databaseDao;
	}

	@Autowired
	public void setDtaabaseDao(DataBaseDAO dtaabaseDao) {
		this.databaseDao = dtaabaseDao;
	}

	public DataBase getDb() {
		return db;
	}

	public void setDb(DataBase db) {
		this.db = db;
	}

	private ServerDAO serverdao;

	public ServerDAO getServerdao() {
		return serverdao;
	}

	@Autowired
	public void setServerdao(ServerDAO serverdao) {
		this.serverdao = serverdao;
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

	public DataBaseConnexion getDbconnection() {
		return dbConnection;
	}

	public void setDbconnection(DataBaseConnexion dbConnection) {
		this.dbConnection = dbConnection;
	}

	@FXML
	private void initialize() {

		validator = Validation.buildDefaultValidatorFactory().getValidator();
		
		db = databaseDao.getDatabaseById(session.getKit().getDatabase().getId());

		hostDB.setText(db.getHote());
		hostDB.setDisable(true);
		passwordDB.setText(db.getPasswordDb());
		portDB.setText("" + db.getPort());
		typeDB.getSelectionModel().select(db.getTypeDB());
		schemaDB.setText(db.getSchemaDB());
		sidDB.setText(db.getSid());
		typeDB.setDisable(true);
		errorLabel.setWrapText(true);
	}

	public void editDB(MouseEvent event) throws IOException {
		
		schemamsg = sidmsg = hostmsg = portmsg = pwmsg = typemsg = dn4umsg = "";

		db.setHote(hostDB.getText());
		db.setPasswordDb(passwordDB.getText());
		db.setPort(Integer.parseInt(portDB.getText()));
		db.setSid(sidDB.getText());
		db.setTypeDB(typeDB.getValue());
		db.setSchemaDB(schemaDB.getText());
		db.setId(session.getKit().getDatabase().getId());
//		db.setServer(serverdao.getServerByEnvid(session.getIdEnv()));

		Set<ConstraintViolation<DataBase>> DBViolations = validator.validate(db);

		if (DBViolations.isEmpty()) {
			try {
				Connection conn = dbConnection.connectDB(db);
				if (conn != null) {
					databaseDao.save(db);
					db.setId(null);
					//welcomecontroller.FireAnEvent(welcomecontroller.getDblabel());
				} else {
					errorLabel.setText("Cannot connect to this Database.\n please verify this info given.");
				}
			} catch (Exception e) {
				System.out.println("controller problem");
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
				} else if (DBViolation.getPropertyPath().toString().equals("schemaDB")) {
					schemaDB.getStyleClass().add("error");
					schemamsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("passwordDb")) {
					passwordDB.getStyleClass().add("error");
					pwmsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("dbName4Url")) {
					dbName4Url.getStyleClass().add("error");
					dn4umsg = DBViolation.getMessage();
				} else if (DBViolation.getPropertyPath().toString().equals("instance")) {
					sidDB.getStyleClass().add("error");
					sidmsg = DBViolation.getMessage();
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

			if (!sidmsg.isEmpty()) {
				sidDB.getStyleClass().add("error");
			} else {
				sidDB.getStyleClass().removeAll("error");
			}

			if (!sidmsg.isEmpty()) {
				sidDB.getStyleClass().add("error");
			} else {
				sidDB.getStyleClass().removeAll("error");
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
