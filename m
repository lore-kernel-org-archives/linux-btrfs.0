Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:60092
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163258AbdDWTBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Apr 2017 15:01:31 -0400
Date: Mon, 24 Apr 2017 00:30:00 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: tests: add variable quotation to convert-tests
Message-ID: <20170423190000.GA15598@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/convert-tests.sh                             |  2 +-
 tests/convert-tests/001-ext2-basic/test.sh         |  4 ++--
 tests/convert-tests/002-ext3-basic/test.sh         |  4 ++--
 tests/convert-tests/003-ext4-basic/test.sh         |  4 ++--
 .../004-ext2-backup-superblock-ranges/test.sh      | 22 +++++++++++-----------
 .../convert-tests/005-delete-all-rollback/test.sh  |  6 +++---
 tests/convert-tests/006-large-hole-extent/test.sh  |  6 +++---
 .../007-unsupported-block-sizes/test.sh            |  8 ++++----
 tests/convert-tests/008-readonly-image/test.sh     |  8 ++++----
 tests/convert-tests/009-common-inode-flags/test.sh | 14 +++++++-------
 10 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index c566336..819e7e2 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -37,7 +37,7 @@ run_one_test() {
 		./test.sh
 		if [ $? -ne 0 ]; then
 			_fail "test failed for case $testname"
-			if [[ $TEST_LOG =~ dump ]]; then
+			if [[ "$TEST_LOG" =~ dump ]]; then
 				cat "$RESULTS"
 			fi
 		fi
diff --git a/tests/convert-tests/001-ext2-basic/test.sh b/tests/convert-tests/001-ext2-basic/test.sh
index 8f4f935..07f1d6e 100755
--- a/tests/convert-tests/001-ext2-basic/test.sh
+++ b/tests/convert-tests/001-ext2-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
diff --git a/tests/convert-tests/002-ext3-basic/test.sh b/tests/convert-tests/002-ext3-basic/test.sh
index aeb111e..be8a929 100755
--- a/tests/convert-tests/002-ext3-basic/test.sh
+++ b/tests/convert-tests/002-ext3-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
diff --git a/tests/convert-tests/003-ext4-basic/test.sh b/tests/convert-tests/003-ext4-basic/test.sh
index 531c81b..44ee592 100755
--- a/tests/convert-tests/003-ext4-basic/test.sh
+++ b/tests/convert-tests/003-ext4-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
diff --git a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
index c56650b..0ce62f7 100755
--- a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
+++ b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
@@ -10,7 +10,7 @@
 # 4) Overlap file extents
 # 5) Unable to rollback
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs-convert
 check_prereq btrfs
@@ -23,20 +23,20 @@ prepare_test_dev 512M
 # override common function
 function check_image() {
 	TEST_DEV="$1"
-	run_check e2fsck -n -f $TEST_DEV
-	run_check $TOP/btrfs-convert $TEST_DEV
-	run_check $TOP/btrfs check $TEST_DEV
-	run_check $TOP/btrfs inspect-internal dump-super $TEST_DEV
+	run_check e2fsck -n -f "$TEST_DEV"
+	run_check "$TOP/btrfs-convert" "$TEST_DEV"
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check "$TOP/btrfs" inspect-internal dump-super "$TEST_DEV"
 
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER e2fsck -n -f $TEST_MNT/ext2_saved/image
-	run_check $SUDO_HELPER umount $TEST_MNT
+	run_check $SUDO_HELPER e2fsck -n -f "$TEST_MNT/ext2_saved/image"
+	run_check $SUDO_HELPER umount "$TEST_MNT"
 
-	run_check $TOP/btrfs check $TEST_DEV
-	run_check $TOP/btrfs-convert -r $TEST_DEV
-	run_check e2fsck -n -f $TEST_DEV
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check "$TOP/btrfs-convert" -r "$TEST_DEV"
+	run_check e2fsck -n -f "$TEST_DEV"
 
-	rm -f $TEST_DEV
+	rm -f "$TEST_DEV"
 }
 
 check_all_images
diff --git a/tests/convert-tests/005-delete-all-rollback/test.sh b/tests/convert-tests/005-delete-all-rollback/test.sh
index cf576e7..c6f7466 100755
--- a/tests/convert-tests/005-delete-all-rollback/test.sh
+++ b/tests/convert-tests/005-delete-all-rollback/test.sh
@@ -2,8 +2,8 @@
 # create a base image, convert to btrfs, remove all files, rollback the ext4 image
 # note: ext4 only
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
@@ -43,7 +43,7 @@ do_test() {
 	# ext2_saved/image must not be deleted
 	run_mayfail $SUDO_HELPER find "$TEST_MNT"/ -mindepth 1 -path '*ext2_saved' -prune -o -exec rm -vrf "{}" \;
 	cd "$here"
-	run_check $TOP/btrfs filesystem sync "$TEST_MNT"
+	run_check "$TOP/btrfs" filesystem sync "$TEST_MNT"
 	run_check_umount_test_dev
 	convert_test_post_rollback
 
diff --git a/tests/convert-tests/006-large-hole-extent/test.sh b/tests/convert-tests/006-large-hole-extent/test.sh
index d3bc093..e99741c 100755
--- a/tests/convert-tests/006-large-hole-extent/test.sh
+++ b/tests/convert-tests/006-large-hole-extent/test.sh
@@ -5,8 +5,8 @@
 # Fast pinpoint regression test. No options combination nor checksum
 # verification
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
@@ -16,7 +16,7 @@ default_mke2fs="mke2fs -t ext4 -b 4096"
 convert_test_preamble '' 'large hole extent test' 16k "$default_mke2fs"
 convert_test_prep_fs $default_mke2fs
 
-run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/file bs=1M \
+run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/file" bs=1M \
 	count=1 seek=1024 > /dev/null 2>&1
 
 run_check_umount_test_dev
diff --git a/tests/convert-tests/007-unsupported-block-sizes/test.sh b/tests/convert-tests/007-unsupported-block-sizes/test.sh
index 9ba1775..a748840 100755
--- a/tests/convert-tests/007-unsupported-block-sizes/test.sh
+++ b/tests/convert-tests/007-unsupported-block-sizes/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if block sizes smaller than 4k expectedly fail to convert
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
@@ -13,9 +13,9 @@ for bs in 1024 2048; do
 	convert_test_preamble '' "unsupported block size $bs" 16k "$default_mke2fs"
 	convert_test_prep_fs $default_mke2fs
 
-	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/file bs=1M \
+	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/file" bs=1M \
 		count=1 seek=1024 > /dev/null 2>&1
 
 	run_check_umount_test_dev
-	run_mustfail "$bs block converted" $TOP/btrfs-convert $TEST_DEV
+	run_mustfail "$bs block converted" "$TOP/btrfs-convert" "$TEST_DEV"
 done
diff --git a/tests/convert-tests/008-readonly-image/test.sh b/tests/convert-tests/008-readonly-image/test.sh
index 4e42237..b2f1ae3 100755
--- a/tests/convert-tests/008-readonly-image/test.sh
+++ b/tests/convert-tests/008-readonly-image/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if the converted ext2 image is readonly
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
@@ -10,13 +10,13 @@ check_prereq btrfs-convert
 
 default_mke2fs="mke2fs -t ext4 -b 4096"
 convert_test_preamble '' 'readonly image test' 16k "$default_mke2fs"
-convert_test_prep_fs $default_mke2fs
+convert_test_prep_fs "$default_mke2fs"
 run_check_umount_test_dev
 convert_test_do_convert
 run_check_mount_test_dev
 
 # It's expected to fail
-$SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/ext2_save/image bs=1M count=1 \
+$SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/ext2_save/image" bs=1M count=1 \
 	&> /dev/null
 if [ $? -ne 1 ]; then
 	echo "after convert ext2_save/image is not read-only"
diff --git a/tests/convert-tests/009-common-inode-flags/test.sh b/tests/convert-tests/009-common-inode-flags/test.sh
index 6f26d18..a582879 100755
--- a/tests/convert-tests/009-common-inode-flags/test.sh
+++ b/tests/convert-tests/009-common-inode-flags/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if btrfs-convert can copy common inode flags like SYNC/IMMUTABLE
 
-source $TOP/tests/common
-source $TOP/tests/common.convert
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev 512M
@@ -11,20 +11,20 @@ check_prereq btrfs-convert
 fail=0
 default_mke2fs="mke2fs -t ext4 -b 4096"
 convert_test_preamble '' 'common inode flags test' 16k "$default_mke2fs"
-convert_test_prep_fs $default_mke2fs
+convert_test_prep_fs "$default_mke2fs"
 
 # create file with specific flags
-run_check $SUDO_HELPER touch $TEST_MNT/flag_test
-run_check $SUDO_HELPER chattr +aAdSi $TEST_MNT/flag_test
+run_check $SUDO_HELPER touch "$TEST_MNT/flag_test"
+run_check $SUDO_HELPER chattr +aAdSi "$TEST_MNT/flag_test"
 
 run_check_umount_test_dev
 convert_test_do_convert
 run_check_mount_test_dev
 
 # Log the status
-run_check lsattr $TEST_MNT/flag_test
+run_check lsattr "$TEST_MNT/flag_test"
 # Above flags should be copied to btrfs flags, and lsattr should get them
-run_check_stdout lsattr $TEST_MNT/flag_test | cut -f1 -d\ | grep "[aAdiS]" -q
+run_check_stdout lsattr "$TEST_MNT/flag_test" | cut -f1 -d\ | grep "[aAdiS]" -q
 if [ $? -ne 0 ]; then
 	rm tmp_output
 	_fail "no common inode flags are copied after convert"
-- 
2.7.4

