Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34712 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdAQWj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:59 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so9426718wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:39:58 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 09/24] btrfs: Make btrfs_check_ref_name_override take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:35 +0200
Message-Id: <1484692310-3987-10-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 20718cfebf89..7669e95be423 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4495,7 +4495,7 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 					 const int slot,
 					 const struct btrfs_key *key,
-					 struct inode *inode,
+					 struct btrfs_inode *inode,
 					 u64 *other_ino)
 {
 	int ret;
@@ -4551,9 +4551,8 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 		}
 
 		read_extent_buffer(eb, name, name_ptr, this_name_len);
-		di = btrfs_lookup_dir_item(NULL, BTRFS_I(inode)->root,
-					   search_path, parent,
-					   name, this_name_len, 0);
+		di = btrfs_lookup_dir_item(NULL, inode->root, search_path,
+				parent, name, this_name_len, 0);
 		if (di && !IS_ERR(di)) {
 			struct btrfs_key di_key;
 
@@ -4769,7 +4768,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 			ret = btrfs_check_ref_name_override(path->nodes[0],
 							    path->slots[0],
-							    &min_key, inode,
+							    &min_key, BTRFS_I(inode),
 							    &other_ino);
 			if (ret < 0) {
 				err = ret;
-- 
2.7.4

