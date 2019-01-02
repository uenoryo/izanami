class Response
  def self.server_error(message)
    [
      500,
      { 'Content-Type' => 'application/json' },
      [
        error: true,
        code: 500,
        message: "サーバーエラーが発生しました",
        message_debug: message
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
        message_debug: message
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
        message: "ページが見つかりません",
        message_debug: "not found"
      ]
    ]
  end
end
