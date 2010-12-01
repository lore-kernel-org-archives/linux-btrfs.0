From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 3/4] btrfs: reduce the times of mmap() in fill_inode_item()
Date: Wed, 01 Dec 2010 16:09:34 +0800
Message-ID: <4CF602BE.6090603@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With the old code, we must map the page every time we want to set a member
variable of the inode item, it is inefficient. We just do it at first.
By this way, we can improve the performance of file creation and deletion
by ~2%

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 46b9d1a..2f0c742 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2539,6 +2539,16 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode)
 {
+	int unmap_on_exit;
+
+	unmap_on_exit = (leaf->map_token == NULL);
+	if (unmap_on_exit)
+		map_extent_buffer(leaf, (unsigned long)item,
+				  sizeof(*item), &leaf->map_token,
+				  &leaf->kaddr, &leaf->map_start,
+				  &leaf->map_len, KM_USER1);
+
+
 	btrfs_set_inode_uid(leaf, item, inode->i_uid);
 	btrfs_set_inode_gid(leaf, item, inode->i_gid);
 	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
@@ -2567,6 +2577,11 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
 	btrfs_set_inode_block_group(leaf, item, BTRFS_I(inode)->block_group);
+
+	if (unmap_on_exit && leaf->map_token) {
+		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
+		leaf->map_token = NULL;
+	}
 }
 
 /*
-- 
1.7.0.1
