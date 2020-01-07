package com.sopraMdv.anotherProject.Controller;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.Kit;

@Controller
@Scope("singleton")
public class Session {

	
	private Kit kit;
	
	private String queryResult;

	private Long IdFile;
	
	private String fileopenerPath;

	private Scanner scanner;
	
	private ExecuteFileController executefile;

	private Connection cnx;
	
	private Long line,preLine;
	
	private int isExePaused;// 0 : not paused |1 : paused | 2 : paused but in initial state.
	
	private boolean isFileDone;// True if file has reached end| False if file hasn't reached end yet.
	
	public ExecuteFileController getExecutefile() {
		return executefile;
	}
	@Autowired
	public void setExecutefile(ExecuteFileController executefile) {
		this.executefile = executefile;
	}

	public Long getPreLine() {
		return preLine;
	}
	public void setPreLine(Long preLine) {
		this.preLine = preLine;
	}
	public Connection getCnxNew() throws SQLException {
		return executefile.connectDB(kit.getDatabase().getId()) ;
	}
	
	public Connection getCnx() throws SQLException {
		return cnx ;
	}

	public void setCnx(Connection cnx) {
		this.cnx = cnx;
	}

	public String getQueryResult() {
		return queryResult;
	}
	public void setQueryResult(String queryResult) {
		this.queryResult = queryResult;
	}
	public Long getIdFile() {
		return IdFile;
	}

	public void setIdFile(Long idFile) {
		IdFile = idFile;
	}


	public Kit getKit() {
		return kit;
	}
	public void setKit(Kit kit) {
		this.kit = kit;
	}
	
	public Scanner getScanner() {
		return scanner;
	}

	public void setScanner(Scanner scanner) {
		this.scanner = scanner;
	}
	
	public boolean isFileDone() {
		return isFileDone;
	}
	public void setFileDone(boolean isFileDone) {
		this.isFileDone = isFileDone;
	}

	public int getExePaused() {
		return isExePaused;
	}

	public void setExePaused(int isExePaused) {
		this.isExePaused = isExePaused;
	}
	public Long getLine() {
		return line;
	}
	public void setLine(Long line) {
		this.line = line;
	}
	public String getFileopenerPath() {
		return fileopenerPath;
	}
	public void setFileopenerPath(String fileopenerPath) {
		this.fileopenerPath = fileopenerPath;
	}

}
