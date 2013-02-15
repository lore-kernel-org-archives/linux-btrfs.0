Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39460 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3BOT5g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 14:57:36 -0500
Received: by mail-pa0-f53.google.com with SMTP id bg4so1845298pad.12
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 11:57:35 -0800 (PST)
From: "Chethan.Y" <chethan.casey@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, praneethu.u@gmail.com,
        hemanthkumar51@gmail.com, kirantpatil@gmail.com,
        "Chethan.Y" <chethan.casey@gmail.com>
Subject: [btrfs-progs 6/7] Detect Device of type SSD or HDD
Date: Sat, 16 Feb 2013 01:27:14 +0530
Message-Id: <1360958234-3461-1-git-send-email-chethan.casey@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Chethan.Y" <chethan.casey@gmail.com>


Signed-off-by: Chethan.Y <chethan.casey@gmail.com>
---
 0001-Deleted-blank-patches.patch | 128 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 0001-Deleted-blank-patches.patch

diff --git a/0001-Deleted-blank-patches.patch b/0001-Deleted-blank-patches.patch
new file mode 100644
index 0000000..bc02ebe
--- /dev/null
+++ b/0001-Deleted-blank-patches.patch
@@ -0,0 +1,128 @@
+From 2881178d57df390bfad6a1f67c51002f88119553 Mon Sep 17 00:00:00 2001
+From: "Chethan.Y" <chethan.casey@gmail.com>
+Date: Sat, 16 Feb 2013 01:10:24 +0530
+Subject: [[btrfs-progs]] Deleted blank patches
+
+
+Signed-off-by: Chethan.Y <chethan.casey@gmail.com>
+---
+ 0001-Detect-device-of-SSD-or-HDD-Patch.patch | 60 ----------------------------
+ 0001-Detect-device-of-SSD-or-HDD.patch       | 39 ------------------
+ 2 files changed, 99 deletions(-)
+ delete mode 100644 0001-Detect-device-of-SSD-or-HDD-Patch.patch
+ delete mode 100644 0001-Detect-device-of-SSD-or-HDD.patch
+
+diff --git a/0001-Detect-device-of-SSD-or-HDD-Patch.patch b/0001-Detect-device-of-SSD-or-HDD-Patch.patch
+deleted file mode 100644
+index 693388c..0000000
+--- a/0001-Detect-device-of-SSD-or-HDD-Patch.patch
++++ /dev/null
+@@ -1,60 +0,0 @@
+-From 5e99b0ebe2b8100c8111168acd710a74724dc4d3 Mon Sep 17 00:00:00 2001
+-From: "Chethan.Y" <chethan.casey@gmail.com>
+-Date: Sat, 16 Feb 2013 00:54:46 +0530
+-Subject: [[btrfs-progs]] Detect device of SSD or HDD Patch
+-
+-
+-Signed-off-by: Chethan.Y <chethan.casey@gmail.com>
+----
+- 0001-Detect-device-of-SSD-or-HDD.patch | 39 ++++++++++++++++++++++++++++++++++
+- 1 file changed, 39 insertions(+)
+- create mode 100644 0001-Detect-device-of-SSD-or-HDD.patch
+-
+-diff --git a/0001-Detect-device-of-SSD-or-HDD.patch b/0001-Detect-device-of-SSD-or-HDD.patch
+-new file mode 100644
+-index 0000000..9223f32
+---- /dev/null
+-+++ b/0001-Detect-device-of-SSD-or-HDD.patch
+-@@ -0,0 +1,39 @@
+-+From e42245b5254f5842e717644c663773606e63e72b Mon Sep 17 00:00:00 2001
+-+From: "Chethan.Y" <chethan.casey@gmail.com>
+-+Date: Sat, 16 Feb 2013 00:48:34 +0530
+-+Subject: [[btrfs-progs]Detect HDD or SSD]] Detect device of SSD or HDD
+-+
+-+
+-+Signed-off-by: Chethan.Y <chethan.casey@gmail.com>
+-+---
+-+ ssd.sh | 14 +++++++-------
+-+ 1 file changed, 7 insertions(+), 7 deletions(-)
+-+
+-+diff --git a/ssd.sh b/ssd.sh
+-+index da81b77..45afeca 100644
+-+--- a/ssd.sh
+-++++ b/ssd.sh
+-+@@ -8,13 +8,13 @@ TEST=$(echo $TEST_DEV | sed 's/\/dev\///' | sed 's/[0-9][0-9]*//')
+-+ 
+-+ if [ -e $TEST_DEV ]
+-+ then
+-+- status=$(cat /sys/block/$TEST/queue/rotational)
+-+- if [ status==1 ]   # result 1 refers device of type HDD & 0 for SSD
+-+- then
+-+- echo "The Device is of type Hard Disk Drive(HDD) "
+-+- else
+-+- echo "The Device is of type Solid State drive(SSD)"
+-+- fi
+-++status=$(cat /sys/block/$TEST/queue/rotational)
+-++if [ status==1 ]   # result 1 refers device of type HDD & 0 for SSD
+-++then
+-++echo "The Device is of type Hard Disk Drive(HDD) "
+-++else
+-++echo "The Device is of type Solid State drive(SSD)"
+-++fi
+-+ else
+-+ echo "The Device entered is not valid or does not exists"
+-+ fi
+-+-- 
+-+1.7.11.7
+-+
+--- 
+-1.7.11.7
+-
+diff --git a/0001-Detect-device-of-SSD-or-HDD.patch b/0001-Detect-device-of-SSD-or-HDD.patch
+deleted file mode 100644
+index 9223f32..0000000
+--- a/0001-Detect-device-of-SSD-or-HDD.patch
++++ /dev/null
+@@ -1,39 +0,0 @@
+-From e42245b5254f5842e717644c663773606e63e72b Mon Sep 17 00:00:00 2001
+-From: "Chethan.Y" <chethan.casey@gmail.com>
+-Date: Sat, 16 Feb 2013 00:48:34 +0530
+-Subject: [[btrfs-progs]Detect HDD or SSD]] Detect device of SSD or HDD
+-
+-
+-Signed-off-by: Chethan.Y <chethan.casey@gmail.com>
+----
+- ssd.sh | 14 +++++++-------
+- 1 file changed, 7 insertions(+), 7 deletions(-)
+-
+-diff --git a/ssd.sh b/ssd.sh
+-index da81b77..45afeca 100644
+---- a/ssd.sh
+-+++ b/ssd.sh
+-@@ -8,13 +8,13 @@ TEST=$(echo $TEST_DEV | sed 's/\/dev\///' | sed 's/[0-9][0-9]*//')
+- 
+- if [ -e $TEST_DEV ]
+- then
+-- status=$(cat /sys/block/$TEST/queue/rotational)
+-- if [ status==1 ]   # result 1 refers device of type HDD & 0 for SSD
+-- then
+-- echo "The Device is of type Hard Disk Drive(HDD) "
+-- else
+-- echo "The Device is of type Solid State drive(SSD)"
+-- fi
+-+status=$(cat /sys/block/$TEST/queue/rotational)
+-+if [ status==1 ]   # result 1 refers device of type HDD & 0 for SSD
+-+then
+-+echo "The Device is of type Hard Disk Drive(HDD) "
+-+else
+-+echo "The Device is of type Solid State drive(SSD)"
+-+fi
+- else
+- echo "The Device entered is not valid or does not exists"
+- fi
+--- 
+-1.7.11.7
+-
+-- 
+1.7.11.7
+
-- 
1.7.11.7

