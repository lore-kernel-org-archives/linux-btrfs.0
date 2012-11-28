Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48533 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2K1QbD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 11:31:03 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so5019651qat.19
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 08:31:02 -0800 (PST)
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbacik@fusionio.com
Subject: [PATCH] vfs: remove DCACHE_NEED_LOOKUP
Date: Wed, 28 Nov 2012 11:30:53 -0500
Message-Id: <1354120253-27438-1-git-send-email-jlayton@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code that relied on that flag was ripped out of btrfs quite some
time ago, and never added back. Josef indicated that he was going to
take a different approach to the problem in btrfs, and that we
could just eliminate this flag.

Cc: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/inode.c       | 16 +---------------
 fs/dcache.c            | 33 +--------------------------------
 fs/namei.c             | 11 +----------
 include/linux/dcache.h |  8 --------
 4 files changed, 3 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..0e5ca81 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4219,16 +4219,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	if (unlikely(d_need_lookup(dentry))) {
-		memcpy(&location, dentry->d_fsdata, sizeof(struct btrfs_key));
-		kfree(dentry->d_fsdata);
-		dentry->d_fsdata = NULL;
-		/* This thing is hashed, drop it for now */
-		d_drop(dentry);
-	} else {
-		ret = btrfs_inode_by_name(dir, dentry, &location);
-	}
-
+	ret = btrfs_inode_by_name(dir, dentry, &location);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -4298,11 +4289,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *ret;
 
 	ret = d_splice_alias(btrfs_lookup_dentry(dir, dentry), dentry);
-	if (unlikely(d_need_lookup(dentry))) {
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags &= ~DCACHE_NEED_LOOKUP;
-		spin_unlock(&dentry->d_lock);
-	}
 	return ret;
 }
 
diff --git a/fs/dcache.c b/fs/dcache.c
index 3a463d0..1782be3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -455,24 +455,6 @@ void d_drop(struct dentry *dentry)
 EXPORT_SYMBOL(d_drop);
 
 /*
- * d_clear_need_lookup - drop a dentry from cache and clear the need lookup flag
- * @dentry: dentry to drop
- *
- * This is called when we do a lookup on a placeholder dentry that needed to be
- * looked up.  The dentry should have been hashed in order for it to be found by
- * the lookup code, but now needs to be unhashed while we do the actual lookup
- * and clear the DCACHE_NEED_LOOKUP flag.
- */
-void d_clear_need_lookup(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__d_drop(dentry);
-	dentry->d_flags &= ~DCACHE_NEED_LOOKUP;
-	spin_unlock(&dentry->d_lock);
-}
-EXPORT_SYMBOL(d_clear_need_lookup);
-
-/*
  * Finish off a dentry we've decided to kill.
  * dentry->d_lock must be held, returns with it unlocked.
  * If ref is non-zero, then decrement the refcount too.
@@ -565,13 +547,7 @@ repeat:
  	if (d_unhashed(dentry))
 		goto kill_it;
 
-	/*
-	 * If this dentry needs lookup, don't set the referenced flag so that it
-	 * is more likely to be cleaned up by the dcache shrinker in case of
-	 * memory pressure.
-	 */
-	if (!d_need_lookup(dentry))
-		dentry->d_flags |= DCACHE_REFERENCED;
+	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
 	dentry->d_count--;
@@ -1737,13 +1713,6 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	}
 
 	/*
-	 * We are going to instantiate this dentry, unhash it and clear the
-	 * lookup flag so we can do that.
-	 */
-	if (unlikely(d_need_lookup(found)))
-		d_clear_need_lookup(found);
-
-	/*
 	 * Negative dentry: instantiate it unless the inode is a directory and
 	 * already has a dentry.
 	 */
diff --git a/fs/namei.c b/fs/namei.c
index 937f9d5..9738f97 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1275,9 +1275,7 @@ static struct dentry *lookup_dcache(struct qstr *name, struct dentry *dir,
 	*need_lookup = false;
 	dentry = d_lookup(dir, name);
 	if (dentry) {
-		if (d_need_lookup(dentry)) {
-			*need_lookup = true;
-		} else if (dentry->d_flags & DCACHE_OP_REVALIDATE) {
+		if (dentry->d_flags & DCACHE_OP_REVALIDATE) {
 			error = d_revalidate(dentry, flags);
 			if (unlikely(error <= 0)) {
 				if (error < 0) {
@@ -1383,8 +1381,6 @@ static int lookup_fast(struct nameidata *nd, struct qstr *name,
 			return -ECHILD;
 		nd->seq = seq;
 
-		if (unlikely(d_need_lookup(dentry)))
-			goto unlazy;
 		if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE)) {
 			status = d_revalidate(dentry, nd->flags);
 			if (unlikely(status <= 0)) {
@@ -1410,11 +1406,6 @@ unlazy:
 	if (unlikely(!dentry))
 		goto need_lookup;
 
-	if (unlikely(d_need_lookup(dentry))) {
-		dput(dentry);
-		goto need_lookup;
-	}
-
 	if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE) && need_reval)
 		status = d_revalidate(dentry, nd->flags);
 	if (unlikely(status <= 0)) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 5920079..c1754b5 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -202,7 +202,6 @@ struct dentry_operations {
 #define DCACHE_MOUNTED		0x10000	/* is a mountpoint */
 #define DCACHE_NEED_AUTOMOUNT	0x20000	/* handle automount on this dir */
 #define DCACHE_MANAGE_TRANSIT	0x40000	/* manage transit from this dirent */
-#define DCACHE_NEED_LOOKUP	0x80000 /* dentry requires i_op->lookup */
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
@@ -408,13 +407,6 @@ static inline bool d_mountpoint(struct dentry *dentry)
 	return dentry->d_flags & DCACHE_MOUNTED;
 }
 
-static inline bool d_need_lookup(struct dentry *dentry)
-{
-	return dentry->d_flags & DCACHE_NEED_LOOKUP;
-}
-
-extern void d_clear_need_lookup(struct dentry *dentry);
-
 extern int sysctl_vfs_cache_pressure;
 
 #endif	/* __LINUX_DCACHE_H */
-- 
1.7.11.7

