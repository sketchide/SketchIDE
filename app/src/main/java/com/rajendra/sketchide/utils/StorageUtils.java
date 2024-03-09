package com.rajendra.sketchide.utils;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.core.content.ContextCompat;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Scoped storage implementation
 */
public class StorageUtils {

    public static void makeDirs(Context context, String relPath) {
        File file = new File(context.getExternalFilesDir(null), relPath);
        file.mkdirs();
    }

    public static void writeToFile(Context context, String filename, List<String> lines) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q &&
                ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            return;
        }

        Log.e("Storage Util", "SDK = " + Build.VERSION.SDK_INT);

//        if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED) {
        File file = new File(context.getExternalFilesDir(null), filename);

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        Log.e("Storage Util", file.getAbsolutePath());

        try (BufferedWriter fw = new BufferedWriter(new FileWriter(file))) {
            for (String line : lines) {
                fw.write(line + System.lineSeparator());
            }
            fw.flush();
        } catch (IOException e) {
            Log.e("writeToFile", e.getMessage());
        }
//        }
    }

    public static List<String> readFromFile(Context context, String filename) {
        List<String> result = new ArrayList<>();
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q &&
                ContextCompat.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            return result;
        }

//        if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED
//                || Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED_READ_ONLY) {
        File file = new File(context.getExternalFilesDir(null), filename);

        Log.e("Storage Util", file.getAbsolutePath());

        try (BufferedReader fr = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = fr.readLine()) != null) {
                result.add(line);
            }
        } catch (IOException e) {
            Log.e("writeToFile", e.getMessage());
        }
//        }
        return result;
    }

    public static void copyFile(InputStream from, OutputStream to) {
        try (BufferedInputStream bis = new BufferedInputStream(from);
             BufferedOutputStream bos = new BufferedOutputStream(to)) {
            byte[] buffer = new byte[1024];
            while (bis.read(buffer) > 0) {
                bos.write(buffer);
            }
        } catch (IOException e) {
            Log.e("COPY", e.getMessage());
        }
    }

}
