require "/file_io"
require "/blog_data"
require "/article_parser"

local http = require('http');
local url = require('url');
local path = require('path')
local fs = require('fs')

local items = {};
-- see Node.js_in_action.pdf : page 89 (110 of 417)
-- Simple BLog based on VR!
-- VR 1.0

local mimes = {
	png = "image/png",
	htm = "text/html",
	html = "text/html",
}

mimes.default = "application/octet-stream"

function getType(path)
  return mimes[path:lower():match("[^.]*$")] or mimes.default
end

local root = module.dir

_io:init( )
blog_data:init( )
articles:init( )

http.createServer( function(req, res)
	--p(req)
	print("req url: "..req.url.."")

	if req.url=='/' then
		if req.method=='GET' then
			show(res, req.url);

		else
			badRequest(res);
		end
	elseif string.find(req.url, "/index") then
		show(res, req.url);
	elseif string.find(req.url, "articles.html") then
		show(res, req.url);
	else
		--notFound(res);
		newURL = url.parse(req.url)
		local path = root .. newURL.pathname
		--p('path',path)
		  fs.stat(path, function (err, stat)
		    if err then
		      if err.code == "ENOENT" then
		        return res:notFound(err.message .. "\n")
		      end
		      return 0--res:error("Error" .. "\n")
		    end
		    --p(stat)
		    if stat.type ~= 'file'    then
		      return res:notFound("Requested url is not a file\n")
		    end

		    res:writeHead(200, {
		      ["Content-Type"] = getType(path),
		      ["Content-Length"] = stat.size
		    })

		    fs.createReadStream(path):pipe(res)
		end)		
	end
end) :listen(80)

function show(res, url)
	--print("UHHH ARRR ELLL: "..url.."")
	local html = ""
	if url == "/" or url == "index.html" then
		--print("its in here")
		html = renderIndex( )
	elseif string.find(url, "articles.html") then
		--print("YEP ARTICLE IT IS! ") 
		local articleID_pos = string.find(url, "=")
		if articleID_pos ~= nil then
			local id = url:sub(articleID_pos+1)
			--print("ID IS: "..id.."")

			html = renderArticle(id) -- "<html><head><title>YAY FOR ARTICLES</title></head><body>LOL</body></html>"
		else
			html = renderIndex( )
		end
	else
		print("O.o")
	end
	res:setHeader('Content-Type', 'text/html');
	res:setHeader('Content-Length', #html);
	res:finish(html);
end

function renderIndex( )
	articles:update_list( )
	local rowString = "<tr>"
	local html = ""
	local indexTable = _io:readFile("index.html")
	local updatedIndex = {}
	local indexCounter = 1
	local insertAt = 0
	local navBarAt = 0
	for i,v in pairs(indexTable) do
		if string.find(v, "#INDEXTABLEGOETHERE") then
			insertAt = indexCounter
			updatedIndex[indexCounter] = ""
		elseif string.find(v, "#NAVBARGOETHHERE") then
			navBarAt = indexCounter
			updatedIndex[indexCounter] = ""
		else
			updatedIndex[indexCounter] = ""..v..""
		end
		indexCounter = indexCounter + 1
	end
	--[[for i,v in pairs(_io:readFile("index.html")) do
		print("Reading I: "..i.." Content: "..v.."")
		html = ""..html.." "..v.."\n"
	end--]]
	local navBarString = ""
	local navBarTable = blog_data:getNavBar( )
	for i = 1, #navBarTable do
		navBarString = navBarString .. '<li><a href='..navBarTable[i].url..'>'..navBarTable[i].text..'</a></li>'
	end
	updatedIndex[navBarAt] = ""..navBarString..""


	articleList = "<table>"
	local articleData = articles:_getArticles(1)
	for i = 1, #articleData do
		if articleData[i].hidden == false then
			articleList = ''..articleList..'<tr>'
			articleList = ''..articleList..'<td><a href="/articles.html&article_id='..articleData[i].name..'">'
			articleList = ''..articleList..'<div class="articleTitle"><h1>'..articleData[i].title..'</h1></div>'
			if articleData[i].image:len() > 3 then
				articleList = ''..articleList..'<div class="articleThumbnail"><img src="media/'..articleData[i].image..'"></div>'
			end
			articleList = ''..articleList..'<div class="articleDescription"><h2> <p>'..articleData[i].description..'</p></h2></div>'
			articleList = ""..articleList..'</a></td></tr>'
		end
	end

	updatedIndex[insertAt] = articleList.."</table>"


	for i =1, indexCounter-1 do
		html = ""..html..""..updatedIndex[i].."\n"
	end

	return html
end

function renderArticle(_name)
	local html = ""
	local indexTable = _io:readFile("articles.html")
	local updatedIndex = {}
	local indexCounter = 1
	local insertAt = 0
	local navBarAt = 0
	for i,v in pairs(indexTable) do
		if string.find(v, "#ARTICLEGOETHHERE") then
			insertAt = indexCounter
			updatedIndex[indexCounter] = ""
		elseif string.find(v, "#NAVBARGOETHHERE") then
			navBarAt = indexCounter
			updatedIndex[indexCounter] = ""
		else
			updatedIndex[indexCounter] = ""..v..""
		end
		indexCounter = indexCounter + 1
	end

	local navBarString = ""
	local navBarTable = blog_data:getNavBar( )
	for i = 1, #navBarTable do
		navBarString = navBarString .. '<li><a href='..navBarTable[i].url..'>'..navBarTable[i].text..'</a></li>'
	end
	updatedIndex[navBarAt] = ""..navBarString..""

	articleList = "<table>"
	local articleData = articles:_getArticleByName(_name) --articles:_getArticleByID(tonumber(_id))
	local v = articleData
	if v ~= nil then
		articleList = ''..articleList..'<tr>'
		articleList = ''..articleList..'<td>'
		articleList = ''..articleList..'<div class="articleTitle"><h1>'..v.title..'</h1></div>'
		articleList = ''..articleList..'<div class="articleDescription"> <p><h2>'..v.description..'</h2></p></div>'
		articleList = ''..articleList..'<div class="articleThumbnail"><img src="media/'..v.image..'"></div>'
		articleList = ''..articleList..'<div class="articleBody">'
		for j = 1, #v.articleBody do
			--print(""..v.articleBody[j].."")
			articleList = ''..articleList..''..v.articleBody[j]..''
			if j == math.floor(#v.articleBody/2) then
				articleList = ''..articleList..'<div id="middle-add"><center><span>Advertisement</span><br/><img src="/media/add_box_1.png"><br/><span>Advertisement</span></center></div>'
			end
		end
		articleList = ''..articleList..'</div>'
		articleList = ""..articleList..'</td></tr>'


		updatedIndex[insertAt] = articleList.."</table>"
		for i =1, indexCounter-1 do
			html = ""..html..""..updatedIndex[i].."\n"
		end
	else
		html = renderIndex()
	end
	return html
end

function notFound(res)
	res.statusCode = 404;
	res:setHeader('Content-Type', 'text/plain');
	res:finish('Not Found');
end
function badRequest(res)
	res.statusCode = 400;
	res:setHeader('Content-Type', 'text/plain');
	res:finish('Bad Request');
end

local qs = require('querystring');
function add(req, res)
	local body = '';
	--req.setEncoding('utf8');
	req:on('data', function(chunk) body =body.. chunk end);
	req:on('end', function()
		local obj = qs.parse(body);
		--p(obj)
		table.insert(items,obj.item);
		show(res);
	end);
end
print('Server running at http://127.0.0.1/\n Connect to server using a web browser.')