From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 08/12 v5] Btrfs: add checksum check for log
Date: Sat, 6 Aug 2011 17:37:43 +0800
Message-ID: <1312623467-31487-9-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If a inode is a BTRFS_INODE_NODATASUM one, it need not to look for csum items
any more.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5394055..15b6f71 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2687,11 +2687,12 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_key *ins_keys;
-	int ret;
+	struct list_head ordered_sums;
 	u32 *ins_sizes;
 	char *ins_data;
+	int ret;
 	int i;
-	struct list_head ordered_sums;
+	int csum = (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) ? 0 : 1;
 
 	INIT_LIST_HEAD(&ordered_sums);
 
@@ -2746,7 +2747,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		 * or deletes of this inode don't have to relog the inode
 		 * again
 		 */
-		if (btrfs_key_type(ins_keys + i) == BTRFS_EXTENT_DATA_KEY) {
+		if (btrfs_key_type(ins_keys + i) ==
+						BTRFS_EXTENT_DATA_KEY && csum) {
 			int found_type;
 			extent = btrfs_item_ptr(src, start_slot + i,
 						struct btrfs_file_extent_item);
-- 
1.6.5.2

