# Sequel_enum

A Sequel plugin that provides enum-like functionality to your models.

## Installation

Add this line to your application's Gemfile:

    gem 'sequel_enum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_enum

## Usage

```ruby
# frozen_string_literal: true
class ChildrenInvitee < Sequel::Model
  plugin :enum
  many_to_one :child
  many_to_one :invitee, class: 'Guardian'

  enum :status, [
    ['pending', '邀请中', 1],
    ['success', '邀请成功', 2],
    ['over_time', '已超时, 目前没用到', 3],
    ['refused', '拒绝', 4]
  ]

  enum :invitation_method, [
    ['phone', '电话', 1],
    ['wechat', '微信', 2]
  ]
end

ChildrenInvitee.enums[:status]

# =>
# {
#       "pending" => 1,
#       "success" => 2,
#     "over_time" => 3,
#       "refused" => 4
# }

ChildrenInvitee.enums[:status_keys] # for use with graphQL enum:

# =>

# {
#       "PENDING" => "邀请中",
#       "SUCCESS" => "邀请成功",
#     "OVER_TIME" => "已超时, 目前没用到",
#       "REFUSED" => "拒绝"
# }
```

Query in the where

```rb
ChildrenInvitee.enums[:status]['pending'] # => 1

ChildrenInvitee.where(status: ChildrenInvitee.enums[:status]['pending'])
```

Assignment only accept valid enum options.

```rb
children_invitee = ChildrenInvitee.last
children_invitee.status # => pending
children_invitee.status = 'success'
children_invitee.save # => OK
children_invitee.status = 'invalid_value' # => Exception: RuntimeError: invalid value is provided.
```

You can set the raw value through the []= accessor:

```ruby
children_invitee[:status] = 1
print children_invitee.status #> 'pending'
```

## Contributing

1. Fork it ( http://github.com/planas/sequel_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
