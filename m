From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: allow subvol deletion by unprivileged user with -o user_subvol_rm_allowed
Date: Mon, 25 Oct 2010 14:24:00 -0700
Message-ID: <1288041840-28431-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add a mount option user_subvol_rm_allowed that allows users to delete a
(potentially non-empty!) subvol when they would otherwise we allowed to do
an rmdir(2).  We duplicate the may_delete() checks from the core VFS code
to implement identical security checks (minus the directory size check).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/ioctl.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/super.c |    6 ++-
 3 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5ac2bca..140003e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1196,6 +1196,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
 #define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
+#define BTRFS_MOUNT_USER_SUBVOL_RM_ALLOWED (1 << 12)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 906e3b3..919b23f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -409,6 +409,76 @@ fail:
 	return ret;
 }
 
+/*  copy of check_sticky in fs/namei.c() 
+* It's inline, so penalty for filesystems that don't use sticky bit is
+* minimal.
+*/
+static inline int btrfs_check_sticky(struct inode *dir, struct inode *inode)
+{
+	uid_t fsuid = current_fsuid();
+
+	if (!(dir->i_mode & S_ISVTX))
+		return 0;
+	if (inode->i_uid == fsuid)
+		return 0;
+	if (dir->i_uid == fsuid)
+		return 0;
+	return !capable(CAP_FOWNER);
+}
+
+/*  copy of may_delete in fs/namei.c() 
+ *	Check whether we can remove a link victim from directory dir, check
+ *  whether the type of victim is right.
+ *  1. We can't do it if dir is read-only (done in permission())
+ *  2. We should have write and exec permissions on dir
+ *  3. We can't remove anything from append-only dir
+ *  4. We can't do anything with immutable dir (done in permission())
+ *  5. If the sticky bit on dir is set we should either
+ *	a. be owner of dir, or
+ *	b. be owner of victim, or
+ *	c. have CAP_FOWNER capability
+ *  6. If the victim is append-only or immutable we can't do antyhing with
+ *     links pointing to it.
+ *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
+ *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
+ *  9. We can't remove a root or mountpoint.
+ * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
+ *     nfs_async_unlink().
+ */
+
+static int btrfs_may_delete(struct inode *dir,struct dentry *victim,int isdir)
+{
+	int error;
+
+	if (!victim->d_inode)
+		return -ENOENT;
+
+	BUG_ON(victim->d_parent->d_inode != dir);
+	audit_inode_child(victim, dir);
+
+	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (error)
+		return error;
+	if (IS_APPEND(dir))
+		return -EPERM;
+	if (btrfs_check_sticky(dir, victim->d_inode)||
+		IS_APPEND(victim->d_inode)||
+	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
+		return -EPERM;
+	if (isdir) {
+		if (!S_ISDIR(victim->d_inode->i_mode))
+			return -ENOTDIR;
+		if (IS_ROOT(victim))
+			return -EBUSY;
+	} else if (S_ISDIR(victim->d_inode->i_mode))
+		return -EISDIR;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+		return -EBUSY;
+	return 0;
+}
+
 /* copy of may_create in fs/namei.c() */
 static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
 {
@@ -1288,9 +1358,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	int ret;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
 		return PTR_ERR(vol_args);
@@ -1320,13 +1387,45 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	}
 
 	inode = dentry->d_inode;
+	dest = BTRFS_I(inode)->root;
+	if (!capable(CAP_SYS_ADMIN)){
+		/*
+		 * Regular user.  Only allow this with a special mount
+		 * option, and when rmdir(2) would have been allowed.
+		 *
+		 * Note that this is _not_ check that the subvol is
+		 * empty or doesn't contain data that we wouldn't
+		 * otherwise be able to delete.
+		 *
+		 * Users who want to delete empty subvols should try
+		 * rmdir(2).
+		 */
+		err = -EPERM;
+		if (!btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
+			goto out_dput;
+
+		/*
+		 * Do not allow deletion if the parent dir is the same
+		 * as the dir to be deleted.  That means the ioctl
+		 * must be called on the dentry referencing the root
+		 * of the subvol, not a random directory contained
+		 * within it.
+		 */
+		err = -EINVAL;
+		if (root == dest)
+			goto out_dput;
+
+		/* check if subvolume may be deleted by a non-root user */	
+		err = btrfs_may_delete(dir, dentry, 1);
+		if (err)
+			goto out_dput;
+	}
+
 	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
 		err = -EINVAL;
 		goto out_dput;
 	}
 
-	dest = BTRFS_I(inode)->root;
-
 	mutex_lock(&inode->i_mutex);
 	err = d_invalidate(dentry);
 	if (err)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4da2680..8ff5a3a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -68,7 +68,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_user_subvol_rm_allowed, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -92,6 +92,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
 	{Opt_err, NULL},
 };
 
@@ -235,6 +236,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_user_subvol_rm_allowed:
+			btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
-- 
1.6.6.1

