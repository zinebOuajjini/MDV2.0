package com.sopraMdv.anotherProject.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public class DataBase {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long Id;

	@Column
	private String TypeDB;

	@Column
	private String hote;

	@Column
	private int port;

	@Column
	private String sid;

	@Column
	private String passwordDb;

	@Column
	private String schemaDB;
	


	// @OneToMany(fetch = FetchType.LAZY,
	// mappedBy="database",cascade=CascadeType.REMOVE)
	// private List<FileHistory> files;

	// @ManyToOne
	// private Server server;
	//
	// public Server getServer() {
	// return server;
	// }
	//
	// public void setServer(Server server) {
	// this.server = server;
	// }



	public DataBase(String typeDB) {
		this.TypeDB = typeDB;
	}

	// public List<FileHistory> getFiles() {
	// return files;
	// }
	//
	// public void setFiles(List<FileHistory> files) {
	// this.files = files;
	// }
	// don't show file in tostring or you'll get an error(because it's lazy fetch)
	@Override
	public String toString() {
		return "DataBase [Id=" + Id + ", TypeDB=" + TypeDB + ", hote=" + hote + ", port=" + port + ", sid=" + sid
				+ ", passwordDb=" + passwordDb + ", schemaDB=" + schemaDB + "]";
	}

	public Long getId() {
		return Id;
	}

	public void setId(Long id) {
		Id = id;
	}

	public String getTypeDB() {
		return TypeDB;
	}

	public void setTypeDB(String typeDB) {
		TypeDB = typeDB;
	}

	public String getHote() {
		return hote;
	}

	public void setHote(String hote) {
		this.hote = hote;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getSchemaDB() {
		return schemaDB;
	}

	public void setSchemaDB(String schemaDB) {
		this.schemaDB = schemaDB;
	}

	public String getPasswordDb() {
		return passwordDb;
	}

	public void setPasswordDb(String passwordDb) {
		this.passwordDb = passwordDb;
	}

	public DataBase(Long id, String schemaDB, String typeDB, String hote, int port, String sid, String passwordDb,Kit kit) {
		super();
		Id = id;
		this.schemaDB = schemaDB;
		this.TypeDB = typeDB;
		this.hote = hote;
		this.port = port;
		this.sid = sid;
		this.passwordDb = passwordDb;
	}

	public DataBase() {
		super();
	}

	public DataBase(DataBase database) {
		Id = database.Id;
		this.schemaDB = database.schemaDB;
		this.TypeDB = database.TypeDB;
		this.hote = database.hote;
		this.port = database.port;
		this.sid = database.sid;
		this.passwordDb = database.passwordDb;
	}

}
