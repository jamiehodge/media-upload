Sequel.migration do
  up do
    create_table :parts do
      uuid_primary_key

      uuid_foreign_key :upload_id, :uploads, on_delete: :cascade

      integer :position, null: false

      timestamps
      lock_version

      unique [:position, :upload_id]
    end

    create_timestamp_trigger :parts
  end

  down do
    drop_timestamp_trigger :parts
    drop_table :parts
  end
end
