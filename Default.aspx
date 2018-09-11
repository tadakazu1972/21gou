<%@ Page Language="C#" %>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0, user-scalable=no" />
  <style type="text/css">
  	html { height: 100% }
  	body { height: 100%; margin: 0; padding: 0 }
  	#map_canvas { height: 100% }
  </style>
  <link rel="stylesheet" href="style.css">
  <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDzA5BJebLXs2f5_raxVC8xcri5crR8khY&region=JP&language=ja"></script>
  <script type="text/javascript">
  //スマホの時はレイアウト変更を判定するため
  var width = window.innerWidth;
  //マップオブジェクト設定
  var mapObj;
  //大阪市役所を緯度・軽度の初期値に設定
  var posX=34.694062;
  var posY=135.502154;
  //マーカーイメージ保存用　グローバルに定義しないとあとのswitch文でたくさん必要になるため。
  var image;
  //マーカー保存用
  var markerArray =  new Array();

  //マップ作成
  google.maps.event.addDomListener(window, 'load', function(){
  	//初期設定
  	var map = document.getElementById("map_canvas");
  	var options = {
  		zoom: 14,
  		center: new google.maps.LatLng(posX, posY),
  		mapTypeId: google.maps.MapTypeId.ROADMAP
  	};
  	mapObj = new google.maps.Map(map, options);

  	//保育園CSVファイル読み込み
  	var xhr = new XMLHttpRequest();
  	xhr.onload = function(){
  		var tempArray = xhr.responseText.split("\n");
  		csvArray = new Array();
  		for(var i=0;i<tempArray.length;i++){
  			csvArray[i] = tempArray[i].split(",");
  			var data = csvArray[i];
  			//マーカー作成　画像ファイルを読み込み
  			image = 'icon32x32.png';
  			var marker = new google.maps.Marker({
  				position: new google.maps.LatLng( parseFloat(data[0]), parseFloat(data[1]) ),
  				map: mapObj,
  				icon: image,
  				title: data[4]
  			});
  			//グローバル保存
  			markerArray.push(marker);
  			//csvファイル　data[2]:GPSDateTime, data[3]:File, data[5]:receivetime, data[4]:msgname, data[7]:subject, data[8]:body
  			attachMessage(marker, data[2], data[3], data[5], data[4], data[7], data[8]);
  		}
  		//console.log(csvArray);
  	};
  	xhr.open("get", "exif_master.csv", true);
  	xhr.send(null);
  });

  //空き状況表示
  function attachMessage(getmarker, gpsdatetime, filename, receivetime, msgname, subject, body) {
  	//写真画像のファイル名をパスとして表示させる
  	var path;
  	if (filename=="") {
  		path="";
  	} else {
  		path='<img src=pictures/'+filename+' width="75%" height="75%"></br>';
  	}
  	//infowindow生成
  	var infowin = new google.maps.InfoWindow({ content:"ファイル名："+msgname+".msg</br>"+"受信日時："+receivetime+"</br>"+"撮影日時："+gpsdatetime+"</br>"+"件名："+subject+"</br>"+"本文："+body+"</br>"+path}, maxWidth: width);
    //マウスオーバー
    google.maps.event.addListener(getmarker, 'mouseover', function() {
    	infowin.open(getmarker.getMap(), getmarker);
    });
    //クリック
    google.maps.event.addListener(getmarker, 'click', function() {
    	infowin.open(getmarker.getMap(), getmarker);
    });
    //マウスアウト
  	/*
  	google.maps.event.addListener(getmarker, 'mouseout', function(){
  		infowin.close();
  	});
  	*/
  	/*
  	//クリックでリンク先へ遷移 スマホでタッチするとすぐに施設HPへジャンプしてしまうため、結局、無効化している
  	google.maps.event.addListener(getmarker, 'click', function(){
  		window.open(url);
  	});
  	*/
  	//ダブルクリックでリンク先へ遷移
  	google.maps.event.addListener(getmarker, 'dblclick', function(){
  		window.open(url);
  	});
  }

  </script>
</head>

<script runat="server">
  void Page_Load(object sender, EventArgs e)
  {
    Welcome.Text = "ログイン済:" + Context.User.Identity.Name;
  }

  void Signout_Click(object sender, EventArgs e)
  {
    FormsAuthentication.SignOut();
    Response.Redirect("login.aspx");
  }
</script>

<body>
 <div id="map_canvas"></div>

  <!--<asp:Label ID="Welcome" runat="server" />
  <form id="Form1" runat="server">
    <asp:Button ID="Submit1" OnClick="Signout_Click"
       Text="サインアウト" runat="server" /><p>
  </form>-->
</body>
</html>
