From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 07/12] Btrfs: add checksum check for log
Date: Thu, 30 Jun 2011 15:36:27 +0800
Message-ID: <1309419392-17770-8-git-send-email-liubo2009@cn.fujitsu.com>
References: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <dave@jikos.cz>, <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If a inode is a BTRFS_INODE_NODATASUM one, it need not to look for csum items
any more.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0ccffb1..5b5c336 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2681,11 +2681,12 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
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
 
@@ -2740,7 +2741,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
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

