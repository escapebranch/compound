package com.example.compound

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
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

        // Setup item click intent template MUST be mutable for fillInIntent to work
        val templateIntent = Intent(context, es.antonborri.home_widget.HomeWidgetBackgroundReceiver::class.java)
        val flags = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val clickIntent = PendingIntent.getBroadcast(context, 0, templateIntent, flags)
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
            var appWidgetIds = intent.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS)
            if (appWidgetIds == null || appWidgetIds.isEmpty()) {
                val component = android.content.ComponentName(context, CompoundWidgetProvider::class.java)
                appWidgetIds = appWidgetManager.getAppWidgetIds(component)
            }
            if (appWidgetIds != null && appWidgetIds.isNotEmpty()) {
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.habit_list)
            }
        }
    }
}
