
module DateValidators
  # Проверяет валидность даты/времени (конец раньше начала, пересечение, выход из промежутка...)
  extend ActiveSupport::Concern

  class EventValidator < ActiveModel::Validator
    def validate(record)
      if record.begin_datetime.blank? || record.end_datetime.blank?
        record.errors[:text] << 'Неправильная дата'
        return
      end

      if (record.end_datetime - record.begin_datetime).to_i / 60 < 15
        record.errors[:text] << 'Длительность < 15 минут'
      end
    end
  end

  class RoomValidator < ActiveModel::Validator
    def validate(record)
      if record.begin_work_time.blank? || record.end_work_time.blank?
        record.errors[:text] << 'Неправильная дата'
        return
      end

      if (record.end_work_time - record.begin_work_time).to_i / 60 < 15
        record.errors[:text] << 'Длительность < 15 минут'
      end

      if (record.end_work_time - record.begin_work_time).to_i / 3600 > 24
        record.errors[:text] << 'Длительность > 1 дня'
      end
    end
  end

  class OrderValidator < ActiveModel::Validator
    def validate(record)
      if record.begin_datetime.blank? || record.end_datetime.blank?
        record.errors[:text] << 'Неправильная дата'
        return
      end

      if (record.end_datetime - record.begin_datetime).to_i / 60 < 15
        record.errors[:text] << 'Длительность < 15 минут'
      end

      if record.event.blank?
        record.errors[:text] << 'Нет события'
        return
      end

      if record.end_datetime > record.event.end_datetime || record.begin_datetime < record.event.begin_datetime
        record.errors[:text] << 'Мимо события'
      end

      if record.room.blank?
        record.errors[:text] << 'Нет комнаты'
        return
      end

      if record.end_datetime.min + 60 * record.end_datetime.hour > record.room.end_work_time.min + 60 * record.room.end_work_time.hour ||
         record.begin_datetime.min + 60 * record.begin_datetime.hour < record.room.begin_work_time.min + 60 * record.room.begin_work_time.hour

        record.errors[:text] << 'Мимо комнаты'
      end

      record.room.orders.each do |order|
        if (record.begin_datetime < order.begin_datetime && record.end_datetime > order.begin_datetime) ||
           (record.begin_datetime < order.end_datetime && record.end_datetime > order.end_datetime) ||
           (record.begin_datetime >= order.begin_datetime && record.end_datetime <= order.end_datetime)

          record.errors[:text] << 'Пересечение событий'
        end
      end
    end
  end
end
