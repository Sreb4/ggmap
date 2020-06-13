

# Kutuphaneler ----

library(ggplot2)
library(dplyr)
library(sp) 
library(ggmap)

## Koordinat Veri Girisi----

turkiye_map <- readRDS("C:/Users/Selim/Documents/R Save/R Programlama ve İstatistiksel Analiz/data/tur_il.rds")

## Koordinatlari veri seti haline getirme

turkiye_map %>% 
  as_tibble()


## Egrileri ve noktalari ayri bir veri seti olarak tanimlama

turkiye_sinir <- fortify(turkiye_map)

## Turkiye grafigini ici dolu renkli cizdirme----

ggplot(turkiye_map) + 
  geom_polygon(aes(x = long, y = lat,group = group),color = "white",fill = "blue") +
  theme_void() + 
  coord_fixed()


## Mutluluk Veri seti girisi ----

mutluluk <- tibble(sehir = turkiye_map$NAME_1, 
                   puan  = sample(c(45:100),81,replace = TRUE))


id_sehir <- data.frame( id    = rownames(turkiye_map@data), 
                        sehir = turkiye_map$NAME_1) %>% 
  left_join(mutluluk, by = "sehir")


## Mutluluk haritasinda kullanilacak veri donusumu----

mutluluk_harita <- left_join(turkiye_sinir, id_sehir, by = "id")


## Mutluluk haritasini cizdirme----

ggplot(mutluluk_harita) +
  geom_polygon( aes( x = long, y = lat, group = group, fill = puan), color = "grey") +
  coord_map() +
  theme_void() + 
  labs(title = "Rasgele Sayılardan Üretilen Türkiye Mutluluk Haritası",
       caption = "@Baki SELİM ") +
  scale_fill_distiller(name = "Mutluluk İndeksi",
                       palette = "Spectral", 
                       limits = c(0,100), 
                       na.value = "white") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))


