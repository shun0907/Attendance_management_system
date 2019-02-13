class Shift < ApplicationRecord
  belongs_to :user
  
  require "time"
  
  WDAY = [ "日", "月", "火", "水", "木", "金", "土" ]
  
  def self.shift_list(info)
    total_days = 0
    shifts_info = []
    
    query = info[:q].nil? ? "0" : info[:q];
  
    today = Time.zone.now.in_time_zone('Tokyo').strftime('%Y-%m-%d')
    target_date = today.to_date.months_since(query.to_i)
    end_day = target_date.end_of_month.day
    
    i = 1
    while i <= end_day
      time_diff = nil
      date = Time.zone.local(target_date.year, target_date.month, i).strftime('%Y-%m-%d')
      shift = self.find_by(user_id: info[:id], date: date)

      if shift.present?
        start_time = shift.start_time.present? ? Time.parse(shift.start_time).strftime('%H:%M') : nil;
        end_time = shift.end_time.present? ? Time.parse(shift.end_time).strftime('%H:%M') : nil;
        
        if start_time.present? && end_time.present?
          s_t = Time.parse(start_time + ':00');
          e_t = Time.parse(end_time + ':00');
          time_diff = ((e_t - s_t) / 3600.0).round(1)
          
          logger.debug('s_t ============')
          logger.debug(s_t)
          logger.debug('e_t ============')
          logger.debug(e_t)
          logger.debug('time_diff ============')
          logger.debug(time_diff)
          
          total_days += 1
        end
      else
        start_time = nil
        end_time = nil
        
        dates = self.new(user_id: info[:id], date: date)
        dates.save
      end
    
    
      is_today = today === date ? 1 : 0;
      clock_in = is_today === 1 && start_time.blank? ? 1 : 0;
      clock_out = is_today === 1 && start_time.present? && end_time.blank? ? 1 : 0;
      
      shifts_info.push({ 
        date: date, 
        wday: WDAY[date.to_date.wday], 
        start_time: start_time, 
        end_time: end_time,
        work_hours: time_diff,
        is_clock_in: clock_in,
        is_clock_out: clock_out
      })
      
      i += 1
    end
    
    logger.debug('shifts_info ============')
    logger.debug(shifts_info)
    
    return shifts_info, query, target_date, end_day, total_days, today
  end
  
  
  
  # def self.shift_list(info)
  #   clock_out = 0
  #   total_days = 0
  #   shifts_info = []
    
  #   query = info[:q].nil? ? "0" : info[:q];
  
  #   today = Time.zone.now.in_time_zone('Tokyo').strftime('%Y-%m-%d')
  #   target_date = today.to_date.months_since(query.to_i)
  #   end_day = target_date.end_of_month.day
    
  #   i = 1
  #   while i <= end_day
  #     date = Time.zone.local(target_date.year, target_date.month, i).strftime('%Y-%m-%d')

  #     shift = self.find_by(user_id: info[:id], date: date)

  #     if shift.present?
  #       start_time = shift.start_time.present? ? Time.parse(shift.start_time).strftime('%H:%M') : nil;
  #       end_time = shift.end_time.present? ? Time.parse(shift.end_time).strftime('%H:%M') : nil;
  #     else
  #       start_time = nil
  #       end_time = nil
  #     end
      
  #     time_diff = nil
  #     if start_time.present? && end_time.present?
  #       s_t = Time.parse(start_time);
  #       e_t = Time.parse(end_time);
  #       time_diff = ((e_t - s_t) / 3600.0).round(1)
  #       total_days += 1
  #     end
    
  #     is_today = today === date ? 1 : 0;
  #     clock_in = is_today === 1 && start_time.blank? ? 1 : 0;
  #     clock_out = is_today === 1 && start_time.present? && end_time.blank? ? 1 : 0;
      
  #     shifts_info.push({ 
  #       date: date, 
  #       wday: WDAY[date.to_date.wday], 
  #       start_time: start_time, 
  #       end_time: end_time,
  #       work_hours: time_diff,
  #       is_clock_in: clock_in,
  #       is_clock_out: clock_out
  #     })
      
  #     i += 1
  #   end
    
  #   logger.debug('shifts_info ============')
  #   logger.debug(shifts_info)
    
  #   return shifts_info, query, target_date, end_day, total_days
  # end
  
end
