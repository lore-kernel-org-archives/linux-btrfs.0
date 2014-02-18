Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44639 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaBRU3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:09 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 2/9] dcache: close d_move race in d_splice_alias
Date: Tue, 18 Feb 2014 15:28:58 -0500
Message-Id: <1392755345-12830-2-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

d_splice_alias will d_move an IS_ROOT() directory dentry into place if
one exists.  This should be safe as long as the dentry remains IS_ROOT,
but I can't see what guarantees that: once we drop the i_lock all we
hold here is the i_mutex on an unrelated parent directory.

Instead copy the logic of d_materialise_unique.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/dcache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 332b58c..fd50e52 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2695,9 +2695,14 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
+			write_seqlock(&rename_lock);
+			__d_materialise_dentry(dentry, new);
+			write_sequnlock(&rename_lock);
+			__d_drop(new);
+			_d_rehash(new);
+			spin_unlock(&new->d_lock);
 			spin_unlock(&inode->i_lock);
 			security_d_instantiate(new, inode);
-			d_move(new, dentry);
 			iput(inode);
 		} else {
 			/* already taking inode->i_lock, so d_add() by hand */
-- 
1.8.5.3

