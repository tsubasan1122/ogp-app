class JobsController < ApplicationController
  before_action :authenticate_user!, expect: :show
  def index
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    image = Magick::ImageList.new('./public/base_image.png')
    draw = Magick::Draw.new
    title = cut_text(@job.title)
    draw.annotate(image, 0 , 0, 0, -120, title) do
      #日本語対応可能なフォントにする
      self.font = 'ArialUnicode'

      #フォントの塗りつぶし色
      self.fill = '#000'

      #描画基準位置(中央)
      self.gravity = Magick::CenterGravity

      #フォントの太さ
      self.font_weight = Magick::BoldWeight

      #フォント縁取り色(透過)
      self.stroke = 'transparent'

      #フォントサイズ（48pt）
      self.pointsize = 48
    end

    image_path = image.write(unique_file_name).filename
    image_url = cut_path(image_path)
    @job.image_url = image_url

    if @job.save

      flash[:notice] = "求人が保存されました"
      redirect_to @job
    else
      flash[:alert] = "募集作成に失敗しました"
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  private

  def job_params
    params.require(:job).permit(:title, :content).merge(user_id: current_user.id)
  end

  def cut_path(url)
    url.sub(/\.\/public\//, "")
  end

  def unique_file_name
    "./public/#{SecureRandom.hex}.png"
  end

  def cut_text(text)
    text.scan(/.{1,15}/).join("\n")
  end
end
