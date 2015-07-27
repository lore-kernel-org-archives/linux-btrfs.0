Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24133 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbbG0G3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 02:29:38 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6R6Rjfq003818
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 14:27:46 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 6/7] btrfs-progs: Move code to create loop device to common
Date: Mon, 27 Jul 2015 14:27:53 +0800
Message-ID: <1af761602385c1f0003822af604f307065a835d0.1437977968.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
References: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

This code block is common used, move it to common function will
make code clean.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common                                     | 16 ++++++++++++++++
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 11 +----------
 tests/misc-tests/001-btrfstune-features/test.sh  | 11 +----------
 tests/misc-tests/002-uuid-rewrite/test.sh        | 11 +----------
 tests/misc-tests/003-zero-log/test.sh            | 11 +----------
 5 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/tests/common b/tests/common
index 899ec7b..2d337b0 100644
--- a/tests/common
+++ b/tests/common
@@ -142,3 +142,19 @@ setup_root_helper()
 	fi
 	SUDO_HELPER=root_helper
 }
+
+prepare_test_dev()
+{
+	# num[K/M/G/T...]
+	local size="$1"
+
+	[[ "$TEST_DEV" ]] && return
+	[[ "$size" ]] || size='1G'
+
+	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
+		$RESULTS
+	TEST_DEV="$TOP/tests/test.img"
+
+	truncate -s "$size" "$TEST_DEV" || _not_run "create file for loop device failed"
+}
+
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 3290cd7..88a66cc 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -5,16 +5,7 @@ source $TOP/tests/common
 check_prereq btrfs-debug-tree
 check_prereq mkfs.btrfs
 setup_root_helper
-
-if [ -z $TEST_DEV ]; then
-	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
-		$RESULTS
-	TEST_DEV="$TOP/tests/test.img"
-
-	# Need at least 1G to avoid mixed block group, which extent tree
-	# rebuild doesn't support.
-	run_check truncate -s 1G $TEST_DEV
-fi
+prepare_test_dev 1G
 
 if [ -z $TEST_MNT ];then
 	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
diff --git a/tests/misc-tests/001-btrfstune-features/test.sh b/tests/misc-tests/001-btrfstune-features/test.sh
index c9981e6..ea33954 100755
--- a/tests/misc-tests/001-btrfstune-features/test.sh
+++ b/tests/misc-tests/001-btrfstune-features/test.sh
@@ -7,16 +7,7 @@ check_prereq btrfs-debug-tree
 check_prereq btrfs-show-super
 check_prereq mkfs.btrfs
 setup_root_helper
-
-if [ -z $TEST_DEV ]; then
-	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
-		$RESULTS
-	TEST_DEV="$TOP/tests/test.img"
-
-	# Need at least 1G to avoid mixed block group, which extent tree
-	# rebuild doesn't support.
-	run_check truncate -s 1G $TEST_DEV
-fi
+prepare_test_dev
 
 if [ -z $TEST_MNT ];then
 	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
diff --git a/tests/misc-tests/002-uuid-rewrite/test.sh b/tests/misc-tests/002-uuid-rewrite/test.sh
index 6c2a393..bffa9b8 100755
--- a/tests/misc-tests/002-uuid-rewrite/test.sh
+++ b/tests/misc-tests/002-uuid-rewrite/test.sh
@@ -7,16 +7,7 @@ check_prereq btrfs-debug-tree
 check_prereq btrfs-show-super
 check_prereq mkfs.btrfs
 check_prereq btrfstune
-
-if [ -z $TEST_DEV ]; then
-	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
-		$RESULTS
-	TEST_DEV="$TOP/tests/test.img"
-
-	# Need at least 1G to avoid mixed block group, which extent tree
-	# rebuild doesn't support.
-	run_check truncate -s 1G $TEST_DEV
-fi
+prepare_test_dev
 
 if [ -z $TEST_MNT ];then
 	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/003-zero-log/test.sh
index da5b351..edab5db 100755
--- a/tests/misc-tests/003-zero-log/test.sh
+++ b/tests/misc-tests/003-zero-log/test.sh
@@ -6,16 +6,7 @@ source $TOP/tests/common
 check_prereq btrfs-show-super
 check_prereq mkfs.btrfs
 check_prereq btrfs
-
-if [ -z $TEST_DEV ]; then
-	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
-		$RESULTS
-	TEST_DEV="$TOP/tests/test.img"
-
-	# Need at least 1G to avoid mixed block group, which extent tree
-	# rebuild doesn't support.
-	run_check truncate -s 1G $TEST_DEV
-fi
+prepare_test_dev
 
 if [ -z $TEST_MNT ];then
 	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
-- 
1.8.5.1

