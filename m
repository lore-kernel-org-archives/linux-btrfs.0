Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422788Ab3CVSMy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 14:12:54 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0FC4AA51CB
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 19:12:53 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make subvol creation/deletion killable in the early stages
Date: Fri, 22 Mar 2013 19:12:51 +0100
Message-Id: <1363975971-8779-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subvolume ioctls block on the parent directory mutex that can be
held by other concurrent snapshot activity for a long time. Give the
user at least some chance to get out of this situation by allowing
to send a kill signal.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 11c17a1..0911d01 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -723,7 +723,9 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	struct dentry *dentry;
 	int error;
 
-	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
+	error = mutex_lock_killable_nested(&dir->i_mutex, I_MUTEX_PARENT);
+	if (error == -EINTR)
+		return error;
 
 	dentry = lookup_one_len(name, parent->dentry, namelen);
 	error = PTR_ERR(dentry);
@@ -2086,7 +2088,9 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	if (err)
 		goto out;
 
-	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
+	err = mutex_lock_killable_nested(&dir->i_mutex, I_MUTEX_PARENT);
+	if (err == -EINTR)
+		goto out;
 	dentry = lookup_one_len(vol_args->name, parent, namelen);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
-- 
1.8.2

