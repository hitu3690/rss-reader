'use strict';

// RSSページ遷移前の処理
$(function(){
  // ログインユーザーかどうか判別
  $.ajax({
    url: "/feeds/",
    type: "GET",
    dataType: "json"
  })
  .done((rssfeed) => {
    if(rssfeed.message != null){
      location.href = "/login"
      alert(rssfeed.message)
      console.log(rssfeed.message)
    }else{
      for(let i = 0; i < rssfeed.length; i++){
        $("#feed-template").clone().css('display', 'block').appendTo("#main-area").attr('id', `feed-${rssfeed[i].id}`);
        // ユーザー毎の記事を取得
        $.ajax({
          url: "/feeds/" + rssfeed[i].id,
          type: "GET",
          dataType: "json"
        })
        .done((data) => {
          $("#feed-" + rssfeed[i].id).find(".feed-title").text(data.feed.title).attr("href", data.feed.url)
          let feedItem = $("#feed-" + rssfeed[i].id).find(".feed-item")
          let feedItems = $("#feed-" + rssfeed[i].id).find(".feed-items")
          let feedList = $("#feed-" + rssfeed[i].id).find(".feed-list")
          let feedBody = $("#feed-" + rssfeed[i].id).find(".feed-body")

          // 設定ボタンを一意化
          $("#feed-" + rssfeed[i].id).find(".delete-item").attr('onClick', `deleteItem(${rssfeed[i].id})`)
          $("#feed-" + rssfeed[i].id).find(".update-item").attr('onClick', `updateItem(${rssfeed[i].id})`)

          for(let j = 0; j < data.feed.items.length; j++){
            feedItems.clone().css("display", "block").appendTo(feedBody)
            feedList.clone().css("display", "block").appendTo(feedItems)
            feedItem.clone().css("display", "block").text(data.feed.items[j].title).attr("href", data.feed.items[j].url).appendTo(feedList)
          }
        })
        .fail((data) => {
          console.log(data.responseText);
        })
        .always((data) => {
        });
      }
    }
  })
  .fail((rssfeed) => {
    console.log(rssfeed.responseText);
  })
  .always((rssfeed) => {
  });
});

// 新しいFeedを追加した時の処理
$(function(){
  $("#add-item").click(()=>{
    let result = prompt("RSSを追加")

    // 記事を追加
    $.ajax({
      url: "/feeds",
      type: "POST",
      dataType: "json",
      data: {feed: {url: result}}
    })
    .done((newFeed)=>{
      if(newFeed.status === "success"){
        $("#feed-template").clone().css('display', 'block').appendTo("#main-area").attr('id', `feed-${newFeed.id}`);

        // ユーザー毎の記事を取得
        $.ajax({
          url: `/feeds/${newFeed.id}`,
          type: "GET",
          dataType: "json"
        })
        .done((data) => {
          $(`#feed-${newFeed.id}`).find(".feed-title").text(data.feed.title).attr("href", data.feed.url)
          let feedItem = $(`#feed-${newFeed.id}`).find(".feed-item")
          let feedItems = $(`#feed-${newFeed.id}`).find(".feed-items")

          // 設定ボタンを一意化
          $("#feed-" + newFeed.id).find(".delete-item").attr('onClick', `deleteItem(${newFeed.id})`)
          $("#feed-" + newFeed.id).find(".update-item").attr('onClick', `updateItem(${newFeed.id})`)

          for(let j = 0; j < data.feed.items.length; j++){
            feedItem.clone().css("display", "block").text(data.feed.items[j].title).attr("href", data.feed.items[j].url).appendTo(feedItems)
          }
        })
        .fail((data) => {
          console.log(data.responseText);
        })
        .always((data) => {
          console.log(data);
        });
      }else if(newFeed.status === "failure"){
        alert("URLの取得に失敗しました")
      }else{
        alert(newFeed.status)
        location.reload();
      }
    })
    .fail((newFeed)=>{
      console.log(newFeed.responseText);
    })
    .always((newFeed)=>{
    })
  })
})

// 編集ボタン
function updateItem(feedId){
  $(function(){
    let updateResult = prompt("記事を変更する", "ここにURLを入力してください")
    if(updateResult){
      $.ajax({
        url: `/feeds/${feedId}`,
        type: "POST",
        dataType: "json",
        data: {feed: {url: updateResult}, "_method": "PATCH"}
      })
      .done((data)=>{
        location.reload();
        alert(data.status)
      })
      .fail(()=>{
        alert("通信に失敗しました")
      })
      .always(()=>{
      })
    }
  })
}

// 削除ボタン
function deleteItem(feedId){
  let result = confirm("本当に削除しますか？")
  if(result){
    $.ajax({
      url: `/feeds/${feedId}`,
      type: "POST",
      dataType: "json",
      data: {"_method": "DELETE"}
    })
    .done((data)=>{
      location.reload();
      alert(data.status)
    })
    .fail(()=>{
      alert("通信に失敗しました")
    })
    .always(()=>{
    })
  }
}

// 並び替え
$(function(){
  $('#main-area').sortable({
    opacity: 0.5,
    cursor: "move"
  })
  $('#main-area').bind("sortupdate", (event, ui)=>{
    let items = $('#main-area').sortable("toArray")
    $.ajax({
      url: "/sort",
      type: "POST",
      dataType: "json",
      data: { feed: items }
    })
  })
});
