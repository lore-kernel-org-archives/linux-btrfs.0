From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: balance_level checks !child after access
Date: Wed, 04 Feb 2009 13:54:48 -0500
Message-ID: <4989E478.4030907@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The BUG_ON(!child) should be before it's used.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/btrfs/ctree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -917,9 +917,9 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 		/* promote the child to a root */
 		child = read_node_slot(root, mid, 0);
+		BUG_ON(!child);
 		btrfs_tree_lock(child);
 		btrfs_set_lock_blocking(child);
-		BUG_ON(!child);
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child, 0);
 		BUG_ON(ret);
 
-- 
Jeff Mahoney
SUSE Labs
