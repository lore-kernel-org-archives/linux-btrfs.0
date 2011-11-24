From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 44/99] btrfs: btrfs_cleanup_fs_uuids should return void
Date: Wed, 23 Nov 2011 19:36:17 -0500
Message-ID: <20111124004224.910713161@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_cleanup_fs_uuids has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |    3 +--
 fs/btrfs/volumes.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -65,7 +65,7 @@ static void free_fs_devices(struct btrfs
 	kfree(fs_devices);
 }
 
-int btrfs_cleanup_fs_uuids(void)
+void btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
 
@@ -75,7 +75,6 @@ int btrfs_cleanup_fs_uuids(void)
 		list_del(&fs_devices->list);
 		free_fs_devices(fs_devices);
 	}
-	return 0;
 }
 
 static noinline struct btrfs_device *__find_device(struct list_head *head,
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -202,7 +202,7 @@ int btrfs_add_device(struct btrfs_trans_
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
-int btrfs_cleanup_fs_uuids(void);
+void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);



