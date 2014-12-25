Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47004 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbaLYBeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:34:16 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1XmeM020171
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:33:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: Move extent tree rebuild test to its dir
Date: Thu, 25 Dec 2014 09:32:15 +0800
Message-ID: <1419471135-10878-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move extent tree rebuild teset to its dir.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests.sh                              | 39 --------------------
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 47 ++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 39 deletions(-)
 create mode 100755 tests/fsck-tests/013-extent-tree-rebuild/test.sh

diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index a992b45..df21423 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -60,42 +60,3 @@ do
 	fi
 	cd $top
 done
-
-if [ -z $TEST_DEV ] || [ -z $TEST_MNT ];then
-	echo "     [NOTRUN] extent tree rebuild"
-	exit 0
-fi
-
-# test whether fsck can rebuild a corrupted extent tree
-test_extent_tree_rebuild()
-{
-	echo "     [TEST]    extent tree rebuild"
-	$top/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
-
-	run_check mount $TEST_DEV $TEST_MNT
-	cp -aR /lib/modules/`uname -r`/ $TEST_MNT 2>&1
-
-	for i in `seq 1 100`;do
-		$top/btrfs sub snapshot $TEST_MNT \
-			$TEST_MNT/snapaaaaaaa_$i >& /dev/null
-	done
-	run_check umount $TEST_DEV
-
-	# get extent root bytenr
-	extent_root_bytenr=`$top/btrfs-debug-tree -r $TEST_DEV | \
-			    grep extent | awk '{print $7}'`
-	if [ -z $extent_root_bytenr ];then
-		_fail "fail to get extent root bytenr"
-	fi
-
-	# corrupt extent root node block
-	run_check $top/btrfs-corrupt-block -l $extent_root_bytenr \
-		-b 4096 $TEST_DEV
-
-	$top/btrfs check $TEST_DEV >& /dev/null && \
-			_fail "btrfs check should detect failure"
-	run_check $top/btrfs check --init-extent-tree $TEST_DEV
-	run_check $top/btrfs check $TEST_DEV
-}
-
-test_extent_tree_rebuild
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
new file mode 100755
index 0000000..ce51e07
--- /dev/null
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -0,0 +1,47 @@
+#!/bin/bash
+
+source $top/tests/common
+
+if [ -z $TEST_DEV ]; then
+	echo "     [NOTRUN] extent tree rebuild, need TEST_DEV variant"
+	exit 0
+fi
+
+if [ -z $TEST_MNT ];then
+	echo "     [NOTRUN] extent tree rebuild, need TEST_MNT variant"
+	exit 0
+fi
+
+# test whether fsck can rebuild a corrupted extent tree
+test_extent_tree_rebuild()
+{
+	echo "     [TEST]    extent tree rebuild"
+	$top/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
+
+	run_check mount $TEST_DEV $TEST_MNT
+	cp -aR /lib/modules/`uname -r`/ $TEST_MNT 2>&1
+
+	for i in `seq 1 100`;do
+		$top/btrfs sub snapshot $TEST_MNT \
+			$TEST_MNT/snapaaaaaaa_$i >& /dev/null
+	done
+	run_check umount $TEST_DEV
+
+	# get extent root bytenr
+	extent_root_bytenr=`$top/btrfs-debug-tree -r $TEST_DEV | \
+			    grep extent | awk '{print $7}'`
+	if [ -z $extent_root_bytenr ];then
+		_fail "fail to get extent root bytenr"
+	fi
+
+	# corrupt extent root node block
+	run_check $top/btrfs-corrupt-block -l $extent_root_bytenr \
+		-b 4096 $TEST_DEV
+
+	$top/btrfs check $TEST_DEV >& /dev/null && \
+			_fail "btrfs check should detect failure"
+	run_check $top/btrfs check --init-extent-tree $TEST_DEV
+	run_check $top/btrfs check $TEST_DEV
+}
+
+test_extent_tree_rebuild
-- 
2.2.1

