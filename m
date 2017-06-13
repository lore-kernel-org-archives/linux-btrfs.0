Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17180 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752572AbdFMJTu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:50 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 13/19] btrfs-progs: Refactor btrfs_find_device to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:29 +0800
Message-ID: <20170613091935.23277-14-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c |  5 +++--
 volumes.c       | 27 ++++++++++++++-------------
 volumes.h       |  2 +-
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 08d2f07e..90791fbd 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -942,11 +942,12 @@ static int build_device_map_by_chunk_record(struct btrfs_root *root,
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u16 num_stripes;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_mapping_tree *map_tree;
 	struct map_lookup *map;
 	struct stripe *stripe;
 
-	map_tree = &root->fs_info->mapping_tree;
+	map_tree = &fs_info->mapping_tree;
 	num_stripes = chunk->num_stripes;
 	map = malloc(btrfs_map_lookup_size(num_stripes));
 	if (!map)
@@ -965,7 +966,7 @@ static int build_device_map_by_chunk_record(struct btrfs_root *root,
 		devid = stripe->devid;
 		memcpy(uuid, stripe->dev_uuid, BTRFS_UUID_SIZE);
 		map->stripes[i].physical = stripe->offset;
-		map->stripes[i].dev = btrfs_find_device(root, devid,
+		map->stripes[i].dev = btrfs_find_device(fs_info, devid,
 							uuid, NULL);
 		if (!map->stripes[i].dev) {
 			free(map);
diff --git a/volumes.c b/volumes.c
index d8b4e993..e4f67d3a 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1601,17 +1601,17 @@ out:
 	return 0;
 }
 
-struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
 
-	cur_devices = root->fs_info->fs_devices;
+	cur_devices = fs_info->fs_devices;
 	while (cur_devices) {
 		if (!fsid ||
 		    (!memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE) ||
-		     root->fs_info->ignore_fsid_mismatch)) {
+		     fs_info->ignore_fsid_mismatch)) {
 			device = __find_device(&cur_devices->devices,
 					       devid, uuid);
 			if (device)
@@ -1839,7 +1839,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
+		map->stripes[i].dev = btrfs_find_device(fs_info, devid, uuid,
 							NULL);
 		if (!map->stripes[i].dev) {
 			map->stripes[i].dev = fill_missing_device(devid);
@@ -1876,12 +1876,12 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 	return 0;
 }
 
-static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
+static int open_seed_devices(struct btrfs_fs_info *fs_info, u8 *fsid)
 {
 	struct btrfs_fs_devices *fs_devices;
 	int ret;
 
-	fs_devices = root->fs_info->fs_devices->seed;
+	fs_devices = fs_info->fs_devices->seed;
 	while (fs_devices) {
 		if (!memcmp(fs_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
 			ret = 0;
@@ -1907,8 +1907,8 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 	if (ret)
 		goto out;
 
-	fs_devices->seed = root->fs_info->fs_devices->seed;
-	root->fs_info->fs_devices->seed = fs_devices;
+	fs_devices->seed = fs_info->fs_devices->seed;
+	fs_info->fs_devices->seed = fs_devices;
 out:
 	return ret;
 }
@@ -1917,6 +1917,7 @@ static int read_one_dev(struct btrfs_root *root,
 			struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_device *device;
 	u64 devid;
 	int ret = 0;
@@ -1931,24 +1932,24 @@ static int read_one_dev(struct btrfs_root *root,
 			   (unsigned long)btrfs_device_fsid(dev_item),
 			   BTRFS_UUID_SIZE);
 
-	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
-		ret = open_seed_devices(root, fs_uuid);
+	if (memcmp(fs_uuid, fs_info->fsid, BTRFS_UUID_SIZE)) {
+		ret = open_seed_devices(fs_info, fs_uuid);
 		if (ret)
 			return ret;
 	}
 
-	device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
+	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
 	if (!device) {
 		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device)
 			return -ENOMEM;
 		device->fd = -1;
 		list_add(&device->dev_list,
-			 &root->fs_info->fs_devices->devices);
+			 &fs_info->fs_devices->devices);
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
-	device->dev_root = root->fs_info->dev_root;
+	device->dev_root = fs_info->dev_root;
 	return ret;
 }
 
diff --git a/volumes.h b/volumes.h
index d2e9cbc0..8647656f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -236,7 +236,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *
 btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
 			   u64 devid, int instance);
-struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int write_raid56_with_parity(struct btrfs_fs_info *info,
 			     struct extent_buffer *eb,
-- 
2.13.1



