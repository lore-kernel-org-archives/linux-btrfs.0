Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39234 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdEBJZl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 05:25:41 -0400
Date: Tue, 2 May 2017 12:25:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Btrfs: remove an unused variable
Message-ID: <20170502092527.rpb42y7ngvh5tkei@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"item" is never used.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e4e4532f381..337aef86dae5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5881,7 +5881,6 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_item *item;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -5932,7 +5931,6 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 			continue;
 		}
 
-		item = btrfs_item_nr(slot);
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 		if (found_key.objectid != key.objectid)
