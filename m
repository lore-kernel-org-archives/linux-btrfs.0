Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:64828 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbbCTBLi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 21:11:38 -0400
Received: from localhost (mxf2.local [127.0.0.1])
	by mxf2-reinject (Postfix) with ESMTP id AF11E1E9490
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:11:36 +0100 (CET)
Received: from mxf2.bahnhof.se ([127.0.0.1])
	by localhost (mxf2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 376QkI2GRt-e for <linux-btrfs@vger.kernel.org>;
	Fri, 20 Mar 2015 02:11:30 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf2.bahnhof.se (Postfix) with ESMTP id 309211E944F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:11:30 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YYlTF-0006zd-V8
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 02:11:30 +0100
Date: Fri, 20 Mar 2015 02:11:29 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs-progs: Add nodesize test for btrfs-convert
In-Reply-To: <cover.1426812639.git.sebth@naju.se>
Message-ID: <5280bf63aa02e4e0c08e70f842e3566693d6a20c.1426812639.git.sebth@naju.se>
References: <cover.1426812639.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

convert-tests now test both 4096 and 16384 nodesizes.

Signed-off-by: Sebastian Thorarensen <sebth@naju.se>
---
 tests/convert-tests.sh |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 6094287..3d912f3 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -16,7 +16,8 @@ rm -f convert-tests-results.txt
 
 test(){
 	echo "    [TEST]   $1"
-	shift
+	nodesize=$2
+	shift 2
 	echo "creating ext image with: $*" >> convert-tests-results.txt
 	# 256MB is the smallest acceptable btrfs image.
 	rm -f $here/test.img >> convert-tests-results.txt 2>&1 \
@@ -25,13 +26,17 @@ test(){
 		|| _fail "could not create test image file"
 	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
 		|| _fail "filesystem create failed"
-	$here/btrfs-convert $here/test.img >> convert-tests-results.txt 2>&1 \
+	$here/btrfs-convert -N "$nodesize" $here/test.img \
+			>> convert-tests-results.txt 2>&1 \
 		|| _fail "btrfs-convert failed"
 	$here/btrfs check $here/test.img >> convert-tests-results.txt 2>&1 \
 		|| _fail "btrfs check detected errors"
 }
 
 # btrfs-convert requires 4k blocksize.
-test "ext2" mke2fs -b 4096
-test "ext3" mke2fs -j -b 4096
-test "ext4" mke2fs -t ext4 -b 4096
+test "ext2 4k nodesize" 4096 mke2fs -b 4096
+test "ext3 4k nodesize" 4096 mke2fs -j -b 4096
+test "ext4 4k nodesize" 4096 mke2fs -t ext4 -b 4096
+test "ext2 16k nodesize" 16384 mke2fs -b 4096
+test "ext3 16k nodesize" 16384 mke2fs -j -b 4096
+test "ext4 16k nodesize" 16384 mke2fs -t ext4 -b 4096
-- 
1.7.10.4
