db.feeds.distinct("tags");
var headed = false, footed = false;
db.feeds.distinct("tags", {}).forEach(tag => {
    if (!headed) {
        headed = true;
        print("<?xml version=\"1.0\" encoding=\"UTF-8\"?><opml version=\"1.0\"><head><title>Butfly's Subscriptions</title></head><body>");
    }
    print("<outline text=\""+ tag + "\" title=\"" + tag + "\">");
    db.feeds.find({"tags": tag}).forEach(o => {
        print("\t<outline type=\"rss\" text=\""+o.title+"\" title=\""+o.title+"\" xmlUrl=\""+o.xmlUrl+"\" htmlUrl=\""+o.htmlUrl+"\"/>");
    });
    print("</outline>");
    if (!footed) {
        footed = true;
        print("</body></opml>");
    }
});
