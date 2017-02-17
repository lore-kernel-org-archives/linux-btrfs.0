Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34693 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934300AbdBQOnt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:49 -0500
Received: by mail-wr0-f196.google.com with SMTP id c4so5515731wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:49 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/38] btrfs: Make btrfs_log_all_parents take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:52 +0200
Message-Id: <1487342609-20652-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-log.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3cc972330ab3..a92a73139065 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5292,15 +5292,15 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 }
 
 static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
-				 struct inode *inode,
+				 struct btrfs_inode *inode,
 				 struct btrfs_log_ctx *ctx)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	const u64 ino = btrfs_ino(BTRFS_I(inode));
+	struct btrfs_root *root = inode->root;
+	const u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5511,7 +5511,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	 * and has a link count of 2.
 	 */
 	if (BTRFS_I(inode)->last_unlink_trans > last_committed) {
-		ret = btrfs_log_all_parents(trans, orig_inode, ctx);
+		ret = btrfs_log_all_parents(trans, BTRFS_I(orig_inode), ctx);
 		if (ret)
 			goto end_trans;
 	}
-- 
2.7.4

