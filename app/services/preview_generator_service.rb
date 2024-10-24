class PreviewGeneratorService
  def initialize(url)
    @url = url
  end

  def call
    begin
      object = LinkThumbnailer.generate(@url)
      {
        title: object.title,
        description: object.description,
        image: object.images.first&.src.to_s,
        video: object.videos.first&.src.to_s
      }
    rescue LinkThumbnailer::Exceptions
      nil
    end
  end
end
