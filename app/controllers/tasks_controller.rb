class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    before_action :correct_user, only:[:show, :edit, :update, :destroy]
    
    def index
        @pagy, @tasks = pagy(current_user.tasks.all, items: 5)
    end
    
    def show
    end
    
    def new
        @task = Task.new
    end
    
    def create
        @task = current_user.tasks.new(task_params)
        
        if @task.save
            flash[:success] = 'Task が正常に入力されました'
            redirect_to @task
        else
            flash[:danger] = 'Task が投稿されませんでした'
            render :new
        end
    end
    
    def edit
    end
    
    def update
        if @task.update(task_params)
            flash[:success] = 'Task が正常に更新されました'
            redirect_to @task
        else
            flash[:danger] = 'Task が更新されませんでした'
            render :edit
        end
    end
    
    def destroy
        @task.destroy
        
        flash[:success] = 'Task は正常に削除されました'
        redirect_to root_url
    end

    private
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
            redirect_to root_url
        end
    end
    
    def task_params
        params.require(:task).permit(:content, :status)
    end
end