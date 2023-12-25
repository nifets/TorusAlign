module PDB
export PDB_Entity, pdb_entities

struct PDB_Entity
    label::String
    value::String
    entry_id::String
    entity_id::String
    entry_title::String
    entity_name::String
    organism::String
    sequence_length::Int
    function PDB_Entity(
        entry_id::String,
        entity_id::String,
        entry_title::String,
        entity_name::String,
        organism::String,
        sequence_length::Int,
    )
        return new(
            entity_name,
            entry_id * "_" * entity_id,
            entry_id,
            entity_id,
            entry_title,
            entity_name,
            organism,
            sequence_length,
        )
    end
end

const pdb_entities = [
    PDB_Entity(
        "1A3N",
        "1",
        "deoxy human hemoglobin",
        "HEMOGLOBIN (ALPHA CHAIN)",
        "Homo sapiens",
        141,
    ),
    PDB_Entity(
        "1A3N",
        "2",
        "deoxy human hemoglobin",
        "HEMOGLOBIN (BETA CHAIN)",
        "Homo sapiens",
        146,
    ),
    PDB_Entity(
        "1MBN",
        "1",
        "the stereochemistry of the protein myoglobin",
        "MYOGLOBIN",
        "Physeter catodon",
        153,
    ),
    PDB_Entity(
        "1UMO",
        "1",
        "the crystal structure of cytoglobin: the fourth globin type discovered in man",
        "CYTOGLOBIN",
        "Homo sapiens",
        190,
    ),
    PDB_Entity(
        "2DHB",
        "1",
        "three dimensional fourier synthesis of horse deoxyhaemoglobin at 2.8 angstroms resolution",
        "HEMOGLOBIN (DEOXY) (ALPHA CHAIN)",
        "Equus caballus",
        141,
    ),
    PDB_Entity(
        "2DHB",
        "2",
        "three dimensional fourier synthesis of horse deoxyhaemoglobin at 2.8 angstroms resolution",
        "HEMOGLOBIN (DEOXY) (BETA CHAIN)",
        "Equus caballus",
        146,
    ),
    PDB_Entity(
        "3MKB",
        "1",
        "crystal structure determination of shortfin Mako (isurus oxyrinchus) hemoglobin at 1.9 angstrom resolution",
        "HEMOGLOBIN SUBUNIT ALPHA",
        "Isurus oxyrinchus",
        140,
    ),
    PDB_Entity(
        "3MKB",
        "2",
        "crystal structure determination of shortfin Mako (isurus oxyrinchus) hemoglobin at 1.9 angstrom resolution",
        "HEMOGLOBIN SUBUNIT BETA",
        "Isurus oxyrinchus",
        136,
    ),
]

end
