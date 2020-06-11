

# Kutuphaneler ----

library(tidyverse)
library(sp) 
library(mapproj)
library(ggmap)
library(DeducerSpatial)
library(maps)

## Koordinat Veri Girisi----

tur <- readRDS("C:/Users/Selim/Documents/R Save/R Programlama ve İstatistiksel Analiz/data/tur1.rds")

## Koordinatlari veri seti haline getirme

tur%>% 
  as_tibble()


## Egrileri ve noktalari ayri bir veri seti olarak tanimlama

tur_for <- fortify(tur)

## Turkiye grafigini ici dolu renkli cizdirme----

ggplot(tur) + 
  geom_polygon(aes(x = long, y = lat,group = group),color = "white",fill = "blue") +
  theme_void() + 
  coord_fixed()


## Mutluluk Veri seti girisi ----

mutluluk <- tibble(sehir = tur$NAME_1,
                   puan  = sample(c(45:100),81,replace = TRUE))


id_sehir <- data.frame( id    = rownames(tur@data), 
                        sehir = tur$NAME_1) %>% 
  left_join(mutluluk, by = "sehir")


## Mutluluk haritasinda kullanilacak veri donusumu----

mutluluk_harita <- left_join(tur_for, id_sehir, by = "id")


## Mutluluk haritasini cizdirme----

ggplot(mutluluk_harita) +
  geom_polygon( aes( x = long, y = lat, group = group, fill = puan), color = "grey") +
  coord_map() +
  theme_void() + 
  labs(title = "Rasgele Sayılardan Üretilen Türkiye Mutluluk Haritası",
       caption = "Kaynak:Baki SELİM ") +
  scale_fill_distiller(name = "Mutluluk İndeksi",
                       palette = "Spectral", 
                       limits = c(0,100), 
                       na.value = "white") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))


