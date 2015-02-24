Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45801 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbbBXKrb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 05:47:31 -0500
Received: by pdjz10 with SMTP id z10so32473589pdj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 02:47:30 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 3/3] btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache
Date: Tue, 24 Feb 2015 02:47:06 -0800
Message-Id: <5aa522a2a863d3cf6805f331932e503a37eeae66.1424773781.git.osandov@osandov.com>
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
References: <cover.1424773781.git.osandov@osandov.com>
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
References: <cover.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If io_ctl_prepare_pages fails, the pages in io_ctl.pages are not valid.
When we try to access them later, things will blow up in various ways.

Also fix the comment about the return value, which is an errno on error,
not -1, and update the cases where it was not.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/free-space-cache.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a719785..03dcda2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1112,7 +1112,7 @@ cleanup_write_cache_enospc(struct inode *inode,
  *
  * This function writes out a free space cache struct to disk for quick recovery
  * on mount.  This will return 0 if it was successfull in writing the cache out,
- * and -1 if it was not.
+ * or an errno if it was not.
  */
 static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				   struct btrfs_free_space_ctl *ctl,
@@ -1128,11 +1128,11 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	int ret;
 
 	if (!i_size_read(inode))
-		return -1;
+		return -EIO;
 
 	ret = io_ctl_init(&io_ctl, inode, root, 1);
 	if (ret)
-		return -1;
+		return ret;
 
 	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
 		down_write(&block_group->data_rwsem);
@@ -1149,7 +1149,9 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	}
 
 	/* Lock all pages first so we can lock the extent safely. */
-	io_ctl_prepare_pages(&io_ctl, inode, 0);
+	ret = io_ctl_prepare_pages(&io_ctl, inode, 0);
+	if (ret)
+		goto out;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
 			 0, &cached_state);
-- 
2.3.0

