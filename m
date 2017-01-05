Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq6.tb.mail.iss.as9143.net ([212.54.42.169]:36660 "EHLO
        smtpq6.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936659AbdAEVRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 16:17:08 -0500
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq6.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cPFOK-00034x-66
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 22:16:08 +0100
Received: from dhcp-077-251-197-105.chello.nl ([77.251.197.105] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cPFO9-00068x-O2
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 22:16:08 +0100
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id v05LFNNJ021730
        for <linux-btrfs@vger.kernel.org>; Thu, 5 Jan 2017 22:15:33 +0100
Received: (from root@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id v05LFDir021676
        for linux-btrfs@vger.kernel.org; Thu, 5 Jan 2017 22:15:13 +0100
Date: Thu, 5 Jan 2017 22:15:13 +0100
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck-tests: corrupt and detect dir_item name
 (with fix)
Message-ID: <20170105211513.GA19134@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore previous 026-dir-item-name-corruption script,it breaks fsck-tests.sh. Use this one instead.

This test script aims to detects the corruption even though looks like --repair 
wont fix the issue.

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 .../026-dir-item-name-corruption/test.sh           | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100755 tests/fsck-tests/026-dir-item-name-corruption/test.sh

diff --git a/tests/fsck-tests/026-dir-item-name-corruption/test.sh b/tests/fsck-tests/026-dir-item-name-corruption/test.sh
new file mode 100755
index 0000000..6e76513
--- /dev/null
+++ b/tests/fsck-tests/026-dir-item-name-corruption/test.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+
+source $TOP/tests/common
+
+check_prereq btrfs-corrupt-block
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 512M
+
+ROOT_NODE=256
+BTRFS_DIR_ITEM_KEY=84
+
+# test whether fsck can detect a corrupted dir item name
+test_dir_item_name_field()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+	run_check $SUDO_HELPER touch $TEST_MNT/testfile.txt
+
+	run_check_umount_test_dev
+
+	# find key offset
+	key_offset=`$SUDO_HELPER $TOP/btrfs-debug-tree -t FS_TREE $TEST_DEV | \
+	grep -B3 'testfile.txt'  | grep "$ROOT_NODE DIR_ITEM" | \
+	cut -f1 -d')' | awk '{print $6}'`
+
+	key=$ROOT_NODE","$BTRFS_DIR_ITEM_KEY","$key_offset
+
+	# corrupt dir item name
+        run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -D -f name \
+		-K $key $TEST_DEV
+
+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
+			_fail "btrfs check failed to detect corruption"
+	run_check $SUDO_HELPER $TOP/btrfs check --repair $TEST_DEV
+}
+
+test_dir_item_name_field
-- 
2.7.4

