Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:36536
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdBBIGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 03:06:09 -0500
Date: Thu, 2 Feb 2017 13:35:02 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: quwenruo@cn.fujitsu.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs-progs: fsck-tests: verify 'btrfs check --repair'
 fixes corrupted nlink field
Message-ID: <20170202080502.GA6676@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/fsck-tests/026-check-inode-link/test.sh | 30 +++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100755 tests/fsck-tests/026-check-inode-link/test.sh

diff --git a/tests/fsck-tests/026-check-inode-link/test.sh b/tests/fsck-tests/026-check-inode-link/test.sh
new file mode 100755
index 0000000..6822ee2
--- /dev/null
+++ b/tests/fsck-tests/026-check-inode-link/test.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+# verify that 'btrfs check --repair' fixes corrupted inode nlink field
+
+source $TOP/tests/common
+
+check_prereq btrfs-corrupt-block
+check_prereq mkfs.btrfs
+
+setup_root_helper
+prepare_test_dev 512M
+
+test_inode_nlink_field()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+	run_check $SUDO_HELPER touch $TEST_MNT/test_nlink.txt
+
+	# find inode_number
+	inode_number=`stat -c%i $TEST_MNT/test_nlink.txt`
+	run_check_umount_test_dev
+
+	# corrupt nlink field of inode object
+        run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -i $inode_number \
+		-f nlink $TEST_DEV
+
+	check_image $TEST_DEV
+}
+
+test_inode_nlink_field
-- 
2.7.4

