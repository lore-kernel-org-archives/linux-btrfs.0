Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:38347 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932887AbdAHHYI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Jan 2017 02:24:08 -0500
Received: from [212.54.42.115] (helo=lsmtp1.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cQ7pl-0001lx-J7
        for linux-btrfs@vger.kernel.org; Sun, 08 Jan 2017 08:24:05 +0100
Received: from dhcp-077-251-197-105.chello.nl ([77.251.197.105] helo=webminal.org)
        by lsmtp1.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cQ7pa-0005Xe-M8
        for linux-btrfs@vger.kernel.org; Sun, 08 Jan 2017 08:24:05 +0100
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id v07NK5rM028472
        for <linux-btrfs@vger.kernel.org>; Sun, 8 Jan 2017 00:20:15 +0100
Received: (from root@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id v07NJt4t028209
        for linux-btrfs@vger.kernel.org; Sun, 8 Jan 2017 00:19:55 +0100
Date: Sun, 8 Jan 2017 00:19:55 +0100
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
Message-ID: <20170107231955.GA24631@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/fsck-tests/025-wrong-inode-nlink/test.sh | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100755 tests/fsck-tests/025-wrong-inode-nlink/test.sh

diff --git a/tests/fsck-tests/025-wrong-inode-nlink/test.sh b/tests/fsck-tests/025-wrong-inode-nlink/test.sh
new file mode 100755
index 0000000..15f1b84
--- /dev/null
+++ b/tests/fsck-tests/025-wrong-inode-nlink/test.sh
@@ -0,0 +1,37 @@
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
+# test whether fsck can fix a corrupted inode nlink
+test_inode_nlink_field()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+	run_check $SUDO_HELPER touch $TEST_MNT/test_nlink.txt
+
+	run_check_umount_test_dev
+
+	# find inode_item id
+	inode_item=`$SUDO_HELPER $TOP/btrfs-debug-tree -t FS_TREE $TEST_DEV | \
+	grep -B3 "test_nlink.txt" |  grep INODE_ITEM | \
+	cut -f2 -d'(' | cut -f1 -d' ' | head -n1`
+
+	# corrupt nlink field of inode object:257
+        run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -i $inode_item \
+		-f nlink $TEST_DEV
+
+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
+			_fail "btrfs check failed to detect nlink corruption"
+	run_check $SUDO_HELPER $TOP/btrfs check --repair $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+}
+
+test_inode_nlink_field
-- 
2.7.4

