# 1. Gunakan base image PHP Apache versi 7.4
FROM php:7.4-apache

# 2. Aktifkan modul mod_rewrite Apache yang dibutuhkan oleh Mikhmon
RUN a2enmod rewrite

# 3. Ubah port default Apache ke port 10000 agar sesuai standar Render
RUN sed -i 's/Listen 80/Listen 10000/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# 4. Salin semua file dari folder mikhmonv3 ke direktori web server
COPY mikhmonv3/ /var/www/html/

# 5. Atur hak akses agar web server bisa menulis file konfigurasi
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 6. Buka akses port 10000
EXPOSE 10000

# 7. Jalankan Apache
CMD ["apache2-foreground"]