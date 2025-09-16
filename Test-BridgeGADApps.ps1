# Bridge GAD Applications Testing Script
# Author: Rajkumar Singh Chauhan
# Date: September 16, 2025

param(
    [string]$TestMode = "All"  # All, Quick, Individual
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  BRIDGE GAD APPLICATIONS TESTER       " -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$bridgeApps = @(
    "BridgeGAD-00", "BridgeGAD-01", "BridgeGAD-02", "BridgeGAD-03",
    "BridgeGAD-04", "BridgeGAD-05", "BridgeGAD-06", "BridgeGAD-07",
    "BridgeGAD-08", "BridgeGAD-09", "BridgeGAD-10", "BridgeGAD-11", "BridgeGAD-12"
)

$baseDir = "C:\Users\Rajkumar"
$outputDir = "C:\Users\Rajkumar\BridgeGAD-01\OUTPUT_01_16092025"
$testResults = @()

foreach ($app in $bridgeApps) {
    $appPath = Join-Path $baseDir $app
    
    Write-Host "Testing $app..." -ForegroundColor Yellow
    
    if (Test-Path $appPath) {
        $result = @{
            App = $app
            Path = $appPath
            Exists = $true
            HasRequirements = $false
            HasMainApp = $false
            HasStreamlit = $false
            CanRun = $false
            TestOutput = ""
        }
        
        # Check for requirements.txt
        if (Test-Path (Join-Path $appPath "requirements.txt")) {
            $result.HasRequirements = $true
        }
        
        # Check for main app files
        $mainFiles = @("app.py", "streamlit_app.py", "main.py", "enhanced_bridge_app.py")
        foreach ($file in $mainFiles) {
            if (Test-Path (Join-Path $appPath $file)) {
                $result.HasMainApp = $true
                $result.MainFile = $file
                break
            }
        }
        
        # Check for streamlit files
        $streamlitFiles = Get-ChildItem $appPath -Filter "*streamlit*" -File
        if ($streamlitFiles.Count -gt 0) {
            $result.HasStreamlit = $true
        }
        
        # Attempt to run a test
        try {
            Push-Location $appPath
            
            if ($result.HasRequirements) {
                Write-Host "  Installing requirements..." -ForegroundColor Gray
                pip install -r requirements.txt *>$null
            }
            
            if ($result.HasMainApp) {
                Write-Host "  Testing main application..." -ForegroundColor Gray
                $testCommand = "python " + $result.MainFile + " --help"
                $output = Invoke-Expression $testCommand 2>&1
                $result.TestOutput = $output -join "`n"
                $result.CanRun = $true
            }
            
            Pop-Location
        }
        catch {
            $result.TestOutput = $_.Exception.Message
            Pop-Location
        }
        
        $testResults += $result
        
        if ($result.CanRun) {
            Write-Host "  ✅ $app - Working" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $app - Issues detected" -ForegroundColor Red
        }
    } else {
        Write-Host "  ❌ $app - Not found" -ForegroundColor Red
        $testResults += @{
            App = $app
            Path = $appPath
            Exists = $false
            CanRun = $false
        }
    }
    
    Write-Host ""
}

# Generate summary report
$summaryFile = Join-Path $outputDir "BridgeGAD_Test_Summary_$(Get-Date -Format 'yyyyMMdd_HHmm').txt"
$summary = @"
BRIDGE GAD APPLICATIONS TEST SUMMARY
Generated: $(Get-Date)
Author: Rajkumar Singh Chauhan

APPLICATIONS TESTED: $($bridgeApps.Count)
WORKING APPLICATIONS: $($testResults | Where-Object {$_.CanRun} | Measure-Object | Select-Object -ExpandProperty Count)

DETAILED RESULTS:
"@

foreach ($result in $testResults) {
    $summary += "`n"
    $summary += "App: $($result.App)`n"
    $summary += "  Exists: $($result.Exists)`n"
    if ($result.Exists) {
        $summary += "  Has Requirements: $($result.HasRequirements)`n"
        $summary += "  Has Main App: $($result.HasMainApp)`n"
        $summary += "  Has Streamlit: $($result.HasStreamlit)`n"
        $summary += "  Can Run: $($result.CanRun)`n"
        if ($result.MainFile) {
            $summary += "  Main File: $($result.MainFile)`n"
        }
        if ($result.TestOutput) {
            $summary += "  Test Output: $($result.TestOutput)`n"
        }
    }
    $summary += "`n"
}

$summary | Out-File -FilePath $summaryFile -Encoding UTF8

Write-Host "Test Summary saved to: $summaryFile" -ForegroundColor Cyan
Write-Host "Testing completed!" -ForegroundColor Green