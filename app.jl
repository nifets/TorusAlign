module App

using GenieFramework
@genietools

using GenieFramework.Genie.Renderer.Html
route("/") do
    html(Renderer.filepath("index.html"))
end

route("/form") do
    return Html.form(
        action="/result",
        method="POST",
        [
            input(; type="number", name="N", placeholder="Enter vector length"),
            input(; type="submit", value="Send"),
        ],
    )
end

using GenieFramework.Genie.Requests: postpayload
route("/result"; method=POST) do
    N = parse(Int, postpayload(:N))
    m = 0.0
    return p("The mean of $N random numbers is: $m"; style="font-size:20px")
end

end

include("ReactiveForm.jl")
