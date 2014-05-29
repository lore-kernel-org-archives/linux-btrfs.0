Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50039 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981AbaE2KFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 06:05:19 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4TA5Ikx005262
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 18:05:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs-progs: fsck: add tests for extent tree rebuilding
Date: Thu, 29 May 2014 18:01:44 +0800
Message-ID: <1401357704-9752-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1401357704-9752-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1401357704-9752-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need test to verify extent tree rebuilding work, this test
create a strange filesystem with some snapshots, destroy
extent root node, and run fsck with "--init-extent-tree".

Since this tests need btrfs internal tool(btrfs-corrupt-block),so
i add this test into btrfs-progs.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/fsck-tests.sh | 69 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 11 deletions(-)

diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 25c390d..b783b78 100644
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -6,27 +6,74 @@
 #
 
 here=`pwd`
+TEST_DEV=
+TEST_MNT=
+RESULT="fsck-tests-results.txt"
 
 _fail()
 {
-	echo "$*" | tee -a fsck-tests-results.txt
+	echo "$*" | tee -a $RESULT
 	exit 1
 }
 
-rm -f fsck-tests-results.txt
+run_check()
+{
+	echo "############### $@" >> $RESULT 2>&1
+	"$@" >> $RESULT 2>&1 || _fail "failed: $@"
+}
+
+rm -f $RESULT
+
+if [ -z $TEST_DEV ] || [ -z $TEST_MNT ];then
+	_fail "please set TEST_DEV and TEST_MNT"
+fi
+
+# test rely on corrupting blocks tool
+run_check make btrfs-corrupt-block
 
 for i in $(find $here/tests/fsck-tests -name '*.img')
 do
 	echo "     [TEST]    $(basename $i)"
-	echo "testing image $i" >> fsck-tests-results.txt
-	$here/btrfs-image -r $i test.img >> fsck-tests-results.txt 2>&1 \
-		|| _fail "restore failed"
-	$here/btrfsck test.img >> fsck-test-results.txt 2>&1
-	[ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
+	echo "testing image $i" >> $RESULT
+
+	run_check $here/btrfs-image -r $i test.img
 
-	$here/btrfsck --repair test.img >> fsck-test-results.txt 2>&1 || \
-		_fail "btrfsck should have repaired the image"
+	$here/btrfsck test.img >> $RESULT 2>&1
+	[ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
 
-	$here/btrfsck test.img >> fsck-test-results.txt 2>&1 || \
-		_fail "btrfsck did not correct corruption"
+	run_check $here/btrfsck --repair test.img
+	run_check $here/btrfsck test.img
 done
+
+# test whether fsck can rebuild a corrupted extent tree
+test_extent_tree_rebuild()
+{
+	echo "     [TEST]    extent tree rebuild"
+	$here/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
+
+	run_check mount $TEST_DEV $TEST_MNT
+	cp -aR /lib/modules/`uname -r`/ $TEST_MNT 2>&1
+
+	for i in `seq 1 100`;do
+		$here/btrfs sub snapshot $TEST_MNT \
+			$TEST_MNT/snapaaaaaaa_$i >& /dev/null
+	done
+	run_check umount $TEST_DEV
+
+	# get extent root bytenr
+	extent_root_bytenr=`$here/btrfs-debug-tree -r $TEST_DEV | grep extent | awk '{print $7}'`
+	if [ -z $extent_root_bytenr ];then
+		_fail "fail to get extent root bytenr"
+	fi
+
+	# corrupt extent root node block
+	run_check $here/btrfs-corrupt-block -l $extent_root_bytenr \
+		-b 4096 $TEST_DEV
+
+	$here/btrfs check $TEST_DEV >& /dev/null && \
+			_fail "fsck should detect failure"
+	run_check $here/btrfs check --init-extent-tree $TEST_DEV
+	run_check $here/btrfs check $TEST_DEV
+}
+
+test_extent_tree_rebuild
-- 
1.9.0

