Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44640 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbaBRU3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:09 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 9/9] dcache: rename DCACHE_DISCONNECTED -> DCACHE_CONNECTING
Date: Tue, 18 Feb 2014 15:29:05 -0500
Message-Id: <1392755345-12830-9-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

The DCACHE_DISCONNECTED flag was intended *only* to mark dentries which
were looked up by filehandle and are currently in the process of being
hooked up to the rest of dcache.

Over time people have also confused it with IS_ROOT, using it to mark
directories that are permanently "disconnected" just because for example
they're the root of some filesystem.

Perhaps a different name would have helped. (Thanks to Eric Biederman
for the suggestion of DCACHE_CONNECTING.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 Documentation/filesystems/nfs/Exporting     |  4 ++--
 drivers/staging/lustre/lustre/llite/namei.c |  4 ++--
 fs/dcache.c                                 |  8 ++++----
 fs/exportfs/expfs.c                         | 16 ++++++++--------
 fs/fat/namei_vfat.c                         |  4 ++--
 fs/nfsd/nfsfh.c                             |  4 ++--
 fs/ocfs2/dcache.c                           |  2 +-
 fs/ocfs2/namei.c                            |  2 +-
 include/linux/dcache.h                      |  4 ++--
 9 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/filesystems/nfs/Exporting b/Documentation/filesystems/nfs/Exporting
index 9b7de5b..6d3b272 100644
--- a/Documentation/filesystems/nfs/Exporting
+++ b/Documentation/filesystems/nfs/Exporting
@@ -52,7 +52,7 @@ the dcache that are not needed for normal filesystem access.
 
 To implement these features, the dcache has:
 
-a/ A dentry flag DCACHE_DISCONNECTED which is set on
+a/ A dentry flag DCACHE_CONNECTING which is set on
    any dentry that might not be part of the proper prefix.
    This is set when anonymous dentries are created, and cleared when a
    dentry is noticed to be a child of a dentry which is in the proper
@@ -69,7 +69,7 @@ c/ Helper routines to allocate anonymous dentries, and to help attach
     d_obtain_alias(inode) will return a dentry for the given inode.
       If the inode already has a dentry, one of those is returned.
       If it doesn't, a new anonymous (IS_ROOT and
-        DCACHE_DISCONNECTED) dentry is allocated and attached.
+        DCACHE_CONNECTING) dentry is allocated and attached.
       In the case of a directory, care is taken that only one dentry
       can ever be attached.
     d_splice_alias(inode, dentry) or d_materialise_unique(dentry, inode)
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index fc8d264..f271111 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -368,7 +368,7 @@ static struct dentry *ll_find_alias(struct inode *inode, struct dentry *dentry)
 		LASSERT(alias != dentry);
 
 		spin_lock(&alias->d_lock);
-		if (alias->d_flags & DCACHE_DISCONNECTED)
+		if (alias->d_flags & DCACHE_CONNECTING)
 			/* LASSERT(last_discon == NULL); LU-405, bz 20055 */
 			discon_alias = alias;
 		else if (alias->d_parent == dentry->d_parent	     &&
@@ -395,7 +395,7 @@ static struct dentry *ll_find_alias(struct inode *inode, struct dentry *dentry)
 
 /*
  * Similar to d_splice_alias(), but lustre treats invalid alias
- * similar to DCACHE_DISCONNECTED, and tries to use it anyway.
+ * similar to DCACHE_CONNECTING, and tries to use it anyway.
  */
 struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
 {
diff --git a/fs/dcache.c b/fs/dcache.c
index 448ef98..0d5e1a5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -726,7 +726,7 @@ EXPORT_SYMBOL(dget_parent);
  * it can be unhashed only if it has no children, or if it is the root
  * of a filesystem.
  *
- * If the inode has an IS_ROOT, DCACHE_DISCONNECTED alias, then prefer
+ * If the inode has an IS_ROOT, DCACHE_CONNECTING alias, then prefer
  * any other hashed alias over that one.
  */
 static struct dentry *__d_find_alias(struct inode *inode)
@@ -739,7 +739,7 @@ again:
 		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
-			    (alias->d_flags & DCACHE_DISCONNECTED)) {
+			    (alias->d_flags & DCACHE_CONNECTING)) {
 				discon_alias = alias;
 			} else {
 				__dget_dlock(alias);
@@ -1860,7 +1860,7 @@ struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
 	add_flags = d_flags_for_inode(inode);
 
 	if (disconnected)
-		add_flags |= DCACHE_DISCONNECTED;
+		add_flags |= DCACHE_CONNECTING;
 
 	spin_lock(&tmp->d_lock);
 	tmp->d_inode = inode;
@@ -1883,7 +1883,7 @@ struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
 }
 
 /**
- * d_obtain_alias - find or allocate a DISCONNECTED dentry for a given inode
+ * d_obtain_alias - find or allocate a CONNECTING dentry for a given inode
  * @inode: inode to allocate the dentry for
  *
  * Obtain a dentry for an inode resulting from NFS filehandle conversion or
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 48a359d..50c6973 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -72,7 +72,7 @@ find_acceptable_alias(struct dentry *result,
 static bool dentry_connected(struct dentry *dentry)
 {
 	dget(dentry);
-	while (dentry->d_flags & DCACHE_DISCONNECTED) {
+	while (dentry->d_flags & DCACHE_CONNECTING) {
 		struct dentry *parent = dget_parent(dentry);
 
 		dput(dentry);
@@ -89,13 +89,13 @@ static bool dentry_connected(struct dentry *dentry)
 static void clear_disconnected(struct dentry *dentry)
 {
 	dget(dentry);
-	while (dentry->d_flags & DCACHE_DISCONNECTED) {
+	while (dentry->d_flags & DCACHE_CONNECTING) {
 		struct dentry *parent = dget_parent(dentry);
 
 		WARN_ON_ONCE(IS_ROOT(dentry));
 
 		spin_lock(&dentry->d_lock);
-		dentry->d_flags &= ~DCACHE_DISCONNECTED;
+		dentry->d_flags &= ~DCACHE_CONNECTING;
 		spin_unlock(&dentry->d_lock);
 
 		dput(dentry);
@@ -187,12 +187,12 @@ out_reconnected:
 /*
  * Make sure target_dir is fully connected to the dentry tree.
  *
- * On successful return, DCACHE_DISCONNECTED will be cleared on
+ * On successful return, DCACHE_CONNECTING will be cleared on
  * target_dir, and target_dir->d_parent->...->d_parent will reach the
  * root of the filesystem.
  *
- * Whenever DCACHE_DISCONNECTED is unset, target_dir is fully connected.
- * But the converse is not true: target_dir may have DCACHE_DISCONNECTED
+ * Whenever DCACHE_CONNECTING is unset, target_dir is fully connected.
+ * But the converse is not true: target_dir may have DCACHE_CONNECTING
  * set but already be connected.  In that case we'll verify the
  * connection to root and then clear the flag.
  *
@@ -208,7 +208,7 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir, char *nbuf)
 
 	dentry = dget(target_dir);
 
-	while (dentry->d_flags & DCACHE_DISCONNECTED) {
+	while (dentry->d_flags & DCACHE_CONNECTING) {
 		BUG_ON(dentry == mnt->mnt_sb->s_root);
 
 		if (IS_ROOT(dentry))
@@ -437,7 +437,7 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 		 * to ensure our dentry is connected all the way up to the
 		 * filesystem root.
 		 */
-		if (result->d_flags & DCACHE_DISCONNECTED) {
+		if (result->d_flags & DCACHE_CONNECTING) {
 			err = reconnect_path(mnt, result, nbuf);
 			if (err)
 				goto err_result;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6df8d3d..3e450fc 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -705,7 +705,7 @@ static int vfat_find(struct inode *dir, struct qstr *qname,
  */
 static int vfat_d_anon_disconn(struct dentry *dentry)
 {
-	return IS_ROOT(dentry) && (dentry->d_flags & DCACHE_DISCONNECTED);
+	return IS_ROOT(dentry) && (dentry->d_flags & DCACHE_CONNECTING);
 }
 
 static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
@@ -738,7 +738,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 	alias = d_find_alias(inode);
 	if (alias && !vfat_d_anon_disconn(alias)) {
 		/*
-		 * This inode has non anonymous-DCACHE_DISCONNECTED
+		 * This inode has non anonymous-DCACHE_CONNECTING
 		 * dentry. This means, the user did ->lookup() by an
 		 * another name (longname vs 8.3 alias of it) in past.
 		 *
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 3c37b16..0bc18ae 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -252,8 +252,8 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 	}
 
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
-			(dentry->d_flags & DCACHE_DISCONNECTED)) {
-		printk("nfsd: find_fh_dentry returned a DISCONNECTED directory: %pd2\n",
+			(dentry->d_flags & DCACHE_CONNECTING)) {
+		printk("nfsd: find_fh_dentry returned a CONNECTING directory: %pd2\n",
 				dentry);
 	}
 
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 0d3a97d..3e954a1 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -455,7 +455,7 @@ static void ocfs2_dentry_iput(struct dentry *dentry, struct inode *inode)
 		 * No dentry lock is ok if we're disconnected or
 		 * unhashed.
 		 */
-		if (!(dentry->d_flags & DCACHE_DISCONNECTED) &&
+		if (!(dentry->d_flags & DCACHE_CONNECTING) &&
 		    !d_unhashed(dentry)) {
 			unsigned long long ino = 0ULL;
 			if (inode)
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f4d609b..a753ae5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -149,7 +149,7 @@ bail_add:
 
 	if (inode) {
 		/*
-		 * If d_splice_alias() finds a DCACHE_DISCONNECTED
+		 * If d_splice_alias() finds a DCACHE_CONNECTING
 		 * dentry, it will d_move() it on top of ourse. The
 		 * return value will indicate this however, so in
 		 * those cases, we switch them around for the locking
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 2973aab..9f22329 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -177,14 +177,14 @@ struct dentry_operations {
 #define DCACHE_OP_DELETE		0x00000008
 #define DCACHE_OP_PRUNE			0x00000010
 
-#define	DCACHE_DISCONNECTED		0x00000020
+#define	DCACHE_CONNECTING		0x00000020
      /* This dentry is possibly not currently connected to the dcache tree, in
       * which case its parent will either be itself, or will have this flag as
       * well.  nfsd will not use a dentry with this bit set, but will first
       * endeavour to clear the bit either by discovering that it is connected,
       * or by performing lookup operations.   Any filesystem which supports
       * nfsd_operations MUST have a lookup function which, if it finds a
-      * directory inode with a DCACHE_DISCONNECTED dentry, will d_move that
+      * directory inode with a DCACHE_CONNECTING dentry, will d_move that
       * dentry into place and return that dentry rather than the passed one,
       * typically using d_splice_alias. */
 
-- 
1.8.5.3

