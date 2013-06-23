class Search
  attr_reader :options
  def initialize(model, options)
    @model = model
    @options = options || {}
  end
  def titolo
    options[:titolo]
  end
  def categoria
    options[:categoria]
  end
  def tag
    options[:tag]
  end
  def event_date_after
    date_from_options(:data_fine)
  end
  def event_date_before
    date_from_options(:data_creazione)
  end
  def has_titolo?
    titolo.present?
  end
  def has_categoria?
    categoria.present?
  end
  def has_tag?
    tag.present?
  end
  def conditions
    conditions = []
    parameters = []
    return nil if options.empty?
    if has_titolo?
      conditions << "#{@model.table_name}.titolo LIKE ?"
      parameters << "%#{name}%"
    end
    if has_categoria?
      conditions << "#{@model.table_name}.categoria LIKE ?"
      parameters << "%#{address}%"
    end
    if has_tag?
      conditions << "#{@model.table_name}.tag LIKE ?"
      parameters << "%#{address}%"
    end
    if event_date_after
      conditions << "#{@model.table_name}.data_creazione >= ?"
      parameters << event_date_after.to_time
    end
    if event_date_before
      conditions << "#{@model.table_name}.data_fine <= ?"
      parameters << event_date_before.to_time.end_of_day
    end
    unless conditions.empty?
      [conditions.join(" AND "), *parameters]
    else
      nil
    end
  end
  private
  def date_from_options(which)
    part = Proc.new { |n| options["#{which}(#{n}i)"] }
    y, m, d = part[1], part[2], part[3]
    y = Date.today.year if y.blank?
    Date.new(y.to_i, m.to_i, d.to_i)
  rescue ArgumentError => e
    return nil
  end
end
