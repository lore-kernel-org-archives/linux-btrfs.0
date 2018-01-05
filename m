Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14657 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751398AbeAELRZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:25 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 05/16] btrfs-progs: scrub: Introduce functions to scrub mirror based tree block
Date: Fri, 5 Jan 2018 19:01:13 +0800
Message-ID: <1515150084-17231-6-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce new functions, check/recover_tree_mirror(), to check and
recover mirror-based tree blocks (Single/DUP/RAID0/1/10).

check_tree_mirror() can also be used on in-memory tree blocks using @data
parameter.
This is very handy for RAID5/6 case, either checking the data stripe
tree block by @bytenr and 0 as @mirror, or using @data parameter for
recovered in-memory data.

While recover_tree_mirror() is only used for mirror-based profiles, as
RAID56 recovery is done by stripe unit, not mirror unit.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 disk-io.c |   4 +-
 disk-io.h |   2 +
 scrub.c   | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index f5edc479..1abc6f71 100644
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
index f6a422f2..0ed7624e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -118,6 +118,8 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 		u64 parent_transid);
 
+int check_tree_block(struct btrfs_fs_info *fs_info,
+		     struct extent_buffer *buf);
 int read_extent_data(struct btrfs_fs_info *fs_info, char *data, u64 logical,
 		     u64 *len, int mirror);
 void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
diff --git a/scrub.c b/scrub.c
index 41c40108..00786dd3 100644
--- a/scrub.c
+++ b/scrub.c
@@ -117,3 +117,148 @@ static struct scrub_full_stripe *alloc_full_stripe(int nr_stripes,
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
+ * Check one tree mirror given by @bytenr and @mirror, or @data.
+ * If @data is not given (NULL), the function will try to read out tree block
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
+static int check_tree_mirror(struct btrfs_fs_info *fs_info,
+			     struct btrfs_scrub_progress *scrub_ctx,
+			     char *data, u64 bytenr, int mirror)
+{
+	struct extent_buffer *eb;
+	u32 nodesize = fs_info->nodesize;
+	int ret;
+
+	if (!IS_ALIGNED(bytenr, fs_info->sectorsize)) {
+		/* Such error will be reported by check_tree_block() */
+		scrub_ctx->verify_errors++;
+		return -EIO;
+	}
+
+	eb = btrfs_find_create_tree_block(fs_info, bytenr);
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
+	if (csum_tree_block(fs_info, eb, 1)) {
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
+
+/*
+ * read_extent_data() helper
+ *
+ * This function will handle short read and update @scrub_ctx when read
+ * error happens.
+ */
+static int read_extent_data_loop(struct btrfs_fs_info *fs_info,
+				 struct btrfs_scrub_progress *scrub_ctx,
+				 char *buf, u64 start, u64 len, int mirror)
+{
+	int ret = 0;
+	u64 cur = 0;
+
+	while (cur < len) {
+		u64 read_len = len - cur;
+
+		ret = read_extent_data(fs_info, buf + cur,
+					start + cur, &read_len, mirror);
+		if (ret < 0) {
+			error("failed to read out data at bytenr %llu mirror %d",
+				start + cur, mirror);
+			scrub_ctx->read_errors++;
+			break;
+		}
+		cur += read_len;
+	}
+	return ret;
+}
+
+/*
+ * Recover all other (corrupted) mirrors for tree block.
+ *
+ * The method is quite simple, just read out the correct mirror specified by
+ * @good_mirror and write back correct data to all other blocks
+ */
+static int recover_tree_mirror(struct btrfs_fs_info *fs_info,
+			       struct btrfs_scrub_progress *scrub_ctx,
+			       u64 start, int good_mirror)
+{
+	char *buf;
+	u32 nodesize = fs_info->nodesize;
+	int i;
+	int num_copies;
+	int ret;
+
+	buf = malloc(nodesize);
+	if (!buf)
+		return -ENOMEM;
+	ret = read_extent_data_loop(fs_info, scrub_ctx, buf, start, nodesize,
+				    good_mirror);
+	if (ret < 0) {
+		error("failed to read tree block at bytenr %llu mirror %d",
+			start, good_mirror);
+		goto out;
+	}
+
+	num_copies = btrfs_num_copies(fs_info, start, nodesize);
+	for (i = 0; i <= num_copies; i++) {
+		if (i == good_mirror)
+			continue;
+		ret = write_data_to_disk(fs_info, buf, start, nodesize, i);
+		if (ret < 0) {
+			error("failed to write tree block at bytenr %llu mirror %d",
+				start, i);
+			goto out;
+		}
+	}
+	ret = 0;
+out:
+	free(buf);
+	return ret;
+}
-- 
2.14.3



