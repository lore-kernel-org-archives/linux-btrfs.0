Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57811 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab3BAUOP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 15:14:15 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id efrZoTEuGYL0N1Ge (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 13:14:14 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: return an error if we can't find an fs root
Date: Fri, 1 Feb 2013 15:21:04 -0500
Message-ID: <1359750064-12794-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of doing a BUG_ON() if we fail to find the last fs root just return
an error so the callers can deal with it how they like.  Also we need to
actually return an error if we can't find the latest root so that the error
handling works.  With this btrfsck was able to deal with a file system that
was missing a root item but still had extents that referred back to the
root.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 disk-io.c   |    3 ++-
 root-tree.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index c4d4631..f6391ed 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -438,7 +438,8 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 		     root, fs_info, objectid);
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	generation = btrfs_root_generation(&root->root_item);
diff --git a/root-tree.c b/root-tree.c
index 782472c..ecb7599 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -47,7 +47,7 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	slot = path->slots[0] - 1;
 	btrfs_item_key_to_cpu(l, &found_key, slot);
 	if (found_key.objectid != objectid) {
-		ret = 1;
+		ret = -ENOENT;
 		goto out;
 	}
 	read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
-- 
1.7.7.6

