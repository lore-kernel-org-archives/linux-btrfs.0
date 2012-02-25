From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: don't add both copies of DUP to reada extent tree
Date: Sat, 25 Feb 2012 09:09:47 +0100
Message-ID: <1330157387-6803-1-git-send-email-sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Normally when there are 2 copies of a block, we add both to the
reada extent tree and prefetch only the one that is easier to reach.
This way we can better utilize multiple devices.
In case of DUP this makes no sense as both copies reside on the
same device.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/reada.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 85ce503..8127ae9 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -325,6 +325,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct btrfs_bio *bbio = NULL;
 	struct btrfs_device *dev;
+	struct btrfs_device *prev_dev;
 	u32 blocksize;
 	u64 length;
 	int nzones = 0;
@@ -404,8 +405,20 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		spin_unlock(&fs_info->reada_lock);
 		goto error;
 	}
+	prev_dev = NULL;
 	for (i = 0; i < nzones; ++i) {
 		dev = bbio->stripes[i].dev;
+		if (dev == prev_dev) {
+			/*
+			 * in case of DUP, just add the first zone. As both
+			 * are on the same device, there's nothing to gain
+			 * from adding both.
+			 * Also, it wouldn't work, as the tree is per device
+			 * and adding would fail with EEXIST
+			 */
+			continue;
+		}
+		prev_dev = dev;
 		ret = radix_tree_insert(&dev->reada_extents, index, re);
 		if (ret) {
 			while (--i >= 0) {
-- 
1.7.3.4

