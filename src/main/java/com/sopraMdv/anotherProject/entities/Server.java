package com.sopraMdv.anotherProject.entities;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;


@Entity
public class Server {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long Id;
	
	@Column
	@Pattern(regexp="(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",message="Doesn't match an ip address")
	private String hote;
	
	@Column
	@NotBlank
	private String nomServer;
	
	@Column
	//@Size(min = 5,message="too short for username")
	private String userName;
	
	@Column
	//@Pattern(regexp="(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}",message="Your password is very weak")
	private String password;
	
	@Column
	@NotNull(message="Can't be null")
	private String platformOS;
	
	
	@Column
	//@Size(min = 5,message="too short for username")
	private String userNameAmp;
	
	@Column
	//@Pattern(regexp="(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}",message="Your password is very weak")
	private String passwordAmp;
	
	@Column
	//@Size(min = 5,message="too short for username")
	private String userNameGener;
	
	@Column
	//@Pattern(regexp="(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}",message="Your password is very weak")
	private String passwordGener;
	
	@Column
	//@Pattern(regexp="^(.*/)([^/]*)$",message="This is not a valid path")
	private String pathAmp;
	
	@Column
	private String pathGener;
	

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String toString() {
		//warning: if you try to display the hole envi object it will rise an invokationExeption(because the class Environnement has an object "Server" too ), 
		//so we only display Envi.id !!!!!!!
		return "Server [Id=" + Id + ", hote=" + hote + ", nomServer=" + nomServer + ", userName=" + userName
				+ ", password=" + password + ", platformOS=" + platformOS + ", userNameAmp=" + userNameAmp
				+ ", passwordAmp=" + passwordAmp + ", userNameGener=" + userNameGener + ", passwordGener="
				+ passwordGener + ", pathAmp=" + pathAmp + ", pathGener=" + pathGener 
				 + "]";
	}

	public Long getId() {
		return Id;
	}

	public void setId(Long id) {
		Id = id;
	}

	public String getHote() {
		return hote;
	}

	public void setHote(String hote) {
		this.hote = hote;
	}

	public String getNomServer() {
		return nomServer;
	}

	public void setNomServer(String nomServer) {
		this.nomServer = nomServer;
	}

	public String getPlatformOS() {
		return platformOS;
	}

	public void setPlatformOS(String platformOS) {
		this.platformOS = platformOS;
	}

	public String getUserNameAmp() {
		return userNameAmp;
	}

	public void setUserNameAmp(String userNameAmp) {
		this.userNameAmp = userNameAmp;
	}

	public String getPasswordAmp() {
		return passwordAmp;
	}

	public void setPasswordAmp(String passwordAmp) {
		this.passwordAmp = passwordAmp;
	}

	public String getUserNameGener() {
		return userNameGener;
	}

	public void setUserNameGener(String userNameGener) {
		this.userNameGener = userNameGener;
	}

	public String getPasswordGener() {
		return passwordGener;
	}

	public void setPasswordGener(String passwordGener) {
		this.passwordGener = passwordGener;
	}

	public String getPathAmp() {
		return pathAmp;
	}

	public void setPathAmp(String pathAmp) {
		this.pathAmp = pathAmp;
	}

	public String getPathGener() {
		return pathGener;
	}

	public void setPathGener(String pathGener) {
		this.pathGener = pathGener;
	}


	public Server(Long id, String hote, String nomServer, String userName, String password, String platformOS,
			String typeServer, String protocole, int port, String userNameAmp, String passwordAmp, String userNameGener,
			String passwordGener, String pathAmp, String pathGener) {
		super();
		Id = id;
		this.hote = hote;
		this.nomServer = nomServer;
		this.userName = userName;
		this.password = password;
		this.platformOS = platformOS;
		this.userNameAmp = userNameAmp;
		this.passwordAmp = passwordAmp;
		this.userNameGener = userNameGener;
		this.passwordGener = passwordGener;
		this.pathAmp = pathAmp;
		this.pathGener = pathGener;
	}

	public Server() {
		super();
	}

	public Server(Server server) {
		super();
		Id = server.Id;
		this.hote = server.hote;
		this.nomServer = server.nomServer;
		this.platformOS = server.platformOS;
		this.userNameAmp = server.userNameAmp;
		this.passwordAmp = server.passwordAmp;
		this.userNameGener = server.userNameGener;
		this.passwordGener = server.passwordGener;
		this.pathAmp = server.pathAmp;
		this.pathGener = server.pathGener;
		this.userName=server.userName;
		this.password=server.password;

	}
	
	

}
