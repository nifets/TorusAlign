<template>
  <q-card style="width: 400px; height: 600px">
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
                float-left
                square
                size="8px"
                @click="removeItem(element.id)"
              />
            </q-item-section>
            <q-item-section>
              <q-item-label caption> {{ element.organism }}</q-item-label>
              <q-item-label>{{ element.moleculeName }} </q-item-label>
            </q-item-section>
            <q-item-section side top>
              <q-item-label caption> {{ element.entryId }}</q-item-label>
              <q-item-label caption> {{ element.entityId }}</q-item-label>
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
                    <q-item-label>{{ scope.opt.moleculeName }}</q-item-label>
                    <q-item-label caption>{{ scope.opt.id }}</q-item-label>
                  </q-item-section>
                </q-item>
              </template>
              <template #selected>
                <q-item v-if="input">
                  <q-item-section>
                    <q-item-label>{{ input.moleculeName }} </q-item-label>
                    <q-item-label caption> {{ input.id }}</q-item-label>
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

const textBox = ref<HTMLInputElement | null>(null);

const allItems = ref<PdbEntity[]>([
  {
    id: '1A3N_1',
    entryId: '1A3N',
    entityId: '1',
    moleculeName: 'HEMOGLOBIN (ALPHA CHAIN)',
    entryTitle: 'deoxy human hemoglobin',
    organism: 'Homo sapiens',
    sequenceLength: 141,
  },
  {
    id: '1A3N_2',
    entryId: '1A3N',
    entityId: '2',
    moleculeName: 'HEMOGLOBIN (BETA CHAIN)',
    entryTitle: 'deoxy human hemoglobin',
    organism: 'Homo sapiens',
    sequenceLength: 146,
  },
  {
    id: '1MBN_1',
    entryId: '1MBN',
    entityId: '1',
    moleculeName: 'MYOGLOBIN',
    entryTitle: 'the stereochemistry of the protein myoglobin',
    organism: 'Physeter catodon',
    sequenceLength: 153,
  },
  {
    id: '1UMO_1',
    entryId: '1UMO',
    entityId: '1',
    moleculeName: 'CYTOGLOBIN',
    entryTitle:
      'the crystal structure of cytoglobin: the fourth globin type discovered in man',
    organism: 'Homo sapiens',
    sequenceLength: 190,
  },
  {
    id: '3MKB_2',
    entryId: '3MKB',
    entityId: '2',
    moleculeName: 'HEMOGLOBIN SUBUNIT BETA',
    entryTitle:
      'crystal structure determination of shortfin Mako (isurus oxyrinchus) hemoglobin at 1.9 angstrom resolution',
    organism: 'Isurus oxyrinchus',
    sequenceLength: 136,
  },
]);
const options = ref<PdbEntity[]>(allItems.value);
const selectedItems = ref<PdbEntity[]>([]);

// Reactive data
const input = ref<PdbEntity>();
const dragging = ref(false);
const adding = ref(false);

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
  if (input.value && !selectedItems.value.includes(input.value)) {
    selectedItems.value.push(input.value);
    adding.value = false;
    input.value = undefined;
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
    options.value = allItems.value.filter((option) => {
      return (
        option.id.toLowerCase().indexOf(needle) > -1 &&
        !selectedItems.value.includes(option)
      );
    });
  });
}
</script>

<style>
input::placeholder {
  font-size: 0.8em;
}
</style>
