Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:34601 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbeEKALi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:38 -0400
Received: by mail-pl0-f68.google.com with SMTP id ay10-v6so2225341plb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:38 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 05/12] Btrfs: don't release reserve or decrement orphan count if orphan item already existed
Date: Thu, 10 May 2018 17:11:15 -0700
Message-Id: <bd6e2bbca787ec95aa33f120acdf725f0aad468b.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Currently, if btrfs_insert_orphan_item() fails, we release the reserved
space and decrement root->orphan_inodes. However, we also ignore -EEXIST
errors, so we still want the space reservation for when we delete the
item, and we still need to count the orphan because we're still going to
decrement root->orphan_inodes from btrfs_orphan_del() later.

Fixes: 4ef31a45a009 ("Btrfs: fix the error handling wrt orphan items")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1460823951d7..e77df96de642 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3408,7 +3408,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 	/* insert an orphan item to track this unlinked file */
 	if (insert) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
-		if (ret) {
+		if (ret && ret != -EEXIST) {
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 					  &inode->runtime_flags);
@@ -3420,14 +3420,11 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 			 * decrease ->orphan_inodes after everything is done.
 			 */
 			atomic_dec(&root->orphan_inodes);
-			if (ret != -EEXIST) {
-				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-					  &inode->runtime_flags);
-				btrfs_abort_transaction(trans, ret);
-				return ret;
-			}
+			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+				  &inode->runtime_flags);
+			btrfs_abort_transaction(trans, ret);
+			return ret;
 		}
-		ret = 0;
 	}
 
 	return 0;
-- 
2.17.0

