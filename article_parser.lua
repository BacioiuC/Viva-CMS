require "/file_io"
articles = {}

function articles:init( )
	print("Article engine is a go")
	
	self._articleTable = {}
	self._articleCount = 0
	self:_parseArticles( )
	self:_getNumberOfArticles( )
end

function articles:_getNumberOfArticles( )
	--print("NR of Articles: "..self._articleCount)
	return self._articleCount;
end

function articles:update_list( )
	self._articleTable = { } -- reset list
	dirname = 'articles'
	articleList = io.popen('ls -t ' .. dirname)
	local articleNumber = 0
	for article in articleList:lines() do
		articleNumber = articleNumber + 1
		self:_addArticleToTable(article)
	end
	self._articleCount = articleNumber
end

function articles:_parseArticles( )
	dirname = 'articles'
	articleList = io.popen('ls -t ' .. dirname)
	local articleNumber = 0
	for article in articleList:lines() do
		articleNumber = articleNumber + 1
		self:_addArticleToTable(article)
	end
	self._articleCount = articleNumber
end

-- get's a string with the filename of the article
-- and parses the fileName!
function articles:_addArticleToTable(_fileName)
	--print("FILE NAME: ".._fileName.."")
	local articleContent = _io:readFile("articles/".._fileName.."")
	--print("Article Content type: "..type(articleContent).." and size: "..#articleContent.."")
	--print("DONE PRINTING")
	if articleContent ~= nil then
		local temp = {
			title = ""..articleContent[1].."",
			image = ""..articleContent[2].."",
			author = ""..articleContent[3].."",
			name = "".._fileName.."",
			description = ""..articleContent[5].."",
			hidden = false,
			name = "".._fileName.."",
		}
		if string.find(_fileName, "hidden") then
			temp.hidden = true
		end
		temp.articleBody = {}
		for i = 6, #articleContent do
			temp.articleBody[i-5] = articleContent[i]
		end

		--for i,v in pairs(temp.articleBody) do
			--print(""..v.."")
		--end
		table.insert(self._articleTable, temp)
	end
end	

function articles:_getArticles(_pageNr)
	-- returns the first X articles
	return self._articleTable
end

function articles:_getArticleByID(_id)
	--print("article Table size: "..#self._articleTable.."")
	return self._articleTable[_id]
end

function articles:_getArticleByName(_name)
	for i,v in ipairs(self._articleTable) do
		if v.name == _name then
			return v
		end
	end
end

function articles:_readArticle(_article)

end