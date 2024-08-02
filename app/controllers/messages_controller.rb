class MessagesController < ApplicationController
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    @message = Message.new
    @messages = Message.all
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to root_path, notice: 'メッセージを保存しました'
    else
      handle_save_error(:index)
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to root_path, notice: 'メッセージを編集しました'
    else
      handle_save_error(:edit)
    end
  end

  def destroy
    @message.destroy
    redirect_to root_path, notice: 'メッセージを削除しました'
  end

  private

  def message_params
    params.require(:message).permit(:name, :body)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def handle_save_error(action)
    @messages = Message.all
    flash.now[:alert] = "メッセージの保存に失敗しました"
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('form_messages', partial: 'form', locals: { message: @message }) }
      format.html { render action }
    end
  end
end
