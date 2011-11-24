From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 57/99] btrfs: __setup_root should return void
Date: Wed, 23 Nov 2011 19:36:30 -0500
Message-ID: <20111124004226.415782987@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 __setup_root has no error conditions and should return void. Its callers
 already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1058,10 +1058,10 @@ int clean_tree_block(struct btrfs_trans_
 	return 0;
 }
 
-static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
-			u32 stripesize, struct btrfs_root *root,
-			struct btrfs_fs_info *fs_info,
-			u64 objectid)
+static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
+			 u32 stripesize, struct btrfs_root *root,
+			 struct btrfs_fs_info *fs_info,
+			 u64 objectid)
 {
 	root->node = NULL;
 	root->commit_root = NULL;
@@ -1114,7 +1114,6 @@ static int __setup_root(u32 nodesize, u3
	root->defrag_running = 0;
	root->root_key.objectid = objectid;
	root->anon_dev = 0;
-	return 0;
 }
 
 static int __must_check find_and_setup_root(struct btrfs_root *tree_root,



