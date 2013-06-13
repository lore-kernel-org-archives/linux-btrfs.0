Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57569 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3FMRwi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 13:52:38 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3ADEF7C069A
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 11:52:37 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id LRDDASsvPEwWiJia (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 11:52:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix not being able to find skinny extents during relocate
Date: Thu, 13 Jun 2013 13:52:34 -0400
Message-ID: <1371145954-3070-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We unconditionally search for the EXTENT_ITEM_KEY for metadata during balance,
and then check the key that we found to see if it is actually a
METADATA_ITEM_KEY, but this doesn't work right because METADATA is a higher key
value, so if what we are looking for happens to be the first item in the leaf
the search will dump us out at the previous leaf, and we won't find our item.
So instead do what we do everywhere else, search for the skinny extent first and
if we don't find it go back and re-search for the extent item.  This patch fixes
the panic I was hitting when balancing a large file system with skinny extents.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/relocation.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6162d90..df3c632 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3309,6 +3309,8 @@ static int __add_tree_block(struct reloc_control *rc,
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	int ret;
+	bool skinny = btrfs_fs_incompat(rc->extent_root->fs_info,
+					SKINNY_METADATA);
 
 	if (tree_block_processed(bytenr, blocksize, rc))
 		return 0;
@@ -3319,10 +3321,15 @@ static int __add_tree_block(struct reloc_control *rc,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-
+again:
 	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
-	key.offset = blocksize;
+	if (skinny) {
+		key.type = BTRFS_METADATA_ITEM_KEY;
+		key.offset = (u64)-1;
+	} else {
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = blocksize;
+	}
 
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
@@ -3330,11 +3337,23 @@ static int __add_tree_block(struct reloc_control *rc,
 	if (ret < 0)
 		goto out;
 
-	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-	if (ret > 0) {
-		if (key.objectid == bytenr &&
-		    key.type == BTRFS_METADATA_ITEM_KEY)
-			ret = 0;
+	if (ret > 0 && skinny) {
+		if (path->slots[0]) {
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+			if (key.objectid == bytenr &&
+			    (key.type == BTRFS_METADATA_ITEM_KEY ||
+			     (key.type == BTRFS_EXTENT_ITEM_KEY &&
+			      key.offset == blocksize)))
+				ret = 0;
+		}
+
+		if (ret) {
+			skinny = false;
+			btrfs_release_path(path);
+			goto again;
+		}
 	}
 	BUG_ON(ret);
 
-- 
1.7.7.6

