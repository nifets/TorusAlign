export interface PdbEntity {
  id: string;
  entryId: string;
  entityId: string;
  moleculeName: string;
  entryTitle: string;
  sourceOrganism: {
    commonName: string;
    scientificName: string;
  };
  sequenceLength: number;
}
