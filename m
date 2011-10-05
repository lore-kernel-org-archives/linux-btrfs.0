From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: take overflow into account in reserving space
Date: Wed,  5 Oct 2011 16:35:51 -0400
Message-ID: <1317846951-19323-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My overcommit stuff can be a little racy when we're filling up the disk with
fs_mark and we overcommit into things that quickly get used up for data.  So use
num_bytes to see if we have enough available space so we're less likely to
overcommit ourselves out of the ability to make reservations.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f9711a8..f95e550 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3521,7 +3521,7 @@ again:
 			avail >>= 1;
 		 spin_unlock(&root->fs_info->free_chunk_lock);
 
-		if (used + orig_bytes < space_info->total_bytes + avail) {
+		if (used + num_bytes < space_info->total_bytes + avail) {
 			space_info->bytes_may_use += orig_bytes;
 			ret = 0;
 		}
-- 
1.7.5.2

