Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaBZCh4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 21:37:56 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1Q2bJuS002205
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 10:37:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Add test for btrfsck on "--init-csum/extent-tree"
Date: Wed, 26 Feb 2014 10:32:58 +0800
Message-Id: <1393381978-11709-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patchset btrfsck with "--init-csum-tree --extent-tree" will
corrupt the btrfs fs.
This patch will add test case for the bug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests.sh | 49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 25c390d..03b0586 100644
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -6,27 +6,60 @@
 #
 
 here=`pwd`
+log=fsck-tests-results.txt
+img=test.img
+mp=mount_point
 
 _fail()
 {
-	echo "$*" | tee -a fsck-tests-results.txt
+	echo "$*" | tee -a $log
 	exit 1
 }
 
-rm -f fsck-tests-results.txt
+_clean()
+{
+	rm -f $log &> /dev/null
+	rm -f $img &> /dev/null
+	umount $mp &> /dev/null
+	rm -rf $mp &> /dev/null
+}
+
+_init()
+{
+	_clean
+	touch $img
+	truncate -s 5G $img
+	mkdir $mp
+}
+
+_init
 
 for i in $(find $here/tests/fsck-tests -name '*.img')
 do
 	echo "     [TEST]    $(basename $i)"
-	echo "testing image $i" >> fsck-tests-results.txt
-	$here/btrfs-image -r $i test.img >> fsck-tests-results.txt 2>&1 \
-		|| _fail "restore failed"
-	$here/btrfsck test.img >> fsck-test-results.txt 2>&1
+	echo "testing image $i" >> $log
+	$here/btrfs-image -r $i $img >> $log 2>&1 || _fail "restore failed"
+	$here/btrfsck $img >> $log 2>&1
 	[ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
 
-	$here/btrfsck --repair test.img >> fsck-test-results.txt 2>&1 || \
+	$here/btrfsck --repair $img >> $log 2>&1 || \
 		_fail "btrfsck should have repaired the image"
 
-	$here/btrfsck test.img >> fsck-test-results.txt 2>&1 || \
+	$here/btrfsck $img >> $log 2>&1 || \
 		_fail "btrfsck did not correct corruption"
+
 done
+
+if [[ $EUID -ne 0 ]]; then
+	echo "init extent csum tree test needs to be run by root"
+	_clean
+	exit 0
+fi
+echo "     [TEST]    init extent csum tree"
+$here/mkfs.btrfs $img -f >> $log 2>&1
+$here/btrfsck $img --init-extent-tree --init-csum-tree >> $log 2>&1
+# just test whether the mount will success, since extent/csum tree is cleared
+# it will never pass btrfsck, but it should be OK to be mounted.
+mount $img $mp -t btrfs >> $log 2>&1  || _fail "btrfsck corrupt the img"
+
+_clean
-- 
1.9.0

