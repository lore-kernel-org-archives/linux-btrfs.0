Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62041 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbbBDCNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 21:13:00 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH RFC v6 6/9] vfs: Add sb_want_write() function to get vfsmount from a given sb.
Date: Wed, 4 Feb 2015 10:10:55 +0800
Message-ID: <1423015855-27357-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*** Please DON'T merge this patch, it's only for disscusion purpose ***

There are sysfs interfaces in some fs, only btrfs yet, which will modify
on-disk data.
Unlike normal file operation routine we can use mnt_want_write_file() to
protect the operation, change through sysfs won't to be binded to any file
in the filesystem.

So introduce new sb_want_write() to do the protection agains a super
block, which acts much like mnt_want_write() but will return success if
the super block is read-write.

Since sysfs handler don't go through the normal vfsmount, so it won't
increase the refcount of and even we have sb_want_write() waiting sb to
be unfrozen, the fs can still be unmounted without problem.
Causing the modules unable to be removed and user can find out what's
wrong until 

To solve such problem, we have different strategies to solve it.
1) Extra check on last instance umount of a sb
This is the method the patch uses.
This method seems valid enough, since we want to get write protection on
a sb, so it's OK for the sb if there is *ANY* mount instance.
Problem 1.1)
But lsof and other tools won't help if sb_want_write() on frozen fs cause
it unable to be unmounted.

Problem 1.2)
When get namespace involved, things will get more complicated.
Like the following case:
	Alice				|		Bob
Mount devA on /mnt1 in her ns		| Mount devA on /mnt2/ in his ns
freeze /mnt1				|
sb_want_write() (waiting)		|
umount /mnt1 (success since there is 	|
another mount instance)			|
					| umount /mnt2 (fail since there
					| is sb_want_write() waiting)

So Alice can't thaw the fs since there is no mount point for it now.

2) Don't allow any umount of the sb if there is sb_want_write().
More aggressive one, purpose by Miao Xie.
Can't resolve problem 1.1) but will solve problem 1.2).
Although introduced new problem like the following:
	Alice
Mount devA on /mnt1
freeze /mnt1
sb_want_write() (waiting)
mount devA on /mnt2 and /mnt3

/mnt[123] all can't be unmounted, but new mount can still be created.

3) sb_want_write() doesn't make any sense and break VFS rules!
Action which will change on-disk data should not be tunable through sysfs,
and sb_want_write() things which by-pass all the VFS check is just evil.
And for btrfs, we already have the ioctl to set label, why bothering new
sysfs interface to do it again?

Although I use method 1) to do it, I am still not certain about which is
method is the correct one.

So any advise is welcomed.

Thanks,
Qu

Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Signed-off-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v4:
  Newly introduced.
v5:
  Change name to sb_want_write() and receive sb and parameter.
v6:
  Add better check when umounting the last instance of a super block. So
  sb_want_write() waiting for fs unfrozen/transaction will prevent
  umount.
---
 fs/namespace.c        | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h    |  9 ++++++
 include/linux/mount.h |  2 ++
 3 files changed, 94 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index cd1e968..eea1946 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1105,6 +1105,56 @@ struct vfsmount *mntget(struct vfsmount *mnt)
 }
 EXPORT_SYMBOL(mntget);
 
+/**
+ * sb_want_write - get write acess to a super block
+ * @sb: the superblock of the filesystem
+ *
+ * This tells the low-level filesystem that a write is about to be performed to
+ * it, and makes sure that the writes are allowed (superblock is read-write,
+ * filesystem is not frozen) before returning success.
+ * When the write operation is finished, sb_drop_write() must be called.
+ * This is much like mnt_want_write() as a refcount, but only needs
+ * the superblock to be read-write.
+ */
+int sb_want_write(struct super_block *sb)
+{
+	spin_lock(&sb->s_want_write_lock);
+	if (sb->s_want_write_block) {
+		spin_unlock(&sb->s_want_write_lock);
+		return -EBUSY;
+	}
+	sb->s_want_write_count++;
+	spin_unlock(&sb->s_want_write_lock);
+
+	sb_start_write(sb);
+	if (sb->s_readonly_remount || sb->s_flags & MS_RDONLY) {
+		sb_end_write(sb);
+		return -EROFS;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(sb_want_write);
+
+/**
+ * sb_drop_write - give up write acess to a super block
+ * @sb: the superblock on which to give up write access
+ *
+ * Tells the low-level filesystem that we are done performing writes to it and
+ * also allows filesystem to be frozen again. Must be matched with
+ * sb_want_write() call above.
+ */
+void sb_drop_write(struct super_block *sb)
+{
+	spin_lock(&sb->s_want_write_lock);
+	WARN_ON(sb->s_want_write_count == 0);
+	if (likely(sb->s_want_write_count > 0))
+		sb->s_want_write_count--;
+	spin_unlock(&sb->s_want_write_lock);
+
+	sb_end_write(sb);
+}
+EXPORT_SYMBOL(sb_drop_write);
+
 struct vfsmount *mnt_clone_internal(struct path *path)
 {
 	struct mount *p;
@@ -1382,6 +1432,8 @@ static void shrink_submounts(struct mount *mnt);
 static int do_umount(struct mount *mnt, int flags)
 {
 	struct super_block *sb = mnt->mnt.mnt_sb;
+	struct mount *mnt;
+	int mounts = 0;
 	int retval;
 
 	retval = security_sb_umount(&mnt->mnt, flags);
@@ -1455,6 +1507,28 @@ static int do_umount(struct mount *mnt, int flags)
 	lock_mount_hash();
 	event++;
 
+	/*
+	 * XXX: Check for blocking sb_want_write if the mount is the last mount
+	 * instance of the superblock (+1 for namespace mount), and block
+	 * further comming sb_want_write().
+	 */
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		mounts++;
+		if (mounts > 2)
+			break;
+	}
+
+	if (mounts == 2) {
+		spin_lock(&sb->s_want_write_lock);
+		if (sb->s_want_write_count != 0) {
+			retval = -EBUSY;
+			spin_unlock(&sb->s_want_write_lock);
+			goto out;
+		}
+		sb->s_want_write_block = true;
+		spin_unlock(&sb->s_want_write_lock);
+	}
+
 	if (flags & MNT_DETACH) {
 		if (!list_empty(&mnt->mnt_list))
 			umount_tree(mnt, 2);
@@ -1468,8 +1542,17 @@ static int do_umount(struct mount *mnt, int flags)
 			retval = 0;
 		}
 	}
+out:
+	/* umount failed, all sb_want_write() to grab sb again. */
+	if (retval) {
+		spin_lock(&sb->s_want_write_lock);
+		sb->s_want_write_block = false;
+		spin_unlock(&sb->s_want_write_lock);
+	}
+
 	unlock_mount_hash();
 	namespace_unlock();
+
 	return retval;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 42efe13..71bc8dd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1305,6 +1305,15 @@ struct super_block {
 	 * Indicates how deep in a filesystem stack this SB is
 	 */
 	int s_stack_depth;
+
+	/*
+	 * sb_want_write() staff, to keep unmount of the last mount instance
+	 * of a superblock return -EBUSY if there is still sb_want_write()
+	 * waiting for fs unfrozen.
+	 */
+	spinlock_t		s_want_write_lock;
+	bool			s_want_write_block;
+	unsigned int		s_want_write_count;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..abf4495 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -74,8 +74,10 @@ struct path;
 extern int mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
+extern int sb_want_write(struct super_block *sb);
 extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mnt_drop_write_file(struct file *file);
+extern void sb_drop_write(struct super_block *sb);
 extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
-- 
2.2.2

