#!/bin/bash

echo "download cdf packages from ftp server"
package_folder=builds/platform-dailyBuild/${cdf_release_name}
ftp -n << EOF
open 16.155.193.1
quote USER cmfshare
quote PASS cmfshare
cd $package_folder || exit 1
mget ITOM_Suite_Foundation_${cdf_version}.zip ITOM_Suite_Foundation_Upgrade_${cdf_version}.zip .|| exit 1
bye
EOF

echo "cdf packages download finished"
echo "sync cdf packages to aws s3"
aws s3 sync . s3://itsma-cdf-package/${cdf_release_name}/${cdf_version} --exclude '*' --include '*.zip'
