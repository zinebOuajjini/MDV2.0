package com.sopraMdv.anotherProject.util;

import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sopraMdv.anotherProject.Controller.Session;
import com.sopraMdv.anotherProject.Controller.WelcomeController;

@Service
public class DataExportService {
	
	private static final String PathSeparator = System.getProperty("file.separator");

	private WelcomeController welcomecontroller;

	public WelcomeController getWelcomecontroller() {
		return welcomecontroller;
	}

	@Autowired
	public void setWelcomecontroller(WelcomeController welcomecontroller) {
		this.welcomecontroller = welcomecontroller;
	}

	private Session session;

	@Autowired
	public void setSession(Session session) {
		this.session = session;
	}

	public void exportData(Connection cnx, String sql, String nom) throws Exception {
		String exportFilePath = welcomecontroller.getCachePath() + ""+PathSeparator+"MDVApp" + ""+PathSeparator+"Cache"+PathSeparator+""
				+ session.getKit().getNomKit() + ""+PathSeparator+"" + nom + ".xls";
		
		//exportFilePath = exportFilePath.replaceAll("\\\\", "\\\\\\\\");
		
		Workbook writeWorkbook = new HSSFWorkbook();
		Sheet desSheet = writeWorkbook.createSheet("new sheet");

		Statement stmt = null;
		ResultSet rs = null;
		try {

			stmt = cnx.createStatement();
			rs = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnsNumber = rsmd.getColumnCount();

			Row desRow1 = desSheet.createRow(0);
			for (int col = 0; col < columnsNumber; col++) {
				Cell newpath = desRow1.createCell(col);
				newpath.setCellValue(rsmd.getColumnLabel(col + 1));
			}
			while (rs.next()) {
				//System.out.println("Row number" + rs.getRow());
				Row desRow = desSheet.createRow(rs.getRow());
				for (int col = 0; col < columnsNumber; col++) {
					Cell newpath = desRow.createCell(col);
					newpath.setCellValue(rs.getString(col + 1));
				}
				FileOutputStream fileOut = new FileOutputStream(exportFilePath);
				writeWorkbook.write(fileOut);
				fileOut.close();
			}
		} catch (SQLException e) {
			System.out.println("Failed to get data from database");
		}
	}
}
