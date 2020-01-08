package com.sopraMdv.anotherProject;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
@EnableJpaRepositories("com.sopraMdv.anotherProject.dao")
@SpringBootApplication
public class AnotherProjectApplication extends Application{
	
//	private static final SpringFxmlLoader loader = new SpringFxmlLoader();

	
	public static  ConfigurableApplicationContext springContext;
	private Parent rootNode;
	
	
	public static void main(String[] args) {
		
		//SpringApplication.run(MdvApplication.class, args);
        Application.launch(args);
	}

	

	@Override
	public void init() throws Exception {
		
	    springContext = SpringApplication.run(AnotherProjectApplication.class);
	    //test
	    FXMLLoader fxmlLoader= new FXMLLoader(getClass().getResource("/com/sopraMdv/anotherProject/view/Welcome.fxml"));
	    springContext.getAutowireCapableBeanFactory().autowireBean(this);
	    fxmlLoader.setControllerFactory(AnotherProjectApplication.springContext::getBean);
	    rootNode=fxmlLoader.load();
	}
	
	
	@Override
	public void start(Stage stage) throws Exception {
		 Scene scene = new Scene(rootNode, 1068, 700);
		 
	     stage.setTitle("Bienvenue Sur MDV APP");
	     stage.setScene(scene);
	     scene.getStylesheets().add("/Resources/login.css");
	     stage.getIcons().add(new Image("/Resources/favicon-32x32.ico"));

	     stage.requestFocus();
	     stage.setResizable(false);
	     stage.initStyle(StageStyle.UNDECORATED);
	     stage.show();

	}

	@Override
	public void stop() throws Exception {
		springContext.close();
	}
	
//	public void setContext() {
//		
//		
//		
//	}
//	

   

	
	
}
