package com.sopraMdv.anotherProject.entities;

import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.validation.constraints.NotEmpty;


@Entity	
public class Kit {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE)
	private Long id;
	
	@Column(unique=true)
	@NotEmpty
	private String nomKit;
	
	private String descriptionKit;
	
	@OneToMany(fetch=FetchType.EAGER,mappedBy="kit")
	private Set<ProgrammeDeReprise> progReprises;
	
	@OneToMany(fetch=FetchType.EAGER,mappedBy="kit")
	private Set<FileHistory> filesExecuted;
	
	private String scripts;
	
	private String scriptsPath;
	
	@OneToOne(cascade=CascadeType.ALL)
	private DataBase database;

	public Kit() {
		super();
	}

	public Kit(Long id, @NotEmpty String nomKit, String descriptionKit, Set<ProgrammeDeReprise> progReprises,
			Set<FileHistory> filesExecutes, String scripts, DataBase database, String scriptsPath) {
		super();
		this.id = id;
		this.nomKit = nomKit;
		this.descriptionKit = descriptionKit;
		this.progReprises = progReprises;
		this.filesExecuted = filesExecutes;
		this.scripts = scripts;
		this.database = database;
		this.scriptsPath = scriptsPath;
	}

	public Kit(Kit kit) {
		this.id = kit.id;
		this.nomKit = kit.nomKit;
		this.descriptionKit = kit.descriptionKit;
		this.progReprises = kit.progReprises;
		this.filesExecuted = kit.filesExecuted;
		this.scripts = kit.scripts;
		this.database = kit.database;
		this.scriptsPath = kit.scriptsPath;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNomKit() {
		return nomKit;
	}

	public void setNomKit(String nomKit) {
		this.nomKit = nomKit;
	}

	public String getDescriptionKit() {
		return descriptionKit;
	}

	public void setDescriptionKit(String descriptionKit) {
		this.descriptionKit = descriptionKit;
	}

	public Set<ProgrammeDeReprise> getProgReprises() {
		return progReprises;
	}

	public void setProgReprises(Set<ProgrammeDeReprise> progReprises) {
		this.progReprises = progReprises;
	}

	public Set<FileHistory> getFilesExecutes() {
		return filesExecuted;
	}

	public void setFilesExecutes(Set<FileHistory> filesExecutes) {
		this.filesExecuted = filesExecutes;
	}

	public String getScripts() {
		return scripts;
	}

	public void setScripts(String scripts) {
		this.scripts = scripts;
	}

	public DataBase getDatabase() {
		return database;
	}

	public void setDatabase(DataBase database) {
		this.database = database;
	}

	public String getScriptsPath() {
		return scriptsPath;
	}

	public void setScriptsPath(String scriptsPath) {
		this.scriptsPath = scriptsPath;
	}

	@Override
	public String toString() {
		return "Kit [id=" + id + ", nomKit=" + nomKit + ", descriptionKit=" + descriptionKit + ", progReprises="
				+ progReprises + ", filesExecutes=" + filesExecuted + ", scripts=" + scripts + ", scriptsPath="
				+ scriptsPath + ", database=" + database + "]";
	}





}
