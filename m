Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:46785 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab2HWMMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 08:12:37 -0400
Received: from venice.bhome (151.24.44.165) by smtp206.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F95051BA6DB for linux-btrfs@vger.kernel.org; Thu, 23 Aug 2012 14:12:35 +0200
Subject: [PATCH v0 2/4] Add hook for sysfs to btrfs.
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Thu, 23 Aug 2012 14:13:18 +0200
Message-ID: <20120823121305.12203.15916.stgit@venice.bhome>
In-Reply-To: <20120823120505.12203.11658.stgit@venice.bhome>
References: <20120823120505.12203.11658.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the hook in the btrfs filesystem code to supporting sysfs.
---
 fs/btrfs/volumes.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ecaad40..e1075ab 100644
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
@@ -458,6 +461,9 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		INIT_LIST_HEAD(&device->dev_alloc_list);
 
 		list_add(&device->dev_list, &fs_devices->devices);
+		
+		btrfs_sysfs_add_device(device);
+		
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
 	}
@@ -576,7 +582,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		new_device->in_fs_metadata = 0;
 		new_device->can_discard = 0;
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
-
+		//btrfs_sysfs_remove_device(device);
 		call_rcu(&device->rcu, free_device);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
@@ -1430,6 +1436,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	cur_devices = device->fs_devices;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	
+	btrfs_sysfs_remove_device(device);
+	
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
@@ -1744,6 +1753,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	 */
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
+	btrfs_sysfs_add_device(device);
 	list_add(&device->dev_alloc_list,
 		 &root->fs_info->fs_devices->alloc_list);
 	root->fs_info->fs_devices->num_devices++;
@@ -4306,6 +4316,9 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 	spin_lock_init(&device->io_lock);
 	INIT_LIST_HEAD(&device->dev_alloc_list);
 	memcpy(device->uuid, dev_uuid, BTRFS_UUID_SIZE);
+	
+	btrfs_sysfs_add_device(device);
+	
 	return device;
 }
 

