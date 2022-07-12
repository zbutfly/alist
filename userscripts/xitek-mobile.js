// ==UserScript==
// @name         色影无忌手机版
// @namespace    http://tampermonkey.net/
// @version      0.01
// @description  色影无忌手机版（https://ssl.xitek.com/mip/）界面和功能优化
// @author       प्याक
// @match        https://ssl.xitek.com/mip/thread/tid/*
// @icon         https://ssl.xitek.com/favicon.ico
// @grant        none
// @require      https://code.jquery.com/jquery-3.6.0.slim.min.js
// ==/UserScript==

(function() {
    'use strict';

    // Your code here...
    var picspans = $('.xitek_forum_item > div.xitek_cell_content > div.row > div.card.card_photo > span[data-href]');
    for (var i = 0; i < picspans.length; i++) {
        var imgs = picspans[i].getElementsByTagName('img');
        for (var j = 0; j < imgs.length; j++) {
            imgs[j].src = picspans[i].getAttribute('data-href');
            imgs[j].style.setProperty('max-width', '100%')
        }
    }
    // var quotedivs = $('.xitek_forum_item > div.xitek_cell_content > div.quote')

    // console.log(pics);
})();
