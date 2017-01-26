Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:44694
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752658AbdAZTtD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 14:49:03 -0500
Date: Fri, 27 Jan 2017 01:09:26 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck-tests: script to verify init-csum-tree
Message-ID: <20170126193926.GA12017@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Corrupt csum entry of a file and re-create csum tree using --init-csum

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 .../fsck-tests/025-verify-init-csum-option/test.sh | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100755 tests/fsck-tests/025-verify-init-csum-option/test.sh

diff --git a/tests/fsck-tests/025-verify-init-csum-option/test.sh b/tests/fsck-tests/025-verify-init-csum-option/test.sh
new file mode 100755
index 0000000..f496b33
--- /dev/null
+++ b/tests/fsck-tests/025-verify-init-csum-option/test.sh
@@ -0,0 +1,38 @@
+#!/bin/bash
+# This is a basic script to verify --init-csum recreates the csum tree.
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
+
+# simulate missing csum error and repair using init-csum option
+test_csum_corruption()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+
+	export DATASET_SIZE=1
+	generate_dataset small
+
+	run_check_umount_test_dev
+
+	# find bytenr
+	bytenr=`$SUDO_HELPER $TOP/btrfs inspect-internal dump-tree -t csum $TEST_DEV | \
+        sed -n -r 's/.*EXTENT_CSUM (.*)\) itemoff .*/\1/p'`
+
+	# corrupt csum bytenr
+	run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -C $bytenr $TEST_DEV
+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV &>> $RESULTS && \
+			_fail "btrfs check failed to detect missing csum."
+	run_check $SUDO_HELPER $TOP/btrfs check --repair --init-csum $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check  $TEST_DEV
+}
+
+test_csum_corruption
-- 
2.7.4

