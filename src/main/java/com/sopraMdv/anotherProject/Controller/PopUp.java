package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;

import com.sopraMdv.anotherProject.AnotherProjectApplication;

import javafx.fxml.FXMLLoader;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

public class PopUp {
	
	public static void errorPopUp(String msg,String btnMsg) {

		Stage popupwindow = new Stage(); 
		
		popupwindow.initModality(Modality.APPLICATION_MODAL);
		popupwindow.setTitle("Erreur !!");  
		
		Label label1= new Label(msg);
		label1.getStyleClass().add("erreur");
		Button button1= new Button(btnMsg);
		     
		button1.setOnAction(e -> popupwindow.close());
	     

		VBox layout= new VBox(10);
		     
		      
		layout.getChildren().addAll(label1, button1);
		      
		layout.setAlignment(Pos.CENTER);
		      
		Scene scene1= new Scene(layout, 200, 200);
		      
		popupwindow.setScene(scene1);
		      
		popupwindow.show();
	}
	
	public void popup(String label,String button) {

		Stage popupwindow=new Stage();
		      
		popupwindow.initModality(Modality.APPLICATION_MODAL);
		popupwindow.setTitle("Nouvelle fenêtre");
		      
		      
		Label label1= new Label(label);
		      
		     
		Button button1= new Button(button);
		     
		     
		button1.setOnAction(e -> popupwindow.close());
	     

		VBox layout= new VBox(10);
		     
		      
		layout.getChildren().addAll(label1, button1);
		      
		layout.setAlignment(Pos.CENTER);
		      
		Scene scene1= new Scene(layout, 300, 250);
		      
		popupwindow.setScene(scene1);

		popupwindow.show();
	}
	
	public static Stage ScriptManagerPopUp() throws IOException {

		Stage window=new Stage();
		      
		window.initModality(Modality.APPLICATION_MODAL);
		window.setTitle("Nouvelle requête.");
		
		   
		
		FXMLLoader fxmlLoader = new FXMLLoader(PopUp.class.getResource("/com/sopraMdv/anotherProject/view/ScriptPopUp.fxml"));
		fxmlLoader.setControllerFactory(AnotherProjectApplication.springContext::getBean);
		AnchorPane layout  = fxmlLoader.load();
      
		Scene scene= new Scene(layout, 744, 427);

		window.setScene(scene);
		      
		
		return window;
	} 

}
