From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 7/9] Btrfs: add checksum check for log
Date: Thu, 19 May 2011 16:11:30 +0800
Message-ID: <1305792692-10635-8-git-send-email-liubo2009@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If a inode is a BTRFS_INODE_NODATASUM one, it need not to look for csum items
any more.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 745933c..28b088b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2652,7 +2652,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       struct inode *inode,
 			       struct btrfs_path *dst_path,
 			       struct extent_buffer *src,
-			       int start_slot, int nr, int inode_only)
+			       int start_slot, int nr, int inode_only,
+			       int csum)
 {
 	unsigned long src_offset;
 	unsigned long dst_offset;
@@ -2719,7 +2720,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		 * or deletes of this inode don't have to relog the inode
 		 * again
 		 */
-		if (btrfs_key_type(ins_keys + i) == BTRFS_EXTENT_DATA_KEY) {
+		if (btrfs_key_type(ins_keys + i) ==
+						BTRFS_EXTENT_DATA_KEY && csum) {
 			int found_type;
 			extent = btrfs_item_ptr(src, start_slot + i,
 						struct btrfs_file_extent_item);
@@ -2833,6 +2835,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int ins_start_slot = 0;
 	int ins_nr;
 	u64 transid;
+	int csum = (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) ? 0 : 1;
 
 	/*
 	 * We use transid in btrfs_search_forward() as a filter, in order to
@@ -2903,7 +2906,7 @@ filter:
 		if (ins_nr) {
 			ret = copy_items(trans, inode, dst_path, src,
 					 ins_start_slot,
-					 ins_nr, inode_only);
+					 ins_nr, inode_only, csum);
 			if (ret) {
 				err = ret;
 				goto out_unlock;
@@ -2922,7 +2925,7 @@ next_slot:
 		if (ins_nr) {
 			ret = copy_items(trans, inode, dst_path, src,
 					 ins_start_slot,
-					 ins_nr, inode_only);
+					 ins_nr, inode_only, csum);
 			if (ret) {
 				err = ret;
 				goto out_unlock;
@@ -2943,7 +2946,7 @@ next_slot:
 	if (ins_nr) {
 		ret = copy_items(trans, inode, dst_path, src,
 				 ins_start_slot,
-				 ins_nr, inode_only);
+				 ins_nr, inode_only, csum);
 		if (ret) {
 			err = ret;
 			goto out_unlock;
-- 
1.6.5.2

