package com.sopraMdv.anotherProject.dao;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sopraMdv.anotherProject.entities.DataBase;
import com.sopraMdv.anotherProject.entities.Kit;

@Repository
public interface KitDAO extends CrudRepository<Kit, Long> {
	


	@Query("SELECT database FROM Kit k WHERE k.id = :id")
	public DataBase getDbByKit(@Param("id") Long kitId);

	

}
