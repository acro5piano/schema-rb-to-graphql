# frozen_string_literal: true

# Fake user
class User < ApplicationRecord
  has_many :posts
end
