Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39903 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeBIHow (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 9 Feb 2018 02:44:52 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 09/10] btrfs-progs: Use btrfs_device->fs_info to replace btrfs_device->dev_root
Date: Fri,  9 Feb 2018 15:44:27 +0800
Message-Id: <20180209074428.29187-11-wqu@suse.com>
In-Reply-To: <20180209074428.29187-1-wqu@suse.com>
References: <20180209074428.29187-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same as kernel declaration.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 utils.c   | 2 +-
 volumes.c | 6 +++---
 volumes.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index e9cb3a82fda6..eff5fb64cfd5 100644
--- a/utils.c
+++ b/utils.c
@@ -216,7 +216,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->total_bytes = device_total_bytes;
 	device->bytes_used = 0;
 	device->total_ios = 0;
-	device->dev_root = fs_info->dev_root;
+	device->fs_info = fs_info;
 	device->name = strdup(path);
 	if (!device->name) {
 		ret = -ENOMEM;
diff --git a/volumes.c b/volumes.c
index c2efb3c674dc..cff54c612872 100644
--- a/volumes.c
+++ b/volumes.c
@@ -380,7 +380,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 				      u64 *start, u64 *len)
 {
 	struct btrfs_key key;
-	struct btrfs_root *root = device->dev_root;
+	struct btrfs_root *root = device->fs_info->dev_root;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_path *path;
 	u64 hole_size;
@@ -724,7 +724,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
-	root = device->dev_root->fs_info->chunk_root;
+	root = device->fs_info->chunk_root;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1895,7 +1895,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
-	device->dev_root = fs_info->dev_root;
+	device->fs_info = fs_info;
 	return ret;
 }
 
diff --git a/volumes.h b/volumes.h
index 950de5a9f910..84deafc98b0d 100644
--- a/volumes.h
+++ b/volumes.h
@@ -26,7 +26,7 @@
 
 struct btrfs_device {
 	struct list_head dev_list;
-	struct btrfs_root *dev_root;
+	struct btrfs_fs_info *fs_info;
 	struct btrfs_fs_devices *fs_devices;
 
 	u64 total_ios;
-- 
2.16.1

