module TagsHelper
  def tag_partial(model_instance)
    locals = {model: model_instance.class, tags: model_instance.tags, show_add_tag: true}
    {partial: 'shared/tag_list', locals: locals}
  end

  def index_tag_partial(model, tags)
    locals = {model: model, tags: tags, show_add_tag: false}
    {partial: 'shared/tag_list', locals: locals}
  end

  def add_tag_path(model)
    if model == Question
      add_tag_question_path
    elsif model == Kpi
      add_tag_kpi_path
    end
  end

  def tag_path(model, tag)
    if model == Question
      question_tag_path(tag)
    elsif model == Kpi
      kpi_tag_path(tag)
    end
  end
end
