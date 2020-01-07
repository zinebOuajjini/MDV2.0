package com.sopraMdv.anotherProject.Controller;


import java.util.Set;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.jcraft.jsch.JSchException;
import com.sopraMdv.anotherProject.dao.ServerDAO;
import com.sopraMdv.anotherProject.entities.Server;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;

@Controller
public class Server_modifierController {


	private Validator validator;
	
	@FXML
	private TextField nameServ;

	private ObservableList<String> platforms = FXCollections.observableArrayList("RedHat", "AIX");
	
	@FXML
	private TextField hostServ;

	@FXML
	private TextField portServ;

	@FXML
	private TextField userNameAmpServ;

	@FXML
	private TextField pathAmp;

	@FXML
	private TextField userNameGenerServ;

	@FXML
	private TextField pathGener;

	@FXML
	private ComboBox<String> platformOSServ;

	@FXML
	private PasswordField passwordAmp;

	@FXML
	private PasswordField passwordGener;
	
	@FXML
	private Label errorLabel; 
	
	String nommsg,hostmsg,osmsg,cbaamsg,pw1msg,cbrdmsg,gaamsg,pw2msg,grdmsg,usermsg,pwmsg;

	private  Session session;
	
	private DataBaseConnexion dbconnexion;
	
	@FXML
	private TextField usernameEdit;
	
	@FXML
	private PasswordField passwordEdit;

	public DataBaseConnexion getDbconnexion() {
		return dbconnexion;
	}

	@Autowired
	public void setDbconnexion(DataBaseConnexion dbconnexion) {
		this.dbconnexion = dbconnexion;
	}
	
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

	private ServerDAO serverDao;


	private Server server;


	public ServerDAO getServerDao() {
		return serverDao;
	}

	@Autowired
	public void setServerDao(ServerDAO serverDao) {
		this.serverDao = serverDao;
	}

	public Server getServer() {
		return server;
	}

	public void setServer(Server server) {
		this.server = server;
	}

	@FXML
	private void initialize() {
		
		validator = Validation.buildDefaultValidatorFactory().getValidator();
		platforms = FXCollections.observableArrayList("RedHat", "AIX");
		System.out.println("3"+this.session);
		platformOSServ.getItems().addAll(platforms);
//		server = new Server(serverDao.getServerByEnvid(session.getIdEnv()));
//		hostServ.setText(server.getHote());
//		nameServ.setText(server.getNomServer());
//		platformOSServ.getSelectionModel().select(server.getPlatformOS());
//		userNameAmpServ.setText(server.getUserNameAmp());
//		passwordAmp.setText(server.getPasswordAmp());
//		userNameGenerServ.setText(server.getUserNameGener());
//		passwordGener.setText(server.getPasswordGener());
//		pathAmp.setText(server.getPathAmp());
//		pathGener.setText(server.getPathGener());
//		usernameEdit.setText(server.getUserName());
//		passwordEdit.setText(server.getPassword());
	}

	

	public void editserver() throws JSchException {
		nommsg=hostmsg=osmsg=cbaamsg=pw1msg=cbrdmsg=gaamsg=pw2msg=grdmsg="";
		server.setHote(hostServ.getText());
		server.setNomServer(nameServ.getText());
		server.setPlatformOS(platformOSServ.getValue());
		server.setUserNameAmp(userNameAmpServ.getText());
		server.setPasswordAmp(passwordAmp.getText());
		server.setUserNameGener(userNameGenerServ.getText());
		server.setPasswordGener(passwordGener.getText());
		server.setPathAmp(pathAmp.getText());
		server.setPathGener(pathGener.getText());
		server.setUserName(usernameEdit.getText());
		server.setPassword(passwordEdit.getText());
		
		
//		server.setId(serverDao.getServerByEnvid(session.getIdEnv()).getId());
//		System.out.println(server);
		Set<ConstraintViolation<Server>> serverViolations = validator.validate(server);
		
		if (serverViolations.isEmpty()) {
			
			com.jcraft.jsch.Session session=dbconnexion.connectServer(server);
			dbconnexion.getSession().disconnect();
			dbconnexion.setSession(null);
			if (session!=null) {

				System.out.println("save server ");
				serverDao.save(server);
				server.setId(null);
				session.disconnect();
				//welcomecontroller.FireAnEvent(welcomecontroller.getServerlabel());

			}

		} else {
			System.out.println("data is Invalid");
			System.out.println("------------------------------------");
			for (ConstraintViolation<Server> serverViolation : serverViolations) {
				if(serverViolation.getPropertyPath().toString().equals("nomServer")) {
					nommsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("hote")) {
					hostmsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("platformOS")) {
					osmsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("userNameAmp")) {
					cbaamsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("passwordAmp")) {
					pw1msg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("pathAmp")) {
					cbrdmsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("userNameGener")) {
					gaamsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("passwordGener")) {
					pw2msg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("pathGener")) {
					grdmsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("userName")) {
					usermsg = serverViolation.getMessage();
				}else if (serverViolation.getPropertyPath().toString().equals("password")) {
					pwmsg = serverViolation.getMessage();
				}else {
					System.out.println(
							"LOGINFO : " + serverViolation.getPropertyPath() + " " + serverViolation.getMessage());
				}
				
			}
			
			if (!nommsg.isEmpty()) {
				nameServ.getStyleClass().add("error");
				 
			}else {
				nameServ.getStyleClass().removeAll("error");
			}
				
			
			if (!hostmsg.isEmpty()) {
				hostServ.getStyleClass().add("error");
			}else {
				hostServ.getStyleClass().removeAll("error");
			}
			
			if (!osmsg.isEmpty()) {
				platformOSServ.getStyleClass().add("error");
			}else {
				platformOSServ.getStyleClass().removeAll("error");
			}
			
			if (!cbaamsg.isEmpty()) {
				userNameAmpServ.getStyleClass().add("error");
			}else {
				userNameAmpServ.getStyleClass().removeAll("error");
			}
			
			if (!pw1msg.isEmpty()) {
				passwordAmp.getStyleClass().add("error");
			}else {
				passwordAmp.getStyleClass().removeAll("error");
			}
			
			if (!cbrdmsg.isEmpty()) {
				pathAmp.getStyleClass().add("error");
			}else {
				pathAmp.getStyleClass().removeAll("error");
			}
			
			if (!gaamsg.isEmpty()) {
				userNameGenerServ.getStyleClass().add("error");
			}else {
				userNameGenerServ.getStyleClass().removeAll("error");
			} 
			
			if (!pw2msg.isEmpty()) {
				passwordGener.getStyleClass().add("error");
			}else {
				passwordGener.getStyleClass().removeAll("error");
			}  
			
			if (!grdmsg.isEmpty()) {
				pathGener.getStyleClass().add("error");
			}else {
				pathGener.getStyleClass().removeAll("error");
			}
			
			
			errorLabel.setText("Ouuups!! les champs en rouge sont invalides.");
			
		}
		
	}

	public void cancel() {
		server = null;
		//welcomecontroller.FireAnEvent(welcomecontroller.getServerlabel());
		
	}
	
}
