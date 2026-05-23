import WidgetKit
import SwiftUI

struct Habit: Codable, Identifiable {
    var id: String { "\(habitId)-\(habitTimeId)" }
    let habitId: Int
    let habitTimeId: Int
    let name: String
    let iconCodePoint: Int
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int
    let isCompleted: Bool
    let emotion: Int?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), habits: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), habits: loadHabits())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let habits = loadHabits()
        let entry = SimpleEntry(date: Date(), habits: habits)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadHabits() -> [Habit] {
        let prefs = UserDefaults(suiteName: "group.com.example.compound")
        guard let jsonString = prefs?.string(forKey: "timeline_data"),
              let data = jsonString.data(using: .utf8) else {
            return []
        }
        return (try? JSONDecoder().decode([Habit].self, from: data)) ?? []
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let habits: [Habit]
}

struct CompoundWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Compound.")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Today")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 4)
            
            Divider().background(Color(white: 0.15))
            
            if entry.habits.isEmpty {
                Spacer()
                Text("No habits for today")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(entry.habits) { habit in
                            HabitRow(habit: habit)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
    }
}

struct HabitRow: View {
    let habit: Habit
    
    var body: some View {
        HStack(spacing: 12) {
            Text(String(format: "%02d:%02d", habit.startHour, habit.startMinute))
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.gray)
                .frame(width: 35)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(habitColor)
                    .strikethrough(habit.isCompleted)
                
                Text(String(format: "%02d:%02d - %02d:%02d", habit.startHour, habit.startMinute, habit.endHour, habit.endMinute))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if habit.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(habitColor)
            } else {
                HStack(spacing: 8) {
                    EmotionButton(habit: habit, emotion: 1, color: .orange)
                    EmotionButton(habit: habit, emotion: 2, color: .yellow)
                    EmotionButton(habit: habit, emotion: 3, color: .green)
                }
            }
        }
        .padding(10)
        .background(Color(white: 0.04))
        .cornerRadius(12)
    }
    
    var habitColor: Color {
        if !habit.isCompleted { return .white }
        switch habit.emotion {
        case 1: return Color(red: 1, green: 0.42, blue: 0)
        case 2: return Color(red: 1, green: 0.84, blue: 0)
        case 3: return Color(red: 0, green: 0.9, blue: 0.46)
        default: return .white
        }
    }
}

struct EmotionButton: View {
    let habit: Habit
    let emotion: Int
    let color: Color
    
    var body: some View {
        Button(intent: LogHabitIntent(habitId: habit.habitId, habitTimeId: habit.habitTimeId, emotion: emotion)) {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
    }
}

@main
struct CompoundWidget: Widget {
    let kind: String = "CompoundWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CompoundWidgetEntryView(entry: entry)
                    .containerBackground(.black, for: .widget)
            } else {
                CompoundWidgetEntryView(entry: entry)
                    .background(Color.black)
            }
        }
        .configurationDisplayName("Compound Timeline")
        .description("Keep track of your habits.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

// AppIntent for iOS 17 interactive widgets
import AppIntents

struct LogHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Habit"
    
    @Parameter(title: "Habit ID")
    var habitId: Int
    
    @Parameter(title: "Habit Time ID")
    var habitTimeId: Int
    
    @Parameter(title: "Emotion")
    var emotion: Int
    
    init() {}
    
    init(habitId: Int, habitTimeId: Int, emotion: Int) {
        self.habitId = habitId
        self.habitTimeId = habitTimeId
        self.emotion = emotion
    }
    
    func perform() async throws -> some IntentResult {
        // This is where we would call the background callback or update the DB
        // For home_widget, we can use a deep link or similar if supported in intents
        if let url = URL(string: "compound://log_habit?habitId=\(habitId)&habitTimeId=\(habitTimeId)&emotion=\(emotion)") {
            // home_widget might have a way to handle this via background URL
        }
        return .result()
    }
}
