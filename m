Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44629 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaBRU3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:09 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 1/9] dcache: move d_splice_alias
Date: Tue, 18 Feb 2014 15:28:57 -0500
Message-Id: <1392755345-12830-1-git-send-email-bfields@redhat.com>
In-Reply-To: <20140218202652.GA12374@fieldses.org>
References: <20140218202652.GA12374@fieldses.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

Just a trivial move to locate it near (similar) d_materialise_unique
code and save some forward references in a following patch.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/dcache.c | 104 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 265e0ce..332b58c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1905,58 +1905,6 @@ struct dentry *d_obtain_alias(struct inode *inode)
 EXPORT_SYMBOL(d_obtain_alias);
 
 /**
- * d_splice_alias - splice a disconnected dentry into the tree if one exists
- * @inode:  the inode which may have a disconnected dentry
- * @dentry: a negative dentry which we want to point to the inode.
- *
- * If inode is a directory and has a 'disconnected' dentry (i.e. IS_ROOT and
- * DCACHE_DISCONNECTED), then d_move that in place of the given dentry
- * and return it, else simply d_add the inode to the dentry and return NULL.
- *
- * This is needed in the lookup routine of any filesystem that is exportable
- * (via knfsd) so that we can build dcache paths to directories effectively.
- *
- * If a dentry was found and moved, then it is returned.  Otherwise NULL
- * is returned.  This matches the expected return value of ->lookup.
- *
- * Cluster filesystems may call this function with a negative, hashed dentry.
- * In that case, we know that the inode will be a regular file, and also this
- * will only occur during atomic_open. So we need to check for the dentry
- * being already hashed only in the final case.
- */
-struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
-{
-	struct dentry *new = NULL;
-
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
-
-	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&inode->i_lock);
-		new = __d_find_alias(inode, 1);
-		if (new) {
-			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
-			spin_unlock(&inode->i_lock);
-			security_d_instantiate(new, inode);
-			d_move(new, dentry);
-			iput(inode);
-		} else {
-			/* already taking inode->i_lock, so d_add() by hand */
-			__d_instantiate(dentry, inode);
-			spin_unlock(&inode->i_lock);
-			security_d_instantiate(dentry, inode);
-			d_rehash(dentry);
-		}
-	} else {
-		d_instantiate(dentry, inode);
-		if (d_unhashed(dentry))
-			d_rehash(dentry);
-	}
-	return new;
-}
-EXPORT_SYMBOL(d_splice_alias);
-
-/**
  * d_add_ci - lookup or allocate new dentry with case-exact name
  * @inode:  the inode case-insensitive lookup has found
  * @dentry: the negative dentry that was passed to the parent's lookup func
@@ -2716,6 +2664,58 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 }
 
 /**
+ * d_splice_alias - splice a disconnected dentry into the tree if one exists
+ * @inode:  the inode which may have a disconnected dentry
+ * @dentry: a negative dentry which we want to point to the inode.
+ *
+ * If inode is a directory and has a 'disconnected' dentry (i.e. IS_ROOT and
+ * DCACHE_DISCONNECTED), then d_move that in place of the given dentry
+ * and return it, else simply d_add the inode to the dentry and return NULL.
+ *
+ * This is needed in the lookup routine of any filesystem that is exportable
+ * (via knfsd) so that we can build dcache paths to directories effectively.
+ *
+ * If a dentry was found and moved, then it is returned.  Otherwise NULL
+ * is returned.  This matches the expected return value of ->lookup.
+ *
+ * Cluster filesystems may call this function with a negative, hashed dentry.
+ * In that case, we know that the inode will be a regular file, and also this
+ * will only occur during atomic_open. So we need to check for the dentry
+ * being already hashed only in the final case.
+ */
+struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
+{
+	struct dentry *new = NULL;
+
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	if (inode && S_ISDIR(inode->i_mode)) {
+		spin_lock(&inode->i_lock);
+		new = __d_find_alias(inode, 1);
+		if (new) {
+			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
+			spin_unlock(&inode->i_lock);
+			security_d_instantiate(new, inode);
+			d_move(new, dentry);
+			iput(inode);
+		} else {
+			/* already taking inode->i_lock, so d_add() by hand */
+			__d_instantiate(dentry, inode);
+			spin_unlock(&inode->i_lock);
+			security_d_instantiate(dentry, inode);
+			d_rehash(dentry);
+		}
+	} else {
+		d_instantiate(dentry, inode);
+		if (d_unhashed(dentry))
+			d_rehash(dentry);
+	}
+	return new;
+}
+EXPORT_SYMBOL(d_splice_alias);
+
+/**
  * d_materialise_unique - introduce an inode into the tree
  * @dentry: candidate dentry
  * @inode: inode to bind to the dentry, to which aliases may be attached
-- 
1.8.5.3

