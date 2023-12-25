defmodule Parser do
  def parse_irc(line) do
    if String.first(line) != "@" do
      raise "invalid format"
    end

    # [tags | rest] = String.split(line, " ")
    tags = String.split(line, " ") |> List.first()
    String.slice(tags, 1..-1) |> parse_tags
  end

  def parse_tags(tags) do
    tags
    |> String.split(";")
    |> Enum.map(fn raw_tag -> Parser.tag_mapper(raw_tag) end)
  end

  def tag_mapper(raw_tag) do
    raw_tag = String.split(raw_tag, "=")

    case raw_tag do
      ["badge-info", value] ->
        %{type: :badgeInfo, value: value}

      ["badge-info"] ->
        %{type: :badgeInfo, value: nil}

      ["badges", value] ->
        %{type: :badges, value: String.split(value, ",")}

      ["badges"] ->
        %{type: :badges, value: nil}

      ["color", value] ->
        %{type: :color, value: value}

      ["display-name", value] ->
        %{type: :displayName, value: value}

      ["emotes"] ->
        %{type: :emotes, value: nil}

      ["emotes", value] ->
        %{type: :emotes, value: String.split(value, "/")}

      ["id", value] ->
        %{type: :id, value: value}

      ["mod", "1"] ->
        %{type: :mod, value: true}

      ["mod", "0"] ->
        %{type: :mod, value: false}

      ["reply-parent-msg-id", value] ->
        %{type: :replyMessageId, value: value}

      ["reply-parent-user-id", value] ->
        %{type: :replyUserId, value: value}

      ["reply-parent-user-login", value] ->
        %{type: :replyUserId, value: value}

      ["reply-parent-display-name", value] ->
        %{type: :replyDisplayName, value: value}

      ["reply-parent-msg-body", value] ->
        %{type: :replyMessageBody, value: value}

      ["reply-parent-msg-body", ""] ->
        %{type: :replyMessageBody, value: ""}

      ["reply-parent-msg-body"] ->
        %{type: :replyMessageBody, value: ""}

      ["room-id", value] ->
        %{type: :roomId, value: value}

      ["subscriber", "1"] ->
        %{type: :subscriber, value: true}

      ["subscriber", "0"] ->
        %{type: :subscriber, value: false}

      ["tmi-sent-ts", value] ->
        %{type: :tmiSentTs, value: value}

      ["turbo", "1"] ->
        %{type: :turbo, value: true}

      ["turbo", "0"] ->
        %{type: :turbo, value: false}

      ["user-id", value] ->
        %{type: :userId, value: value}

      ["user-type"] ->
        %{type: :userType, value: :normal}

      ["user-type", ""] ->
        %{type: :userType, value: :normal}

      ["user-type", "mod"] ->
        %{type: :userType, value: :moderator}

      ["user-type", "admin"] ->
        %{type: :userType, value: :admin}

      ["user-type", "global_mod"] ->
        %{type: :userType, value: :globalMod}

      ["user-type", "staff"] ->
        %{type: :userType, value: :staff}

      ["vip", "1"] ->
        %{type: :vip, value: true}

      ["first-msg", "1"] ->
        %{type: :firstMessage, value: true}

      ["first-msg", "0"] ->
        %{type: :firstMessage, value: false}

      ["returning-chatter", "1"] ->
        %{type: :returningChatter, value: true}

      ["returning-chatter", "0"] ->
        %{type: :returningChatter, value: false}

      ["flags", ""] ->
        %{type: :flags, value: nil}

      ["flags", value] ->
        %{type: :flags, value: String.split(value, ",")}

      ["emote-only", "1"] ->
        %{type: :emoteOnly, value: true}

      ["emote-only", "0"] ->
        %{type: :emoteOnly, value: false}

      ["emote-only"] ->
        %{type: :emoteOnly, value: false}

      ["client-nonce", value] ->
        %{type: :clientNonce, value: value}

      ["ban-duration", value] ->
        {value, _} = Integer.parse(value)
        %{type: :banDuration, value: value}

      ["target-user-id", value] ->
        %{type: :targetUserId, value: value}

      ["login", value] ->
        %{type: :login, value: value}

      ["msg-id", value] ->
        %{type: :messageId, value: value}

      ["msg-param-cumulative-months", value] ->
        {value, _} = Integer.parse(value)
        %{type: :messageParamCumMonths, value: value}

      ["msg-param-months", value] ->
        {value, _} = Integer.parse(value)
        %{type: :messageParamMonths, value: value}

      ["msg-param-multimonth-duration", value] ->
        {value, _} = Integer.parse(value)
        %{type: :messageParamMultiMonthDuration, value: value}

      ["msg-param-multimonth-tenure", value] ->
        {value, _} = Integer.parse(value)
        %{type: :messageParamMultiMonthTenure, value: value}

      ["msg-param-should-share-streak", value] ->
        {value, _} = Integer.parse(value)
        %{type: :messageParamShouldShareStreak, value: value}

      ["msg-param-sub-plan-name", value] ->
        %{type: :messageParamSubPlanName, value: value}

      ["msg-param-sub-plan", value] ->
        %{type: :messageParamSubPlan, value: value}

      ["msg-param-was-gifted", "true"] ->
        %{type: :messageParamWasGifted, value: true}

      ["msg-param-was-gifted", "false"] ->
        %{type: :messageParamWasGifted, value: false}

      ["system-msg", value] ->
        %{type: :systemMessage, value: value}

      ["sent-ts", value] ->
        %{type: :sentTs, value: value}
    end
  end
end
