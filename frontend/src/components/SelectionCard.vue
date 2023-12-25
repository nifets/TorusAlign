<template>
  <q-card>
    <q-card-section style="width: 400px">
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
                style="width: 20px"
                :icon="farSquareMinus"
                flat
                float-left
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
    </q-card-section>
    <q-card-section>
      <q-select v-model="input" :options="allItems">
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
      </q-select>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import draggable from 'vuedraggable';
import { farSquareMinus } from '@quasar/extras/fontawesome-v6';
import { PdbEntity } from 'components/models';

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
const selectedItems = allItems;

// Reactive data
const input = ref<PdbEntity>();
const dragging = ref(false);

// Computed data
const dragOptions = {
  animation: 200,
  group: 'description',
  disabled: false,
  ghostClass: 'ghost',
};

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

// function filterFn(val, update) {
//   if (val === '') {
//     update(() => {
//       options.value = stringOptions;

//       // here you have access to "ref" which
//       // is the Vue reference of the QSelect
//     });
//     return;
//   }

//   update(() => {
//     const needle = val.toLowerCase();
//     options.value = stringOptions.filter(
//       (v) => v.toLowerCase().indexOf(needle) > -1
//     );
//   });
// }
</script>

<style>
.my-btn {
  width: 20px;
}
</style>
