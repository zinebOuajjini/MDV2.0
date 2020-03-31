package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;

import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.AnotherProjectApplication;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

@Controller
public class AuthentificationController {

	@FXML
	private ImageView exit;

	@FXML
	private ImageView minimize;

	@FXML
	private ImageView logoSopra;

	@FXML
	private HBox controlPane;

	double x, y;
	
	@FXML
	private AnchorPane mainpane;

	public AnchorPane getMainpane() {
		return mainpane;
	}

	
	
	@FXML
	private void initialize() {
		
		logoSopra.setImage(new Image("/Resources/logo.png", false));
		minimize.setImage(new Image("/Resources/mini.png", false));
		exit.setImage(new Image("/Resources/close.png", false));
		System.out.println("before");
		FXMLLoader fxmlLoader= new FXMLLoader(getClass().getResource("/com/sopraMdv/anotherProject/view/login.fxml"));
		fxmlLoader.setControllerFactory(AnotherProjectApplication.springContext::getBean);
		try {
			mainpane.getChildren().setAll((Node)fxmlLoader.load());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void exit() {
				Stage stage = (Stage) exit.getScene().getWindow();
				stage.close();
				System.exit(1);
	}

	public void minimize() {
		// get a handle to the stage
		Stage stage = (Stage) minimize.getScene().getWindow();
		stage.setIconified(true);
	}

	public void moving(MouseEvent mouseEvent) {

		controlPane.getScene().getWindow().setX(mouseEvent.getScreenX() + x);
		controlPane.getScene().getWindow().setY(mouseEvent.getScreenY() + y);
	}

	public void premoving(MouseEvent mouseEvent) {
		
		// record a delta distance for the drag and drop operation.
		x = (double) (controlPane.getScene().getWindow().getX() - mouseEvent.getScreenX());
		y = (double) (controlPane.getScene().getWindow().getY() - mouseEvent.getScreenY());
	}
}
