Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54230 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3H2Upf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 16:45:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9ED617C0696
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 14:45:34 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 4l0KLJp2fMvMk6QT (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 14:45:34 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: only update disk_i_size as we remove extents
Date: Thu, 29 Aug 2013 16:45:31 -0400
Message-ID: <1377809131-25425-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a problem where if we fail a truncate we will leave the i_size set
where we wanted to truncate to instead of where we were able to truncate to.
Fix this by making btrfs_truncate_inode_items do the disk_i_size update as it
removes extents, that way it will always be consistent with where its extents
are.  Then if the truncate fails at all we can update the in-ram i_size with
what we have on disk and delete the orphan item.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 11b5927..26992ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3861,6 +3861,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 extent_num_bytes = 0;
 	u64 extent_offset = 0;
 	u64 item_end = 0;
+	u64 last_size = (u64)-1;
 	u32 found_type = (u8)-1;
 	int found_extent;
 	int del_item;
@@ -3958,6 +3959,11 @@ search_again:
 		if (found_type != BTRFS_EXTENT_DATA_KEY)
 			goto delete;
 
+		if (del_item)
+			last_size = found_key.offset;
+		else
+			last_size = new_size;
+
 		if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
 			u64 num_dec;
 			extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
@@ -4069,6 +4075,8 @@ out:
 			btrfs_abort_transaction(trans, root, ret);
 	}
 error:
+	if (last_size != (u64)-1)
+		btrfs_ordered_update_i_size(inode, last_size, NULL);
 	btrfs_free_path(path);
 	return err;
 }
@@ -4397,8 +4405,26 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		btrfs_inode_resume_unlocked_dio(inode);
 
 		ret = btrfs_truncate(inode);
-		if (ret && inode->i_nlink)
-			btrfs_orphan_del(NULL, inode);
+		if (ret && inode->i_nlink) {
+			int err;
+
+			/*
+			 * failed to truncate, disk_i_size is only adjusted down
+			 * as we remove extents, so it should represent the true
+			 * size of the inode, so reset the in memory size and
+			 * delete our orphan entry.
+			 */
+			trans = btrfs_join_transaction(root);
+			if (IS_ERR(trans)) {
+				btrfs_orphan_del(NULL, inode);
+				return ret;
+			}
+			i_size_write(inode, BTRFS_I(inode)->disk_i_size);
+			err = btrfs_orphan_del(trans, inode);
+			if (err)
+				btrfs_abort_transaction(trans, root, err);
+			btrfs_end_transaction(trans, root);
+		}
 	}
 
 	return ret;
@@ -7553,7 +7579,6 @@ static int btrfs_truncate(struct inode *inode)
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
-	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 
 	/*
 	 * Yes ladies and gentelment, this is indeed ugly.  The fact is we have
-- 
1.7.7.6

