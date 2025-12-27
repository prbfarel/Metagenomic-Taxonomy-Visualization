#Visualisasi Taksonomi Metagenom
#Author: Farel Immanuel
#Date: 15 December 2025

# 1. Setup Library & Font
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(showtext)) install.packages("showtext")
if(!require(RColorBrewer)) install.packages("RColorBrewer")
if(!require(ggplot2)) install.packages("ggplot2")

library(tidyverse)
library(showtext)
library(RColorBrewer)
library(ggplot2)

#Mengaktifkan Font Google (Montserrat)
showtext_auto()
font_add_google("Montserrat", "montserrat")

#Set working directory
setwd("C:/Users/farel/Documents/College/Tugas Akhir/R")

# 2. Fungsi Load Data
#Baca format tabular Kraken tanpa header
read_kraken_data <- function(filepath, sample_id) {
  df <- read.delim(filepath, header = FALSE, stringsAsFactors = FALSE)
  
  #Beri Nama kolom Kraken report
  # ket: p= percent, fc=fragments covered, fa=fragments assigned
  colnames(df) <- c("percent", "fragments_covered", "fragments_assigned", "rank", "taxid", "name")
  
  #Beri spasi di nama bakteri
  df$name <- trimws(df$name)
  df$sample <- sample_id
  
  return(df)
}

data_arb1 <- read_kraken_data("ARB1.tabular", "ARB1")
data_arb3 <- read_kraken_data("ARB3.tabular", "ARB3")
raw_data <- bind_rows(data_arb1, data_arb3)


# 3. Data Cleaning & Normalisasi
# Tahap A: Filter Taksa (Famili)
# Hanya mengambil baris yang rank-nya "F" (Famili)
# Membuang data "unclassified"
family_data <- raw_data %>%
  filter(rank == "F") %>%
  filter(name != "unclassified")

# Tahap B: Re-Normalisasi (Menghitung % baru)
# Logic : Persentase file asli dihitung dari total library (termasuk unclassified)
# Persentase yang divisualisasikan hanya berdasar total famili teridentifikasi
plot_data_normalized <- family_data %>%
  group_by(sample) %>%
  # Hitung total reads khusus family
  mutate(total_family_reads = sum(fragments_assigned)) %>%
  # Hitung Abundance Baru (Reads)
  mutate(rel_abundance = (fragments_assigned / total_family_reads) * 100) %>%
  ungroup()

# Tahap C: Memilih top 20 Famili dengan kelimpahan tertinggi
top_20_list <- plot_data_normalized %>%
  group_by(name) %>%
  summarise(mean_abundance = mean(rel_abundance)) %>%
  top_n(20, mean_abundance) %>%
  pull(name)

# Tahap D: Filter untuk Plotting
# Ambil data hasil normalisasi, buang famili yang tidak masuk top 20
final_plot_data <- plot_data_normalized %>%
  filter(name %in% top_20_list)

# 4. Setip Warna BarPlot
colors_20 <- c(brewer.pal(12, "Paired"), brewer.pal(8, "Dark2"))

# 5. Visualisasi (ggplot2)
p <- ggplot(final_plot_data, aes(x = sample, y = rel_abundance, fill = name)) +
  # Geom Col: membuat batang stacked
  geom_col(color = "white", width = 0.55, size = 0.2) +
  scale_fill_manual(values = colors_20) +
  theme_minimal(base_family = "montserrat") +
  # Label dan Judul
  
  labs(
    title = "Komposisi Komunitas Bakteri (Famili)",
    subtitle = "20 Famili dominan (Normalized by Classifidd Reads)",
    y = "Kelimpahan realtif (%)",
    x = NULL,
    fill = "Family"
  ) +
  
  # Kustomisasi Tema Detail
  theme(
    # Judul Plot
    plot.title = element_text(face = "bold", size = 16, margin = margin (b = 5)),
    plot.subtitle = element_text(size = 10, color = "grey40", margin = margin(b = 20)),
    
    # Grid & Sumbu
    panel.grid.major.x = element_blank(), # Hilangkan garis vertikal
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 11, color = "black"),
    axis.title.y = element_text(size = 11, margin = margin(r = 10)),
    
    # Legenda
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(face = "bold", size = 10),
    legend.key.size = unit(0.4, "cm"), # Ukuran kotak warna diperkecil
    legend.box.margin = margin(l = -5) #Rapatkan legenda ke plot
  )

# Print Bar Plot
print(p)




