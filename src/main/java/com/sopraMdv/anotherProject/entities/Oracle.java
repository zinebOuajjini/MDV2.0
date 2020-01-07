package com.sopraMdv.anotherProject.entities;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrimaryKeyJoinColumn;


@Entity
@PrimaryKeyJoinColumn(name = "Id")
public class Oracle extends DataBase {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long Id;

	public Long getId() {
		return Id;
	}

	public void setId(Long id) {
		Id = id;
	}


}

	

