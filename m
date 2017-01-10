Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:33026 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdAJSf6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:35:58 -0500
Received: by mail-wj0-f193.google.com with SMTP id kp2so88396212wjc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:35:57 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 04/12] btrfs: Make btrfs_delayed_inode_reserve_metadata take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:34 +0200
Message-Id: <1484073342-28854-5-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 4059b4168210..7be90eb978d5 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -572,7 +572,7 @@ static void btrfs_delayed_item_release_metadata(struct btrfs_fs_info *fs_info,
 static int btrfs_delayed_inode_reserve_metadata(
 					struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
-					struct inode *inode,
+					struct btrfs_inode *inode,
 					struct btrfs_delayed_node *node)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -601,13 +601,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 * worth which is less likely to hurt us.
 	 */
 	if (src_rsv && src_rsv->type == BTRFS_BLOCK_RSV_DELALLOC) {
-		spin_lock(&BTRFS_I(inode)->lock);
+		spin_lock(&inode->lock);
 		if (test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-				       &BTRFS_I(inode)->runtime_flags))
+				       &inode->runtime_flags))
 			release = true;
 		else
 			src_rsv = NULL;
-		spin_unlock(&BTRFS_I(inode)->lock);
+		spin_unlock(&inode->lock);
 	}
 
 	/*
@@ -635,7 +635,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 			node->bytes_reserved = num_bytes;
 			trace_btrfs_space_reservation(fs_info,
 						      "delayed_inode",
-						      btrfs_ino(BTRFS_I(inode)),
+						      btrfs_ino(inode),
 						      num_bytes, 1);
 		}
 		return ret;
@@ -658,13 +658,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_inode",
-					      btrfs_ino(BTRFS_I(inode)), num_bytes, 1);
+					      btrfs_ino(inode), num_bytes, 1);
 		node->bytes_reserved = num_bytes;
 	}
 
 	if (release) {
 		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(BTRFS_I(inode)), num_bytes, 0);
+					      btrfs_ino(inode), num_bytes, 0);
 		btrfs_block_rsv_release(fs_info, src_rsv, num_bytes);
 	}
 
@@ -1839,7 +1839,7 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
-	ret = btrfs_delayed_inode_reserve_metadata(trans, root, inode,
+	ret = btrfs_delayed_inode_reserve_metadata(trans, root, BTRFS_I(inode),
 						   delayed_node);
 	if (ret)
 		goto release_node;
-- 
2.7.4

