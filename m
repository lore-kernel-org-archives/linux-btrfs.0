Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33093 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbbADE6F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 23:58:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: [PATCH v2] xfstests: btrfs: fix up 001.out
Date: Fri,  2 Jan 2015 21:04:29 +0800
Message-Id: <1420203869-26085-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
References: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subvol delete output has changed with btrfs-progs
    -Delete subvolume 'SCRATCH_MNT/snap'
    +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'

so fix 001 failing.

Signed-off-by: Anand Jain <anand.jain@oracle.com>

v2: Thanks Filipe for mentioning now we have _run_btrfs_util_prog. and
    commit update
---
 tests/btrfs/001     | 2 +-
 tests/btrfs/001.out | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/btrfs/001 b/tests/btrfs/001
index 8258d06..a7747c8 100755
--- a/tests/btrfs/001
+++ b/tests/btrfs/001
@@ -99,7 +99,7 @@ echo "Listing subvolumes"
 $BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | awk '{ print $NF }'
 
 # Delete the snapshot
-$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_btrfs_subvol_delete
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap
 echo "List root dir"
 ls $SCRATCH_MNT
 _scratch_remount
diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
index c782bde..43e8c56 100644
--- a/tests/btrfs/001.out
+++ b/tests/btrfs/001.out
@@ -33,7 +33,6 @@ subvol
 Listing subvolumes
 snap
 subvol
-Delete subvolume 'SCRATCH_MNT/snap'
 List root dir
 subvol
 List root dir
-- 
2.0.0.153.g79dcccc

