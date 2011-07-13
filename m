From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't print the leaf if we had an error
Date: Wed, 13 Jul 2011 11:03:50 -0400
Message-ID: <1310569430-20410-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In __btrfs_free_extent we will print the leaf if we fail to find the extent we
wanted, but the problem is if we get an error we won't have a leaf so often this
leads to a NULL pointer dereference and we lose the error that actually
occurred.  So only print the leaf if ret > 0, which means we didn't find the
item we were looking for but we didn't error either.  This way the error is
preserved.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3e52b85..152669b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4447,7 +4447,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				printk(KERN_ERR "umm, got %d back from search"
 				       ", was looking for %llu\n", ret,
 				       (unsigned long long)bytenr);
-				btrfs_print_leaf(extent_root, path->nodes[0]);
+				if (ret > 0)
+					btrfs_print_leaf(extent_root,
+							 path->nodes[0]);
 			}
 			BUG_ON(ret);
 			extent_slot = path->slots[0];
-- 
1.7.5.2

