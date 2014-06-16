component output=false {
	function testMe( required string helloWhat ) output=false {
		return "hello " & arguments.helloWhat;
	}
}