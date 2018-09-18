Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64618 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729192AbeIRORA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 10:17:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2058B4B6EC8D
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 16:45:11 +0800 (CST)
From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: tests: Add the testcase for subvolume name length limit test
Date: Tue, 18 Sep 2018 16:44:48 +0800
Message-ID: <20180918084448.14195-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Total of three conditions are tested. One for short name, one with
name length 255, the last one with more than 255.

This case should pass after commit
'btrfs-progs: change filename limit to 255 when creating subvolume'.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 .../033-filename-length-limit/test.sh         | 86 +++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100755 tests/misc-tests/033-filename-length-limit/test.sh

diff --git a/tests/misc-tests/033-filename-length-limit/test.sh b/tests/misc-tests/033-filename-length-limit/test.sh
new file mode 100755
index 000000000000..7764ad9b584c
--- /dev/null
+++ b/tests/misc-tests/033-filename-length-limit/test.sh
@@ -0,0 +1,86 @@
+#!/bin/bash
+#
+# test file name length limit settings
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+
+prepare_test_dev
+run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+run_check $SUDO_HELPER chmod a+rw "$TEST_MNT"
+
+cd "$TEST_MNT"
+
+longname=\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+0123456789\
+\
+01234
+
+#
+# subvolume name length limit test
+#
+
+# short name test
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create aaa
+# 255
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$longname"
+# 256, must fail
+run_mustfail "name 256 bytes long succeeded" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume create "$longname"5
+# 255*2, must fail
+run_mustfail "name 2 * 255 bytes long succeeded" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume create "$longname$longname"
+
+#
+# snapshot name length limit test
+#
+
+run_check $SUDO_HELPER mkdir snaps
+
+# short name test
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot aaa snaps/bbb
+# 255
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot aaa snaps/"$longname"
+# 256, must fail
+run_mustfail "name 256 bytes long succeeded" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume snapshot aaa snaps/"$longname"5
+# 255*2, must fail
+run_mustfail "name 2 * 255 bytes long succeeded" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume snapshot aaa snaps/"$longname$longname"
+
+cd ..
+
+run_check_umount_test_dev
-- 
2.18.0
