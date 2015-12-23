Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45326 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbLXMOA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 07:14:00 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/4 v2] fstests: fix btrfs test failures after commit 27d077ec0bda
Date: Wed, 23 Dec 2015 04:43:12 +0000
Message-Id: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Commit 27d077ec0bda (common: use mount/umount helpers everywhere) made
a few btrfs test fail for 2 different reasons:

1) Some tests (btrfs/029 and btrfs/031) use $SCRATCH_MNT as a mount
   point for some subvolume created in $TEST_DEV, therefore calling
   _scratch_unmount does not work as it passes $SCRATCH_DEV as the
   argument to the umount program. This is intentional to test reflinks
   accross different mountpoints of the same filesystem but for different
   subvolumes;

2) For multiple devices filesystems (btrfs/003 and btrfs/011) that test
   the device replace feature, we need to unmount using the mount path
   ($SCRATCH_MNT) because unmounting using one of the devices as an
   argument ($SCRATCH_DEV) does not always work - after replace operations
   we get in /proc/mounts a device other than $SCRATCH_DEV associated
   with the mount point $SCRATCH_MNT (this is mentioned in a comment at
   btrfs/011 for example), so we need to pass that other device to the
   umount program or pass it the mount point.

Using $SCRATCH_MNT as a mountpoint for a device other than $SCRATCH_DEV is
misleading, but that's a different problem that existed long before and
this change attempts only to fix the regression from 27d077ec0bda, leaving
such cleanups to later.
Fix this by making _sctatch_unmmount() pass $SCRATCH_MNT to umount instead
of $SCRATCH_DEV.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Change _sctatch_unmount() to pass $SCRATCH_MNT as the argument to the
    umount program instead of $SCRATCH_DEV. This makes the btrfs tests
    pass again.

 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index d33e3fb..16a47fe 100644
--- a/common/rc
+++ b/common/rc
@@ -319,7 +319,7 @@ _scratch_unmount()
 	if [ "$FSTYP" == "overlay" ]; then
 		_overlay_scratch_unmount
 	else
-		$UMOUNT_PROG $SCRATCH_DEV
+		$UMOUNT_PROG $SCRATCH_MNT
 	fi
 }
 
-- 
2.1.3

