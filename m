Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44624 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaBRU3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:08 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3/9] dcache: d_splice_alias mustn't create directory aliases
Date: Tue, 18 Feb 2014 15:28:59 -0500
Message-Id: <1392755345-12830-3-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

Currently if d_splice_alias finds a directory with an alias that is not
IS_ROOT or not DCACHE_DISCONNECTED, it creates a duplicate directory.

Duplicate directory dentries are unacceptable; it is better just to
error out.

(In the case of a local filesystem the most likely case is filesystem
corruption: for example, perhaps two directories point to the same child
directory, and the other parent has already been found and cached.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/dcache.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index fd50e52..4550227 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2672,6 +2672,9 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
  * DCACHE_DISCONNECTED), then d_move that in place of the given dentry
  * and return it, else simply d_add the inode to the dentry and return NULL.
  *
+ * If a non-IS_ROOT directory is found, the filesystem is corrupt, and
+ * we should error out: directories can't have multiple aliases.
+ *
  * This is needed in the lookup routine of any filesystem that is exportable
  * (via knfsd) so that we can build dcache paths to directories effectively.
  *
@@ -2692,9 +2695,13 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		spin_lock(&inode->i_lock);
-		new = __d_find_alias(inode, 1);
+		new = __d_find_any_alias(inode);
 		if (new) {
-			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
+			if (!IS_ROOT(new) || !(new->d_flags & DCACHE_DISCONNECTED)) {
+				spin_unlock(&inode->i_lock);
+				dput(new);
+				return ERR_PTR(-EIO);
+			}
 			write_seqlock(&rename_lock);
 			__d_materialise_dentry(dentry, new);
 			write_sequnlock(&rename_lock);
-- 
1.8.5.3

