Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45023 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaGQG4t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 02:56:49 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests/btrfs: _devmgt_add() to check if the device is back online
Date: Thu, 17 Jul 2014 15:17:41 +0800
Message-Id: <1405581461-12379-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs/003 uses a method to remove the device as part of the test
case, and after the test completes the removed device is added
back to the system. However on certain system, albeit the slow
running system the device comes back a bit later, and so the
latter occurring sub-test with in the btrfs/003 fails.

This patch adds script to wait and test if the device is back online,
and thus report the same to to the full log.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/rc | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/common/rc b/common/rc
index 2c83340..4a6511f 100644
--- a/common/rc
+++ b/common/rc
@@ -2054,6 +2054,31 @@ _devmgt_add()
 	tdl=`echo ${1} | cut -d":" -f 2-|sed 's/:/ /g'`
 
 	echo ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk failed"
+
+	# ensure the device comes online
+	dev_back_oneline=0
+	for i in `seq 1 10`; do
+		if [ -d /sys/class/scsi_device/${1}/device/block ]; then
+			dev=`ls /sys/class/scsi_device/${1}/device/block`
+			for j in `seq 1 10`;
+			do
+				stat /dev/$dev > /dev/null 2>&1
+				if [ $? -eq 0 ]; then
+					dev_back_oneline=1
+					break
+				fi
+				sleep 1
+			done
+			break
+		else
+			sleep 1
+		fi
+	done
+	if [ $dev_back_oneline -eq 0 ]; then
+		echo "/dev/$dev online failed" >> $seqres.full
+	else
+		echo "/dev/$dev is back online" >> $seqres.full
+	fi
 }
 
 _require_fstrim()
-- 
2.0.0.153.g79dcccc

