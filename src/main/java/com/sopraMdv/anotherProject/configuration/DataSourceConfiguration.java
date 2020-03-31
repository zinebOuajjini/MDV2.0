package com.sopraMdv.anotherProject.configuration;

import java.io.File;
import java.io.IOException;

import javax.sql.DataSource;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataSourceConfiguration {
	
	@Bean
	public DataSource getDataSource() throws IOException {
		
		String pathSeparator = System.getProperty("file.separator");
		String appPath = System.getProperty("user.home") + pathSeparator + "MDVApp";
		new File(System.getProperty("user.home") + pathSeparator + "sqlite").mkdirs();
		new File(appPath + pathSeparator + "Cache").mkdirs();
		
		DataSourceBuilder dataSourceBuilder = DataSourceBuilder.create();
		dataSourceBuilder.driverClassName("org.sqlite.JDBC");
			dataSourceBuilder.url("jdbc:sqlite:"+ System.getProperty("user.home") +"/sqlite/mdv1.db");
		dataSourceBuilder.username("");
		dataSourceBuilder.password("");
		return dataSourceBuilder.build();
	}

}
