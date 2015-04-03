Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751247AbbDCHDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:25 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372Jm3001973
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6] btrfs-progs: convert-tests: Update to use test framework infrastructure.
Date: Fri, 3 Apr 2015 15:01:16 +0800
Message-ID: <1428044477-18485-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also change the test() to convert_test(), to avoid conflict name with
bash test function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests.sh | 68 ++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index f6b919d..7652a6c 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -4,48 +4,46 @@
 # clean.
 #
 
-here=`pwd`
+unset TOP
+unset LANG
+LANG=C
+SCRIPT_DIR=$(dirname $(realpath $0))
+TOP=$(realpath $SCRIPT_DIR/../)
+TEST_DEV=${TEST_DEV:-}
+TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
+RESULTS="$TOP/tests/convert-tests-results.txt"
+IMAGE="$TOP/tests/test.img"
 
-_fail()
-{
-	echo "$*" | tee -a convert-tests-results.txt
-	exit 1
-}
+source $TOP/tests/common
 
-rm -f convert-tests-results.txt
+rm -f $RESULTS
 
-test(){
+convert_test() {
 	echo "    [TEST]   $1"
 	nodesize=$2
 	shift 2
-	echo "creating ext image with: $*" >> convert-tests-results.txt
+	echo "creating ext image with: $*" >> $RESULTS
 	# 256MB is the smallest acceptable btrfs image.
-	rm -f $here/test.img >> convert-tests-results.txt 2>&1 \
-		|| _fail "could not remove test image file"
-	truncate -s 256M $here/test.img >> convert-tests-results.txt 2>&1 \
-		|| _fail "could not create test image file"
-	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
-		|| _fail "filesystem create failed"
-	$here/btrfs-convert -N "$nodesize" $here/test.img \
-			>> convert-tests-results.txt 2>&1 \
-		|| _fail "btrfs-convert failed"
-	$here/btrfs check $here/test.img >> convert-tests-results.txt 2>&1 \
-		|| _fail "btrfs check detected errors"
+	run_check rm -f $IMAGE
+	run_check truncate -s 256M $IMAGE
+	run_check $* -F $IMAGE
+	run_check $TOP/btrfs-convert -N "$nodesize" $IMAGE
+	run_check $TOP/btrfs check $IMAGE
 }
 
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
2.3.5

