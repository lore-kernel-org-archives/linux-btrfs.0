Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56066 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750795AbeBBIeT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:34:19 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <quwenruo.btrfs@gmx.com>
Subject: [RFC PATCH v2 3/4] btrfs-progs: Modify rootdir files when use mkfs.btrfs
Date: Fri, 2 Feb 2018 16:34:04 +0800
Message-ID: <1517560445-5712-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since there is no $TOP/Documentation file after package the testsuite.
So use a common file that is usually exsits.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 tests/misc-tests/002-uuid-rewrite/test.sh       | 4 ++--
 tests/misc-tests/003-zero-log/test.sh           | 2 +-
 tests/mkfs-tests/004-rootdir-keeps-size/test.sh | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/misc-tests/002-uuid-rewrite/test.sh b/tests/misc-tests/002-uuid-rewrite/test.sh
index 158bda90..27341322 100755
--- a/tests/misc-tests/002-uuid-rewrite/test.sh
+++ b/tests/misc-tests/002-uuid-rewrite/test.sh
@@ -25,7 +25,7 @@ test_uuid_random()
 
 	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
 		--uuid $origuuid \
-		--rootdir $TOP/Documentation \
+		--rootdir /lib/modules/`uname -r`/ \
 		$TEST_DEV
 	run_check $EXEC/btrfs inspect-internal dump-super "$TEST_DEV"
 	currentfsid=$(run_check_stdout $EXEC/btrfstune -f -u $TEST_DEV | \
@@ -47,7 +47,7 @@ test_uuid_user()
 
 	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
 		--uuid $origuuid \
-		--rootdir $TOP/Documentation \
+		--rootdir /lib/modules/`uname -r`/ \
 		$TEST_DEV
 	run_check $EXEC/btrfs inspect-internal dump-super "$TEST_DEV"
 	run_check $EXEC/btrfstune -f -U $newuuid \
diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/003-zero-log/test.sh
index 0f3d3cd6..db1b1c67 100755
--- a/tests/misc-tests/003-zero-log/test.sh
+++ b/tests/misc-tests/003-zero-log/test.sh
@@ -27,7 +27,7 @@ test_zero_log()
 {
 	# FIXME: we need an image with existing log_root
 	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
-		--rootdir $TOP/Documentation \
+		--rootdir /lib/modules/`uname -r`/ \
 		$TEST_DEV
 	run_check $EXEC/btrfs inspect-internal dump-super $TEST_DEV
 	if [ "$1" = 'standalone' ]; then
diff --git a/tests/mkfs-tests/004-rootdir-keeps-size/test.sh b/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
index c8d920a5..3c53a1a7 100755
--- a/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
+++ b/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
@@ -16,7 +16,7 @@ test_mkfs_with_size() {
 	run_check truncate -s$size $TEST_DEV
 	imgsize=$(run_check_stdout stat --format=%s $TEST_DEV)
 	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
-		--rootdir $EXEC/Documentation \
+		--rootdir /lib/modules/`uname -r`/ \
 		$TEST_DEV
 	tmp=$(run_check_stdout stat --format=%s $TEST_DEV)
 	if ! [ "$imgsize" = "$tmp" ]; then
-- 
2.14.3



