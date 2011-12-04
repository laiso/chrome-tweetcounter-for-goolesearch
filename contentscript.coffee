class CounterWidgetController

    conn: null

    constructor: ->
        @conn = chrome.extension.connect()
        @conn.onMessage.addListener @onMessage


    initialize: ->
        links = document.querySelectorAll 'a.l'
        for all, a of links
            if typeof a == 'object'
                @addCounter a


    addCounter: (a) ->
        @req a, (response, elem) ->
            counter = document.createElement 'A'
            counter.className = 'tweet-widget-counter'
            counter.href = 'https://twitter.com/#!/search/realtime/' + encodeURIComponent elem.href
            counter.innerText = response['count']

            point = document.createRange()
            point.selectNode(elem)
            point.collapse false
            point.insertNode counter
            point.detach()


    req: (a, callback) ->
        xhr = new XMLHttpRequest()
        xhr.open("GET", 'http://urls.api.twitter.com/1/urls/count.json?url='+a.href, true)
        xhr.onreadystatechange = ->
          if xhr.readyState == 4
            resp = JSON.parse xhr.responseText
            callback resp, a
        xhr.send()


    onMessage: (data) ->
        console.log data


new CounterWidgetController().initialize() if window.top == window.self
