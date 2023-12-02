module MessageController
using Genie.Genie.Renderer.Html
using Dates

function message()
    current = Dates.now()
    tomorrow = current + Dates.Day(1)
    return html(Renderer.filepath("pages/message.jl"), current=current, tomorrow=tomorrow)
end

end
