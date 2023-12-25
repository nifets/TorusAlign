# using GenieFramework
row([
    column(
        card(
            card_section(
                list([
                    toolbar("Protein chains", class="bg-primary text-white shadow-2"),
                    item(
                        @recur("entity in selected_entities"),
                        (key!)="entity.value",
                        [
                            item_section("{{entity.label}}"),
                            item_section(
                                side=true,
                                btn(
                                    @click("selected_entities.pop(entity)"),
                                    round=true,
                                    push=false,
                                    icon="close",
                                ),
                            ),
                        ],
                    ),
                    item(
                        item_section(
                            select(
                                :new_entity_input_value,
                                options=:filtered_select_entities,
                                useinput=true,
                                @on("keyup.enter", :add_entity),
                                emitvalue=true,
                                var"v-on:filter"="filterFn",
                                # template(
                                #     var"v-slot:option"="scope",
                                #     item(var"v-bind"="scope.itemProps"),
                                #     [
                                #         itemsection([
                                #             itemlabel("{{scope.opt.entity_name}}"),
                                #             itemlabel(
                                #                 caption="", "{{scope.opt.value}}"
                                #             ),
                                #         ]),
                                #     ],
                                # ),
                            ),
                        ),
                    ),
                ],),
            ),
        ),
    ),
    column(),
])
