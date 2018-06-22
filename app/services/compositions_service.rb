module CompositionsService
  mattr_accessor :authority
  self.authority = Composition

  def self.select_all_options
    authority.all.map do |element|
      [label(element.id), element.id]
    end
  end

  def self.label(id)
    comp = authority.find(id)
    "#{comp.title.first} | #{comp.creator.first}"
  end

end

