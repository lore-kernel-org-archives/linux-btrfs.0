Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:36546 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499Ab2HXN6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 09:58:24 -0400
Received: from venice.bhome (151.24.44.165) by smtp207.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F9705739053 for linux-btrfs@vger.kernel.org; Fri, 24 Aug 2012 15:58:22 +0200
Subject: [PATCH v1 2/4] Add hook for sysfs to btrfs.
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Fri, 24 Aug 2012 15:59:06 +0200
Message-ID: <20120824135849.20478.86068.stgit@venice.bhome>
In-Reply-To: <20120824135322.20478.88578.stgit@venice.bhome>
References: <20120824135322.20478.88578.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the hook in the btrfs filesystem code to supporting sysfs.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 fs/btrfs/super.c   |    4 ++++
 fs/btrfs/volumes.c |   10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e239915..8927674 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -55,6 +55,7 @@
 #include "export.h"
 #include "compression.h"
 #include "rcu-string.h"
+#include "sysfs.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1093,6 +1094,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(root))
 		deactivate_locked_super(s);
 
+	btrfs_sysfs_add_filesystem(fs_info);
+
 	return root;
 
 error_close_devices:
@@ -1422,6 +1425,7 @@ static void btrfs_kill_super(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	kill_anon_super(sb);
+	btrfs_sysfs_remove_filesystem(fs_info);
 	free_fs_info(fs_info);
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ecaad40..9d83979 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -36,6 +36,7 @@
 #include "async-thread.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
+#include "sysfs.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -405,6 +406,8 @@ static noinline int device_list_add(const char *path,
 		}
 	}
 
+	btrfs_sysfs_add_device(device);
+
 	if (found_transid > fs_devices->latest_trans) {
 		fs_devices->latest_devid = devid;
 		fs_devices->latest_trans = found_transid;
@@ -456,8 +459,9 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		spin_lock_init(&device->io_lock);
 		INIT_LIST_HEAD(&device->dev_list);
 		INIT_LIST_HEAD(&device->dev_alloc_list);
-
 		list_add(&device->dev_list, &fs_devices->devices);
+		btrfs_sysfs_add_device(device);
+		
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
 	}
@@ -1430,6 +1434,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	cur_devices = device->fs_devices;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	btrfs_sysfs_remove_device(device);
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
@@ -1744,6 +1749,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	 */
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
+	btrfs_sysfs_add_device(device);
 	list_add(&device->dev_alloc_list,
 		 &root->fs_info->fs_devices->alloc_list);
 	root->fs_info->fs_devices->num_devices++;
@@ -4306,6 +4312,8 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 	spin_lock_init(&device->io_lock);
 	INIT_LIST_HEAD(&device->dev_alloc_list);
 	memcpy(device->uuid, dev_uuid, BTRFS_UUID_SIZE);
+	btrfs_sysfs_add_device(device);
+	
 	return device;
 }
 

