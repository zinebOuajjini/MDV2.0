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
import javafx.scene.control.PasswordField;
import javafx.scene.input.MouseEvent;

@Controller
public class Kit_modificationController {
	
	private Validator validator;
	
	private Kit kit;

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

	@FXML
	private TextField ipServeurKit;

	@FXML
	private TextField utilisateurServeurKit;

	@FXML
	private PasswordField passServeurKit;

	@FXML
	private TextField repServeurKit;

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
		validator = Validation.buildDefaultValidatorFactory().getValidator();
		kit = new Kit(session.getKit());
		nomKit.setText(kit.getNomKit());
		nomKit.setDisable(true);
		descKit.setText(kit.getDescriptionKit());
		ipServeurKit.setText(kit.getAdressIpServeur());
		utilisateurServeurKit.setText(kit.getUtilisateurServeur());
		passServeurKit.setText(kit.getMotDePassUtilisateurServeur());
		repServeurKit.setText(kit.getRepertoireDeTravail());

	}

	@FXML
	public void editKit(MouseEvent event) throws IOException {

		Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
		String nommsg = "";
		
		//kit.setNomKit(nomKit.getText().replaceAll(" ", "_"));
		kit.setDescriptionKit(descKit.getText());
		kit.setAdressIpServeur(ipServeurKit.getText());
		kit.setUtilisateurServeur(utilisateurServeurKit.getText());
		kit.setMotDePassUtilisateurServeur(passServeurKit.getText());
		kit.setRepertoireDeTravail(repServeurKit.getText());

		Set<ConstraintViolation<Kit>> kitViolation = validator.validate(kit);
		if (kitViolation.isEmpty()) {
			kitDAO.save(kit);
			session.setKit(kit);
			welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kit_info");
		} else {

			for (ConstraintViolation<Kit> kitV : kitViolation) {
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
		welcomecontroller.loadInMainPane(welcomecontroller.getMainpane(), "Kit_info");
	}

}
