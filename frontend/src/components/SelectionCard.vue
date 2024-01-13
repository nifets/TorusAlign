<template>
  <q-card style="width: 500px; height: 600px">
    <q-toolbar class="q-pl-lg bg-primary text-white shadow-2">
      <q-toolbar-title>Protein Chains</q-toolbar-title>
    </q-toolbar>
    <q-card-section>
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
              <q-item-label>{{ element.id }} </q-item-label>
            </q-item-section>
          </q-item>
        </template>
      </draggable>
      <q-item>
        <q-item-section style="width: 40px" side top>
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
                    <q-item-label>{{ scope.opt.id }}</q-item-label>
                  </q-item-section>
                </q-item>
              </template>
              <template #selected>
                <q-item v-if="input">
                  <q-item-section>
                    <q-item-label>{{ input.id }} </q-item-label>
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
  ghostClass: 'ghost',
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
            value: needle,
          },
        },
        return_type: 'polymer_entity',
      })
      .then(function (response) {
        console.log(response.data.result_set[0]);
        interface SearchResult {
          identifier: string;
          score: number;
        }
        const ids = response.data.result_set.map(
          (x: SearchResult) => x.identifier
        );
        options.value = ids.map(
          (id: string) =>
            <PdbEntity>{
              id: id,
            }
        );
      })
      .catch(function (error) {
        console.log(error);
      });
  });
}
</script>

<style>
input::placeholder {
  font-size: 0.8em;
}
</style>
