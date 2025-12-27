# Metagenomic-Taxonomy-Visualization
R script to visualize Kraken2 metagenomic data using Stacked Barplot and Dumbbell Plot

Repository ini berisi skrip R untuk memvisualisasikan data hasil analisis taksonomi (Kraken2/Bracken) dari sampel metagenomik.

## Fitur
- Pembersihan data dan pembuangan reads "unclassified".
- Normalisasi ulang (Re-normalization) berdasarkan reads terklasifikasi.
- Visualisasi **Stacked Barplot** (Komposisi Komunitas).
- Visualisasi **Dumbbell Plot** (Perbandingan Kelimpahan Spesifik).

## Hasil Visualisasi
![Stacked Barplot](stacked_barplot_genus_final.png)
*(Pastikan Anda mengupload gambar hasil plot ke repo agar bisa ditampilkan di sini)*

## Cara Menggunakan
1. Siapkan file input format tabular (`.tabular` atau `.tsv`).
2. Jalankan script `script_name.R`.
