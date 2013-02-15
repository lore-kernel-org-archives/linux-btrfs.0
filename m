Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50960 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3BOG3m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 01:29:42 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so1607285pab.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 22:29:42 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chetahan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, sandeen@redhat.com,
        Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [test] comments removed
Date: Fri, 15 Feb 2013 11:59:15 +0530
Message-Id: <1360909755-2966-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 0001-heirarchical-quotas-test-case.patch | 44 ++++++++++++++++++++++++++++++++
 hquotas.sh                               |  2 --
 2 files changed, 44 insertions(+), 2 deletions(-)
 create mode 100644 0001-heirarchical-quotas-test-case.patch

diff --git a/0001-heirarchical-quotas-test-case.patch b/0001-heirarchical-quotas-test-case.patch
new file mode 100644
index 0000000..c6577e0
--- /dev/null
+++ b/0001-heirarchical-quotas-test-case.patch
@@ -0,0 +1,44 @@
+From 9f49a870eab70ae37028f937331f9ec1b67dadb1 Mon Sep 17 00:00:00 2001
+From: Hemanth Kumar <hemanthkumar51@gmail.com>
+Date: Fri, 15 Feb 2013 11:21:03 +0530
+Subject: [test] heirarchical quotas test case
+
+
+Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
+---
+ hquotas.sh | 8 ++++----
+ 1 file changed, 4 insertions(+), 4 deletions(-)
+
+diff --git a/hquotas.sh b/hquotas.sh
+index 2eaae01..a870d4a 100644
+--- a/hquotas.sh
++++ b/hquotas.sh
+@@ -1,7 +1,5 @@
+ #! /bin/bash
+-# btrfs quotas test case
+-#owner=hemanthkumar51@gamil.com ganeshkumr14@gmail.com
+-
++# btrfs hierarchical quotas test case
+ #here=`pwd`
+ #tmp=/sample
+ status=1
+@@ -11,6 +9,8 @@ cleanup()
+ 	btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
+ 	btrfs subvolume delete $TEST_DIR/vol1/vol2
+ 	btrfs subvolume delete $TEST_DIR/vol1
++	btrfs quota disable $TEST_DIR
++	echo"quota disabled"
+ }
+ 
+ #trap "_cleanup ; exit \$status" 0 1 2 3 15
+@@ -25,6 +25,6 @@ btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
+ btrfs qgroup limit 1m $TEST_DIR/vol1/vol2/vol3
+ dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file3 bs=2M count=1
+ dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file2 bs=1M count=1
+-dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1
++dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=4M count=1
+ cleanup
+ exit
+-- 
+1.8.1.2
+
diff --git a/hquotas.sh b/hquotas.sh
index a870d4a..672b6d1 100644
--- a/hquotas.sh
+++ b/hquotas.sh
@@ -1,7 +1,5 @@
 #! /bin/bash
 # btrfs hierarchical quotas test case
-#here=`pwd`
-#tmp=/sample
 status=1
 
 cleanup()
-- 
1.8.1.2

