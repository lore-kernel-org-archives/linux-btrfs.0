Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45621 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347AbbDBCXl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 22:23:41 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t322MYB2018153
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Apr 2015 10:22:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: convert-test: Add test for converting ext* with regular file extent.
Date: Thu, 2 Apr 2015 10:21:36 +0800
Message-ID: <1427941296-19502-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427941296-19502-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427941296-19502-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before previous patch, btrfs-convert will result fsck complain if there
is any regular file extent in newly converted btrfs.

Add test case for it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests.sh | 85 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 30 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index f6b919d..5c4f22e 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -4,48 +4,73 @@
 # clean.
 #
 
-here=`pwd`
+unset top
+unset LANG
+LANG=C
+script_dir=$(dirname $(realpath $0))
+top=$(realpath $script_dir/../)
+TEST_DEV=${TEST_DEV:-}
+TEST_MNT=${TEST_MNT:-$top/tests/mnt}
+RESULT="$top/tests/convert-tests-results.txt"
+IMAGE="$script_dir/test.img"
 
-_fail()
-{
-	echo "$*" | tee -a convert-tests-results.txt
-	exit 1
-}
+source $top/tests/common
+export top
+export RESULT
+# For comprehensive convert test which needs write something into ext*
+export TEST_MNT
+export LANG
+
+rm -f $RESULT
+mkdir -p $TEST_MNT || _fail "unable to create mount point on $TEST_MNT"
+
+# test reply on btrfs-convert
+check_prereq btrfs-convert
+check_prereq btrfs
 
-rm -f convert-tests-results.txt
 
-test(){
+convert_test(){
 	echo "    [TEST]   $1"
 	nodesize=$2
 	shift 2
-	echo "creating ext image with: $*" >> convert-tests-results.txt
+	echo "creating ext image with: $*" >> $RESULT
 	# 256MB is the smallest acceptable btrfs image.
-	rm -f $here/test.img >> convert-tests-results.txt 2>&1 \
+	rm -f $IMAGE >> $RESULT 2>&1 \
 		|| _fail "could not remove test image file"
-	truncate -s 256M $here/test.img >> convert-tests-results.txt 2>&1 \
+	truncate -s 256M $IMAGE >> $RESULT 2>&1 \
 		|| _fail "could not create test image file"
-	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
+	$* -F $IMAGE >> $RESULT 2>&1 \
 		|| _fail "filesystem create failed"
-	$here/btrfs-convert -N "$nodesize" $here/test.img \
-			>> convert-tests-results.txt 2>&1 \
+
+	# write a file with regular file extent
+	$SUDO_HELPER mount $IMAGE $TEST_MNT
+	$SUDO_HELPER dd if=/dev/zero bs=$nodesize count=4 of=$TEST_MNT/test \
+		1>/dev/null 2>&1
+	$SUDO_HELPER umount $TEST_MNT
+
+	# do convert test
+	$top/btrfs-convert -N "$nodesize" $script_dir/test.img \
+			>> $RESULT 2>&1 \
 		|| _fail "btrfs-convert failed"
-	$here/btrfs check $here/test.img >> convert-tests-results.txt 2>&1 \
+	$top/btrfs check $script_dir/test.img >> $RESULT 2>&1 \
 		|| _fail "btrfs check detected errors"
 }
 
+setup_root_helper
+
 # btrfs-convert requires 4k blocksize.
-test "ext2 4k nodesize" 4096 mke2fs -b 4096
-test "ext3 4k nodesize" 4096 mke2fs -j -b 4096
-test "ext4 4k nodesize" 4096 mke2fs -t ext4 -b 4096
-test "ext2 8k nodesize" 8192 mke2fs -b 4096
-test "ext3 8k nodesize" 8192 mke2fs -j -b 4096
-test "ext4 8k nodesize" 8192 mke2fs -t ext4 -b 4096
-test "ext2 16k nodesize" 16384 mke2fs -b 4096
-test "ext3 16k nodesize" 16384 mke2fs -j -b 4096
-test "ext4 16k nodesize" 16384 mke2fs -t ext4 -b 4096
-test "ext2 32k nodesize" 32768 mke2fs -b 4096
-test "ext3 32k nodesize" 32768 mke2fs -j -b 4096
-test "ext4 32k nodesize" 32768 mke2fs -t ext4 -b 4096
-test "ext2 64k nodesize" 65536 mke2fs -b 4096
-test "ext3 64k nodesize" 65536 mke2fs -j -b 4096
-test "ext4 64k nodesize" 65536 mke2fs -t ext4 -b 4096
+convert_test "ext2 4k nodesize" 4096 mke2fs -b 4096
+convert_test "ext3 4k nodesize" 4096 mke2fs -j -b 4096
+convert_test "ext4 4k nodesize" 4096 mke2fs -t ext4 -b 4096
+convert_test "ext2 8k nodesize" 8192 mke2fs -b 4096
+convert_test "ext3 8k nodesize" 8192 mke2fs -j -b 4096
+convert_test "ext4 8k nodesize" 8192 mke2fs -t ext4 -b 4096
+convert_test "ext2 16k nodesize" 16384 mke2fs -b 4096
+convert_test "ext3 16k nodesize" 16384 mke2fs -j -b 4096
+convert_test "ext4 16k nodesize" 16384 mke2fs -t ext4 -b 4096
+convert_test "ext2 32k nodesize" 32768 mke2fs -b 4096
+convert_test "ext3 32k nodesize" 32768 mke2fs -j -b 4096
+convert_test "ext4 32k nodesize" 32768 mke2fs -t ext4 -b 4096
+convert_test "ext2 64k nodesize" 65536 mke2fs -b 4096
+convert_test "ext3 64k nodesize" 65536 mke2fs -j -b 4096
+convert_test "ext4 64k nodesize" 65536 mke2fs -t ext4 -b 4096
-- 
2.3.4

