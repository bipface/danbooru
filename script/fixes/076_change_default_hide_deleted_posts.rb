#!/usr/bin/env ruby

require_relative "../../config/environment"

User.transaction do
  # prior to fixing issue #4512 deleted posts were always hidden by default
  # regardless of user preferences. to avoid surprises, reset the
  # hide_deleted_posts pref to false.

  # todo: what about api usage?

  bit = 1 << 8 # User.BOOLEAN_ATTRIBUTES.find_index("hide_deleted_posts")
  users = User.where("(bit_prefs & ?) = 0", bit)
  p users.count
  users.update_all("bit_prefs = (bit_prefs | #{bit})")
end
