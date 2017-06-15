Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58467 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750803AbdFORK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 13:10:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C16F8AC41
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 17:10:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: cleanup duplicate return value in insert_inline_extent
Date: Thu, 15 Jun 2017 19:09:51 +0200
Message-Id: <20170615170951.27944-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The pattern when err is used for function exit and ret is used for
return values of callees is not used here.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a21a984d84d9..e837713d0d05 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -177,7 +177,6 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	char *kaddr;
 	unsigned long ptr;
 	struct btrfs_file_extent_item *ei;
-	int err = 0;
 	int ret;
 	size_t cur_size = size;
 	unsigned long offset;
@@ -199,10 +198,8 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		path->leave_spinning = 1;
 		ret = btrfs_insert_empty_item(trans, root, path, &key,
 					      datasize);
-		if (ret) {
-			err = ret;
+		if (ret)
 			goto fail;
-		}
 	}
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, path->slots[0],
@@ -257,9 +254,8 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->disk_i_size = inode->i_size;
 	ret = btrfs_update_inode(trans, root, inode);
 
-	return ret;
 fail:
-	return err;
+	return ret;
 }
 
 
-- 
2.13.0

