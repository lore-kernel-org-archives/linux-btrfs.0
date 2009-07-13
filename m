From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/4] fs/btrfs: adjust NULL test
Date: Mon, 13 Jul 2009 22:48:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907132244330.12374@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Move the call to BUG_ON to before the dereference of the tested value.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E,E1;
identifier f,l;
position p1,p2;
@@

*x@p1->f = E1;
... when != x = E
    when != goto l;
(
*x@p2 == NULL
|
*x@p2 != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/inode.c                    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ffa3d3..8cc6025 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2604,8 +2604,8 @@ noinline int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (root->ref_cows)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 	path = btrfs_alloc_path();
-	path->reada = -1;
 	BUG_ON(!path);
+	path->reada = -1;
 
 	/* FIXME, add redo link to tree so we don't leak on crash */
 	key.objectid = inode->i_ino;
