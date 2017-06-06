ActiveAdmin.register Group do
  config.filters = false

  # permit_params :code, student_ids: []

  controller do
    def create
      @group = Group.new(last_post_params)

      if @group.save
        redirect_to admin_group_path(@group)
      else
        render :new
      end
    end

    def update
      @group = Group.find(params[:id])
      if @group.update(last_post_params)
        redirect_to admin_group_path(@group)
      else
        render :edit
      end
    end

    private

    def last_post_params
      post_params.merge(student_ids: student_ids_params, course_ids: course_ids_params)
    end

    def post_params
      params.require(:group).permit(:code, :student_ids)
    end

    def student_ids_params
      params[:group][:student_ids].reject{ |e| e.blank? }
    end

    def course_ids_params
      params[:group][:course_ids].reject{ |e| e.blank? }
    end
  end

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

  show title: :code do
    panel 'Students list' do
      if group.students.present?
        table_for group.students.sort_by(&:pretty_name) do
          column :name do |s|
            s.pretty_name
          end
          column :email
        end
      else
        div "There're no students assigned yet."
      end
    end
    unless current_user.student? && current_user.group.id != group.id
      panel 'Courses available' do
        if group.courses.present?
          table_for group.courses do
            column :title do |c|
              link_to "#{c.title}", admin_course_path(c)
            end
            column :description do |c|
              c.description.html_safe
            end
          end
        else
          div "There're no students assigned yet."
        end
      end
      active_admin_comments
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :code
    end
    f.inputs 'Attendees' do
      f.input :student_ids,
              as: :select, multiple: true,
              collection: User.student.without_group_or_relates_to(f.object.id).sort_by(&:pretty_name)
                              .map{ |u| [u.pretty_name, u.id] },
              label: 'Students'
    end
    f.inputs 'Subjects available' do
      f.input :course_ids,
              as: :select, multiple: true,
              collection: Course.order(:title).map{ |c| [c.title, c.id] },
              label: 'Courses'
    end
    f.actions
  end

end
