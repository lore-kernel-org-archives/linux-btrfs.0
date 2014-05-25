Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53623 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEYBoz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 21:44:55 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so6323746wgg.6
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 18:44:54 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: set dead flag on the right root when destroying snapshot
Date: Sun, 25 May 2014 03:44:45 +0100
Message-Id: <1400985885-16386-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were setting the BTRFS_ROOT_SUBVOL_DEAD flag on the root of the
parent of our target snapshot, instead of setting it in the target
snapshot's root.

This is easy to observe by running the following scenario:

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt

    btrfs subvolume create /mnt/first_subvol
    btrfs subvolume snapshot -r /mnt /mnt/mysnap1

    btrfs subvolume delete /mnt/first_subvol
    btrfs subvolume snapshot -r /mnt /mnt/mysnap2

    btrfs send -p /mnt/mysnap1 /mnt/mysnap2 -f /tmp/send.data

The send command failed because the send ioctl returned -EPERM.
A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 362720a..482cad5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2314,7 +2314,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	spin_lock(&dest->root_item_lock);
 	root_flags = btrfs_root_flags(&root->root_item);
 	if (root->send_in_progress == 0) {
-		btrfs_set_root_flags(&root->root_item,
+		btrfs_set_root_flags(&dest->root_item,
 				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
 		spin_unlock(&dest->root_item_lock);
 	} else {
@@ -2417,7 +2417,7 @@ out_unlock:
 	if (err) {
 		spin_lock(&dest->root_item_lock);
 		root_flags = btrfs_root_flags(&root->root_item);
-		btrfs_set_root_flags(&root->root_item,
+		btrfs_set_root_flags(&dest->root_item,
 				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
 		spin_unlock(&dest->root_item_lock);
 	}
-- 
1.9.1

