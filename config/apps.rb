Padrino.configure_apps do
  set :protection, except: :path_traversal
  set :protect_from_csrf, true
  set :pickup_weekday, {
        'Rottne' => 4,
        'Tjureda' => 4,
        'Växjö c' => 4,
        'Linneuniversitetet' => 4,
        'Biskopshagen' => 4,
        'Tolg' => 5,
        'Lädja' => 5,
        'Ör' => 5,
        'Bråna' => 5
  }
  set :weekday, ['', 'Måndag', 'Tisdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lordag', 'Sondag']
end

# Mounts the core application for this project
Padrino.mount('Leverans::App', app_file: Padrino.root('app/app.rb')).to('/')
