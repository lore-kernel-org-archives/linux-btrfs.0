Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15660 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932367AbdC3GVa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:21:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E69D149F9A75
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 14:21:23 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 10/19] btrfs-progs: scrub: Introduce function to scrub mirror based tree block
Date: Thu, 30 Mar 2017 14:21:06 +0800
Message-ID: <20170330062116.14379-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_tree_mirror(), to scrub mirror based
tree blocks (Single/DUP/RAID0/1/10)

This function can also be used on in-memory tree blocks using @data
parameter.
This is very handy for RAID5/6 case, either checking the data stripe
tree block by @bytenr and 0 as @mirror, or using @data parameter for
recovered in-memory data.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c |  4 ++--
 disk-io.h |  2 ++
 scrub.c   | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 985c4a9f..b912de9c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -51,8 +51,8 @@ static u32 max_nritems(u8 level, u32 nodesize)
 		sizeof(struct btrfs_key_ptr));
 }
 
-static int check_tree_block(struct btrfs_fs_info *fs_info,
-			    struct extent_buffer *buf)
+int check_tree_block(struct btrfs_fs_info *fs_info,
+		     struct extent_buffer *buf)
 {
 
 	struct btrfs_fs_devices *fs_devices;
diff --git a/disk-io.h b/disk-io.h
index ad8efb43..dbb51fc5 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -126,6 +126,8 @@ static inline struct extent_buffer* read_tree_block(
 			parent_transid);
 }
 
+int check_tree_block(struct btrfs_fs_info *fs_info,
+		     struct extent_buffer *buf);
 int read_extent_data(struct btrfs_root *root, char *data, u64 logical,
 		     u64 *len, int mirror);
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
diff --git a/scrub.c b/scrub.c
index 1dcdc8df..1ea2645b 100644
--- a/scrub.c
+++ b/scrub.c
@@ -119,3 +119,75 @@ static struct scrub_full_stripe *alloc_full_stripe(int nr_stripes,
 	}
 	return ret;
 }
+
+static inline int is_data_stripe(struct scrub_stripe *stripe)
+{
+	u64 bytenr = stripe->logical;
+
+	if (bytenr == BTRFS_RAID5_P_STRIPE || bytenr == BTRFS_RAID6_Q_STRIPE)
+		return 0;
+	return 1;
+}
+
+/*
+ * Scrub one tree mirror given by @bytenr and @mirror, or @data.
+ * If @data is not given(NULL), the function will try to read out tree block
+ * using @bytenr and @mirror.
+ * If @data is given, use data directly, won't try to read from disk.
+ *
+ * The extra @data prameter is handy for RAID5/6 recovery code to verify
+ * the recovered data.
+ *
+ * Return 0 if everything is OK.
+ * Return <0 something goes wrong, and @scrub_ctx accounting will be updated
+ * if it's a data corruption.
+ */
+static int scrub_tree_mirror(struct btrfs_fs_info *fs_info,
+			     struct btrfs_scrub_progress *scrub_ctx,
+			     char *data, u64 bytenr, int mirror)
+{
+	struct extent_buffer *eb;
+	u32 nodesize = fs_info->tree_root->nodesize;
+	int ret;
+
+	if (!IS_ALIGNED(bytenr, fs_info->tree_root->sectorsize)) {
+		/* Such error will be reported by check_tree_block() */
+		scrub_ctx->verify_errors++;
+		return -EIO;
+	}
+
+	eb = btrfs_find_create_tree_block(fs_info, bytenr, nodesize);
+	if (!eb)
+		return -ENOMEM;
+	if (data) {
+		memcpy(eb->data, data, nodesize);
+	} else {
+		ret = read_whole_eb(fs_info, eb, mirror);
+		if (ret) {
+			scrub_ctx->read_errors++;
+			error("failed to read tree block %llu mirror %d",
+			      bytenr, mirror);
+			goto out;
+		}
+	}
+
+	scrub_ctx->tree_bytes_scrubbed += nodesize;
+	if (csum_tree_block(fs_info->tree_root, eb, 1)) {
+		error("tree block %llu mirror %d checksum mismatch", bytenr,
+			mirror);
+		scrub_ctx->csum_errors++;
+		ret = -EIO;
+		goto out;
+	}
+	ret = check_tree_block(fs_info, eb);
+	if (ret < 0) {
+		error("tree block %llu mirror %d is invalid", bytenr, mirror);
+		scrub_ctx->verify_errors++;
+		goto out;
+	}
+
+	scrub_ctx->tree_extents_scrubbed++;
+out:
+	free_extent_buffer(eb);
+	return ret;
+}
-- 
2.12.1



