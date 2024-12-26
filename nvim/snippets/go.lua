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
    t("type "), 
    i(1, "name"), 
    t("Req struct {"),
    t({"", "  TimeStamp   int64      `json:\"timestamp\"`"}),
    t({"", "  SN          string     `json:\"sn\"`"}),
    t({"", "  "}),
    i(2, {"content"}),
    t({"", "}"})
  }),
  s("reqlt", {
    t("type "), 
    i(1, "name"), 
    t({"Req struct {", "  TimeStamp  int64  `json:\"timestamp\"`", "  LoginToken string `json:\"login_token\"`", ""}),
    t({"", "  "}),
    i(2, "content"),
    t("}")
  }),
})

