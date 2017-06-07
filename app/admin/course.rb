ActiveAdmin.register Course do
  permit_params :title, :description, :created_by,
                theories_attributes: [:id, :_destroy, :title, :content, :document],
                practices_attributes: [:id, :_destroy, :title, :content, :document]

  scope_to do
    @@user = current_user

    Class.new do
      def self.courses
        if @@user.student?
          Course.joins(:groups).where(groups: {id: @@user.group&.id})
        else
          Course.all
        end
      end
    end
  end

  controller do
    def create
      @course  = Course.new(post_params.merge(created_by: current_user.id))

      if @course.save
        redirect_to admin_course_path(@course)
      else
        render :new
      end
    end

    private

    def post_params
      params.require(:course).permit(:title, :description, :created_by,
                                     theories_attributes: [:id, :_destroy, :title, :content, :document],
                                     practices_attributes: [:id, :_destroy, :title, :content, :document])
    end
  end

  index do
    selectable_column
    id_column if current_user.super?
    column :title
    column :description do |obj|
      obj.description.html_safe
    end
    column :created_by do |obj|
      obj.created_by.present? && obj.created_by == current_user.id ?
          '<strong>Me</strong>'.html_safe :
          (User.find_by_id(obj.created_by)&.pretty_name || 'N/A')
    end
    column :created_at
    actions
  end

  show do
    panel 'Course info' do
      attributes_table_for course do
        row :title
        row :description do
          course.description.html_safe
        end
        row :created_by do |c|
          User.find_by_id(c.created_by)&.pretty_name || 'N/A'
        end
        if current_user.super?
          row :created_at
          row :updated_at
        end
      end
    end
    panel 'Theories' do
      if course.theories.present?
        table_for course.theories do
          column :title
          column :content
          column :document do |t|
            link_to "#{t.document_file_name}", t.document.url(:original, false)
          end
        end
      else
        'There is no theory items yet.'
      end
    end
    panel 'Practices' do
      if course.practices.present?
        table_for course.practices do
          column :title
          column :content
          column :document do |p|
            link_to "#{p.document_file_name}", p.document.url(:original, false)
          end
        end
      else
        'There is no practice items yet.'
      end
    end
    panel 'Groups assigned' do
      if course.groups.present?
        table_for course.groups do
          column :group do |g|
            g.code
          end
          column :students do |g|
            g.students.count
          end
        end
      else
        div "There're no students assigned yet."
      end
    end
    active_admin_comments
  end

  filter :title
  filter :description

  form html: { enctype: 'multipart/form-data' } do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :description, as: :html_editor
    end
    f.inputs do
      f.has_many :theories, heading: 'Theories', allow_destroy: true do |t|
        t.input :title
        t.input :content
        t.input :document, as: :file
      end
    end
    f.inputs do
      f.has_many :practices, heading: 'Practices', allow_destroy: true do |t|
        t.input :title
        t.input :content
        t.input :document, as: :file
      end
    end
    f.actions
  end

end
