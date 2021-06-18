class SDG::Goals::IconComponent < ApplicationComponent
  attr_reader :goal
  delegate :code, to: :goal

  def initialize(goal)
    @goal = goal
  end

  def png
    image_tag image_path, alt: image_text, class: "sdg-goal-icon"
  end

  def image_path
    png_path(locale)
  end

  def svg
    tag.svg(role: "img", "aria-label": image_text, viewBox: "0 0 1000 1000", class: "sdg-goal-icon") do
      tag.use(href: asset_path("#{svg_path(locale)}#goal_#{goal.code}"))
    end
  end

  private

    def image_text
      goal.code_and_title
    end

    def locale
      @locale ||= [*I18n.fallbacks[I18n.locale], "default"].find do |fallback|
        AssetFinder.find_asset(svg_path(fallback)) || AssetFinder.find_asset(png_path(fallback))
      end
    end

    def svg_available?
      AssetFinder.find_asset("sdg/#{locale}/goals.svg")
    end

    def svg_path(locale)
      "sdg/#{locale}/goals.svg"
    end

    def png_path(locale)
      "sdg/#{locale}/goal_#{code}.png"
    end
end
