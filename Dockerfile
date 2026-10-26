# 1. Gunakan base image resmi PHP dengan Apache yang ringan
FROM php:7.4-apache

# 2. Install ekstensi PHP yang dibutuhkan Mikhmon (jika diperlukan) dan aktifkan mod_rewrite
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    && docker-php-ext-install session \
    && a2enmod rewrite

# 3. Ubah port default Apache dari 80 ke 10000 (karena Render mewajibkan port di atas 1024 untuk non-root)
RUN sed -i 's/Listen 80/Listen 10000/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# 4. Salin seluruh source code Mikhmon dari folder lokal ke direktori web server di dalam container
COPY mikhmonv3/ /var/www/html/

# 5. Berikan hak akses (permission) agar web server bisa menulis file (penting untuk simpan session/konfigurasi router)
RUN chown -r www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 6. Buka port 10000 agar bisa diakses dari luar oleh Render
EXPOSE 10000

# 7. Jalankan Apache di latar depan (foreground)
CMD ["apache2-foreground"]
