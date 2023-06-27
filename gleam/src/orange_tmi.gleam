import gleam/string
import gleam/erlang/file
import gleam/option.{None, Option, Some}
import gleam/list
import gleam/result
import gleam/int
import glychee/benchmark

pub type UserTypeData {
  Normal
  Admin
  GlobalMod
  Moderator
  Staff
}

pub type Tags {
  BadgeInfo(Option(String))
  Badges(Option(List(String)))
  Bits(Option(String))
  Color(String)
  DisplayName(String)
  Emotes(Option(List(String)))
  Id(String)
  Mod(Bool)

  ReplyMessageId(String)
  ReplyUserId(String)
  ReplyUserLogin(String)
  ReplyDisplayName(String)
  ReplyMessageBody(String)

  RoomId(String)
  Subscriber(Bool)
  TmiSentTs(String)
  Turbo(Bool)
  UserId(String)
  UserType(UserTypeData)
  Vip(Bool)

  // =========Undocumented by Twitch ================================
  Flags(Option(List(String)))
  ReturningChatter(Bool)
  FirstMessage(Bool)
  EmoteOnly(Bool)
  ClientNonce(String)
  // ================================================================
  BanDuration(Int)
  TargetUserId(String)
  Login(String)

  MessageId(String)
  MessageParamCumMonths(Int)
  MessageParamMonths(Int)
  MessageParamMultiMonthDuration(Int)
  MessageParamMultiMonthTenure(Int)
  MessageParamShouldShareStreak(Int)
  MessageParamSubPlanName(String)
  MessageParamSubPlan(String)
  MessageParamWasGifted(Bool)
  SystemMessage(String)
  SentTs(String)
}

pub type Privmsg {
  Privmsg(
    tags: Tags,
    is_reply: Bool,
    is_bit_message: Bool,
    login: String,
    display_name: String,
    text: String,
  )
}

pub fn main() {
  benchmark.run(
    [
      benchmark.Function(
        label: "orange_tmi.parse_irc",
        callable: fn(test_data) { fn() { list.map(test_data, parse_irc) } },
      ),
    ],
    [
      benchmark.Data(
        label: "First 1000 lines",
        data: {
          let assert Ok(file_content) = file.read("../data.txt")
          string.split(file_content, "\n")
          |> list.take(1000)
        },
      ),
    ],
  )
}

pub fn parse_irc(line: String) {
  let assert Ok("@") = string.first(line)

  let message = string.split(line, " ")
  let assert Ok(tags) = list.first(message)

  string.drop_left(up_to: 1, from: tags)
  |> parse_tags()
}

pub fn parse_tags(line: String) {
  string.split(line, ";")
  |> list.map(tag_mapper)
}

pub fn tag_mapper(tag_thingy: String) {
  let tag = string.split(tag_thingy, "=")
  case tag {
    ["badge-info", value] -> BadgeInfo(Some(value))
    ["badge-info"] -> BadgeInfo(None)
    ["badges", value] -> Badges(Some(string.split(value, ",")))
    ["badges"] -> Badges(None)
    ["color", value] -> Color(value)
    ["display-name", value] -> DisplayName(value)
    ["emotes"] -> Emotes(None)
    ["emotes", value] -> Emotes(Some(string.split(value, "/")))
    ["id", value] -> Id(value)
    ["mod", "1"] -> Mod(True)
    ["mod", "0"] -> Mod(False)
    ["reply-parent-msg-id", value] -> ReplyMessageId(value)
    ["reply-parent-user-id", value] -> ReplyUserId(value)
    ["reply-parent-user-login", value] -> ReplyUserId(value)
    ["reply-parent-display-name", value] -> ReplyDisplayName(value)
    ["reply-parent-msg-body", value] -> ReplyMessageBody(value)
    ["reply-parent-msg-body", ""] -> ReplyMessageBody("")
    ["reply-parent-msg-body"] -> ReplyMessageBody("")
    ["room-id", value] -> RoomId(value)
    ["subscriber", "1"] -> Subscriber(True)
    ["subscriber", "0"] -> Subscriber(False)
    ["tmi-sent-ts", value] -> TmiSentTs(value)
    ["turbo", "1"] -> Turbo(True)
    ["turbo", "0"] -> Turbo(False)
    ["user-id", value] -> UserId(value)
    ["user-type"] -> UserType(Normal)
    ["user-type", ""] -> UserType(Normal)
    ["user-type", "mod"] -> UserType(Moderator)
    ["user-type", "admin"] -> UserType(Admin)
    ["user-type", "global_mod"] -> UserType(GlobalMod)
    ["user-type", "staff"] -> UserType(Staff)
    ["vip", "1"] -> Vip(True)
    ["first-msg", "1"] -> FirstMessage(True)
    ["first-msg", "0"] -> FirstMessage(False)
    ["returning-chatter", "1"] -> ReturningChatter(True)
    ["returning-chatter", "0"] -> ReturningChatter(False)
    ["flags", ""] -> Flags(None)
    ["flags", value] -> Flags(Some(string.split(value, ",")))
    ["emote-only", "1"] -> EmoteOnly(True)
    ["emote-only", "0"] -> EmoteOnly(False)
    ["emote-only"] -> EmoteOnly(False)
    ["client-nonce", value] -> ClientNonce(value)
    ["ban-duration", value] ->
      BanDuration(
        int.parse(value)
        |> result.unwrap(0),
      )
    ["target-user-id", value] -> TargetUserId(value)
    ["login", value] -> Login(value)
    ["msg-id", value] -> MessageId(value)
    ["msg-param-cumulative-months", value] ->
      MessageParamCumMonths(
        int.parse(value)
        |> result.unwrap(0),
      )
    ["msg-param-months", value] ->
      MessageParamMonths(
        int.parse(value)
        |> result.unwrap(0),
      )
    ["msg-param-multimonth-duration", value] ->
      MessageParamMultiMonthDuration(
        int.parse(value)
        |> result.unwrap(0),
      )
    ["msg-param-multimonth-tenure", value] ->
      MessageParamMultiMonthTenure(
        int.parse(value)
        |> result.unwrap(0),
      )
    ["msg-param-should-share-streak", value] ->
      MessageParamShouldShareStreak(
        int.parse(value)
        |> result.unwrap(0),
      )
    ["msg-param-sub-plan-name", value] -> MessageParamSubPlanName(value)
    ["msg-param-sub-plan", value] -> MessageParamSubPlan(value)
    ["msg-param-was-gifted", "true"] -> MessageParamWasGifted(True)
    ["msg-param-was-gifted", "false"] -> MessageParamWasGifted(False)
    ["system-msg", value] -> SystemMessage(value)
    ["sent-ts", value] -> SentTs(value)
  }
}
