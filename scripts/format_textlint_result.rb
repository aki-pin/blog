require 'json'

# textlintの結果を読み込み
results = JSON.parse(File.read('textlint-result.json'))

comment_body = "## textlintの結果:\n\n"
results.each do |result|
  next if result['messages'].empty?

  result['messages'].each do |message|
    # Markdown のリスト形式を使用し、行と列の情報を強調
    comment_body += "- **#{message['loc']['start']['line']}行目:#{message['loc']['start']['column']}~#{message['loc']['end']['line']}行目:#{message['loc']['end']['column']}**\n"
    comment_body += "  - #{message['message']}\n\n"
  end
end
File.write('lint_comment.txt', comment_body)
