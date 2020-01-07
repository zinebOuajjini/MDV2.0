package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.HBox;

@Component
public class ScriptManagerController {

	private SplitFileController splitfile;

	private boolean isPopUpActive = false;

	private ExecuteFileController executefile;

	@Autowired
	private DataBaseConnexion dbConnexion;

	private Session session;

	/* FXML Components */
	@FXML
	private TextArea resultat;
	@FXML
	private HBox footer;

	@FXML
	private Label addLabel;

	@FXML
	private ImageView savingSwitch;

	private boolean savingstaus;

	@FXML
	private Label editLabel;

	@FXML
	private Label commentLabel;

	@FXML
	private Label cancelLabel;

	@FXML
	private TextArea scriptEditor;

	@FXML
	private Label correctQuery;

	public boolean isPopUpActive() {
		return isPopUpActive;
	}

	public void setPopUpActive(boolean isPopUpActive) {
		this.isPopUpActive = isPopUpActive;
	}

	public SplitFileController getSplitfile() {
		return splitfile;
	}

	@Autowired
	public void setSplitfile(SplitFileController splitfile) {
		this.splitfile = splitfile;
	}

	public ExecuteFileController getExecutefile() {
		return executefile;
	}

	@Autowired
	public void setExecutefile(ExecuteFileController executefile) {
		this.executefile = executefile;
	}

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	public TextArea getScriptEditor() {
		return scriptEditor;
	}

	public void setScriptEditor(TextArea scriptEditor) {
		this.scriptEditor = scriptEditor;
	}

	@FXML
	private void initialize() {
		savingstaus = false;
		savingSwitch.setImage(new Image("/Resources/switch-off.png", false));
	}

	public void runNewQuery() throws SQLException, IOException {

		resultat.setText("");
		isPopUpActive = true;
		// Connection cnx = executefile.connectDB(session.getIdDB());
		if (session.getCnx().isClosed()) {
			session.setCnx(session.getCnxNew());
		}
		String str = scriptEditor.getText();
		if (!str.toUpperCase().replaceAll("\n"," ").replaceAll("\t", "").replaceAll(" +", " ").matches("^ *\t*CREATE OR REPLACE PROCEDURE.*|^ *\\t*DECLARE.*"
				+ "|^ *\t*BEGIN.*|^ *\t*CREATE TRIGGER.*|^ *\t*CREATE OR REPLACE FUNCTION.*|^ *\t*CREATE TRIGGER.*"
				+ "|^ *\t*CREATE OR REPLACE TRIGGER.*|^ *\t*CREATE OR REPLACE PACKAGE.*")) {
			str = str.replaceAll("; *$", "");
		}

		if (!str.isEmpty()) {
			try {
				dbConnexion.executeNewQuery(str, session.getCnx(),savingstaus);
				correctQuery.setStyle("-fx-text-inner-color : green;");
				correctQuery.setText("requette exécutée");
				

				//resultat.setText(session.getQueryResult());

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				resultat.setText(e.getMessage());
				correctQuery.setStyle("-fx-text-inner-color : red;");
				correctQuery.setText("erreur");
			}

		} else {
			resultat.setText("L'instruction SQL ne peut pas être vide!!");
		}
	}

	@FXML
	public void switchSaving() {
		if (savingstaus) {
			savingstaus = false;
			savingSwitch.setImage(new Image("/Resources/switch-off.png", false));
		} else {
			savingstaus = true;
			savingSwitch.setImage(new Image("/Resources/switch-on.png", false));
		}
	}
}
