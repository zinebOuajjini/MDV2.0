package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;
import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.Kit;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;

@Controller
public class KitListController {

	@FXML
	private Pane listelements;



	private DataBaseDAO dbDAO;

	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}

	private Session session;

	private KitDAO kitDao;

	public KitDAO getKitDao() {
		return kitDao;
	}
	@Autowired
	public void setKitDao(KitDAO kitDao) {
		this.kitDao = kitDao;
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
		
		welcomecontroller.getStopBtn().setVisible(false);
		welcomecontroller.getExecutebtn().setVisible(false);

		
		try {
			for (Kit element : kitDao.findAll()) {
				System.out.println(element);
				AddElemnt(element);
				
			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void AddElemnt(Kit kit) throws IOException {

		AnchorPane element = new AnchorPane();
		element.setPrefHeight(227);
		element.setPrefWidth(230);

		welcomecontroller.loadInMainPane(element, "kit_element");

		Label nom = (Label) element.lookup("#nomKit");
		nom.setText(kit.getNomKit());
		Label idk = (Label) element.lookup("#idlabel");
		idk.setText(kit.getId().toString());
		Label chosebtn = (Label) element.lookup("#chosebtn");
		ImageView img = (ImageView) element.lookup("#img");
		
		
		chosebtn.setOnMouseClicked((MouseEvent t) -> {
			try {
				session.setKit(kit);
				welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "kit_info");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		});

		listelements.getChildren().add(element);

	}
	
	@FXML
	public void createKit() throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kit");
	}
	

}
