package com.example.compound

import android.content.Intent
import android.widget.RemoteViewsService

class HabitListService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return HabitListFactory(this.applicationContext)
    }
}
