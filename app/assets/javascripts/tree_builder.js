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
	var array = gon.model;
	var height_model = gon.length_model;
	var width_model = gon.width_model;
	vector.height = height_model * 40;
	vector.width  = width_model * 40;
	var x = 32
	var y = 32
	var digits_array = ["Sum1","Sum2","Mul1","Mul2","Mul3","Div1","Div2"]
	
	function isInteger(x) {
    return Math.round(x) === x;
	}
y = 64
for (i=0; i < gon.count.length; i++){
	context.beginPath();
	    context.rect(x, y, 32, 32);
	    context.fillStyle = 'orange';
	    context.fill();
	    context.lineWidth = 3;
	    context.strokeStyle = 'black';
	    context.stroke();
	    context.font="16px Georgia";
		  context.fillStyle = 'black';
		  context.fillText(gon.count[i],x+6,y+20);
	    y = y + 32;	
}
y = 32
x = x + 42

for (i=0; i < array.length; i++){
	context.beginPath();
	context.font="25px Georgia";
	context.fillStyle = 'black';
	context.fillText(digits_array[i],x+4,y+20);
	y = y + 32;
	for (j=0; j < array[i].length; j++){
		for (k=0; k < array[i][j].length; k++){
			if (array[i][j][k] != null){
				context.beginPath();
		    context.rect(x, y, 32, 32);
		    context.fillStyle = 'green';
		    context.fill();
		    context.lineWidth = 3;
		    context.strokeStyle = 'black';
		    context.stroke();
		    context.font="14px Georgia";
		   	context.fillStyle = 'black';
		   	context.fillText(array[i][j][k],x+4,y+20);
		    y = y + 32;
	    }
	    else if (array[i][j][k] == null){
		    context.beginPath();
		    context.rect(x, y, 32, 32);
		    context.fillStyle = 'yellow';
		    context.fill();
		    context.lineWidth = 3;
		    context.strokeStyle = 'black';
		    context.stroke();
		    y = y + 32;
	    }
	 	}
	 	y = 64
	 	x = x + 32
  }
  x = x + 10;
  y = 32
}

});

