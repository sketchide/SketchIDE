package com.rajendra.sketchide.activities

import android.Manifest.permission
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.elevation.SurfaceColors
import com.rajendra.sketchide.R.string
import com.rajendra.sketchide.utils.Utils
import kotlin.system.exitProcess

open class BaseActivity : AppCompatActivity() {

  private val permissionLauncher =
    registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
      if (Utils.isPermissionGranted(this).not()) showPermissionDialog()
    }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    window.statusBarColor = SurfaceColors.SURFACE_0.getColor(this)
    if (Utils.isPermissionGranted(this).not()) showPermissionDialog()
  }

  private fun showPermissionDialog() {
    MaterialAlertDialogBuilder(this)
      .setCancelable(false)
      .setTitle(string.file_access_title)
      .setMessage(string.file_access_message)
      .setPositiveButton(string.grant_permission) { _, _ ->
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
          val uri = Uri.parse("package:$packageName")
          permissionLauncher.launch(
            Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION, uri)
          )
        } else {
          ActivityCompat.requestPermissions(
            this,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
              arrayOf(permission.MANAGE_EXTERNAL_STORAGE)
            } else arrayOf(
              permission.READ_EXTERNAL_STORAGE,
              permission.WRITE_EXTERNAL_STORAGE
            ), PERMISSION_CODE
          )
        }
      }
      .setNegativeButton(string.exit) { _, _ ->
        finishAffinity()
        exitProcess(0)
      }
      .show()
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (requestCode == PERMISSION_CODE) {
      if (Utils.isPermissionGranted(this).not()) showPermissionDialog()
    }
  }

  companion object {
    const val PERMISSION_CODE = 3333
  }
}