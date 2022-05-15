$targets = Get-Item ".\jobs\*.cocomake";
foreach ($t in $targets) {
    python util\cocomake.py $t;
}