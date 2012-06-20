<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:url value="/upload/message" var="messageUploadUrl"/>
<c:url value="/upload/file" var="fileUploadUrl"/>

<html>
<head>
	<link rel="stylesheet" type="text/css" media="screen" href='<c:url value="/resources/css/jquery-ui/pepper-grinder/jquery-ui-1.8.16.custom.css"/>'/>
	<link rel="stylesheet" type="text/css" media="screen" href='<c:url value="/resources/css/style.css"/>'/>
	<script type='text/javascript' src='<c:url value="/resources/js/jquery-1.6.4.min.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/resources/js/jquery-ui-1.8.16.custom.min.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/resources/js/util.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/resources/js/jquery-fileupload/vendor/jquery.ui.widget.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/resources/js/jquery-fileupload/jquery.iframe-transport.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/resources/js/jquery-fileupload/jquery.fileupload.js"/>'></script>
	
	<title>Upload</title>
	
	<script type='text/javascript'>
	$(function() {
		init();
	});
	
	function init() {
		$('input:button').button();
		$('#submit').button();
		
		$('#uploadForm').submit(function(event) {
			event.preventDefault();	
			
			$.postJSON('${messageUploadUrl}', {
						owner: $('#owner').val(),
						description: $('#description').val(),
						filename: getFilelist()
					},
					function(result) {
						if (result.success == true) {
							dialog('Success', 'Files have been uploaded!');
						} else {
							dialog('Failure', 'Unable to upload files!');
						}
			});
		});
		
		$('#reset').click(function() {
			clearForm();
			dialog('Success', 'Fields have been cleared!');
		});
		
		$('#upload').fileupload({
	        dataType: 'json',
	        done: function (e, data) {
	            $.each(data.result, function (index, file) {
	                $('body').data('filelist').push(file);
	                $('#filename').append(formatFileDisplay(file));
	                $('#attach').empty().append('Add another file');
	            });
	        }
	    });
		
		// Technique borrowed from http://stackoverflow.com/questions/1944267/how-to-change-the-button-text-of-input-type-file
		// http://stackoverflow.com/questions/210643/in-javascript-can-i-make-a-click-event-fire-programmatically-for-a-file-input
		$("#attach").click(function () {
		    $("#upload").trigger('click');
		});
		
		$('body').data('filelist', new Array());
	}
	
	function formatFileDisplay(file) {
		var size = '<span style="font-style:italic">'+(file.size/1000).toFixed(2)+'K</span>';
		return file.name + ' ('+ size +')<br/>';
	}
	
	function getFilelist() {
		var files = $('body').data('filelist');
		var filenames = '';
		for (var i=0; i<files.length; i<i++) {
			var suffix = (i==files.length-1) ? '' : ',';
			filenames += files[i].name + suffix;
		}
		return filenames;
	}
	
	function dialog(title, text) {
		$('#msgbox').text(text);
		$('#msgbox').dialog( 
				{	title: title,
					modal: true,
					buttons: {"Ok": function()  {
						$(this).dialog("close");} 
					}
				});
	}
	
	function clearForm() {
		$('#owner').val('');
		$('#description').val('');
		$('#filename').empty();
		$('#attach').empty().append('Add a file');
		$('body').data('filelist', new Array());
	}
	</script>
</head>

<body>
	<h1 id='banner'>Upload Files</h1>
	
	<div>
		<form id='uploadForm'>
  			<fieldset>
				<legend>Files</legend>
				<label for='owner'>Owner:</label><input type='text' id='owner'/><br/>
				<textarea name="description" id="description">Description here</textarea><br/>
				<span id='filename'></span><br/>
				<a href='#' id='attach'>Add a file</a><br/>
				<input id="upload" type="file" name="file" data-url="${fileUploadUrl}" multiple style="opacity: 0; filter:alpha(opacity: 0);"><br/>
				<input type='button' value='Reset' id='reset' />
				<input type='submit' value='Upload' id='submit'/>
  			</fieldset>
		</form>
	</div>
	
	<div id='msgbox' title='' style='display:none'></div>
</body>
</html>