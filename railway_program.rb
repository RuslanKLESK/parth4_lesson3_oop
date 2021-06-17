=begin
С этого занятия мы будем создавать объектную модель (классы и методы) для гипотетического приложения управления железнодорожными станциями, которое позволит управлять станциями, принимать и отправлять поезда, показывать информацию о них и т.д.

Требуется написать следующие классы:

Класс Station (Станция):
+ Имеет название, которое указывается при ее создании
+ Может принимать поезда (по одному за раз)
+ Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
+ Может возвращать список всех поездов на станции, находящиеся в текущий момент
+ Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
=end

class Station
  attr_reader :station_name
  attr_reader :train_on_station		# Может возвращать список всех поездов на станции, находящиеся в текущий момент

  @@number_of_stations = 0
  @@train_count = 0
  @stations = [] 			# Далее, может будет как-то использоваться в Route;

  def initialize(station_name)
    @@number_of_stations += 1
    @station_name = station_name
	@stations << station_name	# Создаётся база имён станций в массиве;
	@train_on_station = [] 		# Может принимать поезда (по одному за раз)
  end
  
  def ingoing_train(t_name)
    self.train_on_station << t_name		#записать в списко поездов на станции	
	@@train_count += 1
	puts "The train #{t_name} arrived at the station #{station_name}!"
  end

  def outgoing_train(t_name)
    self.train_on_station.delete(t_name)
	@@train_count -= 1
	puts "The train #{t_name} is leaving the station #{station_name}!"
  end
  
  def train_by_type(t_type)
    self.train_on_station.each do |train|
      if train.type == type
        puts "#{t_type}"
      end
    end
  end 

  def total_number_of_stations	# Просто узнать кол-во созданных станций
    @@number_of_stations
  end
  
  end

=begin
Класс Route (Маршрут):
+ Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
+ Может добавлять промежуточную станцию в список
+ Может удалять промежуточную станцию из списка
+ Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
  attr_reader :stations

  def initialize(start_station, finish_station)
    @stations = []
    @stations << start_station
    @stations << finish_station
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end
end

=begin
Класс Train (Поезд):
+ Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
+ Может набирать скорость
+ Может возвращать текущую скорость
+ Может тормозить (сбрасывать скорость до нуля)
+ Может возвращать количество вагонов
+ Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
+ Может принимать маршрут следования (объект класса Route). 
+ При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
+ Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
+ Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

В качестве ответа приложите ссылку на репозиторий с решением.
=end

class Train < Route
  attr_accessor :t_name, :t_type, :amount_wagons, :station
  attr_reader :route
  
  @@train_count = 0	# Просто так. Для подсчёта общего количества поездов.

  def initialize(t_name, t_type, amount_wagons)
    @t_name = t_name
	@t_type = t_type
	@amount_wagons = amount_wagons
	@current_speed = 0
	@@train_count += 1
	puts "Train #{t_name} created. Type: #{t_type}. Amount of vagons: #{vagon_count} Speed: #{current_speed}"
  end

  def current_speed		# Может возвращать текущую скорость
    puts "You are now going #{@current_speed} km/h."
  end

  def speed_up(number)	# Может набирать скорость
    @current_speed += number
    puts "You speed_up to #{number} km/h."
  end

  def brake				# Может тормозить до 0.
    @current_speed = 0
	puts "Speed down. Current speed = 0 km/h"
  end

  def add_vagon			# Может прицеплять вагоны
	if current_speed == 0
    self.vagon_count += 1
	  puts "Railway carriage added. Current vagons = #{vagon_count}"
	else
	  puts "Need speed down first!"
	end
  end

  def del_vagon			# Может отцеплять вагоны
	if current_speed = 0
    self.vagon_count -= 1
	  puts "Railway carriage unhooked. Current vagons = #{vagon_count}"
	else
	  puts "Need speed down first!"
	end
  end
  
  def train_all			# Всего создано поездов
	@@train_count
  end
  
  def route=(route)
    @route = route
    self.station = self.route.stations.first
  end

  def next_station
    self.route.stations[self.route.stations.index(self.station) + 1]
  end

  def previous_station
    self.route.stations[self.route.stations.index(self.station) - 1]
  end

  def move_next_station
    self.station = self.route.stations[self.route.stations.index(self.station) + 1]
  end
  
  def current_station
    self.station
  end
  
end