From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH retry] btrfs: mount failure return value fix
Date: Sat, 8 Jan 2011 18:09:13 +0800
Message-ID: <20110108100913.GA2659@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I happened to pass swap partition as root partition in cmdline,
then kernel panic and tell me about "Cannot open root device".
It is not correct, in fact it is a fs type mismatch instead of 'no device'.

Eventually I found btrfs mounting failed with -EIO, it should be -EINVAL.
The logic in init/do_mounts.c:
        for (p = fs_names; *p; p += strlen(p)+1) {
                int err = do_mount_root(name, p, flags, root_mount_data);
                switch (err) {
                        case 0:
                                goto out;
                        case -EACCES:
                                flags |= MS_RDONLY;
                                goto retry;
                        case -EINVAL:
                                continue;
                }
		print "Cannot open root device"
		panic
	}
SO fs type after btrfs will have no chance to mount

Here fix the return value as -EINVAL

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 fs/btrfs/disk-io.c |    4 +++-
 fs/btrfs/volumes.c |    8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

--- linux-2.6.orig/fs/btrfs/disk-io.c	2010-12-29 21:53:17.473333338 +0800
+++ linux-2.6/fs/btrfs/disk-io.c	2010-12-29 21:57:37.916666672 +0800
@@ -1713,8 +1713,10 @@ struct btrfs_root *open_ctree(struct sup
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
-	if (!bh)
+	if (!bh) {
+		err = -EINVAL;
 		goto fail_iput;
+	}
 
 	memcpy(&fs_info->super_copy, bh->b_data, sizeof(fs_info->super_copy));
 	memcpy(&fs_info->super_for_commit, &fs_info->super_copy,
--- linux-2.6.orig/fs/btrfs/volumes.c	2010-12-29 21:53:17.503333338 +0800
+++ linux-2.6/fs/btrfs/volumes.c	2010-12-29 21:57:37.920000005 +0800
@@ -598,8 +598,10 @@ static int __btrfs_open_devices(struct b
 		set_blocksize(bdev, 4096);
 
 		bh = btrfs_read_dev_super(bdev);
-		if (!bh)
+		if (!bh) {
+			ret = -EINVAL;
 			goto error_close;
+		}
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;
 		devid = btrfs_stack_device_id(&disk_super->dev_item);
@@ -700,7 +702,7 @@ int btrfs_scan_one_device(const char *pa
 		goto error_close;
 	bh = btrfs_read_dev_super(bdev);
 	if (!bh) {
-		ret = -EIO;
+		ret = -EINVAL;
 		goto error_close;
 	}
 	disk_super = (struct btrfs_super_block *)bh->b_data;
@@ -1193,7 +1195,7 @@ int btrfs_rm_device(struct btrfs_root *r
 		set_blocksize(bdev, 4096);
 		bh = btrfs_read_dev_super(bdev);
 		if (!bh) {
-			ret = -EIO;
+			ret = -EINVAL;
 			goto error_close;
 		}
 		disk_super = (struct btrfs_super_block *)bh->b_data;
