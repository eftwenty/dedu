ActiveAdmin.register Group do
  config.filters = false

  permit_params :code

  index do
    selectable_column
    id_column
    column :code
    column :students do |obj|
      obj.students.count
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :code
    end
    f.actions
  end

end
