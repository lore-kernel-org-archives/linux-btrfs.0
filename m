From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 4/4] Btrfs: try not to sleep as much when doing slow caching
Date: Wed, 11 May 2011 17:35:55 -0400
Message-ID: <1305149755-4413-4-git-send-email-josef@redhat.com>
References: <1305149755-4413-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305149755-4413-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

When the fs is super full and we unmount the fs, we could get stuck in this
thing where unmount is waiting for the caching kthread to make progress and the
caching kthread keeps scheduling because we're in the middle of a commit.  So
instead just let the caching kthread keep going and only yeild if
need_resched().  This makes my horrible umount case go from taking up to 10
minutes to taking less than 20 seconds.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d24414..edc1880 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -359,15 +359,18 @@ again:
 			if (ret)
 				break;
 
-			caching_ctl->progress = last;
-			btrfs_release_path(extent_root, path);
-			up_read(&fs_info->extent_commit_sem);
-			mutex_unlock(&caching_ctl->mutex);
-			if (btrfs_transaction_in_commit(fs_info))
-				schedule_timeout(1);
-			else
+			if (need_resched() ||
+			    btrfs_next_leaf(extent_root, path)) {
+				caching_ctl->progress = last;
+				btrfs_release_path(extent_root, path);
+				up_read(&fs_info->extent_commit_sem);
+				mutex_unlock(&caching_ctl->mutex);
 				cond_resched();
-			goto again;
+				goto again;
+			}
+			leaf = path->nodes[0];
+			nritems = btrfs_header_nritems(leaf);
+			continue;
 		}
 
 		if (key.objectid < block_group->key.objectid) {
-- 
1.7.2.3

