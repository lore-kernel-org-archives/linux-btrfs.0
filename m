Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57520 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEYB4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 21:56:20 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so6454754wgg.22
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 18:56:19 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: set dead flag on the right root when destroying snapshot
Date: Sun, 25 May 2014 03:55:44 +0100
Message-Id: <1400986544-22440-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1400985885-16386-1-git-send-email-fdmanana@gmail.com>
References: <1400985885-16386-1-git-send-email-fdmanana@gmail.com>
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

V2: Add missing replacements of 'root' with 'dest'.

 fs/btrfs/ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 362720a..38f2169 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2312,16 +2312,16 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	 * again is not run concurrently.
 	 */
 	spin_lock(&dest->root_item_lock);
-	root_flags = btrfs_root_flags(&root->root_item);
-	if (root->send_in_progress == 0) {
-		btrfs_set_root_flags(&root->root_item,
+	root_flags = btrfs_root_flags(&dest->root_item);
+	if (dest->send_in_progress == 0) {
+		btrfs_set_root_flags(&dest->root_item,
 				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
 		spin_unlock(&dest->root_item_lock);
 	} else {
 		spin_unlock(&dest->root_item_lock);
 		btrfs_warn(root->fs_info,
 			"Attempt to delete subvolume %llu during send",
-			root->root_key.objectid);
+			dest->root_key.objectid);
 		err = -EPERM;
 		goto out_dput;
 	}
@@ -2416,8 +2416,8 @@ out_up_write:
 out_unlock:
 	if (err) {
 		spin_lock(&dest->root_item_lock);
-		root_flags = btrfs_root_flags(&root->root_item);
-		btrfs_set_root_flags(&root->root_item,
+		root_flags = btrfs_root_flags(&dest->root_item);
+		btrfs_set_root_flags(&dest->root_item,
 				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
 		spin_unlock(&dest->root_item_lock);
 	}
-- 
1.9.1

