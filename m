Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:47992 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3BOGjp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 01:39:45 -0500
Received: by mail-da0-f43.google.com with SMTP id u36so1336144dak.2
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 22:39:45 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, sandeen@redhat.com,
        Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [test] btrfs quotas testing
Date: Fri, 15 Feb 2013 12:09:31 +0530
Message-Id: <1360910371-3258-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 quota.sh | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 quota.sh

diff --git a/quota.sh b/quota.sh
new file mode 100644
index 0000000..8b82bf9
--- /dev/null
+++ b/quota.sh
@@ -0,0 +1,23 @@
+#! /bin/bash
+# btrfs quotas test case
+#tmp=/sample
+status=1
+
+cleanup()
+{
+    btrfs subvolume delete $TEST_DIR/vol1
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

