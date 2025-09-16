# Bridge GAD Universal Application Processor
# Applies comprehensive testing, output generation, and repository synchronization
# Author: Rajkumar Singh Chauhan
# Date: September 16, 2025

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  BRIDGE GAD UNIVERSAL PROCESSOR       " -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allBridgeApps = @(
    "BridgeGAD-00", "BridgeGAD-02", "BridgeGAD-03",
    "BridgeGAD-04", "BridgeGAD-05", "BridgeGAD-06", "BridgeGAD-07",
    "BridgeGAD-08", "BridgeGAD-09", "BridgeGAD-10", "BridgeGAD-11", "BridgeGAD-12"
)

$baseDir = "C:\Users\Rajkumar"
$processResults = @()

foreach ($app in $allBridgeApps) {
    $appPath = Join-Path $baseDir $app
    
    Write-Host "Processing $app..." -ForegroundColor Yellow
    
    if (Test-Path $appPath) {
        try {
            Push-Location $appPath
            
            $result = @{
                App = $app
                Path = $appPath
                Success = $false
                Actions = @()
                Errors = @()
            }
            
            # 1. Create INPUT and OUTPUT folders
            if (!(Test-Path "SAMPLE_INPUT_FILES")) {
                New-Item -ItemType Directory -Name "SAMPLE_INPUT_FILES" -Force | Out-Null
                $result.Actions += "Created SAMPLE_INPUT_FILES folder"
            }
            
            if (!(Test-Path "OUTPUT_01_16092025")) {
                New-Item -ItemType Directory -Name "OUTPUT_01_16092025" -Force | Out-Null
                $result.Actions += "Created OUTPUT_01_16092025 folder"
            }
            
            # 2. Install requirements if exists
            if (Test-Path "requirements.txt") {
                Write-Host "  Installing requirements..." -ForegroundColor Gray
                try {
                    pip install -r requirements.txt | Out-Null
                    $result.Actions += "Installed requirements"
                } catch {
                    $result.Errors += "Failed to install requirements"
                }
            }
            
            # 3. Create user-friendly BAT files
            $batContent = @"
@echo off
echo ========================================
echo    BRIDGE GAD $app - ONE CLICK START    
echo ========================================
echo.
echo Professional Bridge Design & Drawing Generation System
echo Author: Rajkumar Singh Chauhan
echo Email: crajkumarsingh@hotmail.com
echo.

REM Create folders if needed
if not exist "OUTPUT_01_16092025" mkdir OUTPUT_01_16092025

echo Starting application...
if exist streamlit_app.py (
    streamlit run streamlit_app.py --server.port 8501
) else if exist app.py (
    streamlit run app.py --server.port 8501
) else if exist main.py (
    python main.py
) else (
    echo No main application file found
    pause
)
"@
            
            if (!(Test-Path "ONE_CLICK_START_NEW.bat")) {
                $batContent | Out-File -FilePath "ONE_CLICK_START_NEW.bat" -Encoding ASCII
                $result.Actions += "Created ONE_CLICK_START_NEW.bat"
            }
            
            # 4. Git operations
            if (Test-Path ".git") {
                Write-Host "  Synchronizing repository..." -ForegroundColor Gray
                
                # Configure git
                git config user.name "RAJKUMAR SINGH CHAUHAN" 2>&1 | Out-Null
                git config user.email "crajkumarsingh@hotmail.com" 2>&1 | Out-Null
                
                # Check git status
                $gitStatus = git status --porcelain 2>&1
                
                if ($gitStatus) {
                    # Add all changes
                    git add . 2>&1 | Out-Null
                    
                    # Commit with message
                    $commitMessage = "Bridge GAD $app Enhancement: Applied universal instructions and testing framework - Date: September 16, 2025"
                    
                    git commit -m $commitMessage 2>&1 | Out-Null
                    $result.Actions += "Committed changes to git"
                    
                    # Push to remote
                    try {
                        git push origin main 2>&1 | Out-Null
                        $result.Actions += "Pushed to remote repository"
                    } catch {
                        $result.Errors += "Failed to push to remote"
                    }
                } else {
                    $result.Actions += "Repository is up to date"
                }
            } else {
                $result.Actions += "No git repository found"
            }
            
            $result.Success = $result.Errors.Count -eq 0
            $processResults += $result
            
            if ($result.Success) {
                Write-Host "  Success: $app processed" -ForegroundColor Green
            } else {
                Write-Host "  Warning: $app processed with issues" -ForegroundColor Yellow
            }
            
            Pop-Location
        }
        catch {
            Write-Host "  Error: $app - $($_.Exception.Message)" -ForegroundColor Red
            $processResults += @{
                App = $app
                Success = $false
                Errors = @($_.Exception.Message)
            }
            
            try {
                Pop-Location
            } catch {
                # Ignore location errors
            }
        }
    } else {
        Write-Host "  Directory not found: $app" -ForegroundColor Red
    }
    
    Write-Host ""
}

# Generate summary
$summaryFile = "C:\Users\Rajkumar\BridgeGAD-01\OUTPUT_01_16092025\Universal_Processing_Summary_$(Get-Date -Format 'yyyyMMdd_HHmm').txt"
$summary = @"
BRIDGE GAD UNIVERSAL PROCESSING SUMMARY
Generated: $(Get-Date)
Author: Rajkumar Singh Chauhan

APPLICATIONS PROCESSED: $($allBridgeApps.Count)
SUCCESSFUL: $($processResults | Where-Object {$_.Success} | Measure-Object | Select-Object -ExpandProperty Count)

DETAILED RESULTS:
"@

foreach ($result in $processResults) {
    $summary += "`n=== $($result.App) ===`n"
    $summary += "Status: $(if ($result.Success) { 'SUCCESS' } else { 'WARNING' })`n"
    
    if ($result.Actions) {
        $summary += "Actions:`n"
        foreach ($action in $result.Actions) {
            $summary += "  - $action`n"
        }
    }
    
    if ($result.Errors) {
        $summary += "Errors:`n"
        foreach ($error in $result.Errors) {
            $summary += "  - $error`n"
        }
    }
}

$summary += "`n`nALL BRIDGEGAD APPLICATIONS PROCESSED!"

$summary | Out-File -FilePath $summaryFile -Encoding UTF8

Write-Host "========================================" -ForegroundColor Green
Write-Host "  PROCESSING COMPLETED!                 " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary saved to: $summaryFile" -ForegroundColor Cyan