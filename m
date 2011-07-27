From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix oops while writing data to SSD partitions
Date: Wed, 27 Jul 2011 17:49:18 +0800
Message-ID: <4E2FDF1E.8080206@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here I have a two SSD-partitions btrfs, and they are defaultly set to
"data=raid0, metadata=raid1", then I try to fill my btrfs partition
till "No space left on device", via "dd if=/dev/zero of=/mnt/btrfs/tmp".

I get an oops panic from kernel BUG at fs/btrfs/extent-tree.c:5199!, which
refers to find_free_extent's
BUG_ON(index != get_block_group_index(block_group));

In SSD mode, in order to find enough space to alloc, we may check the
block_group cache which has been checked sometime before, but the index is not
updated, where it hits the BUG_ON.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..3213c39 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5065,7 +5065,9 @@ have_block_group:
 			 * group is does point to and try again
 			 */
 			if (!last_ptr_loop && last_ptr->block_group &&
-			    last_ptr->block_group != block_group) {
+			    last_ptr->block_group != block_group &&
+			    index <=
+				 get_block_group_index(last_ptr->block_group)) {
 
 				btrfs_put_block_group(block_group);
 				block_group = last_ptr->block_group;
-- 
1.6.5.2


