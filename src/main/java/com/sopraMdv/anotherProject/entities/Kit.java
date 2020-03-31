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
	
	private String adressIpServeur;
	
	private String utilisateurServeur;
	
	private String motDePassUtilisateurServeur;
	
	private String repertoireDeTravail;

	public Kit() {
		super();
	}

	public Kit(Long id, @NotEmpty String nomKit, String descriptionKit, Set<ProgrammeDeReprise> progReprises,
			Set<FileHistory> filesExecuted, String scripts, String scriptsPath, DataBase database,
			String adressIpServeur, String utilisateurServeur, String motDePassUtilisateurServeur,
			String repertoireDeTravail) {
		super();
		this.id = id;
		this.nomKit = nomKit;
		this.descriptionKit = descriptionKit;
		this.progReprises = progReprises;
		this.filesExecuted = filesExecuted;
		this.scripts = scripts;
		this.scriptsPath = scriptsPath;
		this.database = database;
		this.adressIpServeur = adressIpServeur;
		this.utilisateurServeur = utilisateurServeur;
		this.motDePassUtilisateurServeur = motDePassUtilisateurServeur;
		this.repertoireDeTravail = repertoireDeTravail;
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
		this.adressIpServeur = kit.adressIpServeur;
		this.utilisateurServeur = kit.utilisateurServeur;
		this.motDePassUtilisateurServeur = kit.motDePassUtilisateurServeur;
		this.repertoireDeTravail = kit.repertoireDeTravail;
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
	
	

	public String getAdressIpServeur() {
		return adressIpServeur;
	}

	public void setAdressIpServeur(String adressIpServeur) {
		this.adressIpServeur = adressIpServeur;
	}

	public String getUtilisateurServeur() {
		return utilisateurServeur;
	}

	public void setUtilisateurServeur(String utilisateurServeur) {
		this.utilisateurServeur = utilisateurServeur;
	}

	public String getMotDePassUtilisateurServeur() {
		return motDePassUtilisateurServeur;
	}

	public void setMotDePassUtilisateurServeur(String motDePassUtilisateurServeur) {
		this.motDePassUtilisateurServeur = motDePassUtilisateurServeur;
	}

	public String getRepertoireDeTravail() {
		return repertoireDeTravail;
	}

	public void setRepertoireDeTravail(String repertoireDeTravail) {
		this.repertoireDeTravail = repertoireDeTravail;
	}

	@Override
	public String toString() {
		return "Kit [id=" + id + ", nomKit=" + nomKit + ", descriptionKit=" + descriptionKit + ", progReprises="
				+ progReprises + ", filesExecuted=" + filesExecuted + ", scripts=" + scripts + ", scriptsPath="
				+ scriptsPath + ", database=" + database + ", adressIpServeur=" + adressIpServeur
				+ ", UtilisateurServeur=" + utilisateurServeur + ", motDePassUtilisateurServeur="
				+ motDePassUtilisateurServeur + ", repertoireDeTravail=" + repertoireDeTravail + "]";
	}

}
