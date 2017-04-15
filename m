Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:54368
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdDOKOP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 06:14:15 -0400
Date: Sat, 15 Apr 2017 15:43:08 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: dsterba@suse.cz, quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v4] btrfs-progs: misc-tests: Superblock corruption and
 recovery using backup
Message-ID: <20170415101308.GA7614@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 .../020-fix-superblock-corruption/test.sh          | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100755 tests/misc-tests/020-fix-superblock-corruption/test.sh

diff --git a/tests/misc-tests/020-fix-superblock-corruption/test.sh b/tests/misc-tests/020-fix-superblock-corruption/test.sh
new file mode 100755
index 0000000..0faebad
--- /dev/null
+++ b/tests/misc-tests/020-fix-superblock-corruption/test.sh
@@ -0,0 +1,35 @@
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
+prepare_test_dev
+
+FIRST_SUPERBLOCK_OFFSET=65536
+
+test_superblock_restore()
+{
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+
+	# Corrupt superblock checksum
+        run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_DEV" \
+	seek="$FIRST_SUPERBLOCK_OFFSET" bs=1 count=4 conv=notrunc
+
+	# Run btrfs check to detect corruption
+	run_mayfail "$TOP/btrfs" check "$TEST_DEV" && \
+		_fail "btrfs check should detect corruption"
+
+	# Copy backup superblock to primary
+	run_check "$TOP/btrfs-select-super" -s 1 "$TEST_DEV"
+
+	#Performing btrfs check
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+}
+
+test_superblock_restore
-- 
2.7.4

