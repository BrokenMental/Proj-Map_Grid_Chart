/*-----------
  naver map
-----------*/
var infowindows = [], markers = [], adds = [];
var map = new naver.maps.Map('map', {
	center : new naver.maps.LatLng(37.44802, 126.6553154),
	zoom : 8
});

for (var i = 0; i < jdata.kinderInfo.length; i++) {
	var myaddress = jdata.kinderInfo[i].addr;
	naver.maps.Service.geocode(
		{
			address : myaddress
		},
		function(status, response) {
			if (status !== naver.maps.Service.Status.OK) {
				return alert(myaddress + '의 검색 결과가 없거나 기타 네트워크 에러');
			}
			var result = response.result;

			var marker = new naver.maps.Marker({
				position : new naver.maps.LatLng(
						result.items[0].point.y,
						result.items[0].point.x),
				map : map
			});

			markers.push(marker);
			adds.push(result.items[0].address);

			var infowindow = new naver.maps.InfoWindow();

			naver.maps.Event.addListener(marker, "click",
				function(e) {
					for (var j = 0; j < markers.length; j++) {
						if (markers[j].position === marker.position) {
							for (var k = 0; k < adds.length; k++) {
								if (adds[j].match((jdata.kinderInfo[k].addr))) {
									if (infowindow.getMap()) {
										infowindow.close();
									} else {
										infowindow.setContent(jdata.kinderInfo[k].kindername);
										infowindow.open(map, marker);
									}
								}
							}
						}
					}
				});

		});
}