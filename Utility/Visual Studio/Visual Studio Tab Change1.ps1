# Get running Visual Studio instance
$vs = [Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.17.0")
 
while ($true) {
    $docs = $vs.Documents
    foreach ($doc in $docs) {
        $doc.Activate()
        Start-Sleep -Seconds 10
    }
}