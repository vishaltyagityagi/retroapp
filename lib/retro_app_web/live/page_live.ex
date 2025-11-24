defmodule RetroAppWeb.PageLive do
  use RetroAppWeb, :live_view

  alias RetroApp.Retrospectives

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("create_retro", _params, socket) do
    slug = Base.encode16(:crypto.strong_rand_bytes(4), case: :lower)
    
    case Retrospectives.create_retrospective(%{title: "Retrospective #{Date.utc_today()}", slug: slug}) do
      {:ok, retro} ->
        Retrospectives.create_column(%{title: "What went well", retrospective_id: retro.id})
        Retrospectives.create_column(%{title: "What went wrong", retrospective_id: retro.id})
        Retrospectives.create_column(%{title: "Shoutouts", retrospective_id: retro.id})
        Retrospectives.create_column(%{title: "What can we improve", retrospective_id: retro.id})
        
        {:noreply, push_navigate(socket, to: ~p"/retro/#{retro.slug}")}
        
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not create retrospective")}
    end
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col items-center justify-center bg-slate-50 relative overflow-hidden">
      <!-- Decorative background elements -->
      <div class="absolute top-0 left-0 w-full h-full overflow-hidden z-0">
        <div class="absolute -top-[10%] -left-[10%] w-[40%] h-[40%] rounded-full bg-blue-100/50 blur-3xl"></div>
        <div class="absolute top-[20%] right-[10%] w-[30%] h-[30%] rounded-full bg-sky-100/50 blur-3xl"></div>
        <div class="absolute -bottom-[10%] left-[20%] w-[50%] h-[50%] rounded-full bg-slate-200/30 blur-3xl"></div>
      </div>

      <div class="relative z-10 text-center px-4">
        <div class="mb-8 inline-flex items-center justify-center p-3 bg-white rounded-2xl shadow-sm border border-blue-100">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-blue-600" viewBox="0 0 20 20" fill="currentColor">
            <path d="M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z" />
            <path d="M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z" />
          </svg>
        </div>
        
        <h1 class="text-6xl font-extrabold text-slate-800 mb-6 tracking-tight">
          Retro<span class="text-blue-600">App</span>
        </h1>
        
        <p class="text-xl text-slate-600 mb-10 max-w-2xl mx-auto leading-relaxed">
          Collaborate with your team in real-time. Reflect, discuss, and improve with a simple, beautiful retrospective board.
        </p>
        
        <button phx-click="create_retro" class="group relative inline-flex items-center justify-center px-8 py-4 text-lg font-bold text-white transition-all duration-200 bg-blue-600 font-pj rounded-xl focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 hover:bg-blue-700 shadow-lg hover:shadow-blue-500/30 hover:-translate-y-1">
          <span>Create New Retro</span>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2 transition-transform group-hover:translate-x-1" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
        
        <div class="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8 text-left max-w-4xl mx-auto">
          <div class="bg-white/60 backdrop-blur-sm p-6 rounded-xl border border-slate-100 shadow-sm">
            <div class="text-blue-600 mb-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="font-bold text-slate-800 mb-2">Real-time Updates</h3>
            <p class="text-sm text-slate-600">See changes instantly as your team adds items and votes.</p>
          </div>
          <div class="bg-white/60 backdrop-blur-sm p-6 rounded-xl border border-slate-100 shadow-sm">
            <div class="text-blue-600 mb-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 class="font-bold text-slate-800 mb-2">Action Items</h3>
            <p class="text-sm text-slate-600">Track actionable takeaways to ensure continuous improvement.</p>
          </div>
          <div class="bg-white/60 backdrop-blur-sm p-6 rounded-xl border border-slate-100 shadow-sm">
            <div class="text-blue-600 mb-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
              </svg>
            </div>
            <h3 class="font-bold text-slate-800 mb-2">Discussions</h3>
            <p class="text-sm text-slate-600">Reply to feedback cards to dive deeper into topics.</p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
