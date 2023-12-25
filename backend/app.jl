module App
using GenieFramework
using Main.PDB
@genietools

@app begin
    @in new_entity_input_value = ""
    @in selected_entities::Array{PDB_Entity} = []
    @in filtered_select_entities::Array{PDB_Entity} = []
    @out all_entities::Array{PDB_Entity} = pdb_entities

    @event add_entity begin
        println(new_entity_input_value)
        a = filter(v -> v.value == new_entity_input_value, all_entities)
        b = filter(v -> v.value == new_entity_input_value, selected_entities)
        @show selected_entities
        if !isempty(a) && isempty(b)
            selected_entities = vcat(selected_entities, a[1])
        end
    end
end

@methods """
filterFn: function(val, update) {
    update(() => {
        const needle = val.toLowerCase()
        this.filtered_select_entities = this.all_entities.filter(v => (v.value.toLowerCase().indexOf(needle) > -1 || v.label.toLowerCase().indexOf(needle) > -1)&& !this.selected_entities.some(e => e.value === v.value))
    })
}
"""

layout = Stipple.ReactiveTools.DEFAULT_LAYOUT(; title="Torus Align")

@page("/", "ui.jl", layout = layout)

end
