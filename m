Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36676 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934665AbdJQJNV (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 05:13:21 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/6] btrfs-progs: Introduce function to fix super block total bytes
Date: Tue, 17 Oct 2017 17:13:08 +0800
Message-Id: <20171017091312.31045-3-wqu@suse.com>
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
References: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recent kernel (starting from v4.6) will refuse to mount if super block
total bytes is smaller than all devices' size.

This makes end user unable to do anything to their otherwise quite
healthy fs.

To fix such problem, introduce repair function in btrfs-progs to fix it
offline.

Reported-by: Asif Youssuff <yoasif@gmail.com>
Reported-by: Rich Rauenzahn <rrauenza@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 volumes.h |  1 +
 2 files changed, 53 insertions(+)

diff --git a/volumes.c b/volumes.c
index 5462bf71c611..c86f8a931742 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2403,3 +2403,55 @@ err:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * Return 0 if super block total bytes matches with all devices' total_bytes
+ * Return >0 if super block total bytes mismatch but fixed without problem
+ * Return <0 if we failed to fix super block total_bytes
+ */
+int btrfs_fix_super_size(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_device *device;
+	struct list_head *dev_list = &fs_info->fs_devices->devices;
+	u64 total_bytes = 0;
+	u64 old_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	int ret;
+
+	list_for_each_entry(device, dev_list, dev_list) {
+		/*
+		 * Caller should ensure this function is called after aligning
+		 * all devices' total_bytes.
+		 */
+		if (!IS_ALIGNED(device->total_bytes, fs_info->sectorsize)) {
+			error("device %llu total_bytes %llu not aligned to %u",
+				device->devid, device->total_bytes,
+				fs_info->sectorsize);
+			return -EUCLEAN;
+		}
+		total_bytes += device->total_bytes;
+	}
+
+	if (total_bytes == old_bytes)
+		return 0;
+
+	btrfs_set_super_total_bytes(fs_info->super_copy, total_bytes);
+
+	/* Commit transaction to update all super blocks */
+	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("error starting transaction:  %d (%s)",
+		      ret, strerror(-ret));
+		return ret;
+	}
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (ret < 0) {
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+	printf("Fixed super total bytes, old size: %llu new size: %llu\n",
+		old_bytes, total_bytes);
+	return 1;
+}
diff --git a/volumes.h b/volumes.h
index 89bd4aa81ae0..d5bb5f8663a3 100644
--- a/volumes.h
+++ b/volumes.h
@@ -247,4 +247,5 @@ u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
 			struct btrfs_chunk *chunk);
 int btrfs_fix_device_size(struct btrfs_fs_info *fs_info,
 			  struct btrfs_device *device);
+int btrfs_fix_super_size(struct btrfs_fs_info *fs_info);
 #endif
-- 
2.14.2

