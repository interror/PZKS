window.addEventListener('load', function (){

    var tree = document.getElementById("tree"),
    context = tree.getContext('2d');
    tree.height = 200*(gon.hashes.length+1);
    tree.width  = gon.first_vars.length*80;
    var centerX = 50;
    var centerY = 50;
    var radius = 20;
    var array_of_tops = [];
    var array_of_tops_position = [];
    var drow_array_tops = [];
    var drow_array = [];

    
	for (j=0; j < gon.first_vars.length; j++){
		//Fill circles 1-st stage
		context.beginPath();
	   	context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
	   	context.fillStyle = 'green';
	   	context.fill();
	   	context.lineWidth = 3;
	   	context.strokeStyle = '#003300';
	   	context.stroke();
	 	//Fill text
	   	context.font="14px Georgia";
	   	context.fillStyle = 'black';
	   	context.fillText(gon.first_vars[j],centerX-10,centerY);
	   	array_of_tops.push(gon.first_vars[j])
	   	array_of_tops_position.push([centerX, centerY])
	   	centerX = centerX + 80;
	}
	
	centerY = centerY + 200;
	centralize_pozition = centerX;
	
    for (i=0; i < gon.hashes.length; i++){
    	buf_array = [];
    	buf_array_pos = [];
    	centerX = (centralize_pozition-(gon.hashes[i].length * 100))/2+50;
    	for (j=0; j < gon.hashes[i].length; j++){
	    	context.beginPath();
	    	context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
	    	context.fillStyle = 'green';
	    	context.fill();
	    	context.lineWidth = 3;
	    	context.strokeStyle = '#003300';
	    	context.stroke();
	    	array_of_tops.push(gon.hashes[i][j][0]);
	    	array_of_tops_position.push([centerX, centerY]);
	    	//Fill text
		   	context.font="14px Georgia";
		   	context.fillStyle = 'black';
		   	context.fillText(gon.hashes[i][j][1][1],centerX-10,centerY);
		   	drow_array.push(gon.hashes[i][j][1]);
		   	drow_array_tops.push(gon.hashes[i][j][0]);
	    	centerX = centerX + 80
    	}

    	centerY = centerY + 200;
	}
// console.log(array_of_tops);
// console.log(array_of_tops_position);
// console.log(drow_array);
// console.log(drow_array_tops);
	context.lineWidth = 3;

	for (i=0; i < drow_array_tops.length; i++){
	 	a_index = array_of_tops.indexOf(drow_array[i][0]);
	 	array_of_tops[a_index] = "~"
	 	b_index = array_of_tops.indexOf(drow_array[i][2]);
	 	v_index = array_of_tops.indexOf(drow_array_tops[i]);
	 	array_of_tops[b_index] = "~"
	 	
		context.beginPath();
		context.moveTo(array_of_tops_position[a_index][0]+10,array_of_tops_position[a_index][1]+10);
		context.lineTo(array_of_tops_position[v_index][0]-10,array_of_tops_position[v_index][1]-10);
		context.moveTo(array_of_tops_position[b_index][0]+10,array_of_tops_position[b_index][1]+10);
		context.lineTo(array_of_tops_position[v_index][0]-10,array_of_tops_position[v_index][1]-10);
		context.stroke();

	}
	

});

window.addEventListener('load', function (){

	var vector = document.getElementById("vector_processor"),
	context = vector.getContext('2d');
	var array = gon.vector_diagram
	var array_max = gon.array_height
	var array_wid = gon.array_width
	vector.height = array_max * 50;
	vector.width  = array_wid * 50;
	var x = 40
	var y = 40


	console.log(array)

for (i=0; i < array.length; i++){
	for (j=0; j < array_max; j++){
		if (array[i][j] != null && array[i][j] != "   " ) {
			context.beginPath();
	    context.rect(x, y, 40, 40);
	    context.fillStyle = 'green';
	    context.fill();
	    context.lineWidth = 3;
	    context.strokeStyle = 'black';
	    context.stroke();
	    context.font="14px Georgia";
	   	context.fillStyle = 'black';
	   	context.fillText(array[i][j],x+8,y+20);
	    y = y + 40;
	  }
	  else if (array[i][j] == null ) {
	  	context.beginPath();
	    context.rect(x, y, 40, 40);
	    context.fillStyle = 'yellow';
	    context.fill();
	    context.lineWidth = 3;
	    context.strokeStyle = 'black';
	    context.stroke();
	    y = y + 40;
    }
    else if (array[i][j] == "   "){
    	context.beginPath();
	    context.rect(x, y, 40, 40);
	    context.fillStyle = 'yellow';
	    context.fill();
	    context.lineWidth = 3;
	    context.strokeStyle = 'black';
	    context.stroke();
	    y = y + 40;	
    }
  }
  x = x + 40;
  y = 40
}




});

