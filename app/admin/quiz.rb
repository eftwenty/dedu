ActiveAdmin.register Quiz do
  permit_params :title, :course_id,
                questions_attributes: [:id, :_destroy, :text,
                                       answers_attributes: [:id, :_destroy, :text, :correct]]
                # practices_attributes: [:id, :_destroy, :title, :content, :document]

  # scope_to do
  #   @@user = current_user
  #
  #   Class.new do
  #     def self.courses
  #       if @@user.student?
  #         Course.joins(:groups).where(groups: {id: @@user.group&.id})
  #       else
  #         Course.all
  #       end
  #     end
  #   end
  # end

  # controller do
  #   def create
  #     @quiz = Quiz.new(post_params.merge(course_id: params[:course_id]))
  #
  #     if @quiz.save
  #       redirect_to admin_quiz_path(@quiz)
  #     else
  #       render :new
  #     end
  #   end
  #
  #   private
  #
  #   def post_params
  #     params.require(:quiz).permit(:title, :course_id)
  #                                    # theories_attributes: [:id, :_destroy, :title, :content, :document],
  #                                    # practices_attributes: [:id, :_destroy, :title, :content, :document])
  #   end
  # end

  index do
    selectable_column
    id_column if current_user.super?
    column :title
    column :created_at
    actions
  end

  show do
    panel 'Details' do
      attributes_table_for quiz do
        row :title
      end
    end
    panel 'Course' do
      attributes_table_for quiz.course do
        row :title do |c|
          link_to c.title, admin_course_path(c)
        end
      end
    end
    panel 'Questions' do
      table_for quiz.questions do
        column :text
        column :answers do |q|
          q.answers.map{ |a| a.correct? ? "<i><strong>#{a.text}</strong></i>" : "<i>#{a.text}</i>" }.join('; ').html_safe
        end
      end
    end unless current_user.student? || (current_user.teacher? && quiz.course.created_by != current_user.id)
    active_admin_comments
  end

  filter :title

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :course_id, as: :select, collection: Course.order(:title).map{|c| [c.title, c.id]}
    end
    f.inputs 'Questions' do
      f.has_many :questions, allow_destroy: true do |q|
        q.input :text, label: ''
        q.has_many :answers, allow_destroy: true do |a|
          a.input :text
          a.input :correct, as: :boolean
        end
      end
    end
    f.actions
  end

end
