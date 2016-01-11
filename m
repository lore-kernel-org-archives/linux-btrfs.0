Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38323 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459AbcAKNWm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 08:22:42 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] fstests: fix btrfs test failures after commit 27d077ec0bda
Date: Mon, 11 Jan 2016 13:22:27 +0000
Message-Id: <1452518547-4109-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Commit 27d077ec0bda (common: use mount/umount helpers everywhere) made
a few btrfs tests fail (btrfs/003 and btrfs/011). These tests create
filesystems with multiple devices and test the device replace feature,
which need to unmount using the mount path ($SCRATCH_MNT) because
unmounting using one of the devices as an argument ($SCRATCH_DEV) does
not always work - after replace operations we get in /proc/mounts a
device other than $SCRATCH_DEV associated with the mount point
$SCRATCH_MNT (this is mentioned in a comment at btrfs/011 for example),
so we need to pass that other device to the umount program or pass it the
mount point.
Fix this by making _sctatch_unmount() pass $SCRATCH_MNT to umount instead
of $SCRATCH_DEV (when the filesystem being tested is btrfs).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Change _sctatch_unmount() to pass $SCRATCH_MNT as the argument to the
    umount program instead of $SCRATCH_DEV. This makes the btrfs tests
    pass again.

V3: Pass $SCRATCH_MNT to the umount program instead of $SCRATCH_DEV only
    if the filesystem being tested is btrfs. This was making generic/050
    fail (which I couldn't test using btrfs because btrfs does not have
    the shutdown feature unlike xfs for e.g.).

 common/rc | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 5135260..cbf1854 100644
--- a/common/rc
+++ b/common/rc
@@ -316,11 +316,17 @@ _scratch_mount()
 
 _scratch_unmount()
 {
-	if [ "$FSTYP" == "overlay" ]; then
+	case "$FSTYP" in
+	overlay)
 		_overlay_scratch_unmount
-	else
+		;;
+	btrfs)
+		$UMOUNT_PROG $SCRATCH_MNT
+		;;
+	*)
 		$UMOUNT_PROG $SCRATCH_DEV
-	fi
+		;;
+	esac
 }
 
 _scratch_remount()
-- 
2.1.3

