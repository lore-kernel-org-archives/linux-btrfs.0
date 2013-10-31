Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33775 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JaFC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 01:02:26 -0400
Received: by mail-ie0-f171.google.com with SMTP id tp5so3982262ieb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 22:02:26 -0700 (PDT)
Received: from dshgna ([124.43.179.229])
        by mx.google.com with ESMTPSA id y10sm10274877igl.4.2013.10.30.22.02.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 30 Oct 2013 22:02:25 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:32:18 +0530
From: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: Replace kmalloc with kmalloc_array
Message-ID: <961b8ff1691b30b82385e78427d458088d8a4e43.1383193392.git.dulshani.gunawardhana89@gmail.com>
References: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace kmalloc(size * nr, ) with kmalloc_array(nr, size), thus making
it easier to check is that the calculation doesn't wrap or return a smaller allocation

Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Reviewed-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/delayed-inode.c | 4 ++--
 fs/btrfs/ioctl.c         | 2 +-
 fs/btrfs/super.c         | 2 +-
 fs/btrfs/volumes.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 207e2d0..10c51bd 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -770,13 +770,13 @@ static int btrfs_batch_insert_items(struct btrfs_root *root,
 	 */
 	btrfs_set_path_blocking(path);
 
-	keys = kmalloc(sizeof(struct btrfs_key) * nitems, GFP_NOFS);
+	keys = kmalloc_array(nitems, sizeof(struct btrfs_key), GFP_NOFS);
 	if (!keys) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	data_size = kmalloc(sizeof(u32) * nitems, GFP_NOFS);
+	data_size = kmalloc_array(nitems, sizeof(u32), GFP_NOFS);
 	if (!data_size) {
 		ret = -ENOMEM;
 		goto error;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 62c2a28..8ef76e6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1205,7 +1205,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		ra = &file->f_ra;
 	}
 
-	pages = kmalloc(sizeof(struct page *) * max_cluster,
+	pages = kmalloc_array(max_cluster, sizeof(struct page *),
 			GFP_NOFS);
 	if (!pages) {
 		ret = -ENOMEM;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e913328..9f340d5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1465,7 +1465,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	nr_devices = fs_info->fs_devices->open_devices;
 	BUG_ON(!nr_devices);
 
-	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
+	devices_info = kmalloc_array(nr_devices, sizeof(*devices_info),
 			       GFP_NOFS);
 	if (!devices_info)
 		return -ENOMEM;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2430918..02ead4f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4894,7 +4894,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			num_stripes = map->num_stripes;
 			max_errors = nr_parity_stripes(map);
 
-			raid_map = kmalloc(sizeof(u64) * num_stripes,
+			raid_map = kmalloc_array(num_stripes, sizeof(u64),
 					   GFP_NOFS);
 			if (!raid_map) {
 				ret = -ENOMEM;
-- 
1.8.1.2

