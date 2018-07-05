Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751811AbeGEHhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:37:36 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17381AF5B
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:37:35 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: check: Remove the ability to rebuild root overwritting existing tree blocks
Date: Thu,  5 Jul 2018 15:37:28 +0800
Message-Id: <20180705073731.18459-2-wqu@suse.com>
In-Reply-To: <20180705073731.18459-1-wqu@suse.com>
References: <20180705073731.18459-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have function btrfs_fsck_reinit_root() to reinit csum or extent tree.
However this function allows us to let it overwrite existing tree blocks
using @overwrite parameter.

Such behavior is pretty dangerous while no caller is using this feature
explicitly.

So just remove @overwrite parameter and allow btrfs_fsck_reinit_root()
to error out when it fails to allocate tree block.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/check/main.c b/check/main.c
index 8db300abb825..c8c347236543 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8379,7 +8379,7 @@ static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 }
 
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, int overwrite)
+				  struct btrfs_root *root)
 {
 	struct extent_buffer *c;
 	struct extent_buffer *old = root->node;
@@ -8389,21 +8389,13 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 
 	level = 0;
 
-	if (overwrite) {
-		c = old;
-		extent_buffer_get(c);
-		goto init;
-	}
 	c = btrfs_alloc_free_block(trans, root,
 				   root->fs_info->nodesize,
 				   root->root_key.objectid,
 				   &disk_key, level, 0, 0);
-	if (IS_ERR(c)) {
-		c = old;
-		extent_buffer_get(c);
-		overwrite = 1;
-	}
-init:
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
 	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_level(c, level);
 	btrfs_set_header_bytenr(c, c->start);
@@ -8422,9 +8414,7 @@ init:
 	/*
 	 * this case can happen in the following case:
 	 *
-	 * 1.overwrite previous root.
-	 *
-	 * 2.reinit reloc data root, this is because we skip pin
+	 * reinit reloc data root, this is because we skip pin
 	 * down reloc data tree before which means we can allocate
 	 * same block bytenr here.
 	 */
@@ -8609,7 +8599,7 @@ reinit_data_reloc:
 		goto out;
 	}
 	record_root_in_trans(trans, root);
-	ret = btrfs_fsck_reinit_root(trans, root, 0);
+	ret = btrfs_fsck_reinit_root(trans, root);
 	if (ret)
 		goto out;
 	ret = btrfs_make_root_dir(trans, root, BTRFS_FIRST_FREE_OBJECTID);
@@ -8675,7 +8665,7 @@ again:
 	}
 
 	/* Ok we can allocate now, reinit the extent root */
-	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root, 0);
+	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root);
 	if (ret) {
 		fprintf(stderr, "extent root initialization failed\n");
 		/*
@@ -9764,7 +9754,7 @@ int cmd_check(int argc, char **argv)
 
 		if (init_csum_tree) {
 			printf("Reinitialize checksum tree\n");
-			ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
+			ret = btrfs_fsck_reinit_root(trans, info->csum_root);
 			if (ret) {
 				error("checksum tree initialization failed: %d",
 						ret);
-- 
2.18.0

