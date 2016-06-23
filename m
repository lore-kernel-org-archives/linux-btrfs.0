Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50056 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcFWNQ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 09:16:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, eguan@redhat.com
Subject: [PATCH v3] fstests: btrfs: fix 006
Date: Thu, 23 Jun 2016 21:17:29 +0800
Message-Id: <1466687849-7902-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1466678252-4058-1-git-send-email-anand.jain@oracle.com>
References: <1466678252-4058-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs fi sync /mnt, now does not output anything for success,
so the 006.out should be updated.

This change in btrfs-progs was introduced in the commit
 b005ca024990569d2de459485682158633937928
   btrfs-progs: fi sync: make it silent by default
 which was integrated at btrfs-progs version v4.5.2

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: Update commit log to indicate the btrfs-progs version at
    which sync UI is changed.
 v3: Drop _runnt_btrfs_utils_progs(). fi sync will error stdout
     on error, so don't need. Thanks Eryu.

 tests/btrfs/006     | 2 +-
 tests/btrfs/006.out | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/btrfs/006 b/tests/btrfs/006
index 715fd80fb6fc..086339401153 100755
--- a/tests/btrfs/006
+++ b/tests/btrfs/006
@@ -79,7 +79,7 @@ echo "== Show filesystem by UUID"
 $BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
 
 echo "== Sync filesystem"
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT > /dev/null
 
 echo "== Show device stats by mountpoint"
 $BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats $TOTAL_DEVS
diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index 22bcb777076a..05b9ac020737 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -14,7 +14,6 @@ Label: 'TestLabel.006'  uuid: <EXACTUUID>
 	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
 == Sync filesystem
-FSSync 'SCRATCH_MNT'
 == Show device stats by mountpoint
 <NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
 <NUMDEVS> [SCRATCH_DEV].flush_io_errs   <NUM>
-- 
2.7.0

