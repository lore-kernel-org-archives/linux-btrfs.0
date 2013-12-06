Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3LFQvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Dec 2013 11:51:35 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] btrfs: call mnt_drop_write after interrupted subvol deletion
Date: Fri,  6 Dec 2013 17:51:32 +0100
Message-Id: <1386348692-26122-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_ioctl_snap_destroy blocks on the mutex and the process is
killed, mnt_write count is unbalanced and leads to unmountable
filesystem.

CC: stable@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d237af8..c10aabf 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2117,7 +2117,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	err = mutex_lock_killable_nested(&dir->i_mutex, I_MUTEX_PARENT);
 	if (err == -EINTR)
-		goto out;
+		goto out_drop_write;
 	dentry = lookup_one_len(vol_args->name, parent, namelen);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -2280,6 +2280,7 @@ out_dput:
 	dput(dentry);
 out_unlock_dir:
 	mutex_unlock(&dir->i_mutex);
+out_drop_write:
 	mnt_drop_write_file(file);
 out:
 	kfree(vol_args);
-- 
1.7.9

