Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:54959 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751535AbdDCUVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 16:21:19 -0400
From: Christian Brauner <christian.brauner@ubuntu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 2/2 v2] tests: use receive -e to terminate on end marker
Date: Mon,  3 Apr 2017 22:21:08 +0200
Message-Id: <20170403202108.14859-3-christian.brauner@ubuntu.com>
In-Reply-To: <20170403202108.14859-1-christian.brauner@ubuntu.com>
References: <20170403202108.14859-1-christian.brauner@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 tests/misc-tests/018-recv-end-of-stream/test.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/misc-tests/018-recv-end-of-stream/test.sh b/tests/misc-tests/018-recv-end-of-stream/test.sh
index d39683e9..90655929 100755
--- a/tests/misc-tests/018-recv-end-of-stream/test.sh
+++ b/tests/misc-tests/018-recv-end-of-stream/test.sh
@@ -34,7 +34,7 @@ test_full_empty_stream() {
 
 	run_check $TOP/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$str" "$TEST_MNT"
+	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$str" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$str"
@@ -65,7 +65,7 @@ test_full_simple_stream() {
 
 	run_check $TOP/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$str" "$TEST_MNT"
+	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$str" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$str"
@@ -96,8 +96,8 @@ test_incr_empty_stream() {
 
 	run_check $TOP/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$fstr" "$TEST_MNT"
-	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$istr" "$TEST_MNT"
+	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$fstr" "$TEST_MNT"
+	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$istr" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$fstr" "$istr"
@@ -136,8 +136,8 @@ test_incr_simple_stream() {
 
 	run_check $TOP/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$fstr" "$TEST_MNT"
-	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$istr" "$TEST_MNT"
+	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$fstr" "$TEST_MNT"
+	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$istr" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$fstr" "$istr"
-- 
2.11.0

