ActiveAdmin.register Card do

  permit_params :original_text, :translated_text, :block_id, :user_id

  index do
    selectable_column
    column :id
    column :original_text
    column :translated_text
    column :review_date
    column :created_at
    column :user_id
    actions
  end
end
