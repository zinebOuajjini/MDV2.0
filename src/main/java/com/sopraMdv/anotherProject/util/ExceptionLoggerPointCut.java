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
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Alert.AlertType;

@Configuration
@Aspect
public class ExceptionLoggerPointCut {

	private static final String PathSeparator = System.getProperty("file.separator");

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
		Statement cs = null;

		if (ex.toString().contains("java.sql.SQLRecoverableException: Erreur d'E/S: Socket read timed out")
				|| ex.toString().contains("-01000:")) {

//			System.out.println(ex.toString());
			Platform.runLater(() -> {
				Alert alert = new Alert(AlertType.ERROR);
				alert.setTitle("erreur : curseur ");
				alert.setHeaderText("erreur :  connexion fermée");
				alert.setContentText(ex.getMessage());
				alert.showAndWait().get();
				try {
					welcomeController.stopScript(1);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});

			connection.commit();
			connection.close();
			return;
		}

		Boolean iswarning = false;
		String warningnum = "";
		List<String> listwarnings = new ArrayList<String>();
//			listwarnings.add("-01418:");
//			listwarnings.add("-00001:");
//			listwarnings.add("-01430:");
//			listwarnings.add("-02443:");
//			listwarnings.add("-01442:");
//			listwarnings.add("-24344:");
		// IF (SQLCODE in
		// (-2291,-955,-4080,-1430,-1408,-2260,-1418,-2275,-4043,-957,-942,-2443,-2289,-1))
		// THEN
		listwarnings.add("ORA-02291");
		listwarnings.add("ORA-00955");
		listwarnings.add("ORA-04080");
		// listwarnings.add("ORA-01430");
		listwarnings.add("ORA-01408");
		listwarnings.add("ORA-02260");
		listwarnings.add("ORA-01418");
		listwarnings.add("ORA-02275");
		listwarnings.add("ORA-04043");
		listwarnings.add("ORA-00957");
		listwarnings.add("ORA-00942");
		listwarnings.add("ORA-02443");
		listwarnings.add("ORA-02289");
		listwarnings.add("ORA-24344");
		listwarnings.add("ORA-00001");

		// listwarnings.add("-00955:");
		// listwarnings.add("-00001:");
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
				// trace de l'erreur sur migrationprocesslog
//					 DateFormat df = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
//				     Date stop = new Date();
//					cs = connection.createStatement(); 
//					String sqlErr =  "update  MIGRATIONPROCESSLOG set "+
//							"stoptime = "+df.format(stop)+
//							"SQLERRCODE = "+str+
//							"SQLERRMESS = "+ ex.toString() +" where "+ sql +"=REQUETE" ;
//										
//					cs.execute(sqlErr);
				break;
			}
		}

//		if (!sql.replaceAll(" ", "").endsWith(";")) {
//			sql = sql + ";";
//		}

		if (!scriptmanagercontroller.isPopUpActive()) {
			com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
					fileDao.getFileById(session.getIdFile()));
			String Cashpath = session.getAppLogPath() + "" + PathSeparator + "MDVApp" + PathSeparator + "Cache"
					+ PathSeparator + "";
			String resPath = Cashpath + fichier.getKit().getNomKit() + "" + PathSeparator + "" + "resultats"
					+ PathSeparator + "";
			// String cleanFile = resPath + fichier.getFileName();
			String logFile = fichier.getLogpath()
					+ fichier.getFileName().substring(0, fichier.getFileName().length() - 4) + "_Log.txt";
			DateFormat df = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
			String sql1 = "insert into  MIGRATIONPROCESSLOG "
					+ "(starttime,STOPTIME, SCRIPTNAME,STEPNAME,SQLERRCODE,SQLERRMESS)" + "values ('"
					+ session.getSqlStartDate() + "','" + df.format(new Date()) + "','" + fichier.getFileName() + "',"
					+ session.getLine() + ",'"
					+ ex.toString().replaceAll("\n.*", "").replaceAll(".*ORA-", "").replaceAll(":.*", "") + "','"
					+ ex.toString().replaceAll(".*ORA-", "ORA-").replaceAll("\n.*", "").replaceAll("'", " ") + "')";
//			System.out.println(ex.toString().replaceAll("\n.*", " ").replaceAll(".*ORA-", "").replaceAll(":.*", "")
//					.replaceAll("'", " "));
			System.out.println(sql1);
			cs = connection.createStatement();
			try {
				cs.execute(sql1);
			} catch (Exception e) {
				System.out.println("erreur : " + ex.getStackTrace());
				connection.close();
			}
			cs.close();
			if (iswarning) {
				try {
					Files.write(Paths.get(logFile), ("/* -------------------------- warning !!!!!!!!! ligne : "
							+ session.getLine() + "--------------------------*/" + "\n Num : " + warningnum + sql
							+ "\n "
							+ "   --------------------------    End Warning    -------------------------- */\n\n")
									.getBytes(),
							StandardOpenOption.APPEND);
				} catch (Exception nex) {
					Platform.runLater(() -> {
						Alert alert = new Alert(AlertType.ERROR);
						alert.setTitle("erreur");
						alert.setHeaderText("fichier non trouvé: \n" + logFile);
						alert.setContentText(nex.getMessage());
						alert.showAndWait().get();
						try {
							welcomeController.stopScript(1);
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					});
					connection.close();
					return;
				}

//					Files.write(Paths.get(cleanFile),
//							("/* -------------------------- warning !!!!!!!!! ligne : "+session.getLine()+"--------------------------" + "\n --Num : "
//									+ warningnum + sql + "\n "
//									+ "   --------------------------    End Warning    -------------------------- */\n\n")
//											.getBytes(),
//							StandardOpenOption.APPEND);
				/// mise à jour de la table File (currentLine)

				// System.out.println(fichier);
				fichier.setCurrentline(session.getLine());
				if (session.getLine() != null) {
					fileDao.save(fichier);
				}

				//// starting movingGears
				Platform.runLater(() -> welcomeController.getMovingGears().setVisible(true));
				Platform.runLater(() -> welcomeController.getOnTopPane().setVisible(true));
				/////

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

//					Statement migStatement = connection.createStatement();
//					migStatement.executeUpdate("update MIGRATIONPROCESS set SCRIPTNAME = 'test'");
			} else {
				//// stopping movingGears
				Platform.runLater(() -> welcomeController.getMovingGears().setVisible(false));
				Platform.runLater(() -> welcomeController.getOnTopPane().setVisible(false));
				/////
				Platform.runLater(() -> welcomeController.getExecutebtn().setVisible(false));
				Platform.runLater(() -> welcomeController.getConnectstate().setStyle("-fx-Fill : #F28400"));
				Platform.runLater(() -> welcomeController.getTitre().setText("En attente"));
				Platform.runLater(() -> welcomeController.getTitre().setPrefWidth(200));
				session.setExePaused(1);
				try {
					Files.write(Paths.get(logFile), ("/* -------------------------- Erreur !!!!!!!!! ligne : "
							+ session.getLine() + "--------------------------" + "\n Exception : " + ex
							+ "                    ------------------------------                    \n" + sql + "\n"
							+ "--------------------------      End Erreur     --------------------------  */\n\n")
									.getBytes(),
							StandardOpenOption.APPEND);
				} catch (Exception newex) {
					Platform.runLater(() -> {
						Alert alert = new Alert(AlertType.ERROR);
						alert.setTitle("erreur");
						alert.setHeaderText("fichier non trouvé: \n" + logFile);
						alert.setContentText(newex.getMessage());
						alert.showAndWait().get();
					});
				}

				executefile.getConsoleLog().setText("Numero de ligne : " + session.getLine() + "\n" + ex);

				// PopUp.ScriptManagerPopUp();
				// scriptmanagercontroller.getScriptEditor().setText(""+sql);
				executefile.getQueryProblem().setText(sql);
				mainController.setLog(new String(sql));
				mainController.setError(new String("Numero de ligne ss : " + session.getLine() + "\n" + ex));
//					Statement migStatement = connection.createStatement();
//					migStatement.executeUpdate("update MIGRATIONPROCESS set SCRIPTNAME = 'test'");
//					System.out.println(new Date());
				connection.close();
			}
		}

	}
}