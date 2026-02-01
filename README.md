## Project Overview
This project focuses on the Cleaning, Normalization, and Imputation of a messy real estate dataset using MySQL. The goal was to take raw, unstructured housing records and transform them to be ready for accurate market appraisal and analysis.

## Key Technical Challenges Addressed

-**Data Imputation via Self-Joins:** Developed logic to populate missing property addresses by cross-referencing records with matching Parcel IDs.
-**Advanced String Parsing:** Utilized SUBSTRING_INDEX and LOCATE to decompose complex address strings into atomic attributes (Street, City, State).
-**Semantic Standardization:** Normalized categorical fields (e.g., converting "Y/N" to "Yes/No") to ensure consistency for downstream BI tools.
-**Schema Optimization:** Transferred raw data into optimized VARCHAR schemas and established an audit-friendly workflow.
