Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbbANSgo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:36:44 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AA42DAB0E
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 18:36:43 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/5] btrfs: simplify insert_orphan_item
Date: Wed, 14 Jan 2015 19:36:43 +0100
Message-Id: <f8027f4da166f82301770fd54783cc047df95d4a.1421259762.git.dsterba@suse.cz>
In-Reply-To: <cover.1421259762.git.dsterba@suse.cz>
References: <cover.1421259762.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can search and add the orphan item in one go,
btrfs_insert_orphan_item will find out if the item already exists.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/tree-log.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5be45c12dd71..25a1c363a5f4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1254,21 +1254,13 @@ out:
 }
 
 static int insert_orphan_item(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 offset)
+			      struct btrfs_root *root, u64 ino)
 {
 	int ret;
-	struct btrfs_path *path;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
 
-	ret = btrfs_find_item(root, path, BTRFS_ORPHAN_OBJECTID,
-			offset, BTRFS_ORPHAN_ITEM_KEY, NULL);
-	if (ret > 0)
-		ret = btrfs_insert_orphan_item(trans, root, offset);
-
-	btrfs_free_path(path);
+	ret = btrfs_insert_orphan_item(trans, root, ino);
+	if (ret == -EEXIST)
+		ret = 0;
 
 	return ret;
 }
-- 
1.8.4.5

