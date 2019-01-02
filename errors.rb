def maybe(err_message, &block)
  block.call rescue raise err_message
end

def errors_new(err)
  errors_wrap(err, 'ERROR')
end

def errors_wrap(err, message)
  msg = "#{message} #{err.message}"
  return msg if err.cause.nil?

  errors_wrap(err.cause, msg)
end
