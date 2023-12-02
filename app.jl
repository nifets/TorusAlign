module App

using GenieFramework
using Main.StatisticAnalysis
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
    x = gen_numbers(N)
    m = calc_mean(x)
    return p("The mean of $N random numbers is: $m"; style="font-size:20px")
end

end

include("ReactiveForm.jl")
