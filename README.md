# email_octopus

A Crystal wrapper for the [EmailOctopus](htps://emailoctopus.com) AI.

> **Note** The original repository is hosted at [https://codeberg.org/w0u7/email_octopus](https://codeberg.org/w0u7/email_octopus).

## Installation

1. Add the dependency to your `shard.yml`:

  ```yaml
  dependencies:
    email_octopus:
      codeberg: w0u7/email_octopus
  ```

2. Run `shards install`

## Usage

Add the shard to your app:

```crystal
require "email_octopus"
```

Create a client:

```Crystal
@client =  EmailOctopus::Client.new("eo_api_key")
```

Subscribe a user to an existing list:

```crystal
contact = EmailOctopus::Contact.create_or_update(
  @client,
  list_id: "00000000-0000-0000-0000-000000000000",
  email_address: "otto@example.com",
  tags: {
    "early-bird" => true
  }
)
```

## To-do

This shard is still a work in progress and far from feature complete. The
basics are there to make API calls, but not all resources are implemented yet.

- [X] Client with authentication
- [X] Exceptions
- [ ] Reties for rate limiting
- [ ] Pagination
- Automation
  - [ ] `post` Start an automation for a contact
- Campaign
  - [ ] `get` Get all Campaigns
  - [ ] `get` Get Campaign
  - [ ] `get` Campaign contact reports
  - [ ] `get` Campaign links report
  - [ ] `get` Campaign summary report
- Contact
  - [ ] `get` Get contacts
  - [X] `put` Create or update contact
  - [ ] `post` Create contact
  - [ ] `put` Update multiple list contacts
  - [ ] `get` Get contact
  - [ ] `put` Update contact
  - [ ] `delete` Delete contact
- Field
  - [ ] `post` Create field
  - [ ] `put` Update field
  - [ ] `delete` Delete field
- List
  - [ ] `get` Get all lists
  - [ ] `post` Create list
  - [ ] `get` Get list
  - [ ] `put` Update list
  - [ ] `delete` Delete list
- Tag
  - [ ] `get` Get all tags
  - [ ] `post` Create tag
  - [ ] `put` Update tag
  - [ ] `delete` Delete tag

I will complete the work over the following months, but if you feel inclined to
help out, I'll happily accept PRs.

## Contributing

1. Fork it (<https://codeberg.org/w0u7/email_octopus/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Wout](https://github.com/your-github-user) - creator and maintainer
