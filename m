From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 09/20] btrfs: Don't BUG_ON failures in find_and_setup_root()
Date: Thu, 15 Sep 2011 10:34:48 -0700
Message-ID: <1316108099-5099-10-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

This is very easy - we can just pass an error from btrfs_find_last_root()
back out to the callers - all of them have proper error handling.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/disk-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..e9c7afb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1131,7 +1131,8 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 				   &root->root_item, &root->root_key);
 	if (ret > 0)
 		return -ENOENT;
-	BUG_ON(ret);
+	if (ret < 0)
+		return ret;
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
-- 
1.7.6

