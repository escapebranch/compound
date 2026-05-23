package com.example.compound

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import org.json.JSONArray
import org.json.JSONObject

class HabitListFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private var habits: JSONArray = JSONArray()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        val prefs = context.getSharedPreferences("HomeWidgetPrefs", Context.MODE_PRIVATE)
        val jsonString = prefs.getString("timeline_data", "[]")
        habits = JSONArray(jsonString)
    }

    override fun onDestroy() {}

    override fun getCount(): Int = habits.length()

    override fun getViewAt(position: Int): RemoteViews {
        val habit = habits.getJSONObject(position)
        val views = RemoteViews(context.packageName, R.layout.habit_item)

        val name = habit.getString("name")
        val startHour = habit.getInt("startHour")
        val startMinute = habit.getInt("startMinute")
        val endHour = habit.getInt("endHour")
        val endMinute = habit.getInt("endMinute")
        val isCompleted = habit.getBoolean("isCompleted")
        val emotion = if (habit.has("emotion") && !habit.isNull("emotion")) habit.getInt("emotion") else null

        views.setTextViewText(R.id.habit_name, name)
        views.setTextViewText(R.id.habit_time, String.format("%02d:%02d", startHour, startMinute))
        views.setTextViewText(R.id.habit_duration, String.format("%02d:%02d - %02d:%02d", startHour, startMinute, endHour, endMinute))

        if (isCompleted) {
            val color = when (emotion) {
                1 -> Color.parseColor("#FF6B00")
                2 -> Color.parseColor("#FFD600")
                3 -> Color.parseColor("#00E676")
                else -> Color.parseColor("#FFFFFF")
            }
            views.setTextColor(R.id.habit_name, color)
            views.setViewVisibility(R.id.emotion_container, View.GONE)
            views.setImageViewResource(R.id.habit_icon, android.R.drawable.checkbox_on_background)
            views.setInt(R.id.habit_card, "setBackgroundColor", Color.parseColor("#1A" + Integer.toHexString(color).substring(2)))
        } else {
            views.setTextColor(R.id.habit_name, Color.WHITE)
            views.setViewVisibility(R.id.emotion_container, View.VISIBLE)
            views.setImageViewResource(R.id.habit_icon, android.R.drawable.ic_menu_help)
            views.setInt(R.id.habit_card, "setBackgroundColor", Color.parseColor("#0A0A0A"))
            
            // Setup click intents for emotions
            setupEmotionClick(views, habit, 1, R.id.btn_meh)
            setupEmotionClick(views, habit, 2, R.id.btn_fine)
            setupEmotionClick(views, habit, 3, R.id.btn_crushed)
        }

        return views
    }

    private fun setupEmotionClick(views: RemoteViews, habit: JSONObject, emotion: Int, viewId: Int) {
        val habitId = habit.getInt("habitId")
        val habitTimeId = habit.getInt("habitTimeId")
        
        val fillInIntent = Intent().apply {
            data = Uri.parse("compound://log_habit?habitId=$habitId&habitTimeId=$habitTimeId&emotion=$emotion")
        }
        views.setOnClickFillInIntent(viewId, fillInIntent)
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}
