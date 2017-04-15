Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:42272
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdDOJVa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 05:21:30 -0400
Date: Sat, 15 Apr 2017 14:42:48 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, dsterba@suse.cz
Subject: [PATCH v4] btrfs-progs: fsck-tests: verify 'btrfs check --repair'
 fixes corrupted nlink field
Message-ID: <20170415091248.GA6323@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 5cdcc57b8d599f03fe692e0285ee9e17f32267fa
Author: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
Date:   Sat Apr 15 14:26:20 2017 +0530

    btrfs-progs: fsck-tests: verify 'btrfs check --repair' fixes corrupted nlink field
    
    Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>

diff --git a/tests/fsck-tests/026-check-inode-link/test.sh b/tests/fsck-tests/026-check-inode-link/test.sh
new file mode 100755
index 0000000..3a7a3c1
--- /dev/null
+++ b/tests/fsck-tests/026-check-inode-link/test.sh
@@ -0,0 +1,38 @@
+#!/bin/bash
+# verify that 'btrfs check --repair' fixes corrupted inode nlink field
+
+source $TOP/tests/common
+
+check_prereq btrfs-corrupt-block
+check_prereq mkfs.btrfs
+
+setup_root_helper
+prepare_test_dev
+
+test_inode_nlink_field()
+{
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+
+	run_check_mount_test_dev
+	run_check $SUDO_HELPER touch "$TEST_MNT/test_nlink.txt"
+
+	# find inode_number
+	inode_number=`stat -c%i "$TEST_MNT/test_nlink.txt"`
+	run_check_umount_test_dev
+
+	# corrupt nlink field of inode object
+        run_check $SUDO_HELPER "$TOP/btrfs-corrupt-block" -i "$inode_number" \
+		-f nlink "$TEST_DEV"
+
+	check_image "$TEST_DEV"
+
+	# verify link count
+	run_check_mount_test_dev
+	link_count=`stat -c%h "$TEST_MNT/test_nlink.txt"`
+	run_check_umount_test_dev
+	if [ "$link_count" != 1 ];then
+		_fail "btrfs check --repair: Unable to fix nlink corruption."
+	fi
+}
+
+test_inode_nlink_field
