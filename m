From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't increase the block_rsv's size when emergency allocating space
Date: Mon, 22 Aug 2011 15:25:58 -0400
Message-ID: <1314041158-20533-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we have to emergency reserve space we need to not increase the block_rsv
size, otherwise we'll leak space.  Take for instance delalloc, say we reserve
4k, and we use that 4k, and then we have to emergency allocate another 4k, we
bump the size up to 8k, however we've only accounted for 4k in reservations in
all of our supporting logic, so we'll go to free the 4k and end up having a size
of 4k, which will cause us to later not free as much space.  I saw this doing
testing where I wasn't reserving enough space for something but was still
leaking space, very frustrating.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 99ab571..1f1d3e8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5707,9 +5707,6 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 		ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
 					     0);
 		if (!ret) {
-			spin_lock(&block_rsv->lock);
-			block_rsv->size += blocksize;
-			spin_unlock(&block_rsv->lock);
 			return block_rsv;
 		} else if (ret && block_rsv != global_rsv) {
 			ret = block_rsv_use_bytes(global_rsv, blocksize);
-- 
1.7.5.2

