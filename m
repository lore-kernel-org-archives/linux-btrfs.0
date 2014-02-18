Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44631 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaBRU3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:09 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5/9] dcache: d_obtain_alias callers don't all want DISCONNECTED
Date: Tue, 18 Feb 2014 15:29:01 -0500
Message-Id: <1392755345-12830-5-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

There are a few d_obtain_alias callers that are using it to get the
root of a filesystem which may already have an alias somewhere else.

This is not the same as the filehandle-lookup case, and none of them
actually need DCACHE_DISCONNECTED set.

In the btrfs case this was causing a spurious printk from
nfsd/nfsfh.c:fh_verify when it found an unexpected DCACHE_DISCONNECTED
dentry.

Which isn't really a serious problem, but it would really be clearer if
we reserved DCACHE_DISCONNECTED for those cases where it's actually
needed.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/btrfs/super.c       |  2 +-
 fs/ceph/super.c        |  2 +-
 fs/dcache.c            | 69 +++++++++++++++++++++++++++++++++++---------------
 fs/nfs/getroot.c       |  2 +-
 fs/nilfs2/super.c      |  2 +-
 include/linux/dcache.h |  1 +
 6 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 97cc241..07ce96b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -925,7 +925,7 @@ setup_root:
 		return dget(sb->s_root);
 	}
 
-	return d_obtain_alias(inode);
+	return d_obtain_alias_root(inode);
 }
 
 static int btrfs_fill_super(struct super_block *sb,
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2df963f..9666950 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -732,7 +732,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 				goto out;
 			}
 		} else {
-			root = d_obtain_alias(inode);
+			root = d_obtain_alias_root(inode);
 		}
 		ceph_init_dentry(root);
 		dout("open_root_inode success, root dentry is %p\n", root);
diff --git a/fs/dcache.c b/fs/dcache.c
index e3e4618..3a1057a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1832,25 +1832,7 @@ struct dentry *d_find_any_alias(struct inode *inode)
 }
 EXPORT_SYMBOL(d_find_any_alias);
 
-/**
- * d_obtain_alias - find or allocate a dentry for a given inode
- * @inode: inode to allocate the dentry for
- *
- * Obtain a dentry for an inode resulting from NFS filehandle conversion or
- * similar open by handle operations.  The returned dentry may be anonymous,
- * or may have a full name (if the inode was already in the cache).
- *
- * When called on a directory inode, we must ensure that the inode only ever
- * has one dentry.  If a dentry is found, that is returned instead of
- * allocating a new one.
- *
- * On successful return, the reference to the inode has been transferred
- * to the dentry.  In case of an error the reference on the inode is released.
- * To make it easier to use in export operations a %NULL or IS_ERR inode may
- * be passed in and will be the error will be propagate to the return value,
- * with a %NULL @inode replaced by ERR_PTR(-ESTALE).
- */
-struct dentry *d_obtain_alias(struct inode *inode)
+struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
 {
 	static const struct qstr anonstring = QSTR_INIT("/", 1);
 	struct dentry *tmp;
@@ -1881,7 +1863,10 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	}
 
 	/* attach a disconnected dentry */
-	add_flags = d_flags_for_inode(inode) | DCACHE_DISCONNECTED;
+	add_flags = d_flags_for_inode(inode);
+
+	if (disconnected)
+		add_flags |= DCACHE_DISCONNECTED;
 
 	spin_lock(&tmp->d_lock);
 	tmp->d_inode = inode;
@@ -1902,9 +1887,53 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	iput(inode);
 	return res;
 }
+
+/**
+ * d_obtain_alias - find or allocate a DISCONNECTED dentry for a given inode
+ * @inode: inode to allocate the dentry for
+ *
+ * Obtain a dentry for an inode resulting from NFS filehandle conversion or
+ * similar open by handle operations.  The returned dentry may be anonymous,
+ * or may have a full name (if the inode was already in the cache).
+ *
+ * When called on a directory inode, we must ensure that the inode only ever
+ * has one dentry.  If a dentry is found, that is returned instead of
+ * allocating a new one.
+ *
+ * On successful return, the reference to the inode has been transferred
+ * to the dentry.  In case of an error the reference on the inode is released.
+ * To make it easier to use in export operations a %NULL or IS_ERR inode may
+ * be passed in and the error will be propagated to the return value,
+ * with a %NULL @inode replaced by ERR_PTR(-ESTALE).
+ */
+struct dentry *d_obtain_alias(struct inode *inode)
+{
+	return __d_obtain_alias(inode, 1);
+}
 EXPORT_SYMBOL(d_obtain_alias);
 
 /**
+ * d_obtain_alias_root - find or allocate a dentry for a given inode
+ * @inode: inode to allocate the dentry for
+ *
+ * Obtain an IS_ROOT dentry for the root of a filesystem.
+ *
+ * We must ensure that directory inodes only ever have one dentry.  If a
+ * dentry is found, that is returned instead of allocating a new one.
+ *
+ * On successful return, the reference to the inode has been transferred
+ * to the dentry.  In case of an error the reference on the inode is
+ * released.  A %NULL or IS_ERR inode may be passed in and will be the
+ * error will be propagate to the return value, with a %NULL @inode
+ * replaced by ERR_PTR(-ESTALE).
+ */
+struct dentry *d_obtain_alias_root(struct inode *inode)
+{
+	return __d_obtain_alias(inode, 0);
+}
+EXPORT_SYMBOL(d_obtain_alias_root);
+
+/**
  * d_add_ci - lookup or allocate new dentry with case-exact name
  * @inode:  the inode case-insensitive lookup has found
  * @dentry: the negative dentry that was passed to the parent's lookup func
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 66984a9..7b32522 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -112,7 +112,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh,
 	 * if the dentry tree reaches them; however if the dentry already
 	 * exists, we'll pick it up at this point and use it as the root
 	 */
-	ret = d_obtain_alias(inode);
+	ret = d_obtain_alias_root(inode);
 	if (IS_ERR(ret)) {
 		dprintk("nfs_get_root: get root dentry failed\n");
 		goto out;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7ac2a12..a518a73 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -942,7 +942,7 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 			iput(inode);
 		}
 	} else {
-		dentry = d_obtain_alias(inode);
+		dentry = d_obtain_alias_root(inode);
 		if (IS_ERR(dentry)) {
 			ret = PTR_ERR(dentry);
 			goto failed_dentry;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index bf72e9a..2973aab 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -247,6 +247,7 @@ extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
 extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
 extern struct dentry *d_find_any_alias(struct inode *inode);
 extern struct dentry * d_obtain_alias(struct inode *);
+extern struct dentry * d_obtain_alias_root(struct inode *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
 extern void shrink_dcache_for_umount(struct super_block *);
-- 
1.8.5.3

