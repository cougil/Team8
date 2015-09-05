package com.schibsted.hackathons.example.topquotes.services;

import com.schibsted.hackathons.example.topquotes.exceptions.GarfieldException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class GarfieldImageService {

    final String dateTimeFormatPattern = "yyyy-MM-dd";
    private static final String urlGarfield = "https://garfield.com/comic/";

    private String getImageUrl(String url) {
        String result = null;
        try {
            Document doc = Jsoup.connect(url).get();
            Elements element = doc.select(".img-responsive center-block");
            result = element.hasAttr("src") ?
                    element.attr("src")
                    : null;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    private String createUrl(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(dateTimeFormatPattern);
        return  urlGarfield + date.format(formatter);
    }

    public String getStripUrl(LocalDate date) {
        String result = null;
        String url = this.createUrl(date);
        result = this.getImageUrl(url);
        if(result == null) {
            throw new GarfieldException();
        }
        return result;
    }

    public static void main(String[] args) {

        GarfieldImageService gis = new GarfieldImageService();

        LocalDate ld = LocalDate.now();

        String img = gis.getStripUrl(ld);

        System.out.println(img);
    }
}
