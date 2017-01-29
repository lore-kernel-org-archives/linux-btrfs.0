Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:44498
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdA2Oqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 09:46:31 -0500
Received: from [117.222.161.181] (port=49682 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <Lakshmipathi.G@giis.co.in>)
        id 1cXqiy-00006o-Gp
        for linux-btrfs@vger.kernel.org; Sun, 29 Jan 2017 07:45:01 -0700
Date: Sun, 29 Jan 2017 20:14:55 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: cli-tests: Convert non-raid filesystem to raid
Message-ID: <20170129144455.GA12174@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simple script to verify non-raid filesystem conversion.

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/cli-tests/005-convert-btrfs-to-raid/test.sh | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100755 tests/cli-tests/005-convert-btrfs-to-raid/test.sh

diff --git a/tests/cli-tests/005-convert-btrfs-to-raid/test.sh b/tests/cli-tests/005-convert-btrfs-to-raid/test.sh
new file mode 100755
index 0000000..96772de
--- /dev/null
+++ b/tests/cli-tests/005-convert-btrfs-to-raid/test.sh
@@ -0,0 +1,32 @@
+#!/bin/bash
+#
+# convert non-raid btrfs to raid
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 1g
+run_check truncate -s1g img
+
+run_check $TOP/mkfs.btrfs -f $IMAGE
+run_check_mount_test_dev
+
+loopdev=$(run_check_stdout $SUDO_HELPER losetup --partscan --find --show img)
+
+run_check $SUDO_HELPER $TOP/btrfs device add $loopdev $TEST_MNT
+run_check $SUDO_HELPER $TOP/btrfs balance start -dconvert=raid1 -mconvert=raid1 $TEST_MNT
+
+run_check_stdout $SUDO_HELPER $TOP/btrfs filesystem show $loopdev | grep "Total devices 2" -q
+if [ $? -ne 0 ]; then
+	run_check $SUDO_HELPER losetup -d $loopdev
+	rm -f img
+        _fail "Conversion from non-raid filesystem to raid failed."
+fi
+run_check_umount_test_dev
+
+# cleanup
+run_check $SUDO_HELPER losetup -d $loopdev
+rm -f img
-- 
2.7.4

