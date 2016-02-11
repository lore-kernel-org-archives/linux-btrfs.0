Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcBKRXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3FBECAB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 17:23:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: switch balance item to the temporary item key
Date: Thu, 11 Feb 2016 18:23:31 +0100
Message-Id: <c479cb4f14f99868108da99568950e5311e1fe4c.1455209994.git.dsterba@suse.com>
In-Reply-To: <cover.1455209994.git.dsterba@suse.com>
References: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No visible change.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335946fa..b306a205504b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2966,7 +2966,7 @@ static int insert_balance_item(struct btrfs_root *root,
 	}
 
 	key.objectid = BTRFS_BALANCE_OBJECTID;
-	key.type = BTRFS_BALANCE_ITEM_KEY;
+	key.type = BTRFS_TEMPORARY_ITEM_KEY;
 	key.offset = 0;
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
@@ -3015,7 +3015,7 @@ static int del_balance_item(struct btrfs_root *root)
 	}
 
 	key.objectid = BTRFS_BALANCE_OBJECTID;
-	key.type = BTRFS_BALANCE_ITEM_KEY;
+	key.type = BTRFS_TEMPORARY_ITEM_KEY;
 	key.offset = 0;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
@@ -3867,7 +3867,7 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 		return -ENOMEM;
 
 	key.objectid = BTRFS_BALANCE_OBJECTID;
-	key.type = BTRFS_BALANCE_ITEM_KEY;
+	key.type = BTRFS_TEMPORARY_ITEM_KEY;
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
-- 
2.7.1

