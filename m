From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 3/5] Btrfs: fix the race between remove dev and alloc chunk
Date: Wed, 20 Apr 2011 18:08:16 +0800
Message-ID: <4DAEB090.20609@cn.fujitsu.com>
References: <4DAEB030.1070303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DAEB030.1070303@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On remove device path, it updates device->dev_alloc_list but does not hold
chunk lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a672249..d20351f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1325,7 +1325,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if (device->writeable) {
+		lock_chunks(root);
 		list_del_init(&device->dev_alloc_list);
+		unlock_chunks(root);
 		root->fs_info->fs_devices->rw_devices--;
 	}
 
@@ -1379,7 +1381,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		}
 		fs_devices->seed = device->fs_devices->seed;
 		device->fs_devices->seed = NULL;
+		lock_chunks(root);
 		__btrfs_close_devices(device->fs_devices);
+		unlock_chunks(root);
 		free_fs_devices(device->fs_devices);
 	}
 
@@ -1411,8 +1415,10 @@ out:
 	return ret;
 error_undo:
 	if (device->writeable) {
+		lock_chunks(root);
 		list_add(&device->dev_alloc_list,
 			 &root->fs_info->fs_devices->alloc_list);
+		unlock_chunks(root);
 		root->fs_info->fs_devices->rw_devices++;
 	}
 	goto error_brelse;
-- 
1.7.4.4
