From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: setting of time to the root directory
Date: Wed, 17 Nov 2010 10:07:52 +0900
Message-ID: <201011170107.AA00002@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


This patch adds the setting of time to the root directory to the
mkfs.btrfs command.
As a result, the time of the mount point not correctly displayed
comes to be displayed correctly. 

[before]
 # mkfs.btrfs /dev/sdd10
 # mount /dev/sdd10 /test1
 # ls -ld /test1
 dr-xr-xr-x 1 root root 0 Jan  1  1970 /test1

[after]
 # date
 Tue Nov 16 18:06:05 JST 2010
 # mkfs.btrfs /dev/sdd10
 # mount /dev/sdd10 /test1
 # ls -ld /test1
 dr-xr-xr-x 1 root root 0 Nov 16 18:06 /test1

Thanks,
Tsutomu

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 utils.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -urNp btrfs-progs-unstable/utils.c btrfs-progs-unstable-new/utils.c
--- btrfs-progs-unstable/utils.c	2010-11-09 11:46:23.000000000 +0900
+++ btrfs-progs-unstable-new/utils.c	2010-11-16 17:24:08.000000000 +0900
@@ -565,6 +565,7 @@ int btrfs_make_root_dir(struct btrfs_tra
 {
 	int ret;
 	struct btrfs_inode_item inode_item;
+	time_t now = time(NULL);
 
 	memset(&inode_item, 0, sizeof(inode_item));
 	btrfs_set_stack_inode_generation(&inode_item, trans->transid);
@@ -572,6 +573,14 @@ int btrfs_make_root_dir(struct btrfs_tra
 	btrfs_set_stack_inode_nlink(&inode_item, 1);
 	btrfs_set_stack_inode_nbytes(&inode_item, root->leafsize);
 	btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0555);
+	btrfs_set_stack_timespec_sec(&inode_item.atime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item.atime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item.ctime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item.ctime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item.mtime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item.mtime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item.otime, 0);
+	btrfs_set_stack_timespec_nsec(&inode_item.otime, 0);
 
 	if (root->fs_info->tree_root == root)
 		btrfs_set_super_root_dir(&root->fs_info->super_copy, objectid);

