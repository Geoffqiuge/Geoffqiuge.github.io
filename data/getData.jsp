<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.util.*"%>
<%@page import="java.util.zip.ZipFile"%>
<%@page import="java.util.zip.ZipInputStream"%>
<%@page import="java.nio.charset.Charset"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.*"%>
<%@page import="java.net.URLDecoder"%>
<%!
  public String getHttpClient(String tmpUrl,String str) {
    StringBuilder result = new StringBuilder();
    try {
      URL url = new URL(tmpUrl);
      HttpURLConnection connection = (HttpURLConnection) url.openConnection();

      connection.setRequestProperty("Cookie", str);
      //connection.setRequestHeader("Accept-Encoding","gzip, deflate");
      connection.setRequestMethod("GET");
      connection.setUseCaches(false);
      connection.connect();
      BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
      String lines = "";
      String responseCookie = connection.getHeaderField("Set-Cookie");// 取到所用的Cookie
      while ((lines = reader.readLine()) != null) {
        result.append(lines);
      }
      reader.close();
      connection.disconnect();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result.toString();
  }
%>
<%

  String cookie_str = "";
  Cookie[] c = request.getCookies();
  if(c!=null){
    for(int i=0;i<c.length;i++){
      if("JSESSIONID".equals(c[i].getName())){
        cookie_str = "JSESSIONID="+c[i].getValue();
      }
    }
  }
  String result = "";
  String decodedString = "";
  String temurl = (request.getParameter("dataAddress") == null) ? "0"
          : request.getParameter("dataAddress").toString();
  try
  {
    decodedString = URLDecoder.decode(temurl, "utf-8");
  } catch (UnsupportedEncodingException e)
  {
    e.printStackTrace();
  }
  result = getHttpClient(decodedString,cookie_str);
  out.print(result);

%>




