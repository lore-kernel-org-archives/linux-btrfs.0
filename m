From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/4] fs/btrfs/inode.c: Add missing IS_ERR test
Date: Mon, 24 Jan 2011 20:55:19 +0100
Message-ID: <1295898922-18822-2-git-send-email-julia@diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295898922-18822-1-git-send-email-julia@diku.dk>
List-ID: <linux-btrfs.vger.kernel.org>

After the conditional that precedes the following code, inode may be an
ERR_PTR value.  This can eg result from a memory allocation failure via the
call to btrfs_iget, and thus does not imply that root is different than
sub_root.  Thus, an IS_ERR check is added to ensure that there is no
dereference of inode in this case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@
f(...) { ... return ERR_PTR(...); }

@@
identifier r.f, fld;
expression x;
statement S1,S2;
@@
 x = f(...)
 ... when != IS_ERR(x)
(
 if (IS_ERR(x) ||...) S1 else S2
|
*x->fld
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 160b55b..b322158 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4134,7 +4134,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	}
 	srcu_read_unlock(&root->fs_info->subvol_srcu, index);
 
-	if (root != sub_root) {
+	if (!IS_ERR(inode) && root != sub_root) {
 		down_read(&root->fs_info->cleanup_work_sem);
 		if (!(inode->i_sb->s_flags & MS_RDONLY))
 			btrfs_orphan_cleanup(sub_root);
