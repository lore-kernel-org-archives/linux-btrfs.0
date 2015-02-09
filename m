Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbBIHGK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:06:10 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 4/4] Btrfs-progs: test-btrfs-devmgt.sh have a safe defaults
Date: Mon,  9 Feb 2015 15:05:06 +0800
Message-Id: <1423465506-30934-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
References: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After I burnt my fingers by testing on non test disks,
decided to have a safe defaults

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/test-btrfs-devmgt.sh | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/tests/test-btrfs-devmgt.sh b/tests/test-btrfs-devmgt.sh
index 55bc877..71d9ac4 100755
--- a/tests/test-btrfs-devmgt.sh
+++ b/tests/test-btrfs-devmgt.sh
@@ -9,9 +9,6 @@
 # So to compare with the next iteration with your kernel patch. so
 # you can check for the sysfs changes by running diff of TMP_FILE(s)
 
-# Changelog:
-# v1.0 init asj
-
 
 		#When you change something related to device
 		#remember to test on btrfs boot separately
@@ -74,21 +71,15 @@
 
 # Devices are hard coded. sorry
 
-DEV0=/dev/sdb
-x=0
-if [ $x -eq 1 ]; then
-DEV1=/dev/sdc
-DEV2=/dev/sdd
-DEV3=/dev/sde
-DEV4=/dev/sdf
-DEV5=/dev/sdg
-else
-DEV1=/dev/sdd
-DEV2=/dev/sde
-DEV3=/dev/sdf
-DEV4=/dev/sdg
-DEV5=/dev/sdc
-fi
+# Assign per your config, all 5 needed, replace might fail
+# if DEV5 < DEV4 < DEV3 < DEV2 < DEV1
+#DEV1=/dev/sdd
+#DEV2=/dev/sde
+#DEV3=/dev/sdf
+#DEV4=/dev/sdg
+#DEV5=/dev/sdc
+
+[[ -z $DEV1 ]] || [[ -z $DEV2 ]] || [[ -z $DEV3 ]] || [[ -z $DEV4 ]] || [[ -z $DEV5 ]] && echo "Need to initialize DEVx as above here" && exit
 
 TEST_FSID=1c52f894-0ead-43d6-847a-d42359f78370
 
@@ -97,7 +88,7 @@ TEST_FSID=1c52f894-0ead-43d6-847a-d42359f78370
 TMP_FILE=`mktemp`
 
 #If the btrfs is root fs as well then set this
-CANT_CLEAN='yes'
+#CANT_CLEAN='yes'
 #CANT_CLEAN=''
 
 ent_cont()
@@ -109,12 +100,15 @@ ent_cont()
 
 erase()
 {
-	for i in $DEV0 $DEV1 $DEV2 $DEV3 $DEV4 $DEV5; do wipefs -a $i > /dev/null; done
+	for i in $DEV1 $DEV2 $DEV3 $DEV4 $DEV5; do wipefs -a $i > /dev/null; done
 }
 
 clean()
 {
-	[[ -z $CANT_CLEAN ]] && modprobe -r btrfs && modprobe btrfs
+	[[ -z $CANT_CLEAN ]] && return
+
+	! modprobe -r btrfs && echo "For btrfs boot set CANT_CLEAN to yes here above" && exit
+	modprobe btrfs
 }
 
 collect_sysfs()
-- 
1.9.1

