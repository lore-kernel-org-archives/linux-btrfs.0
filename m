Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35963 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbcCHPAN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 10:00:13 -0500
Received: by mail-pa0-f50.google.com with SMTP id tt10so14271042pab.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Mar 2016 07:00:12 -0800 (PST)
Message-ID: <56dee8fb.9712620a.c80b2.ffffbce5@mx.google.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 8 Mar 2016 20:30:06 +0530
To: linux-btrfs@vger.kernel.org
Cc: lakshmipathi.g@giis.co.in
Subject: [PATCH][btrfs-progs] populate fs with small dataset for convert-tests
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/convert-tests.sh | 84 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 4 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 0bfb41f..c1f3de0 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -10,16 +10,91 @@ LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f $0))
 TOP=$(readlink -f $SCRIPT_DIR/../)
 RESULTS="$TOP/tests/convert-tests-results.txt"
+DATASET_SIZE="50" # how many files to create.
 
 source $TOP/tests/common
 
 rm -f $RESULTS
 
 setup_root_helper
-prepare_test_dev 256M
+prepare_test_dev 512M
 
 CHECKSUMTMP=$(mktemp --tmpdir btrfs-progs-convert.XXXXXXXXXX)
 
+generate_dataset() {
+
+	dataset_type="$1"
+	dirpath=$TEST_MNT/$dataset_type
+	mkdir -p $dirpath
+
+	case $dataset_type in
+		small)
+			for num in $(seq 1 $DATASET_SIZE);do
+				run_check $SUDO_HELPER dd if=/dev/urandom of=$dirpath/$dataset_type.$num bs=10K \
+				count=1 1>/dev/null 2>&1
+			done
+			;;
+
+		hardlink)
+			for num in $(seq 1 $DATASET_SIZE);do
+				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
+				run_check $SUDO_HELPER ln $dirpath/$dataset_type.$num $dirpath/hlink.$num
+			done
+			;;
+
+		symlink)
+			for num in $(seq 1 $DATASET_SIZE);do
+				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
+				run_check $SUDO_HELPER ln -s $dirpath/$dataset_type.$num $dirpath/slink.$num
+			done
+			;;
+
+		brokenlink)
+			for num in $(seq 1 $DATASET_SIZE);do
+				run_check $SUDO_HELPER ln -s $dirpath/$dataset_type.$num $dirpath/blink.$num
+			done
+			;;
+
+		perm)
+			for modes in $(seq 1 7777);do
+				if [[ "$modes" == *9* ]] || [[ "$modes" == *8* ]]
+				then
+					continue;
+				else
+					run_check $SUDO_HELPER touch $dirpath/$dataset_type.$modes
+					run_check $SUDO_HELPER chmod $modes $dirpath/$dataset_type.$modes
+				fi
+			done
+			;;
+
+		sparse)
+			for num in $(seq 1 $DATASET_SIZE);do
+				run_check $SUDO_HELPER dd if=/dev/urandom of=$dirpath/$dataset_type.$num bs=10K \
+				count=1 1>/dev/null 2>&1
+				run_check $SUDO_HELPER truncate -s 500K $dirpath/$dataset_type.$num
+				run_check $SUDO_HELPER dd if=/dev/urandom of=$dirpath/$dataset_type.$num bs=10K \
+				oflag=append conv=notrunc count=1 1>/dev/null 2>&1
+				run_check $SUDO_HELPER truncate -s 800K $dirpath/$dataset_type.$num
+			done
+			;;
+
+		acls)
+			for num in $(seq 1 $DATASET_SIZE);do
+				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
+				run_check $SUDO_HELPER setfacl -m "u:root:x" $dirpath/$dataset_type.$num
+				run_check $SUDO_HELPER setfattr -n user.foo -v bar$num $dirpath/$dataset_type.$num
+			done
+			;;
+	esac
+}
+
+populate_fs() {
+
+        for dataset_type in 'small' 'hardlink' 'symlink' 'brokenlink' 'perm' 'sparse' 'acls' ; do
+		generate_dataset "$dataset_type"
+	done
+}
+
 convert_test() {
 	local features
 	local nodesize
@@ -39,15 +114,16 @@ convert_test() {
 	# when test image is on NFS and would not be writable for root
 	run_check truncate -s 0 $TEST_DEV
 	# 256MB is the smallest acceptable btrfs image.
-	run_check truncate -s 256M $TEST_DEV
+	run_check truncate -s 512M $TEST_DEV
 	run_check $* -F $TEST_DEV
 
 	# create a file to check btrfs-convert can convert regular file
 	# correct
 	run_check_mount_test_dev
+	populate_fs;
 	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
 		count=1 1>/dev/null 2>&1
-	run_check_stdout md5sum $TEST_MNT/test > $CHECKSUMTMP
+	run_check_stdout find $TEST_MNT -type f ! -name 'image' -exec md5sum {} \+ > $CHECKSUMTMP
 	run_check_umount_test_dev
 
 	run_check $TOP/btrfs-convert ${features:+-O "$features"} -N "$nodesize" $TEST_DEV
@@ -56,7 +132,7 @@ convert_test() {
 
 	run_check_mount_test_dev
 	run_check_stdout md5sum -c $CHECKSUMTMP |
-		grep -q 'OK' || _fail "file validation failed."
+		grep -q 'FAILED' && _fail "file validation failed."
 	run_check_umount_test_dev
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
