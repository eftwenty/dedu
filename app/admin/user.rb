ActiveAdmin.register User do
  permit_params :email, :role, :password, :password_confirmation, :group_id

  scope :all, default: true
  scope :student
  scope :teacher

  index do
    selectable_column
    id_column
    column :email
    tag_column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    panel "#{user.role.capitalize} Details" do
      attributes_table_for user do
        row :email
        row :role
        row :sign_in_count
        row :last_sign_in_count
        row :last_sign_in_ip
      end
    end
    if user.student?
      panel 'Group' do
        attributes_table_for user.group do
          row :code
        end
      end
    end
    active_admin_comments
  end

  filter :email
  filter :role, as: :select, collection: User::ROLES
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Details" do
      f.input :email
      f.input :role
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end

      if f.object.student?
        f.input :group_id, as: :select, collection: Group.all.map{ |g| [g.code, g.id] }
      end
    end
    f.actions
  end

end
