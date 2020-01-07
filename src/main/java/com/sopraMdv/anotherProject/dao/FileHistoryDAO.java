package com.sopraMdv.anotherProject.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.FileHistory;

@Repository
public interface FileHistoryDAO extends CrudRepository<FileHistory, Long> {
	
	@Query("SELECT F FROM FileHistory F WHERE F.kit.id = :id")
	public List<FileHistory> getAllFiles(@Param("id")Long  long1);
	
	@Query("SELECT F FROM FileHistory F WHERE F.id = :id")
	public FileHistory getFileById(@Param("id")Long  long1);


}
