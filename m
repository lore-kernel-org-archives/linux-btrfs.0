From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 37/66] btrfs: __setup_root should return void
Date: Mon, 24 Oct 2011 21:03:13 -0400
Message-ID: <20111025010854.813068296@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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


