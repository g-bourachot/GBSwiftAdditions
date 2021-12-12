//
//  DateAdditions.swift
//
//
//  Created by Guillaume Bourachot on 29/10/2019.
//

import Foundation

extension Date {
    public func isGreaterThanDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            return true
        }
        return false
    }
    
    public func isLessThanDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            return true
        }
        return false
    }

    public func dateByAddingDays(_ days : Int, settingHour h: Int? = nil, settingMinutes m: Int? = nil) -> Date? {
        var hours = h ?? Calendar.current.component(.hour, from: self)
        let minutes = m ?? Calendar.current.component(.minute, from: self)
        var days = DateComponents(day: days)
        days.timeZone = TimeZone.init(identifier: "GMT+1")
        
        if days.timeZone?.isDaylightSavingTime() ?? false {
            hours += 1
        }
        return Calendar.current.date(byAdding: days, to: self).flatMap({
            Calendar.current.date(bySettingHour: hours, minute: minutes , second: 0, of: $0)
        })
    }

    public func dateByAddingWeeks(_ weeks : Int, settingHour h: Int? = nil, settingMinutes m: Int? = nil) -> Date? {
        var hours = h ?? Calendar.current.component(.hour, from: self)
        let minutes = m ?? Calendar.current.component(.minute, from: self)
        var weeks = DateComponents(day: weeks*7)
        weeks.timeZone = TimeZone.init(identifier: "GMT+1")
        
        if weeks.timeZone?.isDaylightSavingTime() ?? false {
            hours += 1
        }
        return Calendar.current.date(byAdding: weeks, to: self).flatMap({
            Calendar.current.date(bySettingHour: hours, minute: minutes , second: 0, of: $0)
        })
    }
    
    public func dateByAddingMonths(_ months : Int, settingHour h: Int? = nil, settingMinutes m: Int? = nil) -> Date? {
        var hours = h ?? Calendar.current.component(.hour, from: self)
        let minutes = m ?? Calendar.current.component(.minute, from: self)
        var months = DateComponents(month: months)
        months.timeZone = TimeZone.init(identifier: "GMT+1")
        
        if months.timeZone?.isDaylightSavingTime() ?? false {
            hours += 1
        }
        return Calendar.current.date(byAdding: months, to: self).flatMap({
            Calendar.current.date(bySettingHour: hours, minute: minutes , second: 0, of: $0)
        })
    }

    public func dateByAddingMinutes(_ minutes : Int) -> Date? {
        var hours = Calendar.current.component(.hour, from: self)
        var dateComponent = DateComponents(minute: minutes)
        dateComponent.timeZone = TimeZone.init(identifier: "GMT+1")
        if dateComponent.timeZone?.isDaylightSavingTime() ?? false {
            hours += 1
        }
        return Calendar.current.date(byAdding: dateComponent, to: self).flatMap({
            Calendar.current.date(bySetting: .hour, value: hours, of: $0)
        })
    }

    public static func today() -> Date {
        return Date()
    }
    
    public static func getFirst(weekDay: Weekday, year: Int, month: Int) -> Date? {
        var firstOfMonthComponents = DateComponents()
        firstOfMonthComponents.calendar = Calendar.current
        firstOfMonthComponents.timeZone = TimeZone.init(identifier: "GMT+1")
        firstOfMonthComponents.year = year
        firstOfMonthComponents.month = month
        firstOfMonthComponents.day = 01
        
        if let firstDayOfMonth = firstOfMonthComponents.date {
            return firstDayOfMonth.next(weekDay, considerToday: true)
        } else {
            return nil
        }
    }
    
    public func nextFirstWeekDayOfMonth(_ weekday: Weekday, considerToday: Bool = false) -> Date? {
        var firstOfMonthComponents = DateComponents()
        firstOfMonthComponents.calendar = Calendar.current
        firstOfMonthComponents.timeZone = TimeZone.init(identifier: "GMT+1")
        firstOfMonthComponents.year = Calendar.current.component(.year, from: self)
        firstOfMonthComponents.month = Calendar.current.component(.month, from: self)
        firstOfMonthComponents.hour = 10
        firstOfMonthComponents.day = 01
        
        if let firstDayOfMonth = firstOfMonthComponents.date,
           let nextMonthFirstDay = firstDayOfMonth.dateByAddingMonths(1) {
            return nextMonthFirstDay.next(weekday, considerToday: considerToday)
        } else {
            return nil
        }
    }

    public func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
      return get(.next,
                 weekday,
                 considerToday: considerToday)
    }

    public func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
      return get(.previous,
                 weekday,
                 considerToday: considerToday)
    }

    public func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {

      let dayName = weekDay.rawValue

      let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

      assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

      let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

      let calendar = Calendar(identifier: .gregorian)

      if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
        return self
      }

      var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
      nextDateComponent.weekday = searchWeekdayIndex

      let date = calendar.nextDate(after: self,
                                   matching: nextDateComponent,
                                   matchingPolicy: .nextTime,
                                   direction: direction.calendarSearchDirection)

      return date!
    }
    
    public func get(_ direction: SearchDirection,
                    _ numberDay: Int,
                    considerToday consider: Bool = false) -> Date {
        
        assert(numberDay <= 31, "Numbber of the day should bbe lower than 31")
        
        let calendar = Calendar(identifier: .gregorian)
        var nextDateComponent = calendar.dateComponents([.day], from: self)
        nextDateComponent.day = numberDay
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }

    public func getWeekDaysInEnglish() -> [String] {
      var calendar = Calendar(identifier: .gregorian)
      calendar.locale = Locale(identifier: "en_US_POSIX")
      return calendar.weekdaySymbols
    }

    public enum Weekday: String {
      case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    public enum SearchDirection {
      case next
      case previous

      var calendarSearchDirection: Calendar.SearchDirection {
        switch self {
        case .next:
          return .forward
        case .previous:
          return .backward
        }
      }
    }
}
