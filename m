Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36724 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2EaK1E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 06:27:04 -0400
Message-ID: <4FC7470A.7020005@cn.fujitsu.com>
Date: Thu, 31 May 2012 18:25:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 2/2] Btrfs: fix wrong the mount information in /proc
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we remove the disk that is specified when mounting, the mount information
in /proc can not be updated. It will make us can not add that disk back into
the filesystem. This patch fix this problem by implement the show_devname()
interface and choose the name of the device with minimum device id to show.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c5f8fca..99e5671 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
+#include "../mount.h"
 #include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -892,6 +893,35 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	return 0;
 }
 
+static int btrfs_show_devname(struct seq_file *m, struct vfsmount *mnt)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(mnt->mnt_sb);
+	struct mount *r = real_mount(mnt);
+	struct btrfs_fs_devices *cur_devices;
+	struct btrfs_device *dev;
+	struct list_head *head;
+	struct btrfs_device *first_dev = NULL;
+
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	cur_devices = fs_info->fs_devices;
+	while (cur_devices) {
+		head = &cur_devices->devices;
+		list_for_each_entry(dev, head, dev_list) {
+			if (!strcmp(r->mnt_devname, dev->name)) {
+				seq_escape(m, r->mnt_devname, " \t\n\\");
+				goto out;
+			}
+			if (!first_dev || dev->devid < first_dev->devid)
+				first_dev = dev;
+		}
+		cur_devices = cur_devices->seed;
+	}
+	seq_escape(m, first_dev->name, " \t\n\\");
+out:
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	return 0;
+}
+
 static int btrfs_test_super(struct super_block *s, void *data)
 {
 	struct btrfs_fs_info *p = data;
@@ -1467,6 +1497,7 @@ static const struct super_operations btrfs_super_ops = {
 	.put_super	= btrfs_put_super,
 	.sync_fs	= btrfs_sync_fs,
 	.show_options	= btrfs_show_options,
+	.show_devname	= btrfs_show_devname,
 	.write_inode	= btrfs_write_inode,
 	.dirty_inode	= btrfs_fs_dirty_inode,
 	.alloc_inode	= btrfs_alloc_inode,
-- 
1.7.6.5
