From: Li Dongyang <jerry87905@gmail.com>
Subject: [PATCH]btrfs: don't remove device on a raid0 array when device
 number is 2
Date: Sat, 5 Dec 2009 22:13:52 +0800
Message-ID: <20091205141352.GA8277@Archlinux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

we should not make a raid0 array go below 2 devices.

Signed-off-by: Li Dongyang <Jerry87905@gmail.com>
---
 fs/btrfs/volumes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 20cbd2e..801b8d0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1150,6 +1150,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID0) &&
+	    root->fs_info->fs_devices->rw_devices <= 2) {
+		printk(KERN_ERR "btrfs: unable to go below two "
+		       "devices on raid0\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;
-- 
1.6.5.4

