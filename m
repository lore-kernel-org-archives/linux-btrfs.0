Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750767AbbDCHDY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372HPS001964
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] btrfs-progs: fsck-tests: Update 013-extent-tree-rebuild to use more test framework infrastructure.
Date: Fri, 3 Apr 2015 15:01:14 +0800
Message-ID: <1428044477-18485-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update 013-extent-tree-rebuild to use more framework infrastructure,
including:
1) Use run_check other than open-coded redirect
2) Add root privillege
3) Add dependency on 'btrfs-debug-tree' command

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 25 +++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index cde97db..7453ed7 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -2,6 +2,9 @@
 
 source $TOP/tests/common
 
+check_prereq btrfs-debug-tree
+setup_root_helper
+
 if [ -z $TEST_DEV ]; then
 	echo "    [NOTRUN] extent tree rebuild, need TEST_DEV variant"
 	exit 0
@@ -16,32 +19,32 @@ fi
 test_extent_tree_rebuild()
 {
 	echo "     [TEST]    extent tree rebuild"
-	$TOP/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
 
-	run_check mount $TEST_DEV $TEST_MNT
-	cp -aR /lib/modules/`uname -r`/ $TEST_MNT 2>&1
+	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
+	run_check $SUDO_HELPER cp -aR /lib/modules/`uname -r`/ $TEST_MNT
 
 	for i in `seq 1 100`;do
-		$TOP/btrfs sub snapshot $TEST_MNT \
-			$TEST_MNT/snapaaaaaaa_$i >& /dev/null
+		run_check $SUDO_HELPER $TOP/btrfs sub snapshot $TEST_MNT \
+			$TEST_MNT/snapaaaaaaa_$i
 	done
-	run_check umount $TEST_DEV
+	run_check $SUDO_HELPER umount $TEST_DEV
 
 	# get extent root bytenr
-	extent_root_bytenr=`$TOP/btrfs-debug-tree -r $TEST_DEV | \
+	extent_root_bytenr=`$SUDO_HELPER $TOP/btrfs-debug-tree -r $TEST_DEV | \
 			    grep extent | awk '{print $7}'`
 	if [ -z $extent_root_bytenr ];then
 		_fail "fail to get extent root bytenr"
 	fi
 
 	# corrupt extent root node block
-	run_check $TOP/btrfs-corrupt-block -l $extent_root_bytenr \
+	run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -l $extent_root_bytenr \
 		-b 4096 $TEST_DEV
 
-	$TOP/btrfs check $TEST_DEV >& /dev/null && \
+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
 			_fail "btrfs check should detect failure"
-	run_check $TOP/btrfs check --init-extent-tree $TEST_DEV
-	run_check $TOP/btrfs check $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check --init-extent-tree $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
 }
 
 test_extent_tree_rebuild
-- 
2.3.5

