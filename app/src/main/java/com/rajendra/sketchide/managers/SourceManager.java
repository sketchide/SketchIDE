package com.rajendra.sketchide.managers;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Map;

/**
 * Work with files of a project source code
 */
public class SourceManager {

    public static final String DIR_PROJECTS = "projects";
    public static final String DIR_BACKUPS = "backups";
    public static final String DIR_SOURCE_JAVA = "app/src/main/java";

    private static String projectPackageName = "my.default";

    public static String getProjectPackageName() {
        return projectPackageName;
    }

    public static void setProjectPackageName(String projectPackageName) {
        SourceManager.projectPackageName = "/" + projectPackageName + "/";
    }

    // BACKUP OF PROJECT

    /**
     * Prepare and save source code of project
     *
     * @param id identifier
     */
    public static void saveProjectBackup(Context context, String id, String name) throws IOException {
        // prepare archive
        Path archive = packProject(id);

        // save
        saveToFile(context, archive);

        Log.i("SAVE PROJECT", new String(Files.readAllBytes(archive)));
    }

    /**
     * Save project archive to private storage area
     *
     * @param context of application
     * @param archive archive
     */
    public static void saveToFile(Context context, Path archive) throws IOException {
        Path destination = Paths.get(context.getFilesDir().getAbsolutePath(), archive.getFileName().toString());
        Files.copy(archive, destination);
    }

    /**
     * Pack all parts of project to archive
     *
     * @param id identifier
     * @return project archive
     */
    public static Path packProject(String id) throws IOException {
        //todo to pack project
        String destDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
        Path archive = Paths.get(destDir, DIR_BACKUPS, id + ".swp");
        Files.createFile(archive);

        // fixme implement real process
        Files.write(archive, "TEST".getBytes(StandardCharsets.UTF_8), StandardOpenOption.WRITE);

        return archive;
    }

    // UPDATE SOURCE OF PROJECT TO STORAGE

    // When user has changed something in any file
    //   you must put all strings from file
    //   to Map < file_path, strings_in_file >
    // Don't save any changes to file immediately!
    // Only after either left editor or press button "Save".

    /**
     * Save the source code of project
     *
     * @param id    identifier
     * @param parts Map < file_path, strings_in_file >
     */
    public static void saveSource(String id, Map<String, String[]> parts) throws IOException {
        String destDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
        for (Map.Entry<String, String[]> entry : parts.entrySet()) {
            Path path = Paths.get(destDir, DIR_PROJECTS, id, entry.getKey());
            Files.deleteIfExists(path);
            Files.createFile(path);
            for (String line : entry.getValue()) {
                Files.write(path, (line + "\n").getBytes(), StandardOpenOption.WRITE);
            }
        }
    }
}
