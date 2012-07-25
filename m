Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404Ab2GYPK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:56 -0400
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 07/16] btrfs: nuke write_super from comments
Date: Wed, 25 Jul 2012 18:12:05 +0300
Message-Id: <1343229134-29487-8-git-send-email-artem.bityutskiy@linux.intel.com>
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '->write_super' superblock method is gone, and this patch removes all the
references to 'write_super' from btrfs.

Cc: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/btrfs/super.c   |    4 ----
 fs/btrfs/volumes.c |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e239915..ad31627 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -100,10 +100,6 @@ static void __save_error_info(struct btrfs_fs_info *fs_info)
 	fs_info->fs_state = BTRFS_SUPER_FLAG_ERROR;
 }
 
-/* NOTE:
- *	We move write_super stuff at umount in order to avoid deadlock
- *	for umount hold all lock.
- */
 static void save_error_info(struct btrfs_fs_info *fs_info)
 {
 	__save_error_info(fs_info);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ecaad40..9f2416c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1738,10 +1738,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	device->fs_devices = root->fs_info->fs_devices;
 
-	/*
-	 * we don't want write_supers to jump in here with our device
-	 * half setup
-	 */
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
 	list_add(&device->dev_alloc_list,
-- 
1.7.10

