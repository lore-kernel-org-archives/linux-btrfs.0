Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbdBTSZo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:25:44 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B0D0AAB2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:25:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: do proper error handling in btrfs_insert_xattr_item
Date: Mon, 20 Feb 2017 19:25:06 +0100
Message-Id: <e204841964263393974c193010c74648faa5a761.1487614974.git.dsterba@suse.com>
In-Reply-To: <cover.1487614974.git.dsterba@suse.com>
References: <cover.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The space check in btrfs_insert_xattr_item is duplicated in it's caller
(do_setxattr) so we won't hit the BUG_ON. Continuing without any check
could be disasterous so turn it to a proper error handling.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dir-item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 724504a2d7ac..640801082533 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -80,7 +80,8 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	u32 data_size;
 
-	BUG_ON(name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info));
+	if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info))
+		return -ENOSPC;
 
 	key.objectid = objectid;
 	key.type = BTRFS_XATTR_ITEM_KEY;
-- 
2.10.1

