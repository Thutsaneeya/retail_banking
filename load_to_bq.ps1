# --- Configuration ---
$DATASET = "retail_banking_raw"
$LOCATION = "asia-southeast1" # Optimized for Southeast Asia (Singapore)
$TABLES = @("account_transactions", "bank_accounts", "customer_profiles", "transaction_codes")

Write-Host "`n=== Starting Retail Banking Load to BigQuery  ===" -ForegroundColor Cyan

# --- Step 1: Create the Dataset ---
Write-Host "`n[1/3] Checking Dataset..." -ForegroundColor Yellow
# Try to create the dataset. 2>$null ignores the error if it already exists.
bq mk --dataset --location=$LOCATION $DATASET 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Dataset already exists or was created previously." -ForegroundColor Gray
} else {
    Write-Host "Dataset '$DATASET' created successfully in $LOCATION." -ForegroundColor Green
}

Write-Host "`n[2/3] Loading Local CSV files to BigQuery..." -ForegroundColor Yellow

# --- Step 2: Load CSVs from Laptop ---
$CURRENT_DIR = Get-Location

# foreach ($table in $TABLES) {
#     # Get path
#     $csvFile = "$CURRENT_DIR\data\$table.csv"
    
#     if (Test-Path $csvFile) {
#         Write-Host "Loading $table.csv..." -ForegroundColor White
#         # --autodetect finds the columns automatically
#         # --replace overwrites the table if it already exists
#         # --skip_leading_rows=1 to ensure the first line is treated as column names
#         bq load --autodetect --skip_leading_rows=1 --replace --source_format=CSV "$DATASET.$table" "$csvFile"
#         # bq load --autodetect --replace --source_format=CSV "$DATASET.$table" "$csvFile"
#     } else {
#         Write-Host "Warning: File not found at $csvFile. Skipping..." -ForegroundColor Red
#     }
# }
foreach ($table in $TABLES) {
    $csvFile = "$CURRENT_DIR\data\$table.csv"
    
    if (Test-Path $csvFile) {
        Write-Host "Loading $table.csv..." -ForegroundColor White
        
        # This exact combination handles headers and quoted values correctly
        bq load --autodetect --skip_leading_rows=1 --replace --quote='"' --source_format=CSV "$DATASET.$table" "$csvFile"
        
    } else {
        Write-Host "Warning: File not found at $csvFile. Skipping..." -ForegroundColor Red
    }
}

Write-Host "[3/3] All files have been successfully uploaded to BigQuery Sandbox!" -ForegroundColor Green
Write-Host "Loading files from local laptop to BigQuery Sandbox..." -ForegroundColor Cyan

# Load each file
# bq load --autodetect --source_format=CSV "$DATASET.account_transactions" data\account_transactions.csv
# bq load --autodetect --source_format=CSV "$DATASET.bank_accounts" data\bank_accounts.csv
# bq load --autodetect --source_format=CSV "$DATASET.customer_profiles" data\customer_profiles.csv
# bq load --autodetect --source_format=CSV "$DATASET.transaction_codes" data\transaction_codes.csv

# Write-Host "All files have been successfully uploaded to BigQuery Sandbox!" -ForegroundColor Green
# bq query --use_legacy_sql=false "CREATE OR REPLACE TABLE ${DATASET}.summary AS SELECT customer_id, SUM(amount) as total FROM ${DATASET}.account_transactions GROUP BY 1"


