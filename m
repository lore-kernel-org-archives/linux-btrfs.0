Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28547 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932530AbdJRCBD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 22:01:03 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 279F0AC00A7
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 11:01:00 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: test: add new cli-test for subvol
 get/set-default
Message-ID: <ac41cb86-7571-0c56-aa3b-29696bb1389b@jp.fujitsu.com>
Date: Wed, 18 Oct 2017 11:00:43 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new test to check functionality of subvol get/set-default.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 .../008-subvolume-get-set-default/test.sh          | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100755 tests/cli-tests/008-subvolume-get-set-default/test.sh

diff --git a/tests/cli-tests/008-subvolume-get-set-default/test.sh b/tests/cli-tests/008-subvolume-get-set-default/test.sh
new file mode 100755
index 0000000..5ea473b
--- /dev/null
+++ b/tests/cli-tests/008-subvolume-get-set-default/test.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+# test for "subvolume get-default/set-default"
+
+check_default_id()
+{
+	id=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" sub get-def .) \
+		|| { echo "$id"; exit 1; }
+	if $(echo "$id" | grep -vq "ID $1"); then
+		_fail "subvolume get-default: default id is not $1, but $id"
+	fi
+}
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 2g
+
+run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+cd "$TEST_MNT"
+
+check_default_id 5
+
+# check "subvol set-default <subvolid> <path>"
+run_check "$TOP/btrfs" subvol create sub
+run_check $SUDO_HELPER "$TOP/btrfs" subvol set-default 257 .
+check_default_id 257
+
+run_mustfail "set-default to non existent id" \
+	$SUDO_HELPER "$TOP/btrfs" subvol set-default 100 .
+
+# check "subvol set-default <subvolume>"
+run_check "$TOP/btrfs" subvol create sub2
+run_check $SUDO_HELPER "$TOP/btrfs" subvol set-default ./sub2
+check_default_id 258
+
+run_check mkdir sub2/dir
+run_mustfail "set-default to normal directory" \
+	$SUDO_HELPER "$TOP/btrfs" subvol set-default ./sub2/dir
+
+cd ..
+run_check_umount_test_dev
-- 
2.9.5

