Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38363 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab3JRS0h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 14:26:37 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B5B477C0427
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 12:26:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH 3/8] xfstests: stat the dev we're removing to make sure its' really gone V2
Date: Fri, 18 Oct 2013 14:26:25 -0400
Message-ID: <1382120790-31060-3-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been periodically failing btrfs/003 because my box sometimes takes a little
longer to unregister the device when we remove it and so the output from btrfs
dev show doesn't match what we are wanting since it still sees the device.  To
fix this just stat and sleep if we still see the device node and only continue
once udev or whatever actually removes the device node so that we don't get
random failures.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: Take Eric's suggestion to do this in the helper function

 common/rc       | 9 +++++++++
 tests/btrfs/003 | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index b253948..253bd05 100644
--- a/common/rc
+++ b/common/rc
@@ -2093,7 +2093,16 @@ _require_freeze()
 # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
 _devmgt_remove()
 {
+	local h=$1
+	local disk=$2
+
 	echo 1 > /sys/class/scsi_device/${1}/device/delete || _fail "Remove disk failed"
+
+	stat $disk > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		sleep 1
+		stat $disk > /dev/null 2>&1
+	done
 }
 
 # arg 1 is dev to add and is output of the below eg.
diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 262b1d5..15c2cc7 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -142,7 +142,7 @@ _test_replace()
 	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
 
 	#fail disk
-	_devmgt_remove ${DEVHTL}
+	_devmgt_remove ${DEVHTL} $ds
 	dev_removed=1
 
 	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
-- 
1.8.3.1

