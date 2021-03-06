<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html;"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>header and gird test</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="resources/css/main.css"/>
<style>
	select {
		width: 100px;
	}
</style>
</head>
<body>
	<table>
		<tr>
			<td>지역</td>
			<td>
				<select name="sidoName" id="sidoName" onchange="change_sel()">
					<option>-선택-</option>
					<c:if test="${!empty selectSidoName }">
						<c:forEach var="cd" items="${selectSidoName }" varStatus="i">
							<option value="${cd.sidoCode }"<c:if test="${cd.sidoName eq sidoName }">selected</c:if>>${cd.sidoName}</option>
						</c:forEach>	
					</c:if>
				</select>
			</td>
			<td>
				<select id="sigunguName" name="sigunguName">
					<option value='all'>-선택-</option>
				</select>
			</td>
			<td>
				<input type="button" name="btnSearch" id="btnSearch" value="조회" onclick="search()">
			</td>
		</tr>
	</table>
	<div id="realgrid" style="height: 600px;"></div>
</body>
<script type="text/javascript" src="resources/realgridjs-lic.js"></script>
<script type="text/javascript"
	src="resources/realgridjs_eval.1.1.29.min.js"></script>
<script type="text/javascript" src="resources/realgridjs-api.1.1.29.js"></script>
<script type="text/javascript" src="resources/jszip.min.js"></script>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript">

var gridView;
var dataProvider;

function change_sel() {
	
	var sdName = $("#sidoName option:checked").text();
	console.log(sdName);
	
	$.ajax({
		type: "POST",
		url: "/changeSel",
		dataType:"json",
		data: {param:sdName},
		success: function(result){
			$("#sigunguName").find("option").remove().end().append("<option value='all'>-선택-</option>");
			$.each(result, function(i) {
				$("#sigunguName").append("<option value='"+result[i].sigunguCode+"'>"+result[i].sigunguName+"</option>");
			});
		},
		error: function (jqXHR, textStatus, errorThrown) {
			alert("오류가 발생하였습니다.");
		}                     
	});
}

function search() {
	var sidoCode = $("#sidoName").val();
	var sigunguCode = $("#sigunguName").val();
	
	$.ajax({
		type: "POST",
		url: "/search",
		dataType:"json",
		data: {sidoCode:sidoCode,sigunguCode:sigunguCode},
		success: function(jdata){
			
			RealGridJS.setTrace(false);
			RealGridJS.setRootContext("resources");

			dataProvider = new RealGridJS.LocalDataProvider();
			gridView = new RealGridJS.GridView("realgrid");
			gridView.setDataSource(dataProvider);
			gridView.setPanel({visible:false}); // 상단바(그루핑 영역)
			gridView.setFooter({visible: false}); // 하단바
			gridView.setStateBar({visible: false}); // 숫자 옆 공백
			gridView.setOptions({
			    indicator: {zeroBase: false}, // 상태바
			    checkBar: {visible: false} // 체크바
			});

			//다섯개의 필드를 가진 배열 객체를 생성합니다.
			var fields = [ {
				fieldName : "kindername"
			}, {
				fieldName : "establish"
			}, {
				fieldName : "addr"
			}, {
				fieldName : "telno"
			}, {
				fieldName : "opertime"
			} ];

			//DataProvider의 setFields함수로 필드를 입력합니다.
			dataProvider.setFields(fields);

			//필드와 연결된 컬럼 배열 객체를 생성합니다.
			var columns = [ {
				name : "col1",
				fieldName : "kindername",
				header : {
					text : "유치원명"
				},
				width : 170
			}];

			//컬럼을 GridView에 입력 합니다.
			gridView.setColumns(columns);

			// json 형식 데이터 넣기
			//var data = ${jdata};
			dataProvider.setRows(jdata.kinderInfo);
		},
		error: function (jqXHR, textStatus, errorThrown) {
			alert("오류가 발생하였습니다.");
		}                     
	});
}
</script>
</html>