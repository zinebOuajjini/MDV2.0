package com.sopraMdv.anotherProject.Controller;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.stereotype.Controller;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.sopraMdv.anotherProject.entities.Server;

import javafx.fxml.FXML;

@Controller
public class ServerConnexion {

	private Server server = new Server();

	public Server getServer() {
		return server;
	}

	public void setServer(Server server) {
		this.server = server;
	}

	@FXML
	public void connectServer() throws JSchException {

		JSch jsch = new JSch();
		// Session session = jsch.getSession(server.getUserName(), server.getHote(),
		// server.getPort());
		Session session = jsch.getSession("amplitude", "10.240.164.11", 22);
		// session.setPassword(server.getPassword());
		session.setPassword("amplitude");
		session.setConfig("StrictHostKeyChecking", "no");
		System.out.println("Establishing Connection...");
		session.connect();
		System.out.println("Connection established.");
		System.out.println(sendCommand("ls"));
	}

	public String sendCommand(String command) throws JSchException {

		JSch jsch = new JSch();
		// Session session = jsch.getSession(server.getUserName(), server.getHote(),
		// server.getPort());
		Session session = jsch.getSession("amplitude", "10.240.164.11", 22);
		// session.setPassword(server.getPassword());
		session.setPassword("amplitude");
		session.setConfig("StrictHostKeyChecking", "no");
		System.out.println("Establishing Connection...");
		session.connect();
		System.out.println("Connection established.");
		StringBuilder outputBuffer = new StringBuilder();

		try {
			Channel channel = session.openChannel("exec");
			((ChannelExec) channel).setCommand(command);
			InputStream commandOutput = channel.getInputStream();
			channel.connect();
			int readByte = commandOutput.read();

			while (readByte != 0xffffffff) {
				outputBuffer.append((char) readByte);
				readByte = commandOutput.read();
			}

			channel.disconnect();
		} catch (IOException ioX) {
			return "IOE warning";
		} catch (JSchException jschX) {
			return "JSch warning";
		}
		System.out.println(outputBuffer.toString());
		return outputBuffer.toString();
	}

}
