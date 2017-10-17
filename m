Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34517 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934664AbdJQJNU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 05:13:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 1/6] btrfs-progs: Introduce function to fix unaligned device size
Date: Tue, 17 Oct 2017 17:13:07 +0800
Message-Id: <20171017091312.31045-2-wqu@suse.com>
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
References: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recent kernel introduced alignment check for dev item, however older
kernel doesn't align device size when adding new device or shrinking
existing device.

This makes noisy kernel warning every time when any DEV_ITEM get updated.

Introduce function to fix device size in btrfs-progs to fix the problem
offline.

Reported-by: Asif Youssuff <yoasif@gmail.com>
Reported-by: Rich Rauenzahn <rrauenza@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 volumes.h |  2 ++
 2 files changed, 73 insertions(+)

diff --git a/volumes.c b/volumes.c
index 2209e5a9100b..5462bf71c611 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2332,3 +2332,74 @@ u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
 	}
 	return stripe_len;
 }
+
+/*
+ * Return 0 if size of @device is already good
+ * Return >0 if size of @device is not aligned but fixed without problem
+ * Return <0 if something wrong happened when aligning the size of @device
+ */
+int btrfs_fix_device_size(struct btrfs_fs_info *fs_info,
+			  struct btrfs_device *device)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_dev_item *di;
+	u64 old_bytes = device->total_bytes;
+	int ret;
+
+	if (IS_ALIGNED(old_bytes, fs_info->sectorsize))
+		return 0;
+
+	/* Align the in-memory total_bytes first, and use it as correct size */
+	device->total_bytes = round_down(device->total_bytes,
+					 fs_info->sectorsize);
+
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = BTRFS_DEV_ITEM_KEY;
+	key.offset = device->devid;
+
+	trans = btrfs_start_transaction(chunk_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("error starting transaction: %d (%s)",
+		      ret, strerror(-ret));
+		return ret;
+	}
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
+	if (ret > 0) {
+		error("failed to find DEV_ITEM for devid %llu",
+			device->devid);
+		ret = -ENOENT;
+		goto err;
+	}
+	if (ret < 0) {
+		error("failed to search chunk root: %d (%s)",
+			ret, strerror(-ret));
+		goto err;
+	}
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dev_item);
+	btrfs_set_device_total_bytes(path.nodes[0], di, device->total_bytes);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+	ret = btrfs_commit_transaction(trans, chunk_root);
+	if (ret < 0) {
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+		btrfs_release_path(&path);
+		return ret;
+	}
+	btrfs_release_path(&path);
+	printf("Fixed device size for devid %llu, old size: %llu new size: %llu\n",
+		device->devid, old_bytes, device->total_bytes);
+	return 1;
+
+err:
+	/* We haven't modified anything, it's OK to commit current trans */
+	btrfs_commit_transaction(trans, chunk_root);
+	btrfs_release_path(&path);
+	return ret;
+}
diff --git a/volumes.h b/volumes.h
index d35a4e652b0d..89bd4aa81ae0 100644
--- a/volumes.h
+++ b/volumes.h
@@ -245,4 +245,6 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
 			struct extent_buffer *leaf,
 			struct btrfs_chunk *chunk);
+int btrfs_fix_device_size(struct btrfs_fs_info *fs_info,
+			  struct btrfs_device *device);
 #endif
-- 
2.14.2

