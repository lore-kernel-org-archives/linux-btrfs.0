Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2FLOVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:00 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 11/27] btrfs: Push mnt_want_write() outside of i_mutex
Date: Tue, 12 Jun 2012 16:20:32 +0200
Message-Id: <1339510848-16992-12-git-send-email-jack@suse.cz>
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When mnt_want_write() starts to handle freezing it will get a full lock
semantics requiring proper lock ordering. So push mnt_want_write() call
consistently outside of i_mutex.

CC: Chris Mason <chris.mason@oracle.com>
CC: linux-btrfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/ioctl.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24b776c..440655b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -192,6 +192,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
 	mutex_lock(&inode->i_mutex);
 
 	ip_oldflags = ip->flags;
@@ -206,10 +210,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		}
 	}
 
-	ret = mnt_want_write_file(file);
-	if (ret)
-		goto out_unlock;
-
 	if (flags & FS_SYNC_FL)
 		ip->flags |= BTRFS_INODE_SYNC;
 	else
@@ -272,9 +272,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		inode->i_flags = i_oldflags;
 	}
 
-	mnt_drop_write_file(file);
  out_unlock:
 	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
@@ -640,6 +640,10 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	struct dentry *dentry;
 	int error;
 
+	error = mnt_want_write(parent->mnt);
+	if (error)
+		return error;
+
 	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
 
 	dentry = lookup_one_len(name, parent->dentry, namelen);
@@ -651,13 +655,9 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	if (dentry->d_inode)
 		goto out_dput;
 
-	error = mnt_want_write(parent->mnt);
-	if (error)
-		goto out_dput;
-
 	error = btrfs_may_create(dir, dentry);
 	if (error)
-		goto out_drop_write;
+		goto out_dput;
 
 	down_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
 
@@ -675,12 +675,11 @@ static noinline int btrfs_mksubvol(struct path *parent,
 		fsnotify_mkdir(dir, dentry);
 out_up_read:
 	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
-out_drop_write:
-	mnt_drop_write(parent->mnt);
 out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&dir->i_mutex);
+	mnt_drop_write(parent->mnt);
 	return error;
 }
 
-- 
1.7.1

