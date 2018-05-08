Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6052 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752214AbeEHFsU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 01:48:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5FC554B34D40
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 13:48:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: tests: check btrfs qgroup parent-child relation output
Date: Tue, 8 May 2018 13:48:03 +0800
Message-ID: <20180508054803.20851-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
References: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit aaf2dac5ef37 ("btrfs-progs: qgroup: split update_qgroup to
reduce arguments") cause qgroup show to output the wrong qgroup
parent-child relationship, in addition to fixing the problem, a test case
is needed to prevent the similar problem in the future.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 .../031-qgroup-parent-child-relation/test.sh  | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100755 tests/misc-tests/031-qgroup-parent-child-relation/test.sh

diff --git a/tests/misc-tests/031-qgroup-parent-child-relation/test.sh b/tests/misc-tests/031-qgroup-parent-child-relation/test.sh
new file mode 100755
index 000000000000..5be32aef58d9
--- /dev/null
+++ b/tests/misc-tests/031-qgroup-parent-child-relation/test.sh
@@ -0,0 +1,27 @@
+#!/bin/bash
+# Test that btrfs qgroup show output the correct parent-child qgroup relation
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+
+run_check $SUDO_HELPER "$TOP/btrfs" quota enable "$TEST_MNT"
+run_check $SUDO_HELPER "$TOP/btrfs" qgroup create 1/0 "$TEST_MNT"
+run_check $SUDO_HELPER "$TOP/btrfs" qgroup assign 0/5 1/0 "$TEST_MNT"
+run_check $SUDO_HELPER "$TOP/btrfs" quota rescan -w "$TEST_MNT"
+
+run_check_stdout $SUDO_HELPER "$TOP/btrfs" qgroup show --sort=-qgroupid \
+	-p "$TEST_MNT" | tail -n 1 | grep -q "1/0" \
+	|| _fail "parent qgroup check failed, please check the log"
+run_check_stdout $SUDO_HELPER "$TOP/btrfs" qgroup show --sort=qgroupid \
+	-c "$TEST_MNT" | tail -n 1 | grep -q "0/5" \
+	|| _fail "child qgroup check failed, please check the log"
+
+run_check_umount_test_dev "$TEST_MNT"
-- 
2.17.0



