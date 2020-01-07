package com.sopraMdv.anotherProject.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class FileHistory {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE)
	private Long Id;

	@ManyToOne
	private Kit kit;

//	@ManyToOne
//	private DataBase database;

	@Column
	private String fileName;

	@Column
	private String path;

	@Column
	private String logpath;

	@Column
	private Long currentline;

	@Column
	private Long lines;

	@Column
	private String dateDebut;

	@Column
	private String dateFin;

	public Long getId() {
		return Id;
	}

	public void setId(Long id) {
		Id = id;
	}

	


	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getLogpath() {
		return logpath;
	}

	public void setLogpath(String logpath) {
		this.logpath = logpath;
	}

	public Long getCurrentline() {
		return currentline;
	}

	public void setCurrentline(Long currentline) {
		this.currentline = currentline;
	}

	public Long getLines() {
		return lines;
	}

	public void setLines(Long lines) {
		this.lines = lines;
	}

	public String getDateDebut() {
		return dateDebut;
	}

	public void setDateDebut(String dateDebut) {
		this.dateDebut = dateDebut;
	}

	public String getDateFin() {
		return dateFin;
	}

	public void setDateFin(String dateFin) {
		this.dateFin = dateFin;
	}



	public Kit getKit() {
		return kit;
	}

	public void setKit(Kit kit) {
		this.kit = kit;
	}

	public FileHistory(Long id, Kit kit, DataBase database, String fileName, String path, String logpath,
			Long currentline, Long lines, String dateDebut, String dateFin) {
		super();
		Id = id;
		this.kit = kit;
		this.fileName = fileName;
		this.path = path;
		this.logpath = logpath;
		this.currentline = currentline;
		this.lines = lines;
		this.dateDebut = dateDebut;
		this.dateFin = dateFin;
	}

	public FileHistory(FileHistory file) {
		super();
		Id = file.Id;
		this.fileName = file.fileName;
		this.path = file.path;
		this.logpath = file.logpath;
		this.currentline = file.currentline;
		this.lines = file.lines;
		this.dateDebut = file.dateDebut;
		this.dateFin = file.dateFin;
		this.kit = file.kit;
	}

	public FileHistory() {
		super();
	}

	@Override
	public String toString() {
		return "File [Id=" + Id + ", fileName=" + fileName
				+ ", path=" + path + ", logpath=" + logpath + ", currentline=" + currentline + ", lines=" + lines
				+ ", dateDebut=" + dateDebut + ", dateFin=" + dateFin + "]";
	}

}
