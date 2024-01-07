<template>
  <q-page class="row justify-between bg-secondary">
    <div class="column col-1 justify-center"></div>
    <div class="column col-2 justify-center">
      <selection-card />
    </div>
    <div class="column col-6 justify-evenly">
      <div class="row justify-left">
        <sequence-alignment-card />
      </div>
      <div class="row justify-evenly">
        <structure-alignment-card />
        <phylogeny-card />
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import SelectionCard from 'components/SelectionCard.vue';
import SequenceAlignmentCard from 'src/components/SequenceAlignmentCard.vue';
import StructureAlignmentCard from 'src/components/StructureAlignmentCard.vue';
import PhylogenyCard from 'src/components/PhylogenyCard.vue';
</script>
