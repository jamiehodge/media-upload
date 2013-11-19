Sequel.migration do
  up do
    create_table :uploads do
      uuid_primary_key

      uuid_foreign_key :state_id, :states

      uuid :file_id
      uuid :resource_id, null: false

      citext  :name, null: false

      timestamps
      lock_version

      full_text_index :name
    end

    create_notification_trigger :uploads
    create_timestamp_trigger :uploads
  end

  down do
    drop_timestamp_trigger :uploads
    drop_notification_trigger :uploads
    drop_table :uploads
  end
end
