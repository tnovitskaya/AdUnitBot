# AdUnitBot

AdUnitBot позволяет создавать рекламные места на сайте http://target.my.com.

Он автоматически авторизуется на сайте, используя переданные email и password. Далее бот ищет платформу по переданному `platform_id` и создает новый ad unit. 

Для каждого рекламного блока можно указать название блока, тип и дополнительные параметры.

## Установка

После того, как Вы скачаете код репозитория выполните в директории проекта:

```bash
bundle install
```

А затем для запуска тестов:

```bash
rspec spec
```

## Использование

При создании экземлпяра класса ему нужно передать `email`, 'password', `platform_id`.

Затем вызвать метод `create_ad_unit` с хэшом конфигурации рекламного блока, как показано в примере:

```ruby
require 'ad_unit_bot'

bot = AdUnitBot.new('test@example.com', 'password', '12345')

bot.create_ad_unit( { title:      'Your title',
                      type:       'medium',
                      show_limit: 5,
                      period:     'в день',
                      interval:   4 } )
```
