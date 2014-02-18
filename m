Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44635 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaBRU3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:09 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4/9] dcache: d_splice_alias should ignore DCACHE_DISCONNECTED
Date: Tue, 18 Feb 2014 15:29:00 -0500
Message-Id: <1392755345-12830-4-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

Any IS_ROOT() alias should be safe to use; there's nothing special about
DCACHE_DISCONNECTED dentries.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/dcache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4550227..e3e4618 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2668,9 +2668,9 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
  * @inode:  the inode which may have a disconnected dentry
  * @dentry: a negative dentry which we want to point to the inode.
  *
- * If inode is a directory and has a 'disconnected' dentry (i.e. IS_ROOT and
- * DCACHE_DISCONNECTED), then d_move that in place of the given dentry
- * and return it, else simply d_add the inode to the dentry and return NULL.
+ * If inode is a directory and has an IS_ROOT alias, then d_move that in
+ * place of the given dentry and return it, else simply d_add the inode
+ * to the dentry and return NULL.
  *
  * If a non-IS_ROOT directory is found, the filesystem is corrupt, and
  * we should error out: directories can't have multiple aliases.
@@ -2697,7 +2697,7 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 		spin_lock(&inode->i_lock);
 		new = __d_find_any_alias(inode);
 		if (new) {
-			if (!IS_ROOT(new) || !(new->d_flags & DCACHE_DISCONNECTED)) {
+			if (!IS_ROOT(new)) {
 				spin_unlock(&inode->i_lock);
 				dput(new);
 				return ERR_PTR(-EIO);
-- 
1.8.5.3

