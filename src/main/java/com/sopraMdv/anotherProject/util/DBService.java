package com.sopraMdv.anotherProject.util;

import java.sql.Connection;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sopraMdv.anotherProject.Controller.DataBaseConnexion;
import com.sopraMdv.anotherProject.Controller.HistoriqueController;
import com.sopraMdv.anotherProject.Controller.Session;
import com.sopraMdv.anotherProject.Controller.WelcomeController;
import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.entities.FileHistory;

import javafx.application.Platform;
import javafx.concurrent.Task;

@Service
public class DBService extends javafx.concurrent.Service<Object> {

	private int counter, stop;
	List<String> listMulti;
	private FileHistoryDAO fileDao;
	private boolean checkMulti;
	private boolean isPackage, isDeclareBlock;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileHistoryDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}

	private WelcomeController welcomecontroller;

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	private Session session;

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	private DataBaseConnexion dbConnexion;

	public DataBaseConnexion getDbConnexion() {
		return dbConnexion;
	}

	@Autowired
	public void setDbConnexion(DataBaseConnexion dbConnexion) {
		this.dbConnexion = dbConnexion;
	}

	private HistoriqueController historiqueController;

	public HistoriqueController getHistoriqueController() {
		return historiqueController;
	}

	@Autowired
	public void setHistoriqueController(HistoriqueController historiqueController) {
		this.historiqueController = historiqueController;
	}

	@Override
	protected Task createTask() {

		// SplitFileTask task = new SplitFileTask(dbConnexion, session,
		// welcomecontroller,
		// fileDao, historiqueController);

		return new Task() {

			@Override
			protected Void call() throws Exception {

				Scanner sc = session.getScanner();
				Connection cnx = session.getCnx();
				String s1 = "", s2 = "", s3 = "";
				FileHistory file = fileDao.getFileById(session.getIdFile());
				DateFormat df = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
				double progressVal = 0;
				try {
					while (sc.hasNext()) {
						s1 = sc.nextLine();
						session.setLine(session.getLine() + 1);
						session.setPreLine(session.getLine());
						session.setScanner(sc);
						progressVal = ((double) session.getLine() / file.getLines()) * 100;
						try {
							session.setSqlStartDate(df.format(new Date()));
							dbConnexion.executeQuery(s1.trim(), cnx);
						} catch (Exception e) {
							if (session.getCnx() == null || session.getCnx().isClosed()) {
								return null;
							}
							e.printStackTrace();
							System.out.println("a warning occurred;");
						}
						this.updateMessage((new DecimalFormat("##.##")).format(progressVal) + "%");
						this.updateProgress((float) session.getLine() / file.getLines(), 1);
					}
					// -------end of file
					FileHistory fichier = new FileHistory(fileDao.getFileById(session.getIdFile()));
					/// mise à jour de la table File (currentLine)
					// on fait ce tst car parfois la ligne dans la base rest toujoours dans la ligne
					/// l'avant dernier.
					int val = 0;
					if (fichier.getLines() - session.getLine() == 1) {
						val = 1;
					}
					fichier.setCurrentline(session.getLine() + val);
					/// mise à jour de la table File (dateFin)
					DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
					Date date = new Date();
					String dateFin = dateFormat.format(date);
					fichier.setDateFin(dateFin);
					//////////////////// enregistrement
					if(session.getLine() != null) {
						fileDao.save(fichier);
					}
					///////////////////// fin mise à jour
					Platform.runLater(() -> welcomecontroller.getMovingGears().setVisible(false));
					// historiqueController.executeKit();
					session.setFileDone(true);
					//close file scanner : important
					sc.close();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return null;
			}
		};
	}

//	@Override
//	protected Task createTask() {
//
//		// SplitFileTask task = new SplitFileTask(dbConnexion, session,
//		// welcomecontroller,
//		// fileDao, historiqueController);
//
//		return new Task() {
//
//			@Override
//			protected Void call() throws Exception {
//
//				Scanner sc = session.getScanner();
//				Connection cnx = session.getCnx();
//				String s1 = "", s2 = "", s3 = "";
//				FileHistory file = fileDao.getFileById(session.getIdFile());
//
//				listMulti = new ArrayList<String>(FillListMulti());
//
//				try {
//
//					int querytype = 0; // 0 : single line query -- 1 : multi-line query
//
//					while (sc.hasNext()) {
//
//						if (session.getExePaused() == 1) { // is paused ?
//							break;
//						}
//						checkMulti = true;// set to check if there is a multiline inside another multiline
//						s1 = sc.nextLine();
//						session.setLine(session.getLine() + 1);
//						s1 = eliminateComments(s1, sc);
//						// System.out.println("--" + IsMultiline2(s1, sc));
//						s3 = IsMultiline2(s1, sc);
//						// querytype = IsMultiLine(s1, listMulti);
//						if (!s3.isEmpty()) {
//							// s2 = MultiLine(s1, sc).trim().replaceAll("\n+", "\n");
//							s2 = s3;
//							System.out.println("--" + s2);
//							session.setPreLine(session.getLine());
//							session.setScanner(sc);
//
//							dbConnexion.executeQuery(s2, cnx);
//							double progressVal =  ((double) session.getLine() / file.getLines()) * 100;
//							if(progressVal>100)
//								progressVal = 100;
//							dbConnexion.executeQuery(s2.trim(), cnx);
//							this.updateMessage((new DecimalFormat("##.##")).format(progressVal) + "%");
//							this.updateProgress((float) session.getLine() / file.getLines(), 1);
//						} else {
//							s2 = "";
//							if (!sc.hasNext()) {
//								s2 += "\n" + s1;
//							}
//							while (sc.hasNext()) {
//								if (!s1.equals("")) {
//									s2 += "\n" + s1 + " ";
//								}
//
//								if (s1.contains(";"))
//									break;
//
//								s1 = sc.nextLine();
//								session.setLine(session.getLine() + 1);
//
//								if (!sc.hasNext()) {
//									s2 += "\n" + s1;
//								}
//							}
//							if (querytype == 0) {
//								session.setPreLine(session.getLine());
//								session.setScanner(sc);
//								if (s2.replaceAll(" ", "").endsWith(";")) {
//									s2 = s2.replaceAll(" +$", "").replaceAll(";$", "");
//								}
//								if (s2.replaceAll("\n", "").isEmpty()) {
//									break;
//								} else {
//									double progressVal =  ((double) session.getLine() / file.getLines()) * 100;
//									if(progressVal>100)
//										progressVal = 100;
//									dbConnexion.executeQuery(s2.trim(), cnx);
//									this.updateMessage((new DecimalFormat("##.##")).format(progressVal) + "%");
//									this.updateProgress((float) session.getLine() / file.getLines(), 1);
//								}
//							}
//
//						}
//					}
//					// -------end of file
//					FileHistory fichier = new FileHistory(fileDao.getFileById(session.getIdFile()));
//					/// mise à jour de la table File (currentLine)
//					fichier.setCurrentline(session.getLine());
//					/// mise à jour de la table File (dateFin)
//					DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
//					Date date = new Date();
//					String dateFin = dateFormat.format(date);
//					fichier.setDateFin(dateFin);
//					//////////////////// enregistrement
//					fileDao.save(fichier);
//					///////////////////// fin mise à jour
//					Platform.runLater(() -> welcomecontroller.getMovingGears().setVisible(false));
//					// historiqueController.executeKit();
//					session.setFileDone(true);
//				} catch (Exception e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				return null;
//			}
//		};
//	}

	public String IsMultiline2(String s1, Scanner sc) {
		String s2 = "";
		int linecount = 0;
		isPackage = false;
		isDeclareBlock = false;
		String tmpStrNoSpaces = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
		String tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" +", " ").trim().toLowerCase();
		String[] words = tmpStr.split(" ");
		int wordCounter = 0;
		if (words[0].matches("create")) {
			while (sc.hasNext()) {
				if (Arrays.stream(words).anyMatch("package"::equals) || isPackage) {
					isPackage = true;
					if (Arrays.stream(words).anyMatch("body"::equals)) {
						return s2 + MultiLine(s1, sc);
					} else if ((Arrays.stream(words).anyMatch("as"::equals))
							&& !Arrays.stream(words).anyMatch("body"::equals)) {
						checkMulti = false;
						return s2 + MultiLine(s1, sc);
					} else {
						s2 += s1 + "\n";
						s1 = sc.nextLine();
						session.setLine(session.getLine() + 1);
						tmpStrNoSpaces = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
						tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", " ").trim().toLowerCase();
						words = tmpStr.split(" ");
					}
				} else if (Arrays.stream(words).anyMatch("type"::equals)) {
					return s2 + MultilineIsType(s1, sc);
				} else if (Arrays.stream(words).anyMatch("function"::equals)
						|| Arrays.stream(words).anyMatch("procedure"::equals)
						|| Arrays.stream(words).anyMatch("trigger"::equals)) {
					return s2 + MultiLine(s1, sc);
				} else if (linecount == 0 && !(tmpStrNoSpaces.endsWith("create")
						|| tmpStrNoSpaces.endsWith("createorreplace") || tmpStrNoSpaces.endsWith("createor"))) {
					return "";
				} else {

					if (!s1.isEmpty()) {
						linecount++;
					}
					if (linecount >= 4) {
						return "";
					}

					s2 += s1 + "\n";
					s1 = sc.nextLine();
					session.setLine(session.getLine() + 1);
					s1 = eliminateComments(s1, sc);
					tmpStrNoSpaces = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
					tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" +", " ").toLowerCase();
					words = tmpStr.split(" ");
				}
			}
		}

		else if (tmpStr.startsWith("declare")) {
			isDeclareBlock = true;
			return s2 + MultiLine(s1, sc);
		}

		else if (tmpStr.startsWith("begin"))
			return s2 + MultiLine(s1, sc);

		return "";
	}

	public String IsMultiline3(String s1, Scanner sc) {
		String s2 = "";
		int linecount = 0;
		isPackage = false;
		isDeclareBlock = false;
		String tmpStrNoSpaces = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
		String tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", " ").toLowerCase();
		if (tmpStrNoSpaces.startsWith("create")) {
			while (sc.hasNext()) {
				if (tmpStr.contains("package") || isPackage) {
					isPackage = true;
					if (tmpStr.matches(".*( body | body).*")) {
						return s2 + MultiLine(s1, sc);
					} else if ((tmpStr.matches(".*( as | as).*") || tmpStr.matches("as"))
							&& !tmpStr.contains(" body ")) {
						checkMulti = false;
						return s2 + MultiLine(s1, sc);
					} else {
						s2 += s1 + "\n";
						s1 = sc.nextLine();
						session.setLine(session.getLine() + 1);
						tmpStrNoSpaces = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
						tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", " ").toLowerCase();
					}
				} else if (tmpStr.matches(".*( type | type\n).*")) {
					return s2 + MultilineIsType(s1, sc);
				} else if (tmpStr.contains("function") || tmpStr.contains("procedure") || tmpStr.contains("trigger")) {
					return s2 + MultiLine(s1, sc);
				} else if (linecount == 0 && !(tmpStrNoSpaces.endsWith("create")
						|| tmpStrNoSpaces.endsWith("createorreplace") || tmpStrNoSpaces.endsWith("createor"))) {
					return "";
				} else {
					if (!s1.isEmpty()) {
						linecount++;
					}

					if (linecount >= 4)
						return "";

					s2 += s1 + "\n";
					s1 = sc.nextLine();
					session.setLine(session.getLine() + 1);
					tmpStrNoSpaces = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
					tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", " ").toLowerCase();
				}
			}
		}

		else if (tmpStr.startsWith("declare")) {
			isDeclareBlock = true;
			return s2 + MultiLine(s1, sc);
		}

		else if (tmpStr.startsWith("begin"))
			return s2 + MultiLine(s1, sc);

		return "";
	}

	public String MultilineIsType(String s1, Scanner sc) {
		String s2 = "";
		while (sc.hasNext()) {
			// s1 = eliminateComments(s1, sc);
			//
			// querytype = IsMultiLine(s2 + s1, listMulti);
			// if (querytype == 1) {
			// s2 += MultiLine(s1, sc).trim();
			// System.out.println("-----------------------------");
			// System.out.println(s2);
			// System.out.println("-----------------------------");
			// session.setPreLine(session.getLine());
			// session.setScanner(sc);
			//
			// // dbConnexion.executeQuery(s2, cnx);
			// this.updateMessage(session.getLine().toString());
			//
			// break;
			// }
			if (!s1.equals("")) {
				s2 += "\n" + s1 + " ";
			}

			if (s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase().matches("/"))
				break;

			s1 = sc.nextLine();
			session.setLine(session.getLine() + 1);

			if (!sc.hasNext()) {
				s2 += "\n" + s1;
			}

		}
		return s2;
	}

	public int IsMultiLineInsideMultiline(String s1, List<String> list) {
		String tmpStr = s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" ", "").toLowerCase();
		for (String str : list) {
			if (tmpStr.startsWith(str) && !tmpStr.endsWith(";"))
				return 1;
		}
		return 0;
	}

	public List<String> FillListMulti() {
		List<String> list = new ArrayList<String>();
		list.add("function");
		list.add("trigger");
		// list.add("sequence");
		list.add("procedure");
		list.add("package");
		return list;
	}

	public int IsMultiLine(String s1, List<String> list) {

		for (String str : list) {
			if (s1.replaceAll("\t", " ").replaceAll(" +", " ").toLowerCase().contains("create " + str))
				return 1;
			if (s1.replaceAll("\t", " ").replaceAll(" +", " ").toLowerCase().contains("create or replace " + str))
				return 1;
			if (s1.replaceAll("\t", " ").replaceAll(" ", "").toLowerCase().startsWith("declare"))
				return 1;
			if (s1.replaceAll("\t", " ").replaceAll(" ", "").toLowerCase().startsWith("begin"))
				return 1;
		}
		return 0;
	}

	public String MultiLine(String s1, Scanner sc) {
		stop = 0;
		counter = 0;
		String s2 = "";

		// if (s1.toLowerCase().contains("declare"))
		// counterForDeclare++;
		//
		// if (s1.toLowerCase().contains("package"))
		// stop = -1;

		while (sc.hasNext()) {
			s1 = eliminateComments(s1, sc);

			if (IsMultiLineInsideMultiline(s1, listMulti) == 1 && checkMulti) {
				s2 += "\n" + s1;

				s1 = sc.nextLine();
				session.setLine(session.getLine() + 1);

				s2 += MultiLine(s1, sc);

				if (sc.hasNext() && (isPackage || isDeclareBlock)) {
					s1 = sc.nextLine();
					session.setLine(session.getLine() + 1);
					continue;
				} else
					break;
			}

			if (!s1.equals("")) {
				s2 += "\n" + s1 + " ";
			}

			System.out.println(counter + " || " + s1);
			////////////////////

			if (s1.toLowerCase().contains("begin"))
				counter++;
			if (s1.replaceAll(" ", "").toLowerCase().contains("end;")) {
				counter--;
				if (counter <= stop) {
					break;
				}

				s1 = sc.nextLine();
				// System.out.println(counter+"---"+s1);
				session.setLine(session.getLine() + 1);
				continue;
			}
			if (s1.toLowerCase().replaceAll("\t", " ").replaceAll(" +", " ").contains(" end ")
					|| s1.toLowerCase().replaceAll("\t", " ").replaceAll(" +", " ").startsWith("end ")) {
				if (s1.replaceAll(" ", "").toLowerCase().contains("endif")
						|| s1.replaceAll(" ", "").toLowerCase().contains("endloop")
						|| s1.replaceAll(" ", "").toLowerCase().contains("endcase")
						|| s1.replaceAll(" ", "").toLowerCase().contains("endquery")) {

				} else if (s1.replaceAll(" +", " ").replaceAll("\t", " ").toLowerCase().startsWith("end ")
						|| s1.replaceAll(" +", " ").replaceAll("\t", " ").toLowerCase().contains(" end ")) {
					counter--;
					if (counter <= stop) {
						// System.out.println(counter+"--exiting--"+s1);
						break;
					}
				}
			}

			s1 = sc.nextLine();
			session.setLine(session.getLine() + 1);

			if (!sc.hasNext()) {
				s2 += "\n" + s1;
			}

		}
		return s2;

	}

	public String eliminateComments(String s1, Scanner sc) {

		String s3 = "";
		// s1 = s1.replaceAll("\t", " ");
		if ((s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" +", "").isEmpty()) && sc.hasNext()) {
			// if line is emty or has second end after a multiline
			// query(somtimes the query has "end NAME-PROCEDUR" and a second "end;").

			s1 = sc.nextLine();
			session.setLine(session.getLine() + 1);
			s1 = eliminateComments(s1, sc);
		}
		if (s1.replaceAll(" ", "").equals("/")) { // if line has only the character '/' .
			if (sc.hasNextLine()) {
				s1 = sc.nextLine();
				session.setLine(session.getLine() + 1);
			} else
				s1 = "";
		} else if (s1.contains("/*") && !s1.contains("*/")) { // if comment starts and doesn't end in the same line.

			s3 = s1.replaceAll("/\\*.*", " ");
			while (sc.hasNext()) {
				if (s1.contains("*/")) {// if comment ends.
					s1 = s1.replaceAll("/\\*.*?\\*/", " ");
					s3 += s1.replaceAll(".*?\\*/", " ");
					break;
				} else {
					s1 = sc.nextLine();
					session.setLine(session.getLine() + 1);
				}
			}
			s1 = s3;
		} else if (s1.contains("/*") && s1.contains("*/")) {// if line has entire comment(/**/) .
			s1 = s1.replaceAll("/\\*.*?\\*/", " ");
		}
		if (s1.contains("--")) {// if line has comment(--).
			// System.out.println("found one line");
			String[] str = s1.split("--");
			if (str.length > 1) {
				if (s1.contains("'")) { // if -- inside a single quotes like ( val = '--ERROR--' )
					String[] str1 = s1.split("'");
					String str2 = "";
					boolean var = true; // is inside single quotes
					for (int i = 0; i < s1.length(); i++) {
						if (s1.charAt(i) == '\'') {
							var = !var;
						}
						if (var == true && i < s1.length() - 1 && s1.charAt(i) == '-' && s1.charAt(i + 1) == '-') {
							s1 = s1.substring(0, i);
							break;
						}
					}
				} else {
					s1 = str[0];
				}

			} else {
				s1 = "";
			}
		}
		if (s1.replaceAll("\n", "").replaceAll("\t", "").replaceAll(" +", "").isEmpty()) {
			// if line has only spaces,"\t" or "\n".
			// this happens when there is only comments in a line or for a long set of lines
			// and the line only contains spaces,"\t" or "\n"
			// so this bloc is important !!!!
			if (sc.hasNext()) {
				s1 = sc.nextLine();
				session.setLine(session.getLine() + 1);
				s1 = eliminateComments(s1, sc);
			} else
				s1 = "";
		}
		return s1;
	}

}
