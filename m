Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52705 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2JLG4J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 02:56:09 -0400
Message-ID: <1350024954.5690.1.camel@nexus.lab.ntt.co.jp>
Subject: [PATCH 2/2] btrfs: store pointer to superblock in bd_super
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando_b1@lab.ntt.co.jp>
To: Chris Mason <chris.mason@fusionio.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Date: Fri, 12 Oct 2012 15:55:54 +0900
In-Reply-To: <1350024619.5357.3.camel@nexus.lab.ntt.co.jp>
References: <1350024619.5357.3.camel@nexus.lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subject: btrfs: store pointer to superblock in bd_super

This is needed to get get_active_super and, by extension, thaw_bdev initiated
freezes working.

Thanks go to Josef Bacik and Christoph Hellwig for initiating this effort
to fix btrfs and for suggesting the solution implemented here, respectively.

Cc: Josef Bacik <jbacik@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.6-orig/fs/btrfs/super.c linux-3.6/fs/btrfs/super.c
--- linux-3.6-orig/fs/btrfs/super.c	2012-10-01 08:47:46.000000000 +0900
+++ linux-3.6/fs/btrfs/super.c	2012-10-11 15:58:02.801789404 +0900
@@ -826,6 +826,7 @@ static int btrfs_fill_super(struct super
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
+	btrfs_set_super_devices(fs_devices, sb);
 	return 0;
 
 fail_close:
@@ -1459,6 +1460,7 @@ static int btrfs_statfs(struct dentry *d
 static void btrfs_kill_super(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	btrfs_set_super_devices(fs_info->fs_devices, NULL);
 	kill_anon_super(sb);
 	free_fs_info(fs_info);
 }
diff -urNp linux-3.6-orig/fs/btrfs/volumes.c linux-3.6/fs/btrfs/volumes.c
--- linux-3.6-orig/fs/btrfs/volumes.c	2012-10-01 08:47:46.000000000 +0900
+++ linux-3.6/fs/btrfs/volumes.c	2012-10-11 15:57:52.405787282 +0900
@@ -43,6 +43,8 @@ static int init_first_rw_device(struct b
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
+static void btrfs_set_super_device(struct btrfs_device *device,
+                                   struct super_block *sb);
 
 static DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
@@ -1435,6 +1437,7 @@ int btrfs_rm_device(struct btrfs_root *r
 
 	cur_devices = device->fs_devices;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	btrfs_set_super_device(device, NULL);
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
@@ -1645,6 +1648,23 @@ error:
 	return ret;
 }
 
+static void btrfs_set_super_device(struct btrfs_device *device,
+				   struct super_block *sb)
+{
+	if (device->bdev)
+		device->bdev->bd_super = sb;
+}
+
+void btrfs_set_super_devices(struct btrfs_fs_devices *fs_devices,
+			     struct super_block *sb)
+{
+	struct btrfs_device *device;
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list)
+		btrfs_set_super_device(device, sb);
+	mutex_unlock(&fs_devices->device_list_mutex);
+}
+
 int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 {
 	struct request_queue *q;
@@ -1800,7 +1820,7 @@ int btrfs_init_new_device(struct btrfs_r
 		up_write(&sb->s_umount);
 
 		if (ret) /* transaction commit */
-			return ret;
+			goto out;
 
 		ret = btrfs_relocate_sys_chunks(root);
 		if (ret < 0)
@@ -1809,7 +1829,12 @@ int btrfs_init_new_device(struct btrfs_r
 				    "device initialization. This can be fixed "
 				    "using the \"btrfs balance\" command.");
 	}
-
+out:
+	/*
+	 * The device was successfully added to the filesystem, so we store a
+	 * pointer to the superblock in ->bd_super.
+	 */
+	btrfs_set_super_device(device, sb);
 	return ret;
 
 error_trans:
diff -urNp linux-3.6-orig/fs/btrfs/volumes.h linux-3.6/fs/btrfs/volumes.h
--- linux-3.6-orig/fs/btrfs/volumes.h	2012-10-01 08:47:46.000000000 +0900
+++ linux-3.6/fs/btrfs/volumes.h	2012-10-11 15:57:35.837783455 +0900
@@ -279,6 +279,8 @@ int btrfs_grow_device(struct btrfs_trans
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
+void btrfs_set_super_devices(struct btrfs_fs_devices *fs_devices,
+			     struct super_block *sb);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);


