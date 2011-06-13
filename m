From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: fix uninitialized return value
Date: Mon, 13 Jun 2011 17:18:23 +0200
Message-ID: <1307978303-2756-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When allocation fails in btrfs_read_fs_root_no_name, ret is not set
although it is returned, holding a garbage value.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f68c68..7e48b01 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1300,12 +1300,12 @@ again:
 		return root;
 
 	root->free_ino_ctl = kzalloc(sizeof(*root->free_ino_ctl), GFP_NOFS);
-	if (!root->free_ino_ctl)
-		goto fail;
 	root->free_ino_pinned = kzalloc(sizeof(*root->free_ino_pinned),
 					GFP_NOFS);
-	if (!root->free_ino_pinned)
+	if (!root->free_ino_pinned || !root->free_ino_ctl) {
+		ret = -ENOMEM;
 		goto fail;
+	}
 
 	btrfs_init_free_ino_ctl(root);
 	mutex_init(&root->fs_commit_mutex);
-- 
1.7.5.2.353.g5df3e

