Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35504 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934464AbdBQOoZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:25 -0500
Received: by mail-wm0-f67.google.com with SMTP id u63so2927665wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:24 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 38/38] btrfs: Make btrfs_del_delalloc_inode take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:29 +0200
Message-Id: <1487342609-20652-39-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d78ec8d78781..d83ec55f00d5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1635,15 +1635,15 @@ static void btrfs_add_delalloc_inodes(struct btrfs_root *root,
 }
 
 static void btrfs_del_delalloc_inode(struct btrfs_root *root,
-				     struct inode *inode)
+				     struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 
 	spin_lock(&root->delalloc_lock);
-	if (!list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
-		list_del_init(&BTRFS_I(inode)->delalloc_inodes);
+	if (!list_empty(&inode->delalloc_inodes)) {
+		list_del_init(&inode->delalloc_inodes);
 		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-			  &BTRFS_I(inode)->runtime_flags);
+			  &inode->runtime_flags);
 		root->nr_delalloc_inodes--;
 		if (!root->nr_delalloc_inodes) {
 			spin_lock(&fs_info->delalloc_root_lock);
@@ -1762,7 +1762,7 @@ static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
 		inode->delalloc_bytes -= len;
 		if (do_list && inode->delalloc_bytes == 0 &&
 		    test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &inode->runtime_flags))
-			btrfs_del_delalloc_inode(root, &inode->vfs_inode);
+			btrfs_del_delalloc_inode(root, inode);
 		spin_unlock(&inode->lock);
 	}
 }
-- 
2.7.4

