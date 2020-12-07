BEGIN {PRIMARY_EXPORT_SECTION=0}
/PrimaryExports%%/{PRIMARY_EXPORT_SECTION=1}
/^[^#]/ { 
    if (PRIMARY_EXPORT_SECTION) {
        print $9
    }   
}
/^%%/{PRIMARY_EXPORT_SECTION=0}
