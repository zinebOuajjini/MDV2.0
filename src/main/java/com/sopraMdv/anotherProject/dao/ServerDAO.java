package com.sopraMdv.anotherProject.dao;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.sopraMdv.anotherProject.entities.Server;

public interface ServerDAO extends CrudRepository<Server, Long> {

//	@Query("SELECT S FROM Server S WHERE S.envi.id = :id")
//	public Server getServerByEnvid(@Param("id")Long  long1);
	

	@Query("SELECT userName FROM Server S WHERE S.id = :id")
	public String getServeruserName(@Param("id")Long  long1);
	
	@Query("SELECT S FROM Server S WHERE S.id = :id")
	public Server getServerbsid(@Param("id")Long  long1);
	

}
