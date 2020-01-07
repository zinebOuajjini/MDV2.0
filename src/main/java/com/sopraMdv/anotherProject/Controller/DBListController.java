
package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;

import com.sopraMdv.anotherProject.dao.ServerDAO;
import com.sopraMdv.anotherProject.entities.DataBase;


import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;

@Controller
public class DBListController {


	private DataBaseDAO dbDAO;

	private DataBaseConnexion dbconnexion;

	private SplitFileController splitfilecontroller;

	public DataBaseConnexion getDbconnexion() {
		return dbconnexion;
	}

	public SplitFileController getSplitfilecontroller() {
		return splitfilecontroller;
	}

	@Autowired
	public void setSplitfilecontroller(SplitFileController splitfilecontroller) {
		this.splitfilecontroller = splitfilecontroller;
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

	private ServerDAO serverdao;

	public ServerDAO getServerdao() {
		return serverdao;
	}

	@Autowired
	public void setServerdao(ServerDAO serverdao) {
		this.serverdao = serverdao;
	}

	@FXML
	private Pane listelements;


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

//		try {
//			for (DataBase element : dbDAO.getAllDatabases(serverdao.getServerByEnvid(session.getIdEnv()).getId())) {
//
//				AddElemnt(element);
//			}
//
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

	}

	public void AddElemnt(DataBase db) throws IOException {
		
		AnchorPane element = new AnchorPane();
		element.setPrefHeight(50);
		element.setPrefWidth(880);
		welcomecontroller.loadInMainPane(element, "DB_list_element");
		Label nom = (Label) element.lookup("#nomDBLabel");
		nom.setText(db.getSid());
		Label iddb = (Label) element.lookup("#idlabel");
		iddb.setText(db.getId().toString());
		Label editbtn = (Label) element.lookup("#editbutton");
		Label chosebtn = (Label) element.lookup("#chosebtn");
		ImageView deletebtn = (ImageView) element.lookup("#deletebtn");
		ImageView envimg = (ImageView) element.lookup("#envimg");
		
		DataBase TmpDatabase = new DataBase(dbDAO.getDatabaseById(Long.parseLong(iddb.getText())));
		
		envimg.setOnMousePressed((MouseEvent t) -> {
			welcomecontroller.setAndShowMessage(t,
					"Schema : " + db.getSchemaDB() + "\nHôte : " + db.getHote() + "\nType : " + db.getTypeDB() + "\nPort : "
							+ db.getPort() + "\nSID : " + db.getSid(),
					t.getSceneX() - 150, t.getSceneY() - 70);
		});
		envimg.setOnMouseReleased((MouseEvent t) -> {
			welcomecontroller.hideMessage(t);
		});
		editbtn.setOnMouseClicked((MouseEvent t) -> {
			session.getKit().setDatabase(TmpDatabase);

			try {
				welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "DB_modifier");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		});

//		chosebtn.setOnMouseClicked((MouseEvent t) -> {
//			session.setIdDB(Long.parseLong(iddb.getText()));
//			System.out.println("connect database:" + session.getIdDB());
//			try {
//				welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "TapPane");
//			} catch (IOException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		});

		deletebtn.setOnMouseClicked((MouseEvent t) -> {
			session.getKit().setDatabase(TmpDatabase);
			try {
				
				Alert alert = new Alert(AlertType.CONFIRMATION);
				alert.setTitle("Attention!!!!");
				alert.setHeaderText("Voulez vous supprimer cette Base de données?");
				alert.setContentText("Tout l'historique des fichiers exécutés va être supprimé!!!!");

				Optional<ButtonType> result = alert.showAndWait();
				if (result.get() == ButtonType.OK){
					deleteDB();
				} else {
				    // ... user chose CANCEL or closed the dialog
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//welcomecontroller.FireAnEvent(welcomecontroller.getDblabel());
		});
		deletebtn.setOnMouseEntered((MouseEvent t) -> {

			welcomecontroller.setAndShowMessage(t, "supprimer", t.getSceneX() - 180, t.getSceneY() - 70);
		});
		deletebtn.setOnMouseExited((MouseEvent t) -> {
			welcomecontroller.hideMessage(t);
		});

		listelements.getChildren().add(element);

	}

	@FXML
	public void createDB() throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Base de donnée");
	}

	public void deleteDB() throws IOException {
		
		dbDAO.deleteById(session.getKit().getDatabase().getId());
		
	}

}
