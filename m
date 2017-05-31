Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58416 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750974AbdEaF42 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 01:56:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 6/6] btrfs-progs: test: Introduce functions to prepare and cleanup loop device
Date: Wed, 31 May 2017 13:56:10 +0800
Message-ID: <20170531055610.11606-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
References: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new helpers, prepare_loop_dev() and cleanup_loop_dev() to
prepare and cleanup loop device.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common                                       | 38 ++++++++++++++++++++++
 .../misc-tests/006-image-on-missing-device/test.sh | 12 ++-----
 tests/misc-tests/011-delete-missing-device/test.sh | 12 ++-----
 tests/mkfs-tests/001-basic-profiles/test.sh        | 12 ++-----
 .../005-long-device-name-for-ssd/test.sh           | 10 ++----
 tests/mkfs-tests/006-partitioned-loopdev/test.sh   | 10 ++----
 6 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/tests/common b/tests/common
index 7ad436e3..3808cfc5 100644
--- a/tests/common
+++ b/tests/common
@@ -355,6 +355,44 @@ setup_root_helper()
 	SUDO_HELPER=root_helper
 }
 
+# prepare loop device using specified size and path
+# $1: path of the file
+# $2: size of the device, optional, default value is '2G'
+prepare_loop_dev()
+{
+	local path="$1"
+	local size="$2"
+
+	[[ "$path" ]] || _fail "path must be specified for prepare_loop_dev()"
+	[[ "$size" ]] || size='2G'
+
+	# Cleanup if it's already mounted or set up as loop device
+	cleanup_loop_dev $path
+
+	run_check touch $path
+	chmod a+rw $path
+	run_check truncate -s $size $path
+
+	run_check_stdout $SUDO_HELPER losetup --find --show $path
+}
+
+# cleanup loop device based on its backend file
+# $1: the path of the backend file
+#
+# We don't want to populate result in cleanup, so any error will only be
+# caught manually, don't call run_check here.
+cleanup_loop_dev()
+{
+	local path="$1"
+
+	loop_dev=$(losetup -l | tail -n +2 | grep $path | cut -f1 -d\ )
+	if [ ! -z "$loop_dev" ]; then
+		umount $loop_dev &> /dev/null
+		$SUDO_HELPER losetup -d $loop_dev || \
+			_fail "failed to detach $path"
+	fi
+}
+
 prepare_test_dev()
 {
 	# num[K/M/G/T...]
diff --git a/tests/misc-tests/006-image-on-missing-device/test.sh b/tests/misc-tests/006-image-on-missing-device/test.sh
index 5b6fe065..8249c0e9 100755
--- a/tests/misc-tests/006-image-on-missing-device/test.sh
+++ b/tests/misc-tests/006-image-on-missing-device/test.sh
@@ -23,21 +23,15 @@ setup_root_helper
 prepare_devices()
 {
 	for i in `seq $ndevs`; do
-		touch img$i
-		chmod a+rw img$i
-		truncate -s0 img$i
-		truncate -s2g img$i
-		devs[$i]=`run_check_stdout $SUDO_HELPER losetup --find --show img$i`
+		devs[$i]=$(prepare_loop_dev img$i)
 	done
 }
 
 cleanup_devices()
 {
-	for dev in ${devs[@]}; do
-		run_mayfail $SUDO_HELPER losetup -d $dev
-	done
 	for i in `seq $ndevs`; do
-		truncate -s0 img$i
+		cleanup_loop_dev img$i
+		rm img$i
 	done
 	run_check $SUDO_HELPER losetup --all
 }
diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
index 5b5f9786..ad4b7d45 100755
--- a/tests/misc-tests/011-delete-missing-device/test.sh
+++ b/tests/misc-tests/011-delete-missing-device/test.sh
@@ -16,21 +16,15 @@ setup_root_helper
 prepare_devices()
 {
 	for i in `seq $ndevs`; do
-		touch img$i
-		chmod a+rw img$i
-		truncate -s0 img$i
-		truncate -s2g img$i
-		devs[$i]=`run_check_stdout $SUDO_HELPER losetup --find --show img$i`
+		devs[$i]=$(prepare_loop_dev img$i)
 	done
 }
 
 cleanup_devices()
 {
-	for dev in ${devs[@]}; do
-		run_mayfail $SUDO_HELPER losetup -d $dev
-	done
 	for i in `seq $ndevs`; do
-		truncate -s0 img$i
+		cleanup_loop_dev img$i
+		rm img$i
 	done
 	run_check $SUDO_HELPER losetup --all
 }
diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
index 0dc9a2bd..98bd9e6b 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -16,21 +16,15 @@ setup_root_helper
 prepare_devices()
 {
 	for i in `seq $ndevs`; do
-		touch img$i
-		chmod a+rw img$i
-		truncate -s0 img$i
-		truncate -s2g img$i
-		devs[$i]=`run_check_stdout $SUDO_HELPER losetup --find --show img$i`
+		devs[$i]=$(prepare_loop_dev img$i)
 	done
 }
 
 cleanup_devices()
 {
-	for dev in ${devs[@]}; do
-		run_check $SUDO_HELPER losetup -d $dev
-	done
 	for i in `seq $ndevs`; do
-		truncate -s0 img$i
+		cleanup_loop_dev img$i
+		rm img$i
 	done
 	run_check $SUDO_HELPER losetup --all
 }
diff --git a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
index 63fb1785..aacff6ee 100755
--- a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
+++ b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
@@ -13,11 +13,7 @@ dmname=\
 btrfs-test-with-very-long-name-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
 dmdev=/dev/mapper/$dmname
 
-run_check truncate -s0 img
-chmod a+w img
-run_check truncate -s2g img
-
-loopdev=`run_check_stdout $SUDO_HELPER losetup --find --show img`
+loopdev=$(prepare_loop_dev img)
 run_check $SUDO_HELPER dmsetup create $dmname --table "0 1048576 linear $loopdev 0"
 
 dmbase=`readlink -f $dmdev`
@@ -36,5 +32,5 @@ run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $dmdev
 
 # cleanup
 run_check $SUDO_HELPER dmsetup remove $dmname
-run_mayfail $SUDO_HELPER losetup -d $loopdev
-run_check truncate -s0 img
+cleanup_loop_dev img
+rm img
diff --git a/tests/mkfs-tests/006-partitioned-loopdev/test.sh b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
index 12f37842..b005ef3d 100755
--- a/tests/mkfs-tests/006-partitioned-loopdev/test.sh
+++ b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
@@ -12,12 +12,8 @@ check_prereq mkfs.btrfs
 
 setup_root_helper
 
-run_check truncate -s0 img
-chmod a+w img
 cp partition-1g-1g img
-run_check truncate -s2g img
-
-loopdev=$(run_check_stdout $SUDO_HELPER losetup --partscan --find --show img)
+loopdev=$(prepare_loop_dev img)
 base=$(basename $loopdev)
 
 # expect partitions named like loop0p1 etc
@@ -27,5 +23,5 @@ for looppart in $(ls /dev/$base?*); do
 done
 
 # cleanup
-run_check $SUDO_HELPER losetup -d $loopdev
-run_check truncate -s0 img
+cleanup_loop_dev img
+rm img
-- 
2.13.0



