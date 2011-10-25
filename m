From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 26/66] btrfs: btrfs_close_extra_devices should return void
Date: Mon, 24 Oct 2011 21:03:02 -0400
Message-ID: <20111025010853.553998358@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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


