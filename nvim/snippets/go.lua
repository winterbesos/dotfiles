local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local fmt = extras.fmt
local m = extras.m
local l = extras.l
local postfix = require "luasnip.extras.postfix".postfix

ls.add_snippets("all", {
    s("reqsn", {
        -- type UploadUserFaceEmotionReq struct {
        -- 	TimeStamp   int64      `json:"timestamp"`
        -- 	SN          string     `json:"sn"`
        --   $1
        -- }
        t("type "), i(1, "name"), t("Req struct {")
        -- i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
    })
})
