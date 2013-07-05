Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33849 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab3GESNT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 14:13:19 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E4D0E9A0695
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:13:18 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id S9SUulry9983BsoS (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 12:13:02 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure the backref walker catches all refs to our extent
Date: Fri, 5 Jul 2013 14:13:00 -0400
Message-ID: <1373047980-3785-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because we don't mess with the offset into the extent for compressed we will
properly find both extents for this case

[extent a][extent b][rest of extent a]

but because we already added a ref for the front half we won't add the inode
information for the second half.  This causes us to leak that memory and not
print out the other offset when we do logical-resolve.  So fix this by calling
ulist_add_merge and then add our eie to the existing entry if there is one.
With this patch we get both offsets out of logical-resolve.  With this and the
other 2 patches I've sent we now pass btrfs/276 on my vm with compress-force=lzo
set.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/backref.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 30dbe1c..8bc5e8c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -196,7 +196,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	struct extent_buffer *eb;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
-	struct extent_inode_elem *eie = NULL;
+	struct extent_inode_elem *eie = NULL, *old = NULL;
 	u64 disk_byte;
 
 	if (level != 0) {
@@ -230,6 +230,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 
 		if (disk_byte == wanted_disk_byte) {
 			eie = NULL;
+			old = NULL;
 			if (extent_item_pos) {
 				ret = check_extent_in_eb(&key, eb, fi,
 						*extent_item_pos,
@@ -237,18 +238,20 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 				if (ret < 0)
 					break;
 			}
-			if (!ret) {
-				ret = ulist_add(parents, eb->start,
-						(uintptr_t)eie, GFP_NOFS);
-				if (ret < 0)
-					break;
-				if (!extent_item_pos) {
-					ret = btrfs_next_old_leaf(root, path,
-							time_seq);
-					continue;
-				}
+			if (ret > 0)
+				goto next;
+			ret = ulist_add_merge(parents, eb->start,
+					      (uintptr_t)eie,
+					      (u64 *)&old, GFP_NOFS);
+			if (ret < 0)
+				break;
+			if (!ret && extent_item_pos) {
+				while (old->next)
+					old = old->next;
+				old->next = eie;
 			}
 		}
+next:
 		ret = btrfs_next_old_item(root, path, time_seq);
 	}
 
-- 
1.7.7.6

