package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.sql.Connection;
import java.util.Date;
import java.text.DateFormat;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.Server;

import javafx.application.Platform;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Alert.AlertType;

@Controller
public class DataBaseConnexion {

	private static final String PathSeparator = System.getProperty("file.separator");

	private Connection connection = null;
	private Session session = null;
	private String driverName = "oracle.jdbc.driver.OracleDriver";
	private com.sopraMdv.anotherProject.Controller.Session sessionController;

	public void setSession(Session session) {
		this.session = session;
	}

	public Session getSession() {
		return session;
	}

	private MainController mainController;

	public com.sopraMdv.anotherProject.Controller.Session getSessionController() {
		return sessionController;
	}

	@Autowired
	public void setSessionController(com.sopraMdv.anotherProject.Controller.Session sessionController) {
		this.sessionController = sessionController;
	}

	public MainController getMainController() {
		return mainController;
	}

	@Autowired
	public void setMainController(MainController mainController) {
		this.mainController = mainController;
	}

	private FileHistoryDAO fileDao;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}

	private SplitFileController splitfile;

	public SplitFileController getSplitfile() {
		return splitfile;
	}

	@Autowired
	public void setSplitfile(SplitFileController splitfile) {
		this.splitfile = splitfile;
	}

	private WelcomeController welcomecontroller;

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	public Connection connectDB(DataBase db) throws SQLException {

		try {
			if (session == null) {

				// cnx au serveur
				// connectServer(server);
			}

			Class.forName(driverName);

			connection = DriverManager.getConnection(
					"jdbc:oracle:thin:@" + db.getHote() + ":" + db.getPort() + ":" + db.getSid(), db.getSchemaDB(),
					db.getPasswordDb());
			System.out.println("Connecté à la Base de Donnée!");

		} catch (Exception e) {

			e.printStackTrace();
			// session.disconnect();
			welcomecontroller.MyAlert(AlertType.ERROR, "Erreur de connexion", null, "echec de connexion au BD ");
			welcomecontroller.getOnTopPane().setVisible(false);
			return null;
		}
		return connection;
	}

	public Session connectServer(Server server) throws JSchException {

		JSch jsch = new JSch();
		// Get SSH session
		session = jsch.getSession(server.getUserName(), server.getHote(), 22);
		session.setPassword(server.getPassword());
		java.util.Properties config = new java.util.Properties();
		// Never automatically add new host keys to the host file
		config.put("StrictHostKeyChecking", "no");
		session.setConfig(config);
		// Connect to remote server
		session.connect();
		// Apply the port forwarding
		session.setPortForwardingL(1521, server.getHote(), 22);
		return session;
	}

	@Transactional
	public void executeQuery(String sql, Connection connection) throws SQLException, IOException {

		Statement cs = null;
		if (connection == null) {
			welcomecontroller.MyAlert(AlertType.ERROR, "Erreur de connexion", null, "echec de connexion au BD ");

		} else {
			com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
					fileDao.getFileById(sessionController.getIdFile()));
			String Cashpath = sessionController.getAppLogPath() + "" + PathSeparator + "MDVApp" + PathSeparator
					+ "Cache" + PathSeparator + "";
			String resPath = Cashpath + fichier.getKit().getNomKit() + "" + PathSeparator + "" + "resultats"
					+ PathSeparator + "";
			String cleanFile = resPath + fichier.getFileName();
			String logFile = fichier.getLogpath() 
					+ fichier.getFileName().substring(0, fichier.getFileName().length() - 4) + "_Log.txt";
			Statement ps = connection.createStatement();

			DateFormat df = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
			Date start = new Date();

			ps.execute(sql);

			String sql1 = "insert into  MIGRATIONPROCESSLOG " + "(starttime,STOPTIME, SCRIPTNAME,STEPNAME,SQLERRCODE)"
					+ "values ('" + sessionController.getSqlStartDate() + "','" + df.format(new Date()) + "','"
					+ fichier.getFileName() + "'," + sessionController.getLine() + ",'" + "0" + "')";
			// System.out.println(sql1);
			cs = connection.createStatement();
			cs.execute(sql1);
			cs.close();

			fichier.setCurrentline(sessionController.getLine());
			if(sessionController.getLine() != null) {
				fileDao.save(fichier);
			}
			try {
				Files.write(Paths.get(cleanFile), (sql + "\n").getBytes(), StandardOpenOption.APPEND);
			} catch (Exception ex) {
				Platform.runLater(() -> {
					Alert alert = new Alert(AlertType.CONFIRMATION);
					alert.setTitle("erreur");
					alert.setHeaderText("fichier non trouvé: \n" + cleanFile);
					alert.setContentText(ex.getMessage());
					if (alert.showAndWait().get() == ButtonType.OK) {

					}
				});
				welcomecontroller.stopScript(0);
			}

			try {
				Files.write(Paths.get(logFile),
						("/* ------------------------------   Succés ligne : " + sessionController.getLine()
								+ "  -------------------------------  \n\n" + sql
								+ "\n -------------------------------------------------------------------------  */\n")
										.getBytes(),
						StandardOpenOption.APPEND);
			} catch (Exception ex) {
				Platform.runLater(() -> {
					Alert alert = new Alert(AlertType.CONFIRMATION);
					alert.setTitle("erreur");
					alert.setHeaderText("fichier non trouvé: \n" + logFile);
					alert.setContentText(ex.getMessage());
					if (alert.showAndWait().get() == ButtonType.OK) {

					}
				});
				welcomecontroller.stopScript(0);
			}

			ps.close();
		}
	}

	public void executeNewQuery(String sql, Connection connection, boolean savingStatus)
			throws SQLException, IOException {

		if (connection == null) {
			welcomecontroller.MyAlert(AlertType.ERROR, "Erreur de connexion", null, "echec de connexion au BD ");

		} else {
			com.sopraMdv.anotherProject.entities.FileHistory fichier = new com.sopraMdv.anotherProject.entities.FileHistory(
					fileDao.getFileById(sessionController.getIdFile()));
			String Cashpath = welcomecontroller.getCachePath() + "" + PathSeparator + "MDVApp" + PathSeparator + "Cache"
					+ PathSeparator + "";
			String resPath = Cashpath + fichier.getKit().getNomKit() + "" + PathSeparator + "" + "resultats"
					+ PathSeparator + "";
			String cleanFile = resPath + fichier.getFileName();
			String logFile = fichier.getLogpath() + "" + PathSeparator + ""
					+ fichier.getFileName().substring(0, fichier.getFileName().length() - 4) + "_Log.txt";
			Statement ps = connection.createStatement();
			ps.execute(sql);

//			ResultSet rs = ps.executeQuery(sql);
//
//			String row = "";
//			ResultSetMetaData metadata = rs.getMetaData();
//			int columnCount = metadata.getColumnCount();
//			while (rs.next()) {
//				row += "\n";
//				if (row.equals("\n")) {
//					for (int i = 1; i <= columnCount; i++) {
//						row += metadata.getColumnName(i) + "  " + metadata.getColumnTypeName(i) + " | ";
//					}
//				}
//				row += "\n";
//				for (int i = 1; i <= columnCount; i++) {
//					row += rs.getString(i) + " | ";
//				}
//			}
//			sessionController.setQueryResult(row);

//			if (!sql.replaceAll(" ", "").endsWith(";")) {
//				sql = sql + ";";
//			}
			sql = sql.replaceAll("\n", " ");
			if (savingStatus) {
				Files.write(Paths.get(cleanFile), (sql + "\n").getBytes(), StandardOpenOption.APPEND);
				Files.write(Paths.get(logFile),
						("/* ------------------------------   Succés   -------------------------------  \n\n" + sql
								+ "\n\n -------------------------------------------------------------------------  */\n\n")
										.getBytes(),
						StandardOpenOption.APPEND);
			}

			ps.close();
		}
	}

	public void executeCommand() throws JSchException, IOException {

		StringBuilder outputBuffer = new StringBuilder();

		Channel channel = session.openChannel("exec");
		((ChannelExec) channel).setCommand("");
		InputStream commandOutput = channel.getInputStream();
		channel.connect();
		int readByte = commandOutput.read();

		while (readByte != 0xffffffff) {
			outputBuffer.append((char) readByte);
			readByte = commandOutput.read();
		}

		channel.disconnect();

	}

}
