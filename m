Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56688 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbaFLQIk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 12:08:40 -0400
Received: by mail-pd0-f169.google.com with SMTP id w10so1123113pde.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 09:08:40 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] Use sparse files for filesystem conversion tests.
Date: Thu, 12 Jun 2014 09:08:33 -0700
Message-Id: <1402589313-15493-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On my system, this brings the FS conversion test suite's runtime from over
ten seconds down to under two.

Thanks to Julien Muchembled for the suggestion.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 tests/convert-tests.sh | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 87369c5..9f7a5c8 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -13,15 +13,16 @@ _fail()
 }
 
 rm -f convert-tests-results.txt
-rm -f test.img
 
 test(){
 	echo "     [TEST]    $1"
-        shift
-        echo "creating ext image with: $*" >> convert-tests-results.txt
+	shift
+	echo "creating ext image with: $*" >> convert-tests-results.txt
 	# 256MB is the smallest acceptable btrfs image.
-	dd if=/dev/zero of=$here/test.img bs=1024 count=$((256*1024)) \
-		>> convert-tests-results.txt 2>&1 || _fail "dd failed"
+	rm -f $here/test.img >> convert-tests-results.txt 2>&1 \
+		|| _fail "could not remove test image file"
+	truncate -s 256M $here/test.img >> convert-tests-results.txt 2>&1 \
+		|| _fail "could not create test image file"
 	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
 		|| _fail "filesystem create failed"
 	$here/btrfs-convert $here/test.img >> convert-tests-results.txt 2>&1 \
@@ -30,6 +31,7 @@ test(){
 		|| _fail "btrfsck detected errors"
 }
 
-test "ext2, 4k blocksize" mke2fs -b 4096
-test "ext3, 4k blocksize" mke2fs -j -b 4096
-test "ext4, 4k blocksize" mke2fs -t ext4 -b 4096
+# btrfs-convert requires 4k blocksize.
+test "ext2" mke2fs -b 4096
+test "ext3" mke2fs -j -b 4096
+test "ext4" mke2fs -t ext4 -b 4096
-- 
2.0.0.526.g5318336

