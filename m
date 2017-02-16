Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:53552
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933429AbdBPWdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 17:33:14 -0500
Date: Fri, 17 Feb 2017 04:01:59 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs-progs: misc-tests: Superblock corruption and
 recovery using backup.
Message-ID: <20170216223159.GA23242@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test script to recover damaged primary superblock using backup superblock.

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 .../019-fix-superblock-corruption/test.sh          | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100755 tests/misc-tests/019-fix-superblock-corruption/test.sh

diff --git a/tests/misc-tests/019-fix-superblock-corruption/test.sh b/tests/misc-tests/019-fix-superblock-corruption/test.sh
new file mode 100755
index 0000000..95815e4
--- /dev/null
+++ b/tests/misc-tests/019-fix-superblock-corruption/test.sh
@@ -0,0 +1,36 @@
+#!/bin/bash
+#
+# Corrupt primary superblock and restore it using backup superblock.
+#
+
+source $TOP/tests/common
+
+check_prereq btrfs-select-super
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 512M
+
+FIRST_SUPERBLOCK_OFFSET=65536
+
+test_superblock_restore()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	# Corrupt superblock checksum
+        dd if=/dev/zero of=$TEST_DEV seek=$FIRST_SUPERBLOCK_OFFSET bs=1 \
+        count=4  conv=notrunc &> /dev/null
+	# Run btrfs check to detect corruption
+	$TOP/btrfs check $TEST_DEV >& /dev/null && \
+		_fail "btrfs check should detect corruption"
+	# Copy backup superblock to primary
+	run_check $TOP/btrfs-select-super -s 1 $TEST_DEV
+
+	echo "Performing btrfs check" &>> $RESULTS
+	$TOP/btrfs check $TEST_DEV &>> $RESULTS
+        if [ $? -ne 0 ]; then
+		_fail "Failed to fix superblock."
+        fi
+}
+
+test_superblock_restore
-- 
2.7.4

