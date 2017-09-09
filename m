Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38578 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753731AbdIIO3m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 10:29:42 -0400
From: Christos Gkekas <chris.gekas@gmail.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] btrfs: Clean up dead code in root-tree
Date: Sat,  9 Sep 2017 15:29:34 +0100
Message-Id: <1504967374-14144-1-git-send-email-chris.gekas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of variable 'can_recover' is never used after being set, thus
it should be removed.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 fs/btrfs/root-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 95bcc3c..3338407 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -226,10 +226,6 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 	struct btrfs_root *root;
 	int err = 0;
 	int ret;
-	bool can_recover = true;
-
-	if (sb_rdonly(fs_info->sb))
-		can_recover = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
2.7.4

