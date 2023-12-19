module ReactiveForm
using GenieFramework
using PlotlyBase
using Statistics
@genietools

@app begin
    # reactive code goes here
    @in N = 0
    @out m = 0.0
    @out trace = [histogram(; x=[])]
    @out layout = PlotlyBase.Layout(; title="Histogram plot")

    @onchange N begin
        x = rand(N)
        m = mean(x)
        trace = [histogram(; x=x)]
    end
end

function ui()
    # UI definition goes here
    return row([
        cell([
            h1("A simple dashboard"),
            slider(1:1:1000, :N),
            p("The average of {{N}} random numbers is {{m}}"),
            plot(:trace; layout=:layout),
        ]),
    ])
end

@page("/reactive", ui)
end
