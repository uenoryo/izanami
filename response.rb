# Response (｀・ω・)▄︻┻┳═一
class Response
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
      { 'Content-Type' => 'application/json' },
      [
        error: false,
        code: 200,
        message: message,
        message_debug: message_debug,
        data: data
      ]
    ]
  end

  def self.server_error(message)
    [
      500,
      { 'Content-Type' => 'application/json' },
      [
        error: true,
        code: 500,
        message: 'サーバーエラーが発生しました',
        message_debug: message,
        data: []
      ]
    ]
  end

  def self.bad_request(message)
    [
      400,
      { 'Content-Type' => 'application/json' },
      [
        error: true,
        code: 400,
        message: message,
        message_debug: message,
        data: []
      ]
    ]
  end

  def self.not_found
    [
      404,
      { 'Content-Type' => 'application/json' },
      [
        error: true,
        code: 404,
        message: 'ページが見つかりません',
        message_debug: 'not found',
        data: []
      ]
    ]
  end
end
