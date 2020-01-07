package com.sopraMdv.anotherProject.Controller;

import org.springframework.stereotype.Controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

@Controller
public class HistoriqueElementController {

	@FXML
	private ImageView deletebtn;
	
	@FXML
	private Label chosebtn;
	
	@FXML
	private ImageView img;
	
	@FXML
	private Label idlabel;

	@FXML
	private void initialize() {
		
		deletebtn.setImage(new Image("/Resources/delete.png",false));
		img.setImage(new Image("/Resources/file.png",false));
        
	}
	
}
