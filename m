Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:47985 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161356Ab3BONGd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 08:06:33 -0500
Received: by mail-da0-f41.google.com with SMTP id e20so1494134dak.28
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 05:06:32 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, hugo@carfax.org.uk, sandeen@redhat.com,
        Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [btrfs-progs] testing btrfs hierarchical quotas
Date: Fri, 15 Feb 2013 18:35:41 +0530
Message-Id: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 hq.sh | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 hq.sh

diff --git a/hq.sh b/hq.sh
new file mode 100644
index 0000000..6a0a820
--- /dev/null
+++ b/hq.sh
@@ -0,0 +1,33 @@
+#! /bin/bash
+# Btrfs quotas test case
+# Hi all,
+# This is shell script to test the hierarchical quotas feature of Btrfs
+# I created Btrfs filesystem on a new
+# partition, then activated quota management ('btrfs quota enable'), and
+# created a few subvolumes of multiple levels.
+
+
+cleanup()
+{
+    btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
+    btrfs subvolume delete $TEST_DIR/vol1/vol2
+    btrfs subvolume delete $TEST_DIR/vol1
+    btrfs subvolume disable $TEST_DIR
+}
+
+#trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+btrfs quota enable $TEST_DIR
+echo "quota enabled on $TEST_DEV"
+btrfs subvolume create $TEST_DIR/vol1
+btrfs subvolume create $TEST_DIR/vol1/vol2
+btrfs subvolume create $TEST_DIR/vol1/vol2/vol3
+btrfs qgroup limit 5m $TEST_DIR/vol1
+btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
+btrfs qgroup limit 2m $TEST_DIR/vol1/vol2/vol3
+dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file1 bs=3M count=1
+dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file1 bs=2M count=1
+dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1
+
+cleanup
+exit
-- 
1.8.1.2

