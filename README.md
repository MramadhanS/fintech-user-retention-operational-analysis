# Fintech Operational Excellence: User Retention & Transaction Reliability

[![BigQuery](https://img.shields.io/badge/Database-Google%20BigQuery-blue?style=flat&logo=google-cloud)](https://cloud.google.com/bigquery)
[![Looker Studio](https://img.shields.io/badge/Visualization-Looker%20Studio-orange?style=flat&logo=google)](https://lookerstudio.google.com/)
[![Status](https://img.shields.io/badge/Project%20Status-Completed%20(Week%2012)-success)](https://github.com)

## 📌 1. Scenario & Context Business
PT Nusantara Digital Wallet merupakan platform e-wallet skala nasional yang tengah mengalami pertumbuhan pengguna (*user growth*) yang masif di berbagai daerah. Untuk mengendalikan kualitas layanan secara *end-to-end*, proyek analitik ini difokuskan pada tiga pilar operasional utama: **User Analytics**, **Merchant Development**, dan **Risk & Fraud Management**.

Proyek ini bertujuan untuk mengatasi kendala pelaporan operasional yang sebelumnya memakan waktu lebih dari 3 hari (*delay decision making*), mengidentifikasi pemicu kegagalan transaksi pembayaran (*transaction drop-off*), serta memetakan laju keaktifan pengguna baru dari bulan ke bulan menggunakan metode **Cohort Retention Analysis**.

---

## 📊 2. Interactive Dashboard Analytics
Seluruh visualisasi interaktif, metrik harian (*Daily GTV*), tren kegagalan sistem, dan filter segmentasi wilayah telah diintegrasikan ke dalam dashboard pusat berikut:

🔗 **[Akses Live Dashboard - Looker Studio](https://datastudio.google.com/reporting/a7ac1ba8-cd1e-4b4b-b778-d8ae3c88fda6)**

---

## 🛠️ 3. Core Technical Stack & Architecture
* **Data Warehouse:** Google BigQuery (Penyimpanan dan agregasi data historis mentah berskala besar: `dim_users`, `dim_merchants`, dan `fact_transactions` sebanyak 75.000 log baris).
* **Data Processing:** SQL Advanced (Menggunakan Common Table Expressions (CTE) dan SQL Window Functions).
* **Data Visualization:** Looker Studio (Dashboard interaktif dinamis dengan kontrol rentang waktu, wilayah, dan metode pembayaran).

---

## 📈 4. Key Performance Indicators (KPIs)
Berdasarkan hasil konsolidasi data analitik akhir, platform berhasil merekam performa operasional global sebagai berikut:
* **Total Pengguna Unik:** 2.500 User terverifikasi & tidak terverifikasi.
* **Gross Transaction Value (GTV):** Rp 18.806.850.895 (Delapan Belas Miliar Rupiah) dari seluruh transaksi sukses.
* **Volume Transaksi Sukses:** 67.610 Transaksi berhasil diselesaikan.
* **Tingkat Keberhasilan Sistem (Global Success Rate):** **90,2%** (67.610 Berhasil vs 7.390 Gagal dari total 75.000 beban transaksi masuk).

---

## 📑 5. SQL Implementation & Agregation Results

### A. Analisis Retensi Pengguna Bulanan (`v_cohort_retention`)
Menggunakan logika penyaringan ketat (*SQL Window Function*) untuk mengisolasi kelompok pengguna yang bertransaksi tepat di bulan pertama registrasi (Bulan 0):

| Bulan Registrasi (Cohort) | Total User Dasar | Bulan 0 | Bulan 1 | Bulan 2 | Bulan 3 | Bulan 4 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **November 2025** | 419 | 100% | 99,3% | 99,5% | 99,5% | 99,5% |
| **Desember 2025** | 423 | 100% | 100,0% | 100,0% | 100,0% | 100,0% |
| **Januari 2026** | 437 | 100% | 99,8% | 100,0% | 100,0% | 99,5% |
| **Februari 2026** | 439 | 100% | 100,0% | 100,0% | 99,8% | **0,0%** |
| **Maret 2026** | 478 | 100% | 100,0% | 99,8% | **0,0%** | 0,0% |

> 🚨 **Temuan Anomali Data Kritis:** Nilai retensi **0,0%** pada Cohort Februari (Bulan 4) dan Maret (Bulan 3) terjadi secara serentak di bulan Juni 2026. Ini mengindikasikan adanya **kegagalan pipa data (ETL/Data Ingestion Error)** pada server produksi khusus bulan Juni, bukan representasi perilaku alami hilangnya minat pengguna (*natural churn*).

### B. Performa Finansial Kategori Industri (`v_merchant_performance`)
Sektor retail digital didominasi oleh segmen **E-Commerce** yang menyumbang kontribusi GTV tertinggi, disusul oleh pemenuhan kebutuhan harian (*Groceries*):

| Kategori Industri | Total Transaksi Sukses | Gross Transaction Value (GTV) | Dana Promo Terbakar | Promo Burn Rate (%) |
| :--- | :---: | :---: | :---: | :---: |
| **E-Commerce** | 13.535 | **Rp 10.496.836.518** | Rp 317.434.000 | 3,0% |
| **Groceries** | 20.288 | **Rp 5.576.363.548** | Rp 169.283.300 | 3,0% |
| **Telco** | 14.961 | Rp 1.573.123.130 | Rp 47.958.000 | 3,0% |
| **F&B** | 8.049 | Rp 667.390.382 | Rp 19.622.700 | 2,9% |
| **Transportation**| 10.777 | Rp 493.137.317 | Rp 15.084.100 | 3,1% |

### C. Sebaran Pasar Geografis Teratas (`v_user_demographics`)
Penetrasi pasar luar Jawa mencatatkan performa bersaing ketat dengan kota metropolitan utama:
1. **Makassar:** Rp 3.414.216.915 GTV (Rata-rata usia user: 37 tahun)
2. **Jakarta:** Rp 3.197.260.978 GTV (Rata-rata usia user: 36 tahun)
3. **Surabaya:** Rp 3.190.644.778 GTV (Rata-rata usia user: 36 tahun)
4. **Palembang:** Rp 3.021.333.785 GTV (Rata-rata usia user: 37 tahun)

---

## 🔍 6. Operational Failure Diagnosis
Dari 7.390 log transaksi berstatus *Failed*, ditemukan tiga akar masalah utama yang berkontribusi secara seimbang terhadap *transaction drop-off*:
1. **Insufficient Balance (33,9% / 2.502 Kejadian):** Pengguna bertransaksi dengan saldo akun aplikasi yang kurang.
2. **OTP Verification Failed (33,2% / 2.455 Kejadian):** Gangguan teknis pengiriman atau kedaluwarsa kode verifikasi via SMS Gateway.
3. **System Timeout (32,9% / 2.433 Kejadian):** Keterlambatan waktu respons server internal (*core network latency*) pada jam sibuk harian.

---

## 💡 7. Actionable Recommendations for Stakeholders
1. **Efisiensi Anggaran Pemasaran via RFM:** Menghentikan *pembakaran* budget promo statis 3,0% secara merata di seluruh lini merchant. Alihkan subsidi dana ke strategi promosi bersasaran (*targeted cashback*) hanya untuk kelompok pengguna dengan keaktifan rendah guna mendongkrak retensi.
2. **Fitur "Auto-Topup Reminder":** Membuat integrasi *pop-up notification* instan saat pengguna menekan tombol pembayaran jika nilai transaksi melebihi saldo e-wallet yang tersedia guna menekan angka kegagalan akibat saldo kurang (*Insufficient Balance*).
3. **Migrasi Gerbang Otentikasi Keamanan:** Mengalihkan infrastruktur SMS gateway tradisional yang rentan *delay* ke protokol WhatsApp Business API atau sistem *In-App Biometric Verification* (Sidik jari/Face ID) untuk menekan angka kegagalan OTP hingga 0%.
4. **Audit Validasi Pipeline Data:** Melakukan koordinasi segera dengan tim *Data Engineer* untuk melakukan pengecekan ulang pada proses ETL pengisihan data transaksi bulan Juni 2026 demi memperbaiki anomali nilai retensi cohort.

---

## 👨‍💻 Author
**Muhammad Ramadhan Syaputra (Rama)**
