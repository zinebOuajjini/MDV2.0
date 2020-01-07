package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.KitDAO;
import com.sopraMdv.anotherProject.entities.Kit;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;


@Controller
public class KitController {

	private KitDAO kitDAO;

	public KitDAO getKitDAO() {
		return kitDAO;
	}
	
	@Autowired
	public void setKitDAO(KitDAO kitDAO) {
		this.kitDAO = kitDAO;
	}

	@FXML
	private TextField nomKit;

	@FXML
	private TextArea descKit;

	@FXML
	private Label errorLabel;

	private Kit kit ;

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
	public void initialize() {
		
	}

	@FXML
	public void createKit(MouseEvent event) throws IOException {

		
		kit = new Kit();
		Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
		String nommsg = "";
		
		kit.setNomKit(nomKit.getText().replaceAll(" ", "_"));
		kit.setScripts("");
		kit.setDescriptionKit(descKit.getText());	
		
		Set<ConstraintViolation<Kit>> kitViolation = validator.validate(kit);
		if(kitViolation.isEmpty()) {
			kitDAO.save(kit);
			welcomecontroller.FireAnEvent(welcomecontroller.getKitlabel());
		}else {

			for(ConstraintViolation<Kit> kitV : kitViolation) {
				if (kitV.getPropertyPath().toString().equals("nomKit")) {
					nommsg = kitV.getMessage();
				} 
			}
			
			if (!nommsg.isEmpty()) {
				nomKit.getStyleClass().add("error");
			} else {
				nomKit.getStyleClass().remove("error");
			}
			
			errorLabel.setText("\t\t\tOuuups!!\nLes champs en rouge sont invalides.");
			
		}

	}

	

	@FXML
	public void cancel(MouseEvent event) throws IOException {
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kits de migration");
	}

}
