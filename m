Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51517 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbdJLVkq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 17:40:46 -0400
From: Christos Gkekas <chris.gekas@gmail.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] btrfs: Clean up unused variables in free-space-tree.c
Date: Thu, 12 Oct 2017 22:40:42 +0100
Message-Id: <1507844442-26013-1-git-send-email-chris.gekas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove variables 'start' and 'end', which are set but never used.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 fs/btrfs/free-space-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 684f122..fe5e032 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1286,12 +1286,8 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 					struct btrfs_block_group_cache *block_group,
 					struct btrfs_path *path)
 {
-	u64 start, end;
 	int ret;
 
-	start = block_group->key.objectid;
-	end = block_group->key.objectid + block_group->key.offset;
-
 	block_group->needs_free_space = 0;
 
 	ret = add_new_free_space_info(trans, fs_info, block_group, path);
-- 
2.7.4

