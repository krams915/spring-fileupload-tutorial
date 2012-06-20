package org.krams.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.krams.domain.Message;
import org.krams.domain.UploadedFile;
import org.krams.response.StatusResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/upload")
public class UploadController {

	private static Logger logger = Logger.getLogger("controller");
	
	@RequestMapping
	public String form() {
		return "form";
	}
	
	@RequestMapping(value="/message", method=RequestMethod.POST)
	public @ResponseBody StatusResponse message(@RequestBody Message message) {
		// Do custom steps here
		// i.e. Persist the message to the database
		logger.debug("Service processing...done");
		
		return new StatusResponse(true, "Message received");
	}
	
	@RequestMapping(value="/file", method=RequestMethod.POST)
	public @ResponseBody List<UploadedFile> upload(
			@RequestParam("file") MultipartFile file) {
		// Do custom steps here
		// i.e. Save the file to a temporary location or database
		logger.debug("Writing file to disk...done");
		
		List<UploadedFile> uploadedFiles = new ArrayList<UploadedFile>();
		UploadedFile u = new UploadedFile(file.getOriginalFilename(),
				Long.valueOf(file.getSize()).intValue(),
				"http://localhost:8080/spring-fileupload-tutorial/resources/"+file.getOriginalFilename());

		uploadedFiles.add(u);
		return uploadedFiles;
	}
}