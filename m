Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45891 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936012Ab3BOMph (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:37 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so602679pbc.14
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 04:45:36 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, hugo@carfax.org.uk, sandeen@redhat.com,
        Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [btrfs-progs] Btrfs quotas testing
Date: Fri, 15 Feb 2013 18:15:24 +0530
Message-Id: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 quotas.sh | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 quotas.sh

diff --git a/quotas.sh b/quotas.sh
new file mode 100644
index 0000000..7e64578
--- /dev/null
+++ b/quotas.sh
@@ -0,0 +1,30 @@
+#! /bin/bash
+# Btrfs quotas test case
+# Hi all,
+# This is shell script to test the quotas feature of Btrfs
+# I created Btrfs filesystem on a new
+# partition, then activated quota management ('btrfs quota enable'), and
+# created a few subvolumes.
+# I have lmited the quota to 2mb and tried filling it
+# its working as expected
+
+
+cleanup()
+{
+    btrfs subvolume delete $TEST_DIR/vol1
+    btrfs subvolume disable $TEST_DIR
+}
+
+#trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+btrfs quota enable $TEST_DIR
+echo "quota enabled on $TEST_DEV"
+btrfs subvolume create $TEST_DIR/vol1
+echo "vol1 created"
+btrfs qgroup show $TEST_DIR
+btrfs qgroup limit 2m $TEST_DIR/vol1
+echo "qgroup limited to 2mb"
+dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=3M count=1
+echo "tried to write 3m worth data"
+cleanup
+exit
-- 
1.8.1.2

