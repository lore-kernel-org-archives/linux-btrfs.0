Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46910 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaAJOu2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 09:50:28 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so4647797pdj.18
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 06:50:27 -0800 (PST)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] Btrfs-progs: check return value of read_tree_block() in check_chunks_and_extents()
Date: Fri, 10 Jan 2014 22:50:02 +0800
Message-Id: <1389365402-1866-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following steps could trigger btrfs segfault:

mkfs -t btrfs -m raid5 -d raid5 /dev/loop{0..3}
losetup -d /dev/loop2
btrfs check /dev/loop0

The reason is that read_tree_block() returns NULL and
add_root_to_pending() dereferences it without checking it first.

Also replace a BUG_ON with proper error checking.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-check.c       | 6 +++++-
 disk-io.c          | 5 ++++-
 free-space-cache.c | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a65670e..1059c0a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5513,7 +5513,11 @@ again:
 			buf = read_tree_block(root->fs_info->tree_root,
 					      btrfs_root_bytenr(&ri),
 					      btrfs_level_size(root,
-					       btrfs_root_level(&ri)), 0);
+					      btrfs_root_level(&ri)), 0);
+			if (!buf) {
+				ret = -EIO;
+				goto out;
+			}
 			add_root_to_pending(buf, &extent_cache, &pending,
 					    &seen, &nodes, &found_key);
 			free_extent_buffer(buf);
diff --git a/disk-io.c b/disk-io.c
index 0af3898..b0a8d01 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -644,7 +644,10 @@ out:
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
-	BUG_ON(!root->node);
+	if (!root->node) {
+		free(root);
+		return ERR_PTR(-EIO);
+	}
 insert:
 	root->ref_cows = 1;
 	return root;
diff --git a/free-space-cache.c b/free-space-cache.c
index ddeeeb6..899a766 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -435,7 +435,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	if (ret < 0) {
 		ret = 0;
 
-		printf("failed to load free space cache for block group %llu",
+		printf("failed to load free space cache for block group %llu\n",
 			block_group->key.objectid);
 	}
 
-- 
1.8.4.2

