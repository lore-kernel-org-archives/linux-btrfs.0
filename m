From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix fallocate regression
Date: Mon,  7 Jun 2010 14:26:37 -0400
Message-ID: <1275935197-4306-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Seems that when btrfs_fallocate was converted to use the new ENOSPC stuff we
dropped passing the mode to the function that actually does the preallocation.
This breaks anybody who wants to use FALLOC_FL_KEEP_SIZE.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2551b80..d999c53 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6893,7 +6893,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
-			ret = btrfs_prealloc_file_range(inode, 0, cur_offset,
+			ret = btrfs_prealloc_file_range(inode, mode, cur_offset,
 							last_byte - cur_offset,
 							1 << inode->i_blkbits,
 							offset + len,
-- 
1.6.6.1

