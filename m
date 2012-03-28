From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/19] btrfs: Push mnt_want_write() outside of i_mutex
Date: Thu, 29 Mar 2012 01:43:19 +0200
Message-ID: <1332978214-15535-5-git-send-email-jack@suse.cz>
References: <1332978214-15535-1-git-send-email-jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com,
	sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332978214-15535-1-git-send-email-jack@suse.cz>
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
index 03bb62a..c855e55 100644
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
@@ -271,9 +271,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		inode->i_flags = i_oldflags;
 	}
 
-	mnt_drop_write_file(file);
  out_unlock:
 	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
@@ -624,6 +624,10 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	struct dentry *dentry;
 	int error;
 
+	error = mnt_want_write(parent->mnt);
+	if (error)
+		return error;
+
 	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
 
 	dentry = lookup_one_len(name, parent->dentry, namelen);
@@ -635,13 +639,9 @@ static noinline int btrfs_mksubvol(struct path *parent,
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
 
@@ -659,12 +659,11 @@ static noinline int btrfs_mksubvol(struct path *parent,
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

