From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: advance window_start if we're using a bitmap
Date: Tue, 24 Jan 2012 11:29:41 -0500
Message-ID: <1327422581-3618-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we span a long area in a bitmap we could end up taking a lot of time
searching to the next free area if we're searching from the original
window_start, so advance window_start in order to make sure we don't do any
superficial searching.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 43e75f2..c2f2059 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2251,6 +2251,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 						 offset_index);
 				continue;
 			}
+			cluster->window_start += bytes;
 		} else {
 			ret = entry->offset;
 
-- 
1.7.5.2

