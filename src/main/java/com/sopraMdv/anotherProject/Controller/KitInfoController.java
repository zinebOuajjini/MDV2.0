package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.Kit;

import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;

@Controller
public class KitInfoController {

	@FXML
	private ImageView img1;
	
	@FXML
	private ImageView img2;
	
	@FXML
	private ImageView img3;
	
	@FXML
	private ImageView img4;
	
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
	
	@FXML
	private void initialize() {
		
		kit = new Kit(session.getKit());
		
		img1.setImage(new Image("/Resources/progress-arrows.png",false));
		img2.setImage(new Image("/Resources/db1.png",false));
		img3.setImage(new Image("/Resources/code.png",false));
		img4.setImage(new Image("/Resources/code-file.png",false));
		goBackImg.setImage(new Image("/Resources/back-arrow.png", false));
		delete.setImage(new Image("/Resources/rubbish.png", false));
		deleteDBImg.setImage(new Image("/Resources/rubbish.png", false));
		
		nomKit.setText(kit.getNomKit());
		descriptionKit.setText(kit.getDescriptionKit());
		if(session.getKit().getDatabase() != null)
			databaseNom.setText(session.getKit().getDatabase().getSid());
		
		if (kitDAO.getDbByKit(session.getKit().getId()) != null) {
			dataBaseBtn.setText("Modifier");
		}else {
			deleteDBImg.setVisible(false);
			dataBaseBtn.setText("Créer");
		}	
	}
		
	@FXML
	public void showScripts() throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Historique");
	}
	

	@FXML
	public void createDB() throws IOException { // modify DB
//		DbShooser.setVisible(true);
		if ( dataBaseBtn.getText().equals("Créer") ) {
			
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "création_base_de_donnée");
		} 
		
		if (dataBaseBtn.getText().equals("Modifier")) {
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "modification_base_de_donnée");
			
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
	public void delete() throws IOException{
		
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Confirmation!!!!");
		alert.setHeaderText("Voulez vous Supprimer ce kit ?");
		alert.setContentText("tous les données liées vont être supprimées!!!!");

		Optional<ButtonType> result = alert.showAndWait();
		if (result.get() == ButtonType.OK) {
			kitDAO.delete(kit);
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(),"Kits de migration");
		}
	}
	
	@FXML
	public void deleteDB() throws IOException {
		Alert alert = new Alert(AlertType.CONFIRMATION);
		alert.setTitle("Confirmation!!!!");
		alert.setHeaderText("Voulez vous Supprimer cette base de données ?");

		Optional<ButtonType> result = alert.showAndWait();
		if (result.get() == ButtonType.OK) {
		Long tmpDBId =session.getKit().getDatabase().getId();
		session.getKit().setDatabase(null);
		kitDAO.save(session.getKit());
		dbDAO.deleteById(tmpDBId);
		System.out.println("after delete "+ session.getKit().getId());
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(),"kit_info");
		}
	}
	@FXML
	public void showDBInfo(MouseEvent t) {
		welcomecontroller.setAndShowMessage(t,"IP : "+session.getKit().getDatabase().getHote()
				+"\nSID : "+session.getKit().getDatabase().getSid()
				+"\nPort : "+session.getKit().getDatabase().getPort()
				+"\nSchema : "+session.getKit().getDatabase().getSchemaDB()
				+"\nType : "+session.getKit().getDatabase().getTypeDB(),
				t.getSceneX() - 150, t.getSceneY() - 70);
	}
	public void hideDBInfo(MouseEvent t) {
		welcomecontroller.hideMessage(t);;
	}
	
}
