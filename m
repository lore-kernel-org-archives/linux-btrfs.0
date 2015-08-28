Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36369 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbbH1DvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 23:51:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7S3p8dO010737
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 11:51:08 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: progs: Unmount TEST_DEV before mount again
Date: Fri, 28 Aug 2015 11:49:39 +0800
Message-ID: <208f203f83cb0bef7d820e8b6b53fd69fc209514.1440733675.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a testcase failed, we can't run it(or other tests needs mount) again,
 # ./misc-tests.sh 007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
 # ./misc-tests.sh 007
   [TEST]   007-subvolume-sync
   failed: mount /root/btrfs-progs/tests/test.img /root/btrfs-progs/tests/mnt
   test failed for case 007-subvolume-sync
 #

This patch add umount to above tests, to avoid this problem.
After patch:
 # ./misc-tests.sh  007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
 # ./misc-tests.sh  007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
 #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/convert-tests.sh                               | 1 +
 tests/fsck-tests/012-leaf-corruption/test.sh         | 1 +
 tests/fsck-tests/013-extent-tree-rebuild/test.sh     | 1 +
 tests/misc-tests/004-shrink-fs/test.sh               | 1 +
 tests/misc-tests/006-image-on-missing-device/test.sh | 1 +
 tests/misc-tests/007-subvolume-sync/test.sh          | 1 +
 6 files changed, 6 insertions(+)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index b395e25..038ab3c 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -34,6 +34,7 @@ convert_test() {
 	nodesize=$2
 	shift 2
 	echo "creating ext image with: $*" >> $RESULTS
+	$SUDO_HELPER umount $TEST_MNT &>/dev/null
 	# IMAGE not removed as the file might have special permissions, eg.
 	# when test image is on NFS and would not be writable for root
 	run_check truncate -s 0 $IMAGE
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index f8701ad..10e78ea 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -103,6 +103,7 @@ check_leaf_corrupt_no_data_ext()
 
 setup_root_helper
 
+$SUDO_HELPER umount $TEST_MNT &>/dev/null
 generate_leaf_corrupt_no_data_ext test.img
 check_image test.img
 check_leaf_corrupt_no_data_ext test.img
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 88a66cc..d609562 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -15,6 +15,7 @@ fi
 # test whether fsck can rebuild a corrupted extent tree
 test_extent_tree_rebuild()
 {
+	$SUDO_HELPER umount $TEST_DEV &>/dev/null
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
 
 	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
diff --git a/tests/misc-tests/004-shrink-fs/test.sh b/tests/misc-tests/004-shrink-fs/test.sh
index b132152..4df98f0 100755
--- a/tests/misc-tests/004-shrink-fs/test.sh
+++ b/tests/misc-tests/004-shrink-fs/test.sh
@@ -21,6 +21,7 @@ shrink_test()
 	run_check $SUDO_HELPER $TOP/btrfs filesystem resize $min_size $TEST_MNT
 }
 
+$SUDO_HELPER umount $TEST_MNT &>/dev/null
 run_check truncate -s 20G $IMAGE
 run_check $TOP/mkfs.btrfs -f $IMAGE
 run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
diff --git a/tests/misc-tests/006-image-on-missing-device/test.sh b/tests/misc-tests/006-image-on-missing-device/test.sh
index 8680a70..d062bf1 100755
--- a/tests/misc-tests/006-image-on-missing-device/test.sh
+++ b/tests/misc-tests/006-image-on-missing-device/test.sh
@@ -71,6 +71,7 @@ test_run()
 	test_image_dump
 }
 
+$SUDO_HELPER umount $TEST_MNT &>/dev/null
 prepare_devices
 dev1=${devs[1]}
 dev2=${devs[2]}
diff --git a/tests/misc-tests/007-subvolume-sync/test.sh b/tests/misc-tests/007-subvolume-sync/test.sh
index d4019f4..b12bc25 100755
--- a/tests/misc-tests/007-subvolume-sync/test.sh
+++ b/tests/misc-tests/007-subvolume-sync/test.sh
@@ -12,6 +12,7 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
+$SUDO_HELPER umount $TEST_MNT &>/dev/null
 run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$TEST_DEV"
 run_check $SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"
 
-- 
1.8.5.1

