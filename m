Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58562 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752360AbaKGMQX (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 7 Nov 2014 07:16:23 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: avoid crash when overflowing a dir_item
Date: Fri,  7 Nov 2014 12:15:15 +0000
Message-Id: <1415362515-4118-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When attempting to insert a new dir_item, we were calling btrfs_extent_item()
without checking if the leaf has enough space to extend the item. This made
btrfs_extent_item() crash through a BUG() call.
Therefore do the check and return ENOSPC if the leaf doesn't have enough space.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/dir-item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index fc8df86..65bf60e 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -53,6 +53,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
 		if (di)
 			return ERR_PTR(-EEXIST);
+		if (btrfs_leaf_free_space(root, path->nodes[0]) < data_size)
+			return ERR_PTR(-ENOSPC);
 		btrfs_extend_item(root, path, data_size);
 	} else if (ret < 0)
 		return ERR_PTR(ret);
-- 
1.9.1

