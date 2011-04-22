From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 05/12] btrfs: remove useless mutex lock/unlock sequences
Date: Fri, 22 Apr 2011 11:41:51 +0200
Message-ID: <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31f33ba..c97ceab 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -756,8 +756,6 @@ again:
 
 			btrfs_release_path(root->fs_info->extent_root, path);
 
-			mutex_lock(&head->mutex);
-			mutex_unlock(&head->mutex);
 			btrfs_put_delayed_ref(&head->node);
 			goto again;
 		}
@@ -2297,8 +2295,6 @@ again:
 				atomic_inc(&ref->refs);
 
 				spin_unlock(&delayed_refs->lock);
-				mutex_lock(&head->mutex);
-				mutex_unlock(&head->mutex);
 
 				btrfs_put_delayed_ref(ref);
 				cond_resched();
@@ -2363,8 +2359,6 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 
 		btrfs_release_path(root->fs_info->extent_root, path);
 
-		mutex_lock(&head->mutex);
-		mutex_unlock(&head->mutex);
 		btrfs_put_delayed_ref(&head->node);
 		return -EAGAIN;
 	}
-- 
1.7.5.rc3

