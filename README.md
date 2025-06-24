# Campaign-Performance-Analysis-And-Automation-Dashboard

# Campaign Performance Analysis And Automation Dashboard

**This is a real-world business analytics project** designed for **1800remodel.com**, a US-based home remodeling company. The goal was to analyze campaign performance data, automate reporting through SQL & Power BI, and uncover actionable marketing insights.

---

<img width="879" alt="Image" src="https://github.com/user-attachments/assets/c94228ae-8ce5-47df-bbd1-6f3e1cec6916" />

**Power Bi Dashboard** [View Live Dashboard](https://app.powerbi.com/view?r=eyJrIjoiZjhiOGI0MzgtZTVjNi00MzgxLWFmODItZDE3YTNiZjVlNTAyIiwidCI6IjUyZjdkNjFhLTEyZmYtNDU3Ni04YjZhLWI0MDg1Y2ZmMzczZCIsImMiOjEwfQ%3D%3D)

**Document** [Walkthrough report](https://github.com/AbuSufian-org/campaign-performance-analysis-and-automation-1800remodel/blob/main/campaign-performance-1800remodel/Report/CampaignPerformance.pdf)

## Business Problem

> 1800Remodel.com runs multiple digital marketing campaigns, but lacks a clear system to:

- Monitor campaign-wise **profitability** and **conversion**
- Identify **underperforming campaigns** costing revenue
- Detect **monthly performance patterns**
- Automate performance reports without manual SQL queries

---

## Project Goals

- Identify top-performing and underperforming campaigns  
- Track conversion, error, and ping success rates over time  
- Provide monthly and campaign-based profitability analysis  
- Build **automated SQL views + Power BI dashboard**  
- Enable decision-makers to **act quickly using real-time insights**

---

## Data Source

- Source: Internal campaign data (scraped from backend)
- Period: March 2024 – January 2025
- Format: `.csv` → imported to MySQL via `LOAD DATA INFILE`
- Columns: `Leads`, `Gross_Profit`, `Ping_Success`, `Errors`, `Conversion`, etc.

---

## Tools & Technologies Used

| Tool         | Purpose                                                  |
|--------------|----------------------------------------------------------|
| **MySQL**    | Data import, cleaning, KPI queries, stored procedures    |
| **Power BI** | Dashboard development, visualization, DAX calculations   |
| **Excel**    | Initial formatting of raw CSV                            |
| **SQL Triggers & Procedures** | To automate monthly master table updates |

---

## Solution Highlights

### SQL Automation

- Created schema: `campaign_performance`
- Developed 14+ KPI queries, including:
  - Total Gross Profit by Campaign
  - Conversion Rate, Ping Success Rate, Error Rate
  - Monthly trends & top/bottom campaign filters

- Created master tables:
  - `campaign_best_master` (for campaign-level KPIs)
  - `monthly_best_master` (for month-level KPIs)

- Added `Stored Procedure: update_campaign_master()`  
  → So, no need to write new queries every time!

---

### Power BI Dashboard Features

- Total Gross Profit by Campaign (bar chart)
- Success vs Error Rate comparison (bubble chart)
- Monthly Trend of Profit, Acceptance, Ping Success (line chart)
- Top 5 vs Bottom 5 Campaign Insights
- Profit vs Conversion comparison
- Cards for Key Metrics: Total Leads, Gross Profit, Highest Month

_Sample Visuals_:
- [x] Top 5 Campaign Profit
- [x] Campaign-wise Conversion & Error Rate
- [x] Monthly Acceptance & Ping Success Rate
- [x] ROI Trend by Month

---

## Key Business Insights

- **Roofing** had the highest profit ($11.69K) despite lower conversion
- **Plumbing** had a higher conversion rate but lower profit
- Underperformers: **Mvaid**, **Medicare**, **Auto**, **Home**
- Highest profit month: **June ($4,546)**  
- Lowest profit month: **December ($1,956)**
- Ping success rate & acceptance rate dropped sharply in September & October

---

## Recommendations & Business Actions

-**Boost Roofing Campaign:**
Highest profit ($11.7K) despite low conversion → Scale budget & improve targeting.

-**Pause or Optimize Low Performers:**
Mvaid, Medicare, Auto showing low profit & high error → Reassess or pause.

-**Investigate Sept–Oct Drop:**
Acceptance & ping success rates dropped → Check lead quality or tech issues.

-**Run Key Campaigns in June & Jan:**
Peak months for profit → Align promotions accordingly.

-**Maintain SQL + Power BI Automation:**
Efficient workflow → Just update the campaign_performance table monthly.

-**Future Improvements:**
Add CPC, channel metrics, customer feedback, and real-time alerts in Power BI.


## Project Structure

📁 campaign-performance-1800remodel/

├── SQL/
- campaign_analysis_and_automation.sql

├── assets/
- Dashboard_Screenshot.pdf

├── Report/
- CampaignPerformance.pdf

├── README.md
- PowerBI/ Dashboard link

