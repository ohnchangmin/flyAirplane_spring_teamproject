<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>Home</title>
<!-- Load d3.js -->
<script src="https://d3js.org/d3.v3.min.js"></script>
<!-- Load d3-cloud -->
<script src="https://rawgit.com/jasondavies/d3-cloud/master/build/d3.layout.cloud.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=865bb5e6b5dd1c9aafd66f786f305256&libraries=services"></script>
</head>
<body>
	<div id="map" style="width: 500px; height: 400px;"></div>
	<script type="text/javascript" src="/pension/resources/kakaoMap.js"></script>

	<div>
		<select id="year" onchange="drawGra()">
			<option value='2021'>2021</option>
			<option value='2020'>2020</option>
			<option value='2019'>2019</option>
			<option value='2018'>2018</option>
		</select>
	</div>
	
<!-- Create a div where the graph will take place -->
<div id="my_dataviz"></div>

  <script>

//Simple animated example of d3-cloud - https://github.com/jasondavies/d3-cloud
//Based on https://github.com/jasondavies/d3-cloud/blob/master/examples/simple.html

// Encapsulate the word cloud functionality
function wordCloud(selector) {

	//색 20개 색깔 지정 함수
    var fill = d3.scale.category20();

    //Construct the word cloud's SVG element
    var svg = d3.select(selector).append("svg")
        .attr("width", 500)
        .attr("height", 500)
        .append("g")
        .attr("transform", "translate(250,250)");


    //Draw the word cloud
    function draw(words) {
        var cloud = svg.selectAll("g text")
                        .data(words, function(d) { return d.text; })

        //Entering words
        cloud.enter()
            .append("text")
            .style("font-family", "Impact")
            .style("fill", function(d, i) { return fill(i); })
            .attr("text-anchor", "middle")
            .attr('font-size', 1)
            .text(function(d) { return d.text; });

        //Entering and existing words
        cloud
            .transition()
                .duration(600)
                .style("font-size", function(d) { return d.size + "px"; })
                .attr("transform", function(d) {
                    return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
                })
                .style("fill-opacity", 1);

        //Exiting words
        cloud.exit()
            .transition()
                .duration(200)
                .style('fill-opacity', 1e-6)
                .attr('font-size', 1)
                .remove();
    }


    //Use the module pattern to encapsulate the visualisation code. We'll
    // expose only the parts that need to be public.
    return {

        //Recompute the word cloud for a new set of words. This method will
        // asycnhronously call draw when the layout has been computed.
        //The outside world will need to call this function, so make it part
        // of the wordCloud return value.
        update: function(words) {
            d3.layout.cloud().size([500, 500])
                .words(words)
                .padding(5)
                .rotate(function() { return ~~(Math.random() * 2) * 90; })
                .font("Impact")
                .fontSize(function(d) { return d.size; })
                .on("end", draw)
                .start();
        }
    }

}

//Some sample data - http://en.wikiquote.org/wiki/Opening_lines
var words = [
    "정말 너무 예쁜 펜션이였어요! 사장님도 친절하시고 다음에 또 가고싶은 펜션이에요!",
    "The boy with fair hair lowered himself down the last few feet of rock and began to pick his way toward the lagoon.",
    "When Mr. Bilbo Baggins of Bag End announced that he would shortly be celebrating his eleventy-first birthday with a party of special magnificence, there was much talk and excitement in Hobbiton.",
    "It was inevitable: the scent of bitter almonds always reminded him of the fate of unrequited love."
]

//Prepare one of the sample sentences by removing punctuation,
// creating an array of words and computing a random size attribute.
function getWords(i) {
    return words[i]
    .replace(/[!\.,:;\?]/g, '')
    .split(' ')
    .map(function(d) {
                return {text: d, size: 10 + Math.random() * 60};})
}


//This method tells the word cloud to redraw with a new set of words.
//In reality the new words would probably come from a server request,
// user input or some other source.
function showNewWords(vis, i) {
    i = i || 0;

    vis.update(getWords(i ++ % words.length))
    setTimeout(function() { showNewWords(vis, i + 1)}, 4000)
}

//Create a new instance of the word cloud visualisation.
var myWordCloud = wordCloud('body');

//Start cycling through the demo data
showNewWords(myWordCloud);


</script>

</body>
</html>
