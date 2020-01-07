package com.sopraMdv.anotherProject.Controller;

import java.sql.Connection;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.dao.FileHistoryDAO;
import com.sopraMdv.anotherProject.entities.FileHistory;

@Controller
public class SplitFileController {

	private DataBaseConnexion dbConnexion;
	private Session session;
	private int counter;

	private HistoriqueController historiqueController;

	public HistoriqueController getHistoriqueController() {
		return historiqueController;
	}

	@Autowired
	public void setHistoriqueController(HistoriqueController historiqueController) {
		this.historiqueController = historiqueController;
	}

	public Session getSession() {
		return session;
	}

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	public DataBaseConnexion getDbConnexion() {
		return dbConnexion;
	}

	@Autowired
	public void setDbConnexion(DataBaseConnexion dbConnexion) {
		this.dbConnexion = dbConnexion;
	}

	private FileHistoryDAO fileDao;

	public FileHistoryDAO getFileDao() {
		return fileDao;
	}

	@Autowired
	public void setFileDao(FileHistoryDAO fileDao) {
		this.fileDao = fileDao;
	}
	
	private WelcomeController welcomecontroller;

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}
	
	public void ExtractQuery(Scanner sc, Connection cnx) {

		String s1 = "", s2 = "";

		List<String> listMulti = new ArrayList<String>(FillListMulti());

		/*
		 * FileReader file; FileOutputStream file2 = null; try { file = new FileReader(
		 * "D:\\Profiles\\saqaoui\\Documents\\testScript\\mig_V09.1.312_ora.sql"); file2
		 * = new
		 * FileOutputStream("D:\\Profiles\\saqaoui\\Documents\\testScript\\out.txt"); sc
		 * = new Scanner(file); } catch (FileNotFoundException e1) { // TODO
		 * Auto-generated catch block e1.printStackTrace();
		 * 
		 * }
		 */

		try {

			int querytype = 0;  // 0 :  single line query -- 1 : multi-line query

			while (sc.hasNext()) {

				if (session.getExePaused() == 1) { // is paused ?
					break;
				}

				s1 = sc.nextLine();

				// a++;
				session.setLine(session.getLine() + 1);

				/*
				 * s1 = eliminateComments(s1, sc); String ll = session.getLine() + " ||";
				 * file2.write(ll.getBytes()); file2.write(s1.getBytes());
				 * file2.write("\n".getBytes());
				 */

				s1 = eliminateComments(s1, sc);
				
					s2 = "";
					if (!sc.hasNext()) {
						s2 += "\n" + s1;
					}
					while (sc.hasNext()) {
						
						if (!s1.equals("")) {
							s2 += "\n" + s1 + " ";
						}

						if (s1.contains(";"))
							break;

						s1 = sc.nextLine();
						session.setLine(session.getLine() + 1);

						if (!sc.hasNext()) {
							s2 += "\n" + s1;
						}

					}
					// System.out.println(session.getLine() + "--------;---------"
					// + s2.trim().replaceAll("\n", "").replaceAll(" +", " ") +
					// "----------;-------");
					if (querytype == 0) {
						session.setPreLine(session.getLine());
						session.setScanner(sc);
						if (s2.replaceAll(" ", "").endsWith(";")) {
							s2 = s2.replaceAll(" +$", "").replaceAll(";$", "");
						}
						if (s2.replaceAll("\n", "").isEmpty()) {
							break;
						} else
							dbConnexion.executeQuery(s2.trim(), cnx);
					}

				
			}
				// -------end of file
				FileHistory fichier = new FileHistory(fileDao.getFileById(session.getIdFile()));
				/// mise à jour de la table File (currentLine)
				fichier.setCurrentline(session.getLine());
				/// mise à jour de la table File (dateFin)
				DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
				Date date = new Date();
				String dateFin = dateFormat.format(date);
				fichier.setDateFin(dateFin);
				//////////////////// enregistrement
				fileDao.save(fichier);
				///////////////////// fin mise à jour
			historiqueController.executeKit();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

//	public void ExtractQuery(Scanner sc, Connection cnx) {
//
//		String s1 = "", s2 = "";
//
//		List<String> listMulti = new ArrayList<String>(FillListMulti());
//
//		/*
//		 * FileReader file; FileOutputStream file2 = null; try { file = new FileReader(
//		 * "D:\\Profiles\\saqaoui\\Documents\\testScript\\mig_V09.1.312_ora.sql"); file2
//		 * = new
//		 * FileOutputStream("D:\\Profiles\\saqaoui\\Documents\\testScript\\out.txt"); sc
//		 * = new Scanner(file); } catch (FileNotFoundException e1) { // TODO
//		 * Auto-generated catch block e1.printStackTrace();
//		 * 
//		 * }
//		 */
//
//		try {
//
//			int querytype = 0;  // 0 :  single line query -- 1 : multi-line query
//
//			while (sc.hasNext()) {
//
//				if (session.getExePaused() == 1) { // is paused ?
//					break;
//				}
//
//				s1 = sc.nextLine();
//
//				// a++;
//				session.setLine(session.getLine() + 1);
//
//				/*
//				 * s1 = eliminateComments(s1, sc); String ll = session.getLine() + " ||";
//				 * file2.write(ll.getBytes()); file2.write(s1.getBytes());
//				 * file2.write("\n".getBytes());
//				 */
//
//				s1 = eliminateComments(s1, sc);
//				querytype = IsMultiLine(s1, listMulti);
//				if (querytype == 1) {
//					s2 = MultiLine(s1, sc).trim().replaceAll("\n+", "\n");
//					// System.out.println(session.getLine() + " ---------1multiLine--------"
//					// + s2.replaceAll("\n", "").replaceAll(" +", " ") +
//					// "---------1multiLine--------");
//					/*
//					 * String ll = session.getLine() + " ||"; file2.write(ll.getBytes());
//					 * file2.write("-----m---------".getBytes()); file2.write(s2.getBytes());
//					 * file2.write("\n".getBytes());
//					 */
//					session.setPreLine(session.getLine());
//					session.setScanner(sc);
//
//					dbConnexion.executeQuery(s2, cnx);
//
//				} else {
//					s2 = "";
//					if (!sc.hasNext()) {
//						s2 += "\n" + s1;
//					}
//					while (sc.hasNext()) {
//						s1 = eliminateComments(s1, sc);
//						querytype = IsMultiLine(s2 + s1, listMulti);
//						if (querytype == 1) {
//							s2 += MultiLine(s1, sc).trim();
//							// System.out.println(session.getLine() + " ---------2multiLine--------"
//							// + s2.replaceAll("\n", "").replaceAll(" +", " ") +
//							// "---------2multiLine--------");
//
//							session.setPreLine(session.getLine());
//							session.setScanner(sc);
//
//							dbConnexion.executeQuery(s2, cnx);
//
//							break;
//						}
//						if (!s1.equals("")) {
//							s2 += "\n" + s1 + " ";
//						}
//
//						if (s1.contains(";"))
//							break;
//
//						s1 = sc.nextLine();
//						session.setLine(session.getLine() + 1);
//
//						if (!sc.hasNext()) {
//							s2 += "\n" + s1;
//						}
//
//					}
//					// System.out.println(session.getLine() + "--------;---------"
//					// + s2.trim().replaceAll("\n", "").replaceAll(" +", " ") +
//					// "----------;-------");
//					if (querytype == 0) {
//						session.setPreLine(session.getLine());
//						session.setScanner(sc);
//						if (s2.replaceAll(" ", "").endsWith(";")) {
//							s2 = s2.replaceAll(" +$", "").replaceAll(";$", "");
//						}
//						if (s2.replaceAll("\n", "").isEmpty()) {
//							break;
//						} else
//							dbConnexion.executeQuery(s2.trim(), cnx);
//					}
//
//				}
//			}
//				// -------end of file
//				FileHistory fichier = new FileHistory(fileDao.getFileById(session.getIdFile()));
//				/// mise à jour de la table File (currentLine)
//				fichier.setCurrentline(session.getLine());
//				/// mise à jour de la table File (dateFin)
//				DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
//				Date date = new Date();
//				String dateFin = dateFormat.format(date);
//				fichier.setDateFin(dateFin);
//				//////////////////// enregistrement
//				fileDao.save(fichier);
//				///////////////////// fin mise à jour
//			historiqueController.executeKit();
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}

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
			if (s1.replaceAll(" +", " ").toLowerCase().contains("create " + str))
				return 1;
			if (s1.replaceAll(" +", " ").toLowerCase().contains("create or replace " + str))
				return 1;
			if (s1.replaceAll(" ", "").toLowerCase().startsWith("declare"))
				return 1;
			if (s1.replaceAll(" ", "").toLowerCase().startsWith("begin"))
				return 1;
		}
		return 0;
	}

	public String MultiLine(String s1, Scanner sc) {
		int stop = 0;
		counter = 0;
		String s2 = "";
		if (s1.toLowerCase().contains("package"))
			stop = -1;

		while (sc.hasNext()) {
			s1 = eliminateComments(s1, sc);

			if (!s1.equals("")) {
				s2 += "\n" + s1 + " ";
			}

//			 System.out.println(counter + " || " + s1);
			////////////////////

			if (s1.toLowerCase().contains("begin"))
				counter++;
			if (s1.replaceAll(" ", "").toLowerCase().contains("end;")) {
				counter--;
//				System.out.println(counter+"--before ending--"+s1);
				if (counter <= stop) {
					break;
				}
				s1 = sc.nextLine();
//				System.out.println(counter+"---"+s1);
				session.setLine(session.getLine() + 1);
				continue;
			}

			if (s1.toLowerCase().replaceAll(" +", " ").contains(" end ")
					|| s1.toLowerCase().replaceAll(" +", " ").startsWith("end ")) {
				if (s1.replaceAll(" ", "").toLowerCase().contains("endif")
						|| s1.replaceAll(" ", "").toLowerCase().contains("endloop")
						|| s1.replaceAll(" ", "").toLowerCase().contains("endcase")
						|| s1.replaceAll(" ", "").toLowerCase().contains("endquery")) {

				} else if (s1.replaceAll(" +", " ").toLowerCase().startsWith("end ")
						|| s1.replaceAll(" +", " ").toLowerCase().contains(" end ")) {
					counter--;
					if (counter <= stop) {
//						System.out.println(counter+"--exiting--"+s1);
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
		if ((s1.isEmpty()
				|| (counter == 0 && (s1.toLowerCase().startsWith("end ") || s1.toLowerCase().startsWith(" *end "))))
				&& sc.hasNext()) { // if line is emty or has second end after a multiline query(somtimes the query
									// has
									// "end NAME-PROCEDUR" and a second "end;").

			s1 = sc.nextLine();
			session.setLine(session.getLine() + 1);

		}
		if (s1.replaceAll(" ", "").equals("/")) { // if line has only the character '/' .
			if (sc.hasNextLine()) {
				s1 = sc.nextLine();
				session.setLine(session.getLine() + 1);
			} else
				s1 = "";
		} else if (s1.contains("/*") && !s1.contains("*/")) {   // if comment starts and doesn't end in the same line.

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
		// if (s1.contains("--")) {// if line has comment(--).
		// String[] str = s1.split("--");
		// if (str.length > 1) {
		// s1 = str[0];
		// } else
		// s1 = "";
		// }
		if (s1.replaceAll(" +", " ").equals(" ")) {// if line has only spaces(empty).
			s1 = "";
		}
		return s1;
	}
}