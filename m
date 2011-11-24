From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 95/99] btrfs: del_fs_roots should return void
Date: Wed, 23 Nov 2011 19:37:08 -0500
Message-ID: <20111124004230.813659524@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 del_fs_roots has no error conditions and should return void

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2764,7 +2764,7 @@ static void free_fs_root(struct btrfs_ro
 	kfree(root);
 }
 
-static int del_fs_roots(struct btrfs_fs_info *fs_info)
+static void del_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 	struct btrfs_root *gang[8];
@@ -2793,7 +2793,6 @@ static int del_fs_roots(struct btrfs_fs_
 		for (i = 0; i < ret; i++)
 			btrfs_free_fs_root(fs_info, gang[i]);
 	}
-	return 0;
 }
 
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)


