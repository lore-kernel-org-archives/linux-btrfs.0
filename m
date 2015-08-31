Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53026 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbbHaFGW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 01:06:22 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7V56928020006
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 13:06:09 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 2/4] btrfs-progs: tests: Fix mount fail of 013-extent-tree-rebuild
Date: Mon, 31 Aug 2015 13:04:37 +0800
Message-ID: <d5c6fc74720d36f78e378a8bfa50aea164751991.1440997237.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using loop device for test, fsck-tests/013-extent-tree-rebuild
failed with following error message:
  # ./fsck-tests.sh
  ...
    [TEST]   013-extent-tree-rebuild
  failed: mount /data/btrfsprogs/tests/test.img /data/btrfsprogs/tests/mnt
  test failed for case 013-extent-tree-rebuild
  #

Considering that $TEST_DEV can be block or loop device, we need determine
our mount option in a condition for both case.

This patch make above request to a common function, to solve current
problem in 013-extent-tree-rebuild, and support similar request in future.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common                                     | 23 +++++++++++++++++++++++
 tests/fsck-tests/013-extent-tree-rebuild/test.sh |  4 ++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index c597915..eae6b2b 100644
--- a/tests/common
+++ b/tests/common
@@ -178,3 +178,26 @@ init_env()
 	mkdir -p "$TEST_MNT" || { echo "Failed mkdir -p $TEST_MNT"; exit 1; }
 }
 init_env
+
+mount_test_dev()
+{
+	local loop_opt
+	if [[ -b "$TEST_DEV" ]]; then
+		loop_opt=()
+	elif [[ -f "$TEST_DEV" ]]; then
+		loop_opt=(-o loop)
+	else
+		_fail "Invalid \$TEST_DEV: $TEST_DEV"
+	fi
+
+	[[ -d "$TEST_MNT" ]] || {
+		_fail "Invalid \$TEST_MNT: $TEST_MNT"
+	}
+
+	mount "${loop_opt[@]}" "$TEST_DEV" "$TEST_MNT" || _fail "mount $TEST_DEV to $TEST_MNT failed"
+}
+
+umount_test_dev()
+{
+	umount "$TEST_DEV"
+}
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index b7909d2..ff3c922 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -12,14 +12,14 @@ test_extent_tree_rebuild()
 {
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
 
-	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
+	run_check $SUDO_HELPER mount_test_dev
 	run_check $SUDO_HELPER cp -aR /lib/modules/`uname -r`/ $TEST_MNT
 
 	for i in `seq 1 100`;do
 		run_check $SUDO_HELPER $TOP/btrfs sub snapshot $TEST_MNT \
 			$TEST_MNT/snapaaaaaaa_$i
 	done
-	run_check $SUDO_HELPER umount $TEST_DEV
+	run_check $SUDO_HELPER umount_test_dev
 
 	# get extent root bytenr
 	extent_root_bytenr=`$SUDO_HELPER $TOP/btrfs-debug-tree -r $TEST_DEV | \
-- 
1.8.5.1

