Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38195 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:39 -0400
Received: by mail-qt0-f193.google.com with SMTP id x7-v6so29180768qtk.5
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:59:13 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 34/36] btrfs: fix insert_reserved error handling
Date: Tue, 11 Sep 2018 13:58:05 -0400
Message-Id: <20180911175807.26181-35-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were not handling the reserved byte accounting properly for data
references.  Metadata was fine, if it errored out the error paths would
free the bytes_reserved count and pin the extent, but it even missed one
of the error cases.  So instead move this handling up into
run_one_delayed_ref so we are sure that both cases are properly cleaned
up in case of a transaction abort.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47690589d89b..414492a18f1e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2405,6 +2405,9 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 					   insert_reserved);
 	else
 		BUG();
+	if (ret && insert_reserved)
+		btrfs_pin_extent(trans->fs_info, node->bytenr,
+				 node->num_bytes, 1);
 	return ret;
 }
 
@@ -8252,21 +8255,14 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	}
 
 	path = btrfs_alloc_path();
-	if (!path) {
-		btrfs_free_and_pin_reserved_extent(fs_info,
-						   extent_key.objectid,
-						   fs_info->nodesize);
+	if (!path)
 		return -ENOMEM;
-	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      &extent_key, size);
 	if (ret) {
 		btrfs_free_path(path);
-		btrfs_free_and_pin_reserved_extent(fs_info,
-						   extent_key.objectid,
-						   fs_info->nodesize);
 		return ret;
 	}
 
-- 
2.14.3
