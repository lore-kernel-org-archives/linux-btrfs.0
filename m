Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8909 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755535AbbIAKFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 06:05:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t81A4uHB032611
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 18:04:56 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs-progs: tests: Fix mount fail of 013-extent-tree-rebuild
Date: Tue, 1 Sep 2015 18:03:27 +0800
Message-ID: <899dfa2f9238ab5905eeeb3613ade2549a5a1f6a.1441101420.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441101420.git.zhaolei@cn.fujitsu.com>
References: <cover.1441101420.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mount command in old system can not add "-o loop" option automatically
for loop device, and make following test failed:
  # ./fsck-tests.sh
  ...
    [TEST]   013-extent-tree-rebuild
  failed: mount /data/btrfsprogs/tests/test.img /data/btrfsprogs/tests/mnt
  test failed for case 013-extent-tree-rebuild

Considering that $TEST_DEV can be block or loop device, we need determine
our mount option in a condition for both case.

This patch create a wrapper function for above request, to solve current
problem in 013-extent-tree-rebuild, and support similar request in future.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common                                     | 26 ++++++++++++++++++++++++
 tests/fsck-tests/013-extent-tree-rebuild/test.sh |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index c597915..8205b33 100644
--- a/tests/common
+++ b/tests/common
@@ -171,6 +171,32 @@ prepare_test_dev()
 	truncate -s "$size" "$TEST_DEV" || _not_run "create file for loop device failed"
 }
 
+run_check_mount_test_dev()
+{
+	setup_root_helper
+
+	local loop_opt
+	if [[ -b "$TEST_DEV" ]]; then
+		loop_opt=""
+	elif [[ -f "$TEST_DEV" ]]; then
+		loop_opt="-o loop"
+	else
+		_fail "Invalid \$TEST_DEV: $TEST_DEV"
+	fi
+
+	[[ -d "$TEST_MNT" ]] || {
+		_fail "Invalid \$TEST_MNT: $TEST_MNT"
+	}
+
+	run_check $SUDO_HELPER mount $loop_opt "$TEST_DEV" "$TEST_MNT"
+}
+
+run_check_umount_test_dev()
+{
+	setup_root_helper
+	run_check $SUDO_HELPER umount "$TEST_DEV"
+}
+
 init_env()
 {
 	TEST_MNT="${TEST_MNT:-$TOP/tests/mnt}"
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index b7909d2..7419d6e 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -12,14 +12,14 @@ test_extent_tree_rebuild()
 {
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
 
-	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
+	run_check_mount_test_dev
 	run_check $SUDO_HELPER cp -aR /lib/modules/`uname -r`/ $TEST_MNT
 
 	for i in `seq 1 100`;do
 		run_check $SUDO_HELPER $TOP/btrfs sub snapshot $TEST_MNT \
 			$TEST_MNT/snapaaaaaaa_$i
 	done
-	run_check $SUDO_HELPER umount $TEST_DEV
+	run_check_umount_test_dev
 
 	# get extent root bytenr
 	extent_root_bytenr=`$SUDO_HELPER $TOP/btrfs-debug-tree -r $TEST_DEV | \
-- 
1.8.5.1

