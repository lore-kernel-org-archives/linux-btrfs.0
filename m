Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44625 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaBRU3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:08 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 6/9] dcache: remove unused d_find_alias parameter
Date: Tue, 18 Feb 2014 15:29:02 -0500
Message-Id: <1392755345-12830-6-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/dcache.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3a1057a..efe3d3b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -719,8 +719,6 @@ EXPORT_SYMBOL(dget_parent);
 /**
  * d_find_alias - grab a hashed alias of inode
  * @inode: inode in question
- * @want_discon:  flag, used by d_splice_alias, to request
- *          that only a DISCONNECTED alias be returned.
  *
  * If inode has a hashed alias, or is a directory and has any alias,
  * acquire the reference to alias and return it. Otherwise return NULL.
@@ -729,10 +727,9 @@ EXPORT_SYMBOL(dget_parent);
  * of a filesystem.
  *
  * If the inode has an IS_ROOT, DCACHE_DISCONNECTED alias, then prefer
- * any other hashed alias over that one unless @want_discon is set,
- * in which case only return an IS_ROOT, DCACHE_DISCONNECTED alias.
+ * any other hashed alias over that one.
  */
-static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
+static struct dentry *__d_find_alias(struct inode *inode)
 {
 	struct dentry *alias, *discon_alias;
 
@@ -744,7 +741,7 @@ again:
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				discon_alias = alias;
-			} else if (!want_discon) {
+			} else {
 				__dget_dlock(alias);
 				spin_unlock(&alias->d_lock);
 				return alias;
@@ -775,7 +772,7 @@ struct dentry *d_find_alias(struct inode *inode)
 
 	if (!hlist_empty(&inode->i_dentry)) {
 		spin_lock(&inode->i_lock);
-		de = __d_find_alias(inode, 0);
+		de = __d_find_alias(inode);
 		spin_unlock(&inode->i_lock);
 	}
 	return de;
@@ -2784,7 +2781,7 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 		struct dentry *alias;
 
 		/* Does an aliased dentry already exist? */
-		alias = __d_find_alias(inode, 0);
+		alias = __d_find_alias(inode);
 		if (alias) {
 			actual = alias;
 			write_seqlock(&rename_lock);
-- 
1.8.5.3

