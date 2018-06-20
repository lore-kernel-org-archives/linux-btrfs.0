Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39979 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932808AbeFTRDr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:03:47 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 1/3] btrfs: Fix indentation
Date: Wed, 20 Jun 2018 10:03:31 -0700
Message-Id: <20180620170333.29182-2-bart.vanassche@wdc.com>
In-Reply-To: <20180620170333.29182-1-bart.vanassche@wdc.com>
References: <20180620170333.29182-1-bart.vanassche@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch avoids that building the BTRFS source code with smatch
triggers complaints about inconsistent indenting.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/ioctl.c       | 4 ++--
 fs/btrfs/reada.c       | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..db46ceb62b3f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6279,7 +6279,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		if (list_empty(&cache->dirty_list)) {
 			list_add_tail(&cache->dirty_list,
 				      &trans->transaction->dirty_bgs);
-				trans->transaction->num_dirty_bgs++;
+			trans->transaction->num_dirty_bgs++;
 			btrfs_get_block_group(cache);
 		}
 		spin_unlock(&trans->transaction->dirty_bgs_lock);
@@ -7534,7 +7534,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		 * for the proper type.
 		 */
 		if (!block_group_bits(block_group, flags)) {
-		    u64 extra = BTRFS_BLOCK_GROUP_DUP |
+			u64 extra = BTRFS_BLOCK_GROUP_DUP |
 				BTRFS_BLOCK_GROUP_RAID1 |
 				BTRFS_BLOCK_GROUP_RAID5 |
 				BTRFS_BLOCK_GROUP_RAID6 |
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c2837a32d689..93b23549ee1e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2507,8 +2507,8 @@ static int btrfs_search_path_in_tree_user(struct inode *inode,
 static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 					   void __user *argp)
 {
-	 struct btrfs_ioctl_ino_lookup_args *args;
-	 struct inode *inode;
+	struct btrfs_ioctl_ino_lookup_args *args;
+	struct inode *inode;
 	int ret = 0;
 
 	args = memdup_user(argp, sizeof(*args));
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 40f1bcef394d..4be425f70c2d 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -355,7 +355,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		dev = bbio->stripes[nzones].dev;
 
 		/* cannot read ahead on missing device. */
-		 if (!dev->bdev)
+		if (!dev->bdev)
 			continue;
 
 		zone = reada_find_zone(dev, logical, bbio);
-- 
2.17.1

