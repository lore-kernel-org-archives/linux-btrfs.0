Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39858 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbaAVDG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 22:06:29 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, kreijack@inwind.it
Subject: [PATCH] btrfs: undo sysfs when open_ctree() fails
Date: Wed, 22 Jan 2014 11:15:51 +0800
Message-Id: <1390360551-9781-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reproducer:
mkfs.btrfs -f /dev/sdb &&\
mount /dev/sdb /btrfs &&\
btrfs dev add -f /dev/sdc /btrfs &&\
umount /btrfs &&\
wipefs -a /dev/sdc &&\
mount -o degraded /dev/sdb /btrfs
//above mount fails so try with RO
mount -o degraded,ro /dev/sdb /btrfs

------
sysfs: cannot create duplicate filename '/fs/btrfs/3f48c79e-5ed0-4e87-b189-86e749e503f4'
::

dump_stack+0x49/0x5e
warn_slowpath_common+0x87/0xb0
warn_slowpath_fmt+0x41/0x50
strlcat+0x69/0x80
sysfs_warn_dup+0x87/0xa0
sysfs_add_one+0x40/0x50
create_dir+0x76/0xc0
sysfs_create_dir_ns+0x7a/0xc0
kobject_add_internal+0xad/0x220
kobject_add_varg+0x38/0x60
kobject_init_and_add+0x53/0x70
mutex_lock+0x11/0x40
__free_pages+0x25/0x30
free_pages+0x41/0x50
selinux_sb_copy_data+0x14e/0x1e0
mount_fs+0x3e/0x1a0
vfs_kern_mount+0x71/0x120
do_mount+0x3f7/0x980
SyS_mount+0x8b/0xe0
system_call_fastpath+0x16/0x1b
------

further 'modprobe -r btrfs' fails as well

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9850a51..66d02fe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2739,13 +2739,13 @@ retry_root_backup:
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
 		printk(KERN_ERR "BTRFS: Failed to initial space info: %d\n", ret);
-		goto fail_block_groups;
+		goto fail_sysfs;
 	}
 
 	ret = btrfs_read_block_groups(extent_root);
 	if (ret) {
 		printk(KERN_ERR "BTRFS: Failed to read block groups: %d\n", ret);
-		goto fail_block_groups;
+		goto fail_sysfs;
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
@@ -2754,13 +2754,13 @@ retry_root_backup:
 	    !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING "BTRFS: "
 			"too many missing devices, writeable mount is not allowed\n");
-		goto fail_block_groups;
+		goto fail_sysfs;
 	}
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
-		goto fail_block_groups;
+		goto fail_sysfs;
 
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
 						   tree_root,
@@ -2938,6 +2938,9 @@ fail_cleaner:
 	 */
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 
+fail_sysfs:
+	btrfs_sysfs_remove_one(fs_info);
+
 fail_block_groups:
 	btrfs_put_block_group_cache(fs_info);
 	btrfs_free_block_groups(fs_info);
-- 
1.7.1

