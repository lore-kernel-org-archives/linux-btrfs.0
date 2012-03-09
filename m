From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only use the existing eb if it's count isn't 0
Date: Fri,  9 Mar 2012 09:53:04 -0500
Message-ID: <1331304784-2745-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We can run into a problem where we find an eb for our existing page already on
the radix tree but it has a ref count of 0.  It hasn't yet been removed by RCU
yet so this can cause issues where we will use the EB after free.  So do
atomic_inc_not_zero on the exists->refs and if it is zero just do
synchronize_rcu() and try again.  We won't have to worry about new allocators
coming in since they will block on the page lock at this point.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 197595a..6d948eb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3732,7 +3732,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	}
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-
+again:
 	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
 	if (ret)
 		goto free_eb;
@@ -3742,7 +3742,13 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	if (ret == -EEXIST) {
 		exists = radix_tree_lookup(&tree->buffer,
 						start >> PAGE_CACHE_SHIFT);
-		atomic_inc(&exists->refs);
+		if (!atomic_inc_not_zero(&exists->refs)) {
+			spin_unlock(&tree->buffer_lock);
+			radix_tree_preload_end();
+			synchronize_rcu();
+			exists = NULL;
+			goto again;
+		}
 		spin_unlock(&tree->buffer_lock);
 		radix_tree_preload_end();
 		goto free_eb;
-- 
1.7.5.2

