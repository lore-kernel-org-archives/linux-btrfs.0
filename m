From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/5] fs/btrfs: Eliminate memory leak
Date: Tue, 24 Aug 2010 16:39:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008241638560.15172@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

This code is preceded by a call to btrfs_alloc_path, which allocates some
memory.  There is some error handling code at the end of the function that
frees it, that can be taken advantage of with a little ordering adjustment.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = btrfs_alloc_path(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/inode.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..d38587c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4438,15 +4438,14 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BUG_ON(!path);
 
 	inode = new_inode(root->fs_info->sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
+	if (!inode) {
+		ret = -ENOMEM;
+		goto fail_path;
+	}
 	if (dir) {
 		ret = btrfs_set_inode_index(dir, index);
-		if (ret) {
-			iput(inode);
-			return ERR_PTR(ret);
-		}
+		if (ret)
+			goto fail_inode;
 	}
 	/*
 	 * index_cnt is ignored for everything but a dir,
@@ -4519,8 +4518,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 fail:
 	if (dir)
 		BTRFS_I(dir)->index_cnt--;
-	btrfs_free_path(path);
+fail_inode:
 	iput(inode);
+fail_path:
+	btrfs_free_path(path);
 	return ERR_PTR(ret);
 }
 
