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
    private static final String urlGarfield = "https://garfield.com/uploads/strips/%s.jpg";

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
        return String.format(urlGarfield, date.format(formatter));
    }

    public String getStripUrl(LocalDate date) {
        String result = null;
        result = this.createUrl(date);
        if(result == null) {
            throw new GarfieldException();
        }
        return result;
    }
}
