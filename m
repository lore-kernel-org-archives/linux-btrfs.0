Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51664 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3BVGMk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 01:12:40 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so214607pbc.40
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 22:12:40 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, hugo@carfax.org.uk, sandeen@redhat.com,
        Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [Tests] xfs test[299]:Btrfs hierarchical Quotas
Date: Fri, 22 Feb 2013 11:42:19 +0530
Message-Id: <1361513539-3954-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 299     | 38 ++++++++++++++++++++++++++++++++++++++
 299.out | 20 ++++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 299
 create mode 100644 299.out

diff --git a/299 b/299
new file mode 100644
index 0000000..6b03438
--- /dev/null
+++ b/299
@@ -0,0 +1,38 @@
+#! /bin/bash
+# FS QA Test No. 299
+#
+# Test btrfs's hierarchical quotas
+#
+#------------------------------------------------------------------
+#
+# creator
+owner=hemanthkumar51@gmail.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+
+_cleanup()
+{
+    rm -rf $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+#Enabeling btrfs qutas
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
+btrfs qgroup show $TEST_DIR
+exit
diff --git a/299.out b/299.out
new file mode 100644
index 0000000..f9a6b96
--- /dev/null
+++ b/299.out
@@ -0,0 +1,20 @@
+QA output created by 299
+quota enabled on /dev/sdc5
+Create subvolume '/test/vol1'
+Create subvolume '/test/vol1/vol2'
+Create subvolume '/test/vol1/vol2/vol3'
+dd: writing ‘/test/vol1/vol2/vol3/file1’: Disk quota exceeded
+1+0 records in
+0+0 records out
+2031616 bytes (2.0 MB) copied, 0.128843 s, 15.8 MB/s
+1+0 records in
+1+0 records out
+2097152 bytes (2.1 MB) copied, 0.00884457 s, 237 MB/s
+dd: writing ‘/test/vol1/file1’: Disk quota exceeded
+1+0 records in
+0+0 records out
+5177344 bytes (5.2 MB) copied, 0.0732531 s, 70.7 MB/s
+0/257 4096 4096
+0/258 4096 4096
+0/259 4096 4096
+
-- 
1.8.1.2

