Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:59144
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750937AbdA1Kse (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 05:48:34 -0500
Date: Sat, 28 Jan 2017 16:17:26 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: quwenruo@cn.fujitsu.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck-tests: verify 'btrfs check --repair' fixes
 corrupted nlink field
Message-ID: <20170128104726.GA4757@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/fsck-tests/026-check-inode-link/test.sh | 34 +++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100755 tests/fsck-tests/026-check-inode-link/test.sh

diff --git a/tests/fsck-tests/026-check-inode-link/test.sh b/tests/fsck-tests/026-check-inode-link/test.sh
new file mode 100755
index 0000000..9e75ef4
--- /dev/null
+++ b/tests/fsck-tests/026-check-inode-link/test.sh
@@ -0,0 +1,34 @@
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
+# verify that 'btrfs check --repair' fixes corrupted inode nlink field.
+test_inode_nlink_field()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+	run_check $SUDO_HELPER touch $TEST_MNT/test_nlink.txt
+
+	# find inode_item id
+	inode_item=`stat -c%i $TEST_MNT/test_nlink.txt`
+	run_check_umount_test_dev
+
+	# corrupt nlink field of inode object
+        run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -i $inode_item \
+		-f nlink $TEST_DEV
+
+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV &>> $RESULTS && \
+			_fail "btrfs check failed to detect nlink corruption"
+	run_check $SUDO_HELPER $TOP/btrfs check --repair $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+}
+
+test_inode_nlink_field
-- 
2.7.4

