package com.example.compound

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class CompoundWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val views = RemoteViews(context.packageName, R.layout.compound_widget)

        // Setup the list view
        val intent = Intent(context, HabitListService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        views.setRemoteAdapter(R.id.habit_list, intent)
        views.setEmptyView(R.id.habit_list, R.id.widget_title) // Simple fallback

        // Setup item click intent
        val clickIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("compound://log_habit")
        )
        views.setPendingIntentTemplate(R.id.habit_list, clickIntent)

        // App launch intent
        val launchIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java
        )
        views.setOnClickPendingIntent(R.id.widget_title, launchIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
        appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.habit_list)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(intent.component)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.habit_list)
        }
    }
}
