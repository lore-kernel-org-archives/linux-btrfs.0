From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 46/99] btrfs: btrfs_close_extra_devices should return void
Date: Wed, 23 Nov 2011 19:36:19 -0500
Message-ID: <20111124004225.142618978@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_close_extra_devices has no error conditions and should return
 void. Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |    3 +--
 fs/btrfs/volumes.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -437,7 +437,7 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
-int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device, *next;
 
@@ -470,7 +470,6 @@ again:
 	}
 
 	mutex_unlock(&uuid_mutex);
-	return 0;
 }
 
 static void __free_device(struct work_struct *work)
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -197,7 +197,7 @@ int btrfs_open_devices(struct btrfs_fs_d
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);



