Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43711 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3HLLdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 07:33:23 -0400
Received: by mail-lb0-f179.google.com with SMTP id v1so4687462lbd.38
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 04:33:21 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 1/4] Btrfs: find_next_devid: root -> fs_info
Date: Mon, 12 Aug 2013 14:33:01 +0300
Message-Id: <1376307184-7175-2-git-send-email-idryomov@gmail.com>
In-Reply-To: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
References: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_next_devid() knows which root to search, so it should take an
fs_info instead of an arbitrary root.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..ae1bcb0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1307,15 +1307,14 @@ static u64 find_next_chunk(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static noinline int find_next_devid(struct btrfs_root *root, u64 *objectid)
+static noinline int find_next_devid(struct btrfs_fs_info *fs_info,
+				    u64 *devid_ret)
 {
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
 
-	root = root->fs_info->chunk_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1324,20 +1323,21 @@ static noinline int find_next_devid(struct btrfs_root *root, u64 *objectid)
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = (u64)-1;
 
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, fs_info->chunk_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto error;
 
 	BUG_ON(ret == 0); /* Corruption */
 
-	ret = btrfs_previous_item(root, path, BTRFS_DEV_ITEMS_OBJECTID,
+	ret = btrfs_previous_item(fs_info->chunk_root, path,
+				  BTRFS_DEV_ITEMS_OBJECTID,
 				  BTRFS_DEV_ITEM_KEY);
 	if (ret) {
-		*objectid = 1;
+		*devid_ret = 1;
 	} else {
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 				      path->slots[0]);
-		*objectid = found_key.offset + 1;
+		*devid_ret = found_key.offset + 1;
 	}
 	ret = 0;
 error:
@@ -1971,7 +1971,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 	rcu_assign_pointer(device->name, name);
 
-	ret = find_next_devid(root, &device->devid);
+	ret = find_next_devid(root->fs_info, &device->devid);
 	if (ret) {
 		rcu_string_free(device->name);
 		kfree(device);
-- 
1.7.10.4

