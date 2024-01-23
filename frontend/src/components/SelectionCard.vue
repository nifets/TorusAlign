<template>
    <q-card style="width: 500px; height: 520px">
        <q-toolbar class="q-pl-lg bg-primary text-white shadow-2">
            <q-toolbar-title class="text-weight-regular"
                >Protein Chains</q-toolbar-title
            >
        </q-toolbar>
        <q-card-section>
            <div style="max-height: 360px; overflow: auto">
                <draggable
                    :list="selectedItems"
                    item-key="id"
                    @start="dragging = true"
                    @end="endDrag"
                    v-bind="dragOptions"
                    drag-class="drag"
                    ghost-class="ghost"
                >
                    <template #item="{ element }">
                        <q-item
                            :style="dragging ? 'border:none;' : ''"
                            key="element.id"
                            clickable
                        >
                            <q-tooltip max-width="360px">
                                {{ element.entryTitle }}<br />
                            </q-tooltip>
                            <q-item-section style="width: 40px" side top>
                                <q-btn
                                    :icon="farSquareMinus"
                                    flat
                                    dense
                                    color="primary"
                                    float-left
                                    square
                                    size="8px"
                                    @click="removeItem(element.id)"
                                />
                            </q-item-section>
                            <q-item-section>
                                <q-item-label
                                    class="text-uppercase text-weight-medium"
                                    >{{ element.moleculeName }}
                                </q-item-label>
                                <q-item-label
                                    caption
                                    class="text-weight-light"
                                    >{{
                                        element.sourceOrganism.scientificName
                                    }}</q-item-label
                                >
                            </q-item-section>
                            <q-item-section side top>
                                <q-item-label
                                    caption
                                    class="text-primary text-weight-bold"
                                    >{{ element.entryId }}:{{
                                        element.entityId
                                    }}
                                </q-item-label>
                                <q-item-label
                                    caption
                                    class="text-weight-light text-grey-6"
                                >
                                    length: {{ element.sequenceLength }}
                                </q-item-label>
                            </q-item-section>
                        </q-item>
                    </template>
                </draggable>
            </div>
            <q-item>
                <q-item-section style="width: 40px" side>
                    <q-btn
                        :icon="adding ? farSquareMinus : farSquarePlus"
                        flat
                        dense
                        float-left
                        square
                        color="primary"
                        size="8px"
                        @click="
                            adding = !adding;
                            input = undefined;
                            setFocus();
                        "
                    />
                </q-item-section>
                <template v-if="adding">
                    <q-item-section>
                        <q-select
                            v-model="input"
                            :options="options"
                            placeholder="Enter search term (PDB id, name, class etc.)"
                            ref="textBox"
                            :use-input="input == null"
                            clearable
                            hide-dropdown-icon
                            @keyup.enter="addItem()"
                            @filter="filterFn"
                        >
                            <template #option="scope">
                                <q-item v-bind="scope.itemProps">
                                    <q-item-section>
                                        <q-item-label>{{
                                            scope.opt.id
                                        }}</q-item-label>
                                    </q-item-section>
                                </q-item>
                            </template>
                            <template #selected>
                                <q-item v-if="input">
                                    <q-item-section>
                                        <q-item-label
                                            >{{ input.id }}
                                        </q-item-label>
                                    </q-item-section>
                                </q-item>
                            </template>
                            <template #no-option>
                                <q-item>
                                    <q-item-section class="text-grey">
                                        No results
                                    </q-item-section>
                                </q-item>
                            </template>
                            <template #after>
                                <q-btn
                                    v-if="input"
                                    color="primary"
                                    label="Add"
                                    square
                                    padding="xs"
                                    size="10px"
                                    @click="addItem()"
                                />
                            </template>
                        </q-select>
                    </q-item-section>
                </template>
            </q-item>
        </q-card-section>
    </q-card>
</template>

<script setup lang="ts">
import { ref, nextTick } from 'vue';
import draggable from 'vuedraggable';
import { farSquareMinus, farSquarePlus } from '@quasar/extras/fontawesome-v6';
import { PdbEntity } from 'components/models';
import { search_api } from 'src/boot/axios';
import { useQuery } from '@vue/apollo-composable';
import { gql } from '@apollo/client/core';

const textBox = ref<HTMLInputElement | null>(null);

const options = ref<PdbEntity[]>([]);
const selectedItems = ref<PdbEntity[]>([]);

// Reactive data
const input = ref<PdbEntity>();
const dragging = ref(false);
const adding = ref(true);

// Computed data
const dragOptions = {
    animation: 200,
    group: 'description',
    disabled: false,
    ghostClass: 'ghost'
};

function setFocus() {
    nextTick(() => {
        textBox.value?.focus();
    });
}

// Methods
function endDrag() {
    dragging.value = false;
}

function removeItem(id: string) {
    const index = selectedItems.value.findIndex((item) => item.id === id);
    if (index !== -1) {
        selectedItems.value.splice(index, 1);
    }
}

function addItem() {
    if (input.value) {
        const index = selectedItems.value.findIndex(
            (item) => item.id === input.value?.id
        );
        if (index === -1) {
            selectedItems.value.push(input.value);
            adding.value = false;
            input.value = undefined;
        }
    }
}

function filterFn(
    val: string,
    update: (fn: () => void) => void,
    abort: () => void
) {
    if (val.length < 2) {
        abort();
        return;
    }
    update(() => {
        const needle = val.toLowerCase();
        search_api
            .post('', {
                query: {
                    type: 'terminal',
                    service: 'full_text',
                    parameters: {
                        value: needle
                    }
                },
                return_type: 'polymer_entity'
            })
            .then(function (response) {
                interface SearchResult {
                    identifier: string;
                    score: number;
                }
                const ids = response.data.result_set.map(
                    (x: SearchResult) => x.identifier
                );
                const entry_ids = ids.map((id: string) => id.slice(0, 4));

                const query = gql`
                    query GetPDBData($entry_ids: [String!]!, $ids: [String!]!) {
                        entries(entry_ids: $entry_ids) {
                            citation {
                                rcsb_authors
                                title
                            }
                            struct {
                                title
                            }
                            rcsb_entry_container_identifiers {
                                polymer_entity_ids
                            }
                            struct_keywords {
                                text
                            }
                        }
                        polymer_entities(entity_ids: $ids) {
                            entity_poly {
                                type
                                rcsb_sample_sequence_length
                            }
                            rcsb_entity_source_organism {
                                common_name
                                ncbi_scientific_name
                            }
                            rcsb_polymer_entity {
                                pdbx_description
                            }
                        }
                    }
                `;
                const { onResult } = useQuery(query, {
                    entry_ids: entry_ids,
                    ids: ids
                });
                onResult((result) => {
                    if (result.data) {
                        const entry_data = result.data.entries;
                        const entity_data = result.data.polymer_entities;
                        options.value = ids.map(
                            (id: string, i: number) =>
                                <PdbEntity>{
                                    id: id,
                                    entryId: entry_ids[i],
                                    entityId: id.slice(5),
                                    moleculeName:
                                        entity_data[i].rcsb_polymer_entity
                                            .pdbx_description,
                                    entryTitle: entry_data[i].struct.title,
                                    sourceOrganism: {
                                        commonName:
                                            entity_data[i]
                                                .rcsb_entity_source_organism[0]
                                                .common_name,
                                        scientificName:
                                            entity_data[i]
                                                .rcsb_entity_source_organism[0]
                                                .ncbi_scientific_name
                                    },
                                    citation: {
                                        authors:
                                            entry_data[i].citation.rcsb_authors
                                    },
                                    sequenceLength:
                                        entity_data[i].entity_poly
                                            .rcsb_sample_sequence_length
                                }
                        );
                    }
                });
            });
    });
}
</script>

<style>
input::placeholder {
    font-size: 0.8em;
}
</style>
