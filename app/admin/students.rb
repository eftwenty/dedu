# ActiveAdmin.register User, as: 'Student' do
#   scope_to :student
#
#   actions :all, except: %i[edit update destroy]
#
#   permit_params :email, :role, :password, :password_confirmation
#
#   index do
#     selectable_column
#     id_column
#     column :email
#     column :role
#     column :current_sign_in_at
#     column :sign_in_count
#     column :created_at
#     actions
#   end
#
#   filter :email
#   filter :current_sign_in_at
#   filter :sign_in_count
#   filter :created_at
#
#   form do |f|
#     f.inputs "Details" do
#       f.input :email
#       f.input :role
#       if f.object.new_record?
#         f.input :password
#         f.input :password_confirmation
#       end
#     end
#     f.actions
#   end
#
# end
