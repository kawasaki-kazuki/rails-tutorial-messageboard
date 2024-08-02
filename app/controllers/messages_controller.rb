class MessagesController < ApplicationController
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    @message = Message.new
    # messegeを全て取得する
    @messages = Message.all
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to root_path , notice: 'メッセージを保存しました'
    else
      #メッセージが保存できなかった時
      @messages = Message.all
      flash.now[:alert] = "メッセージの保存に失敗しました"
      # render 'index'　←_form.html.erbでTurboを無効にしているのでindexをレンダリングできないのでコメントアウトした
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('form_messages', partial: 'form', locals: { message: @message }) }
        format.html { render :index }
      end
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      #保存に成功した場合はトップメッセージへリダイレクト
      redirect_to root_path , notice: 'メッセージを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end

  def destroy
    @message.destroy
    redirect_to root_path , notice: 'メッセージを削除しました'
  end

  private
  
  def message_params
    params.require(:message).permit(:name, :body)
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
