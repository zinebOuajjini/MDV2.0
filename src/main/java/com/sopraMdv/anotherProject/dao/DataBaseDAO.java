package com.sopraMdv.anotherProject.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sopraMdv.anotherProject.entities.DataBase;

@Repository
public interface DataBaseDAO extends CrudRepository<DataBase, Long> {
	
//	@Query("SELECT D FROM DataBase D WHERE D.server.id = :id")
//	public List<DataBase> getAllDatabases(@Param("id")Long  long1);
//	
	@Query("SELECT D FROM DataBase D WHERE D.id = :id")
	public DataBase getDatabaseById(@Param("id")Long  long1);
	

	@Query("SELECT D FROM DataBase D WHERE D.schemaDB = :nomdb")
	public DataBase getDbbyName(@Param("nomdb")String nomdb);

}
