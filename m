From: David Rientjes <rientjes@google.com>
Subject: [patch 2/6] btrfs: remove dependency on __GFP_NOFAIL
Date: Mon, 16 Aug 2010 19:57:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008161955110.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
List-ID: <linux-btrfs.vger.kernel.org>

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/btrfs/extent-tree.c |   18 ++++++++++++++----
 fs/btrfs/inode.c       |    5 ++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3822,6 +3822,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
+			int err;
+
 			old_val -= num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			cache->pinned += num_bytes;
@@ -3831,9 +3833,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
-			set_extent_dirty(info->pinned_extents,
+			do {
+				/* FIXME: this may potentially loop forever */
+				err = set_extent_dirty(info->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 GFP_NOFS);
+			} while (err);
 		}
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -3861,6 +3866,8 @@ static int pin_down_extent(struct btrfs_root *root,
 			   struct btrfs_block_group_cache *cache,
 			   u64 bytenr, u64 num_bytes, int reserved)
 {
+	int err;
+
 	spin_lock(&cache->space_info->lock);
 	spin_lock(&cache->lock);
 	cache->pinned += num_bytes;
@@ -3872,8 +3879,11 @@ static int pin_down_extent(struct btrfs_root *root,
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
-	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
-			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		err = set_extent_dirty(root->fs_info->pinned_extents, bytenr,
+			 bytenr + num_bytes - 1, GFP_NOFS);
+	} while (err);
 	return 0;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1967,7 +1967,10 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		delayed = kmalloc(sizeof(*delayed), GFP_NOFS);
+	} while (!delayed);
 	delayed->inode = inode;
 
 	spin_lock(&fs_info->delayed_iput_lock);
