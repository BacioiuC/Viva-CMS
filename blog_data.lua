blog_data = {}

function blog_data:init( )
  self._blogTitle = "Viva Chrome: Your source for anything related to ChromeOS"
  self._author = "Bacioiu Ciprian"
  self._version = "0.0.1"
  self._articlesPerPage = 10
  self._navigationMenu = {}
  self:buildNavBar( )
  
  print("Starting Blog - "..self._blogTitle.." by "..self._author..". Version: "..self._version.."")
end

function blog_data:getTitle( )
  return self._blogTitle
end

function blog_data:getAuthor( )
  return self._author
end

function blog_data:getVersion()
  return self._version( )
end

function blog_data:buildNavBar( )
  self._navigationMenu[1] = {text = "Home", url = "/"}
  self._navigationMenu[2] = {text = "Manifesto", url = "/articles.html&article_id=viva_chrome_manifesto.artcl"}
  self._navigationMenu[3] = {text = "Copyright Information", url = "/articles.html&article_id=copyright_info.artcl"}
  self._navigationMenu[4] = {text = "About", url = "/articles.html&article_id=about_page_hidden.artcl"}
end

function blog_data:getNavBar( )
  return self._navigationMenu
end

data = [[

<html>
  <head>
    <title>Lua, VR and Chromebooks</title>
  </head>
  <body>
    <h1 style="text-align: center;">
      Lua, VR and Chromebooks</h1>
    <hr />
    <ul>
      <li>
        Articles</li>
    </ul>
    <p>
      &nbsp;</p>
  </body>
</html>


]]

htmlBegin = [[
<html>
  <head>
  <title>
    Lua, VR and Chromebooks
  </title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <script src="javascript/jquery-2.1.3.min.js" type="text/javascript"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  </head>
  <body>
    <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#collapsible-navbar" aria-expanded="false" aria-controls="navbar">
            <span class="glyphicon glyphicon-chevron-down"></span>
          </button>
          <a class="navbar-brand" href="index.html">
            <img alt="Navbar_Icon" src="media/nbl.png">
          </a>
        </div>
        <div id="collapsible-navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li><a href="">Category 1</a></li>
            <li><a href="">Category 2</a></li>
            <li><a href="">Category 3</a></li>
            <li><a href="">Category 4</a></li>
            <li><a href="">Category 4</a></li>
            <li><a href="">Category 4</a></li>
            <li><a href="">Category 4</a></li>
          </ul>
        </div>
      </div>
    </nav>
    <div id="banner-background"></div>

    <div class="container">
      <div id="logo">
        <img id="logo-image" class="img-responsive center-block" src="media/viva_chrome.png">
      </div>
    </div>

    <div class="contentBody">
      <table>

]]

htmlEnd = [[
      </table>
    </div>
    
    <div id="footer">
      <ul>
        <li>Designed and Developed by <a href="http://twitter.com/zapakitul">Zapa</a> using <a href="http://www.lua.org">Lua</a> and <a href="http://luvit.io">Luvit</a>. (C) 2017.</li>
        <li>Website Source: <a href="http://github.com/BacioiuC">Github</a></li>
        <li>All articles are available under CC-3.0</li>
      </ul>
    </div>

  </body>
</html>


]]