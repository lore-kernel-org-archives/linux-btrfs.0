Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33315 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707AbbBQKvc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 05:51:32 -0500
Received: by pabkx10 with SMTP id kx10so5491548pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 02:51:32 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 3/3] btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache
Date: Tue, 17 Feb 2015 02:51:09 -0800
Message-Id: <a0a696b3a042c53d868e29a6bd49960eef2aeee9.1424168589.git.osandov@osandov.com>
In-Reply-To: <cover.1424168589.git.osandov@osandov.com>
References: <cover.1424168589.git.osandov@osandov.com>
In-Reply-To: <cover.1424168589.git.osandov@osandov.com>
References: <cover.1424168589.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If io_ctl_prepare_pages fails, the pages in io_ctl.pages are not valid.
When we try to access them later, things will blow up in various ways.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/free-space-cache.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6c03f7..0460632 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1114,7 +1114,7 @@ cleanup_write_cache_enospc(struct inode *inode,
  *
  * This function writes out a free space cache struct to disk for quick recovery
  * on mount.  This will return 0 if it was successfull in writing the cache out,
- * and -1 if it was not.
+ * or an errno if it was not.
  */
 static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				   struct btrfs_free_space_ctl *ctl,
@@ -1130,11 +1130,11 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
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
@@ -1151,7 +1151,9 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
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

