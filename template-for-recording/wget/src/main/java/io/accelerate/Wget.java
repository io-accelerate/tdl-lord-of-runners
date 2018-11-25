package io.accelerate;

import java.io.*;
import java.net.*;
import java.util.*;

public class Wget {

    public static final String FILE_DOWNLOAD_ALREADY_COMPLETED = "File Download already completed.";

    public static void main(String[] args) {
//        try {
//            final String appDir = new File(".").getCanonicalPath();
//            System.out.println("app appDir = " + appDir);
//            System.setProperty("java.library.path", appDir + "/");
//            System.out.println("java.library.path = " + System.getProperty("java.library.path"));
//        } catch (Exception ex) {
//            System.out.println("Error occurred trying to retrieve app directory or setting java.library.path: " + ex.getMessage());
//        }

        if ((args != null) && (args.length > 0)) {
            String url = args[0];
            String targetFilename = args[1];

            System.out.format("Downloading %s from %s%n", targetFilename, url);
            try {
                Wget.downloadFileWithResume(url, targetFilename);
            } catch (Exception ex) {
                if (ex.getMessage().contains(FILE_DOWNLOAD_ALREADY_COMPLETED)) {
                    System.out.println(ex.getMessage());
                } else {
                    System.out.println("Could not download file successfully due to an error, error message: " + ex.getMessage());
                }
            }
        } else {
            System.out.println("No parameters passed in.");
            System.out.println("Usage: ");
            System.out.println(" Wget [url] [targetFilename]");
        }
    }

    public static long downloadFile(String downloadUrl, String saveAsFileName) throws IOException, URISyntaxException {

        File outputFile = new File(saveAsFileName);
        URLConnection downloadFileConnection = new URI(downloadUrl).toURL()
                .openConnection();
        return transferDataAndGetBytesDownloaded(downloadFileConnection, outputFile);
    }

    private static long transferDataAndGetBytesDownloaded(URLConnection downloadFileConnection, File outputFile) throws IOException {

        long bytesDownloaded = 0;
        try (InputStream is = downloadFileConnection.getInputStream(); OutputStream os = new FileOutputStream(outputFile, true)) {

            byte[] buffer = new byte[1024];

            int bytesCount;
            while ((bytesCount = is.read(buffer)) > 0) {
                os.write(buffer, 0, bytesCount);
                bytesDownloaded += bytesCount;
                String progressStatus = String.format(" Downloading bytes %d, total downloaded bytes: %d\b\r", bytesCount, bytesDownloaded);
                System.out.print(progressStatus);
            }
        }
        return bytesDownloaded;
    }

    public static long downloadFileWithResume(String downloadUrl, String saveAsFileName) throws IOException, URISyntaxException {
        File outputFile = new File(saveAsFileName);

        URLConnection downloadFileConnection = addFileResumeFunctionality(downloadUrl, outputFile);
        return transferDataAndGetBytesDownloaded(downloadFileConnection, outputFile);
    }

    private static URLConnection addFileResumeFunctionality(String downloadUrl, File outputFile) throws IOException, URISyntaxException, ProtocolException, ProtocolException {
        long existingFileSize = 0L;
        URLConnection downloadFileConnection = new URI(downloadUrl).toURL()
                .openConnection();

        if (outputFile.exists() && downloadFileConnection instanceof HttpURLConnection) {
            HttpURLConnection httpFileConnection = (HttpURLConnection) downloadFileConnection;

            HttpURLConnection tmpFileConn = (HttpURLConnection) new URI(downloadUrl).toURL()
                    .openConnection();
            tmpFileConn.setRequestMethod("HEAD");
            long fileLength = tmpFileConn.getContentLengthLong();
            existingFileSize = outputFile.length();

            if (existingFileSize < fileLength) {
                httpFileConnection.setRequestProperty("Range", "bytes=" + existingFileSize + "-" + fileLength);
            } else {
                throw new IOException(FILE_DOWNLOAD_ALREADY_COMPLETED);
            }
        }
        return downloadFileConnection;
    }
}
