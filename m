Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42841 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3CAQos (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 11:44:48 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 02FF97C0445
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2013 09:44:48 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id QH2eXQeQAeVSqoFx (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2013 09:44:47 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: delete inline extents when we find them during logging
Date: Fri, 1 Mar 2013 11:51:55 -0500
Message-ID: <1362156715-9253-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apparently when we do inline extents we allow the data to overlap the last chunk
of the btrfs_file_extent_item, which means that we can possibly have a
btrfs_file_extent_item that isn't actually as large as a btrfs_file_extent_item.
This messes with us when we try to overwrite the extent when logging new extents
since we expect for it to be the right size.  To fix this just delete the item
and try to do the insert again which will give us the proper sized
btrfs_file_extent_item.  This fixes a panic where map_private_extent_buffer
would blow up because we're trying to write past the end of the leaf.  Thanks,

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8e85e0e..c7ef569 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3300,6 +3300,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	int index = log->log_transid % 2;
 	bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
+insert:
 	INIT_LIST_HEAD(&ordered_sums);
 	btrfs_init_map_token(&token);
 	key.objectid = btrfs_ino(inode);
@@ -3315,6 +3316,23 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
+
+	/*
+	 * If we are overwriting an inline extent with a real one then we need
+	 * to just delete the inline extent as it may not be large enough to
+	 * have the entire file_extent_item.
+	 */
+	if (ret && btrfs_token_file_extent_type(leaf, fi, &token) ==
+	    BTRFS_FILE_EXTENT_INLINE) {
+		ret = btrfs_del_item(trans, log, path);
+		btrfs_release_path(path);
+		if (ret) {
+			path->really_keep_locks = 0;
+			return ret;
+		}
+		goto insert;
+	}
+
 	btrfs_set_token_file_extent_generation(leaf, fi, em->generation,
 					       &token);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
-- 
1.7.7.6

