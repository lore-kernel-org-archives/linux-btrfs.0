Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:47664
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdBOUvi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 15:51:38 -0500
Date: Thu, 16 Feb 2017 02:20:24 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: misc-tests: Superblock corruption and
 recovery using backup.
Message-ID: <20170215205024.GA2486@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 .../019-fix-superblock-corruption/test.sh          | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100755 tests/misc-tests/019-fix-superblock-corruption/test.sh

diff --git a/tests/misc-tests/019-fix-superblock-corruption/test.sh b/tests/misc-tests/019-fix-superblock-corruption/test.sh
new file mode 100755
index 0000000..55159dc
--- /dev/null
+++ b/tests/misc-tests/019-fix-superblock-corruption/test.sh
@@ -0,0 +1,38 @@
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
+	
+	# Run btrfs check to detect corruption
+	$TOP/btrfs check $TEST_DEV >& /dev/null && \
+		_fail "btrfs check should detect corruption"
+
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

