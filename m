From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: map the inode item when doing fill_inode_item
Date: Tue,  5 Apr 2011 13:02:27 -0400
Message-ID: <1302022947-4883-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Instead of calling kmap_atomic for every thing we set in the inode item, map the
entire inode item at the start and unmap it at the end.  This makes a sequential
dd of 400mb O_DIRECT something like 1% faster.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9e9417b..5c5e1c4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2581,6 +2581,13 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode)
 {
+	if (!leaf->map_token)
+		map_private_extent_buffer(leaf, (unsigned long)item,
+					  sizeof(struct btrfs_inode_item),
+					  &leaf->map_token, &leaf->kaddr,
+					  &leaf->map_start, &leaf->map_len,
+					  KM_USER1);
+
 	btrfs_set_inode_uid(leaf, item, inode->i_uid);
 	btrfs_set_inode_gid(leaf, item, inode->i_gid);
 	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
@@ -2609,6 +2616,11 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
 	btrfs_set_inode_block_group(leaf, item, BTRFS_I(inode)->block_group);
+
+	if (leaf->map_token) {
+		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
+		leaf->map_token = NULL;
+	}
 }
 
 /*
-- 
1.7.2.3

