From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check free space in block group before searching for a cluster
Date: Fri, 18 Mar 2011 15:16:26 -0400
Message-ID: <1300475786-1836-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The free space cluster stuff is heavy duty, so there is no sense in going
through the entire song and dance if there isn't enough space in the block group
to begin with.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0282033..f631df8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1999,6 +1999,16 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		min_bytes = max(bytes, (bytes + empty_size) >> 2);
 
 	spin_lock(&block_group->tree_lock);
+
+	/*
+	 * If we know we don't have enough space to make a cluster don't even
+	 * bother doing all the work to try and find one.
+	 */
+	if (block_group->free_space < min_bytes) {
+		spin_unlock(&block_group->tree_lock);
+		return -ENOSPC;
+	}
+
 	spin_lock(&cluster->lock);
 
 	/* someone already found a cluster, hooray */
-- 
1.7.2.3

