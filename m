Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:59058
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbdBNVci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 16:32:38 -0500
Received: from [42.109.217.201] (port=28955 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <Lakshmipathi.G@giis.co.in>)
        id 1cdkhE-0003yK-QA
        for linux-btrfs@vger.kernel.org; Tue, 14 Feb 2017 14:31:37 -0700
Date: Wed, 15 Feb 2017 03:01:25 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: misc-tests: Primary Superblock corruption and
 recovery using backup Superblock.
Message-ID: <20170214213125.GA25514@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 .../019-fix-corrupted-superblock/test.sh           | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100755 tests/misc-tests/019-fix-corrupted-superblock/test.sh

diff --git a/tests/misc-tests/019-fix-corrupted-superblock/test.sh b/tests/misc-tests/019-fix-corrupted-superblock/test.sh
new file mode 100755
index 0000000..806c775
--- /dev/null
+++ b/tests/misc-tests/019-fix-corrupted-superblock/test.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+#
+# Corrupt primary superblock and restore it using backup superblock.
+#
+
+source $TOP/tests/common
+
+check_prereq btrfs-select-super
+
+setup_root_helper
+prepare_test_dev 512M
+
+superblock_offset=65536
+
+test_superblock_restore()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	# Corrupt superblock checksum
+        dd if=/dev/zero of=$TEST_DEV seek=$superblock_offset bs=1 \
+        count=4  conv=notrunc &> /dev/null
+	run_check_stdout $SUDO_HELPER mount $TEST_DEV $TEST_MNT | \
+	grep -q 'wrong fs type'
+        if [ $? -ne 0 ]; then
+		_fail "Failed to corrupt superblock."
+        fi 
+
+	# Copy backup superblock to primary
+	run_check $TOP/btrfs-select-super -s 1 $TEST_DEV
+	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
+        if [ $? -ne 0 ]; then
+		_fail "Failed to fix superblock."
+        fi 
+	run_check_umount_test_dev
+}
+
+test_superblock_restore
-- 
2.7.4

