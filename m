Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47321 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbbH1DoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 23:44:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7S3i0K8010343
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 11:44:00 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: tests: Introduce subvolume sync test
Date: Fri, 28 Aug 2015 11:42:11 +0800
Message-ID: <0375c5ddbbc6f00df7f67265df81d71cfd2ab0f8.1440733313.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code have following bug for subvolume sync:
1: If there are more than 1 subvolume to sync, the program will
   infinitely loop.
2: return !0 in exit

This patch add misc-tests/007-subvolume-sync for above case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/misc-tests/007-subvolume-sync/test.sh | 32 +++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100755 tests/misc-tests/007-subvolume-sync/test.sh

diff --git a/tests/misc-tests/007-subvolume-sync/test.sh b/tests/misc-tests/007-subvolume-sync/test.sh
new file mode 100755
index 0000000..d4019f4
--- /dev/null
+++ b/tests/misc-tests/007-subvolume-sync/test.sh
@@ -0,0 +1,32 @@
+#!/bin/bash
+# test btrfs subvolume run normally with more than one subvolume
+#
+# - btrfs subvolume must not loop indefinetelly
+# - btrfs subvolume return 0 in normal case
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$TEST_DEV"
+run_check $SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"
+
+# to check following thing in both 1 and multiple subvolume case:
+# 1: is subvolume sync loop indefinetelly
+# 2: is return value right
+#
+run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol1
+run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol2
+run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol1
+run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol2
+run_check $SUDO_HELPER $TOP/btrfs subvolume sync "$TEST_MNT"
+
+run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol
+run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol
+run_check $SUDO_HELPER $TOP/btrfs subvolume sync "$TEST_MNT"
+
+run_check $SUDO_HELPER umount $TEST_MNT
-- 
1.8.5.1

