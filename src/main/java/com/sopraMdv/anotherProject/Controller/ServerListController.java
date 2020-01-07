package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.sopraMdv.anotherProject.dao.ServerDAO;
import com.sopraMdv.anotherProject.entities.Server;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;

@Controller
public class ServerListController {

	@FXML
	private ImageView serverimg;

	@FXML
	private Label nomenv;
	@FXML
	private Label label1;
	@FXML
	private Label label2;
	@FXML
	private Label label3;
	@FXML

	private Label label4;
	@FXML
	private Label label5;
	@FXML
	private Label label6;
	@FXML

	private Label label7;
	@FXML
	private Label label8;
	@FXML
	private Label label9;
	@FXML
	private Label label10;

	private Server serv;

	private WelcomeController welcomecontroller;


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

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	@FXML
	private void initialize() throws IOException {
		serverimg.setImage(new Image("/Resources/server.png", false));

		// serv = serverdao.getServerByEnvid(session.getIdEnv());
		FillLabels();
	}

	public void FillLabels() {

		System.out.println(serv);
		if (serv != null) {
			label1.setText(serv.getNomServer());
			label2.setText(serv.getHote());
			label3.setText(serv.getPlatformOS());
			label7.setText(serv.getUserNameAmp());
			label8.setText(serv.getPathAmp());
			label9.setText(serv.getUserNameGener());
			label10.setText(serv.getPathGener());

		}
	}

	@FXML
	public void editserver(MouseEvent event) throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Server_modifier");
	}

	@FXML
	public void deleteserver(MouseEvent event) throws IOException {
		
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Attention!!!!");
		alert.setHeaderText("Voulez vous supprimer ce serveur?");
		alert.setContentText("L'historique et les bases de données liées vont êtres supprimées!!!!");

		Optional<ButtonType> result = alert.showAndWait();
		if (result.get() == ButtonType.OK){
			serverdao.deleteById(serv.getId());
			
			
		} else {
		    // ... user chose CANCEL or closed the dialog
		}
		
		
	}

	@FXML
	public void connectserver(MouseEvent event) throws IOException {
		
		welcomecontroller.setDbShow(true);
		//welcomecontroller.FireAnEvent(welcomecontroller.getDblabel());
	}

}
