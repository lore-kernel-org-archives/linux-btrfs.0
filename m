Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36223 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdALOBF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:05 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so3894665wmr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:04 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 09/24] btrfs: Make btrfs_check_ref_name_override take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:35 +0200
Message-Id: <1484229650-24554-10-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0fc963454c82..2b44835b4dea 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4494,7 +4494,7 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 					 const int slot,
 					 const struct btrfs_key *key,
-					 struct inode *inode,
+					 struct btrfs_inode *inode,
 					 u64 *other_ino)
 {
 	int ret;
@@ -4550,9 +4550,8 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 		}
 
 		read_extent_buffer(eb, name, name_ptr, this_name_len);
-		di = btrfs_lookup_dir_item(NULL, BTRFS_I(inode)->root,
-					   search_path, parent,
-					   name, this_name_len, 0);
+		di = btrfs_lookup_dir_item(NULL, inode->root, search_path,
+				parent, name, this_name_len, 0);
 		if (di && !IS_ERR(di)) {
 			struct btrfs_key di_key;
 
@@ -4762,7 +4761,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 			ret = btrfs_check_ref_name_override(path->nodes[0],
 							    path->slots[0],
-							    &min_key, inode,
+							    &min_key, BTRFS_I(inode),
 							    &other_ino);
 			if (ret < 0) {
 				err = ret;
-- 
2.7.4

