Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61888 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3BVFyV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 00:54:21 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so206442pbc.38
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 21:54:20 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, hugo@carfax.org.uk, sandeen@redhat.com,
        Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [Tests] xfs test[298]: Btrfs Quota testing
Date: Fri, 22 Feb 2013 11:24:04 +0530
Message-Id: <1361512444-3451-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 298     | 37 +++++++++++++++++++++++++++++++++++++
 298.out | 12 ++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100644 298
 create mode 100644 298.out

diff --git a/298 b/298
new file mode 100644
index 0000000..d699fb7
--- /dev/null
+++ b/298
@@ -0,0 +1,37 @@
+
+#! /bin/bash
+# FS QA Test No. 298
+#
+# Test btrfs's quotas
+#
+#------------------------------------------------------------------
+#
+# creator
+#owner=hemanthkumar51@gmail.com
+
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
+echo "vol1 created"
+btrfs qgroup show $TEST_DIR
+btrfs qgroup limit 2m $TEST_DIR/vol1
+echo "qgroup limited to 2mb"
+dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=3M count=1
+echo "tried to write 3m worth data"
+exit
diff --git a/298.out b/298.out
new file mode 100644
index 0000000..344ab7f
--- /dev/null
+++ b/298.out
@@ -0,0 +1,12 @@
+QA output created by 298
+quota enabled on /dev/sdb5
+Create subvolume '/test/vol1'
+vol1 created
+0/257 4096 4096
+qgroup limited to 2mb
+dd: writing ‘/test/vol1/file1’: Disk quota exceeded
+1+0 records in
+0+0 records out
+2031616 bytes (2.0 MB) copied, 0.135429 s, 15.0 MB/s
+tried to write 3m worth data
+
-- 
1.8.1.2

