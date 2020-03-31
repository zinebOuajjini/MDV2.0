package com.sopraMdv.anotherProject.Controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.DataBaseDAO;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

@Controller
public class DBListElementController {

	@FXML
	private ImageView deletebtn;
	
	@FXML
	private Label chosebtn;
	
	@FXML
	private ImageView envimg;
	
	@FXML
	private Label idlabel;
	
	@FXML
	private Label editbutton;
	


	private  Session session;

	
	
	
	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}
	
	private DataBaseDAO dbDAO;
	
	@FXML
	private Label nomDBLabel;
	

	
	public DataBaseDAO getDbDAO() {
		return dbDAO;
	}

	@Autowired
	public void setDbDAO(DataBaseDAO dbDAO) {
		this.dbDAO = dbDAO;
	}
	
	
	@FXML
	private void initialize() {
		
		deletebtn.setImage(new Image("/Resources/delete.png",false));
		envimg.setImage(new Image("/Resources/database.png",false));
        
	}
	
//	@FXML
//	public void connectdb() throws SQLException {
//		
//		
//		DataBase database=dbDAO.getDatabaseById(storebdId.getId());
//		
//		Server server=database.getServer();
//		
//		dbconnexion.connectDB(database,server);
//		
//	}
//	

}
