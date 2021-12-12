# GBSwiftAdditions

GBComponents
- GBAudioPLayer
- GBTimerWorker
- GBLocationWorker
    - func setUpLocationManager()
    - func requestLocation(_ completion: @escaping (Result<CLLocation, Error>) -> Void)
- GBCacheWorker
    - func saveCache(object: Any, for key: NSString)
    - func getCachedObject(for key: NSString) -> Any?
    - func removeCache(for key: NSString)

GBExtensions
- ArrayAdditions
    - public func chunked(by distance: Int) -> [[Element]]
- DateAdditions
    - public func numberOfDaysFromToday() -> Int
    - public func isGreaterThanDate(dateToCompare: Date) -> Bool
    - public func isLessThanDate(dateToCompare: Date) -> Bool
    - public func dateByAddingDays(_ days : Int, settingHour h: Int? = nil, settingMinutes m: Int? = nil) -> Date?
    - public func dateByAddingWeeks(_ weeks : Int, settingHour h: Int? = nil, settingMinutes m: Int? = nil) -> Date?
    - public func dateByAddingMonths(_ months : Int, settingHour h: Int? = nil, settingMinutes m: Int? = nil) -> Date?
    - public func dateByAddingMinutes(_ minutes : Int) -> Date?
    - public static func today() -> Date
    - public static func getFirst(weekDay: Weekday, year: Int, month: Int) -> Date?
    - public func nextFirstWeekDayOfMonth(_ weekday: Weekday, considerToday: Bool = false) -> Date?
    - public func next(_ weekday: Weekday, considerToday: Bool = false) -> Date
    - public func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date
    - public func get(_ direction: SearchDirection, _ weekDay: Weekday, considerToday consider: Bool = false) -> Date
    - public func get(_ direction: SearchDirection, _ numberDay: Int, considerToday consider: Bool = false) -> Date
    - public func getWeekDaysInEnglish() -> [String]
    - public enum Weekday: String
    - public enum SearchDirection 
- NSMutableAttributedStringAdditions
    - @discardableResult public func bold(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString
    - @discardableResult public func black(_ text: String, size: CGFloat = 17, color: UIColor? = nil) -> NSMutableAttributedString
    - @discardableResult public func normal(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString
    - @discardableResult public func customFont(_ text: String, FontName: String, size: CGFloat) -> NSMutableAttributedString
    - @discardableResult public func customSystemFont(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> NSMutableAttributedString
    - @discardableResult public func underlined(_ text: String, color: UIColor = .black) -> NSMutableAttributedString
    - @discardableResult public func strikeThrough(_ text: String, color: UIColor = .black) -> NSMutableAttributedString
    - @discardableResult public func colored(_ text: String, color: UIColor) -> NSMutableAttributedString
- StringAdditions
    - public func index(of string: Self, options: String.CompareOptions = []) -> Index?
    - public func endIndex(of string: Self, options: String.CompareOptions = []) -> Index?
    - public func indexes(of string: Self, options: String.CompareOptions = []) -> [Index]
    - public func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>]
    - public func rangeFromStart(upTo endOfString: String) throws -> NSRange
    - public func rangeUntilEnd(from endOfString: String) throws -> NSRange
    - public func simpleHTMLInterpreted() -> NSMutableAttributedString
- TimeIntervalAdditions
    - public var clockString: String
- UICollectionViewAdditons
    - public func registerCells<T: UICollectionViewCell>(cells: [T])
    - public func dequeueReusableCell<T: UICollectionViewCell>(at indexPath:IndexPath, withIdentifier cellName:String = String(describing: type(of: T.self))) -> T
- UIFontAdditions
    - public func systemFontItalic(of weight: UIFont.Weight) -> UIFont?
    - public func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont?
    - public func bold() -> UIFont?
    - public func italic() -> UIFont?
- UIImageViewAdditions
    - func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    - func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)
- UITableViewAdditions
    - public func registerCells<T: UITableViewCell>(cells: [T])
    - public func dequeueReusableCell<T: UITableViewCell>(for indexPath:IndexPath, withIdentifier cellName:String = String(describing: type(of: T.self))) -> T
- UIViewAdditions
    - public func setRoundedCorner(for corners: UIRectCorner, with radius: CGFloat)
    - public func setRoundedBorder(radius: CGFloat, borderWidth: CGFloat, color: UIColor)

GBSwiftAdditions
- Several generic functions

GBUIKitAdditions
- DoneButtonKeyboard
- GBCircularProgressView
- GBCopyableLabel
- GBGradientBackgroundView
- GBProgressSpeedometer
- GBResizableUISlider
- GBStrikeThroughLabel
- GBTwoLinesTextDisplayControl
- GBUnderLinedButton
- GBUnderlinedLabel
