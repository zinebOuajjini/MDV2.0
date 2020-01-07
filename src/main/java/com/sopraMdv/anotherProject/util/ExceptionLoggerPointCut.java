package com.sopraMdv.anotherProject.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import com.sopraMdv.anotherProject.Controller.ExecuteFileController;
import com.sopraMdv.anotherProject.Controller.MainController;
import com.sopraMdv.anotherProject.Controller.ScriptManagerController;
import com.sopraMdv.anotherProject.Controller.Session;
import com.sopraMdv.anotherProject.Controller.SplitFileController;
import com.sopraMdv.anotherProject.Controller.WelcomeController;
import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.entities.FileHistory;

import javafx.application.Platform;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;

@Configuration
@Aspect
public class ExceptionLoggerPointCut {

	private ExecuteFileController executefile;
	private WelcomeController welcomeController;
	private ScriptManagerController scriptmanagercontroller;
	private Session session;
	private SplitFileController splitfile;

	private FileHistoryDAO fileDao;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}

	public WelcomeController getWelcomeController() {
		return welcomeController;
	}

	@Autowired
	public void setWelcomeController(WelcomeController welcomeController) {
		this.welcomeController = welcomeController;
	}

	public ScriptManagerController getScriptmanagercontroller() {
		return scriptmanagercontroller;
	}

	@Autowired
	public void setScriptmanagercontroller(ScriptManagerController scriptmanagercontroller) {
		this.scriptmanagercontroller = scriptmanagercontroller;
	}

	private MainController mainController;

	public MainController getMainController() {
		return mainController;
	}

	@Autowired
	public void setMainController(MainController mainController) {
		this.mainController = mainController;
	}

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
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

	@AfterThrowing(pointcut = "execution(* com.sopraMdv.anotherProject.Controller.DataBaseConnexion.*(..)) && args(sql,connection)", throwing = "ex")
	public void logError(Exception ex, String sql, Connection connection) throws IOException, SQLException {
		// i had to use Platform.runLater because of the conflict between the main FX
		// Thread and the threads created for DataBase access.
		// If the DB thread use the FX interface an error will rise .
		Statement cs  = null;
		if (ex.toString().contains("java.sql.SQLRecoverableException: Erreur d'E/S: Socket read timed out")) {

			connection.commit();
			connection.close();
			session.setCnx(session.getCnxNew());
		} else {
			//// stopping movingGears
			Platform.runLater(() -> welcomeController.getMovingGears().setVisible(false));
			Platform.runLater(() -> welcomeController.getOnTopPane().setVisible(false));
			/////

			Boolean iswarning = false;
			String warningnum = "";
			List<String> listwarnings = new ArrayList<String>();
//			listwarnings.add("-01418:");
//			listwarnings.add("-00001:");
//			listwarnings.add("-01430:");
//			listwarnings.add("-02443:");
//			listwarnings.add("-01442:");
//			listwarnings.add("-24344:");

			listwarnings.add("-02291");
			listwarnings.add("-0955");
			listwarnings.add("-04080");
			listwarnings.add("-01430");
			listwarnings.add("-01408");
			listwarnings.add("-02260");
			listwarnings.add("-01418");
			listwarnings.add("-02275");
			listwarnings.add("-04043");
			listwarnings.add("-0957");
			listwarnings.add("-0942");
			listwarnings.add("-02443");
			listwarnings.add("-02289");
			listwarnings.add("-24344:");
			// listwarnings.add("-02291:");
			// listwarnings.add("-04080:");
			// listwarnings.add("-02260:");
			// listwarnings.add("-02275:");
			// listwarnings.add("-04043:");
			// listwarnings.add("-00957:");
			// listwarnings.add("-00942:");
			// listwarnings.add("-02443:");
			// listwarnings.add("-02289:");

			for (String str : listwarnings) {
				if (ex.toString().contains(str)) {
					iswarning = true;
					warningnum = str;
					//trace de l'erreur sur migrationprocesslog
					 DateFormat df = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
				     Date stop = new Date();
					cs = connection.createStatement(); 
					String sqlErr =  "update  MIGRATIONPROCESSLOG set "+
							"stoptime = "+df.format(stop)+
							"SQLERRCODE = "+str+
							"SQLERRMESS = "+ ex.toString() +" where "+ sql +"=REQUETE" ;
										
					cs.execute(sqlErr);
					break;
				}
			}

//		if (!sql.replaceAll(" ", "").endsWith(";")) {
//			sql = sql + ";";
//		}

			if (!scriptmanagercontroller.isPopUpActive()) {
				com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
						fileDao.getFileById(session.getIdFile()));
				String Cashpath = welcomeController.getCachePath() + "\\MDVApp\\Cache\\";
				String resPath = Cashpath + fichier.getKit().getNomKit() + "\\" + "resultats\\";
				String cleanFile = resPath + fichier.getFileName();
				String logFile = fichier.getLogpath() + "\\"
						+ fichier.getFileName().substring(0, fichier.getFileName().length() - 4) + "_Log.txt";
				if (iswarning) {
					Files.write(Paths.get(logFile),
							("/* -------------------------- warning !!!!!!!!! --------------------------*/"
									+ "\n Num : " + warningnum + sql + "\n "
									+ "   --------------------------    End Warning    -------------------------- */\n\n")
											.getBytes(),
							StandardOpenOption.APPEND);
					Files.write(Paths.get(cleanFile),
							("/* -------------------------- warning !!!!!!!!! --------------------------" + "\n Num : "
									+ warningnum + sql + "\n "
									+ "   --------------------------    End Warning    -------------------------- */\n\n")
											.getBytes(),
							StandardOpenOption.APPEND);
					/// mise à jour de la table File (currentLine)
					System.out.println(fichier);
					fichier.setCurrentline(session.getLine());
					fileDao.save(fichier);
					///////////////////// fin mise à jour
					///////////////////// fin mise à jour
					// Mise à jour du kit
					Set tmpFiles = new HashSet<FileHistory>(session.getKit().getFilesExecutes());
					for (FileHistory element : session.getKit().getFilesExecutes()) {
						if (element.getId() == fichier.getId()) {
							tmpFiles.remove(element);
							tmpFiles.add(fichier);
							session.getKit().setFilesExecutes(tmpFiles);
							break;
						}
					}

					///////////////////// fin mise à jour

					// executefile.continueScript();
				} else {
					Platform.runLater(() -> welcomeController.getExecutebtn().setVisible(false));
					Platform.runLater(() -> welcomeController.getConnectstate().setStyle("-fx-Fill : #F28400"));
					Platform.runLater(() -> welcomeController.getTitre().setText("En attente"));
					Platform.runLater(() -> welcomeController.getTitre().setPrefWidth(200));
					session.setExePaused(1);
					Files.write(Paths.get(logFile),
							("/* -------------------------- Erreur !!!!!!!!! --------------------------"
									+ "\n Exception : " + ex
									+ "                    ------------------------------                    \n" + sql
									+ "\n"
									+ "--------------------------      End Erreur     --------------------------  */\n\n")
											.getBytes(),
							StandardOpenOption.APPEND);

					executefile.getConsoleLog().setText("Numero de ligne : " + session.getLine() + "\n" + ex);

					// PopUp.ScriptManagerPopUp();
					// scriptmanagercontroller.getScriptEditor().setText(""+sql);
					executefile.getQueryProblem().setText(sql);
					mainController.setLog(new String(sql));
					mainController.setError(new String("Numero de ligne ss : " + session.getLine() + "\n" + ex));
					connection.close();
				}
			}
		}
	}
}