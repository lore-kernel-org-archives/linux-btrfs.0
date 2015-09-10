Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8090 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752666AbbIJCjl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 22:39:41 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 5/5] btrfs-progs: convert-test: Disable different nodesize test
Date: Thu, 10 Sep 2015 10:37:38 +0800
Message-ID: <1441852658-11385-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As now btrfs-convert is forced to used mixed block group, only test
pagesize as nodesize for convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests.sh | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 68c03dc..f6f4679 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -57,19 +57,25 @@ if ! [ -z "$TEST" ]; then
 fi
 
 for feature in '' 'extref' 'skinny-metadata' 'no-holes'; do
-	convert_test "$feature" "ext2 4k nodesize" 4096 mke2fs -b 4096
-	convert_test "$feature" "ext3 4k nodesize" 4096 mke2fs -j -b 4096
-	convert_test "$feature" "ext4 4k nodesize" 4096 mke2fs -t ext4 -b 4096
-	convert_test "$feature" "ext2 8k nodesize" 8192 mke2fs -b 4096
-	convert_test "$feature" "ext3 8k nodesize" 8192 mke2fs -j -b 4096
-	convert_test "$feature" "ext4 8k nodesize" 8192 mke2fs -t ext4 -b 4096
-	convert_test "$feature" "ext2 16k nodesize" 16384 mke2fs -b 4096
-	convert_test "$feature" "ext3 16k nodesize" 16384 mke2fs -j -b 4096
-	convert_test "$feature" "ext4 16k nodesize" 16384 mke2fs -t ext4 -b 4096
-	convert_test "$feature" "ext2 32k nodesize" 32768 mke2fs -b 4096
-	convert_test "$feature" "ext3 32k nodesize" 32768 mke2fs -j -b 4096
-	convert_test "$feature" "ext4 32k nodesize" 32768 mke2fs -t ext4 -b 4096
-	convert_test "$feature" "ext2 64k nodesize" 65536 mke2fs -b 4096
-	convert_test "$feature" "ext3 64k nodesize" 65536 mke2fs -j -b 4096
-	convert_test "$feature" "ext4 64k nodesize" 65536 mke2fs -t ext4 -b 4096
+	# Btrfs-convert is forced to use mixed-bg, so must use pagesize
+	# for nodesize right now
+	nodesize=`getconf PAGESIZE`
+	convert_test "$feature" "ext2 4k nodesize" $nodesize mke2fs -b 4096
+	convert_test "$feature" "ext3 4k nodesize" $nodesize mke2fs -b 4096
+	convert_test "$feature" "ext4 4k nodesize" $nodesize mke2fs -b 4096
+#	convert_test "$feature" "ext2 4k nodesize" 4096 mke2fs -b 4096
+#	convert_test "$feature" "ext3 4k nodesize" 4096 mke2fs -j -b 4096
+#	convert_test "$feature" "ext4 4k nodesize" 4096 mke2fs -t ext4 -b 4096
+#	convert_test "$feature" "ext2 8k nodesize" 8192 mke2fs -b 4096
+#	convert_test "$feature" "ext3 8k nodesize" 8192 mke2fs -j -b 4096
+#	convert_test "$feature" "ext4 8k nodesize" 8192 mke2fs -t ext4 -b 4096
+#	convert_test "$feature" "ext2 16k nodesize" 16384 mke2fs -b 4096
+#	convert_test "$feature" "ext3 16k nodesize" 16384 mke2fs -j -b 4096
+#	convert_test "$feature" "ext4 16k nodesize" 16384 mke2fs -t ext4 -b 4096
+#	convert_test "$feature" "ext2 32k nodesize" 32768 mke2fs -b 4096
+#	convert_test "$feature" "ext3 32k nodesize" 32768 mke2fs -j -b 4096
+#	convert_test "$feature" "ext4 32k nodesize" 32768 mke2fs -t ext4 -b 4096
+#	convert_test "$feature" "ext2 64k nodesize" 65536 mke2fs -b 4096
+#	convert_test "$feature" "ext3 64k nodesize" 65536 mke2fs -j -b 4096
+#	convert_test "$feature" "ext4 64k nodesize" 65536 mke2fs -t ext4 -b 4096
 done
-- 
2.5.1

