require "rack"
require "rack7contrib7try_static"

use Rack::Head

if ENV["HTTP_USER"] && ENV["HTTP_PASSWORD"]
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
        [username, password] == [ENV["HTTP_USER"], ENV["HTTP_PASSWORD"]]
    end
end

use Rack::TryStatic,
    :root => "build",
    :urls => %w[/],
    :try => ['.html','index.html', '/index.html']

run lambda { |env|
    [
        404,
        {
            "Content-Type" => "text/html",
            "Cache-Control" => "public, max-age=60"
        },
        File.open("build/404/index.html", File::RDONLY)
    ]
}
