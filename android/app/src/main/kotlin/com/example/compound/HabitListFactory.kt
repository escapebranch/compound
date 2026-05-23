package com.example.compound

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class HabitListFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private var habits: JSONArray = JSONArray()

    override fun onCreate() {
        Log.d("CompoundWidget", "Factory onCreate")
    }

    override fun onDataSetChanged() {
        Log.d("CompoundWidget", "Factory onDataSetChanged")
        try {
            val prefs = HomeWidgetPlugin.getData(context)
            val jsonString = prefs.getString("timeline_data", "[]")
            Log.d("CompoundWidget", "Data loaded: $jsonString")
            habits = JSONArray(jsonString)
        } catch (e: Exception) {
            Log.e("CompoundWidget", "Error loading data", e)
            habits = JSONArray()
        }
    }

    override fun onDestroy() {}

    override fun getCount(): Int = habits.length()

    override fun getViewAt(position: Int): RemoteViews {
        Log.d("CompoundWidget", "getViewAt: $position")
        if (position >= habits.length()) {
            return RemoteViews(context.packageName, R.layout.habit_item)
        }

        val views = RemoteViews(context.packageName, R.layout.habit_item)
        try {
            val habit = habits.getJSONObject(position)

            val name = habit.optString("name", "Unknown")
            val startHour = habit.optInt("startHour", 0)
            val startMinute = habit.optInt("startMinute", 0)
            val endHour = habit.optInt("endHour", 0)
            val endMinute = habit.optInt("endMinute", 0)
            val isCompleted = habit.optBoolean("isCompleted", false)
            val emotion = if (habit.has("emotion") && !habit.isNull("emotion")) habit.getInt("emotion") else null

            views.setTextViewText(R.id.habit_name, name)
            views.setTextViewText(R.id.habit_time, String.format("%02d:%02d", startHour, startMinute))
            views.setTextViewText(R.id.habit_duration, String.format("%02d:%02d - %02d:%02d", startHour, startMinute, endHour, endMinute))

            if (isCompleted) {
                val colorStr = when (emotion) {
                    1 -> "#FF6B00"
                    2 -> "#FFD600"
                    3 -> "#00E676"
                    else -> "#FFFFFF"
                }
                val color = Color.parseColor(colorStr)
                views.setTextColor(R.id.habit_name, color)
                views.setViewVisibility(R.id.emotion_container, View.GONE)
                views.setImageViewResource(R.id.habit_icon, android.R.drawable.checkbox_on_background)
                
                // Set background color with transparency
                val hexColor = String.format("%06X", (0xFFFFFF and color))
                views.setInt(R.id.habit_card, "setBackgroundColor", Color.parseColor("#1A$hexColor"))
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
        } catch (e: Exception) {
            Log.e("CompoundWidget", "Error in getViewAt", e)
            views.setTextViewText(R.id.habit_name, "Error")
        }

        return views
    }

    private fun setupEmotionClick(views: RemoteViews, habit: JSONObject, emotion: Int, viewId: Int) {
        val habitId = habit.optInt("habitId", -1)
        val habitTimeId = habit.optInt("habitTimeId", -1)
        
        if (habitId != -1) {
            val fillInIntent = Intent().apply {
                data = Uri.parse("compound://log_habit?habitId=$habitId&habitTimeId=$habitTimeId&emotion=$emotion")
            }
            views.setOnClickFillInIntent(viewId, fillInIntent)
        }
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}
