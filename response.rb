require 'json'

# Response (｀・ω・)▄︻┻┳═一
class Response
  def self.view(erb)
    [
      200,
      { 'Content-Type' => 'text/html; charset=utf8' },
      erb
    ]
  end

  def self.success_list(data)
    success(
      'コンテナリストの取得に成功しました',
      'list success',
      data
    )
  end

  def self.success_launch(data)
    success(
      'コンテナの起動に成功しました',
      'launch success',
      data
    )
  end

  def self.success_destroy(data)
    success(
      'コンテナの削除に成功しました',
      'destroy success',
      data
    )
  end

  def self.success(message, message_debug, data)
    [
      200,
      { 'Content-Type' => 'application/json; charset=utf8' },
      [
        error: false,
        code: 200,
        message: message,
        message_debug: message_debug,
        data: data
      ].to_json
    ]
  end

  def self.server_error(message)
    [
      500,
      { 'Content-Type' => 'application/json; charset=utf8' },
      [
        error: true,
        code: 500,
        message: 'サーバーエラーが発生しました',
        message_debug: message,
        data: []
      ].to_json
    ]
  end

  def self.bad_request(message)
    [
      400,
      { 'Content-Type' => 'application/json; charset=utf8' },
      [
        error: true,
        code: 400,
        message: message,
        message_debug: message,
        data: []
      ].to_json
    ]
  end

  def self.not_found
    [
      404,
      { 'Content-Type' => 'application/json; charset=utf8' },
      [
        error: true,
        code: 404,
        message: 'ページが見つかりません',
        message_debug: 'not found',
        data: []
      ].to_json
    ]
  end
end
