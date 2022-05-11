local webroot = ''
function Meta (meta) webroot = meta.webroot end
function fix_link (url) return url:sub(1,1) == '/' and webroot .. url or url end
function Link (link) link.target = fix_link(link.target); return link end
function Image (img) img.src = fix_link(img.src); return img end
return {{Meta = Meta}, {Link = Link, Image = Image}}
