package com.sopraMdv.anotherProject.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
@Entity
public class ProgrammeDeReprise   {
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE)
	private Long idProg;
	
	private String path;
	private String nomProg;
	@ManyToOne
	private Kit kit;
	public ProgrammeDeReprise() {
		super();
		// TODO Auto-generated constructor stub
	}
	public ProgrammeDeReprise(Long idProg, String path, String nomProg, Kit kit) {
		super();
		this.idProg = idProg;
		this.path = path;
		this.nomProg = nomProg;
		this.kit = kit;
	}
	public Long getIdProg() {
		return idProg;
	}
	public void setIdProg(Long idProg) {
		this.idProg = idProg;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getNomProg() {
		return nomProg;
	}
	public void setNomProg(String nomProg) {
		this.nomProg = nomProg;
	}
	public Kit getKit() {
		return kit;
	}
	public void setKit(Kit kit) {
		this.kit = kit;
	}
	
	
	
	

}
