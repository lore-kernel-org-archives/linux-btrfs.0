Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54020 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754944AbbAPB7i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 20:59:38 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH] fstest: btrfs/006: Add extra check on return value and 'fi show' by device
Date: Fri, 16 Jan 2015 09:57:10 +0800
Message-ID: <1421373430-21915-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported in Red Hat BZ#1181627, 'btrfs fi show' on unmounted device will
return 1 even no error happens.

Introduced by: commit 2513077f
btrfs-progs: fix device missing of btrfs fi show with seed devices

Patch fixing it:
https://patchwork.kernel.org/patch/5626001/
btrfs-progs: Fix wrong return value when executing 'fi show' on
umounted device.

Reported-by: Vratislav Podzimek <vpodzime@redhat.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/006     | 51 ++++++++++++++++++++++++++++++++++++++++++++-------
 tests/btrfs/006.out | 10 ++++++++++
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/tests/btrfs/006 b/tests/btrfs/006
index 715fd80..2d8c1c0 100755
--- a/tests/btrfs/006
+++ b/tests/btrfs/006
@@ -62,33 +62,70 @@ _scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 
 # These have to be done unmounted...?
 echo "== Set filesystem label to $LABEL"
-$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL
+$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL || \
+	_fail "set lable failed"
 echo "== Get filesystem label"
-$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV
+$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV || \
+	_fail "get lable failed"
+
+echo "== Show filesystem by device(offline)"
+$BTRFS_UTIL_PROG filesystem show $FIRST_POOL_DEV | \
+	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show filesystem by device(offline) return value wrong"
 
 echo "== Mount."
 _scratch_mount
 
 echo "== Show filesystem by label"
-$BTRFS_UTIL_PROG filesystem show $LABEL | _filter_btrfs_filesystem_show $TOTAL_DEVS
+$BTRFS_UTIL_PROG filesystem show $LABEL | \
+	_filter_btrfs_filesystem_show $TOTAL_DEVS
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show filesystem by lable return value wrong"
 UUID=`$BTRFS_UTIL_PROG filesystem show $LABEL | grep uuid: | awk '{print $NF}'`
 
 echo "UUID $UUID" >> $seqres.full
 
 echo "== Show filesystem by UUID"
-$BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
+$BTRFS_UTIL_PROG filesystem show $UUID | \
+	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show filesystem by UUID return value wrong"
+
+echo "== Show filesystem by device(online)"
+$BTRFS_UTIL_PROG filesystem show $FIRST_POOL_DEV | \
+	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show filesystem by UUID return value wrong"
 
 echo "== Sync filesystem"
 $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "sync filesystem failed"
+
 
 echo "== Show device stats by mountpoint"
-$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats $TOTAL_DEVS
+$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | \
+	_filter_btrfs_device_stats $TOTAL_DEVS
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show device status return value wrong"
+
 echo "== Show device stats by first/scratch dev"
 $BTRFS_UTIL_PROG device stats $SCRATCH_DEV | _filter_btrfs_device_stats
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show device status return value wrong"
+
 echo "== Show device stats by second dev"
-$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g"
+$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | \
+	sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g"
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show device status return value wrong"
+
 echo "== Show device stats by last dev"
-$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g"
+$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | \
+	sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g"
+[ ${PIPESTATUS[0]} -ne 0 ] && \
+	_fail "show device status return value wrong"
 
 # success, all done
 status=0
diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index 22bcb77..497de67 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -2,6 +2,11 @@
 == Set filesystem label to TestLabel.006
 == Get filesystem label
 TestLabel.006
+== Show filesystem by device(offline)
+Label: 'TestLabel.006'  uuid: <UUID>
+	Total devices <EXACTNUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
 == Mount.
 == Show filesystem by label
 Label: 'TestLabel.006'  uuid: <UUID>
@@ -13,6 +18,11 @@ Label: 'TestLabel.006'  uuid: <EXACTUUID>
 	Total devices <EXACTNUM> FS bytes used <SIZE>
 	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
+== Show filesystem by device(online)
+Label: 'TestLabel.006'  uuid: <EXACTUUID>
+	Total devices <EXACTNUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
 == Sync filesystem
 FSSync 'SCRATCH_MNT'
 == Show device stats by mountpoint
-- 
2.2.2

