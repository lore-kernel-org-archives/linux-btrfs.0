Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1034342AbcJ1CdC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:33:02 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 10/19] btrfs-progs: check/scrub: Introduce function to scrub mirror based tree block
Date: Fri, 28 Oct 2016 10:31:46 +0800
Message-Id: <20161028023155.27336-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_tree_mirror(), to scrub mirror based
tree blocks (Single/DUP/RAID0/1/10)

This function can be used on in-memory tree blocks using @data parameter
for RAID5/6 full stripe, or just by @bytenr, for other profiles.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 disk-io.c     |  4 ++--
 disk-io.h     |  2 ++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/check/scrub.c b/check/scrub.c
index 1ae7acd..ef94193 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -108,3 +108,62 @@ static struct scrub_full_stripe *alloc_full_stripe(int nr_stripes,
 	return ret;
 }
 
+static inline int is_data_stripe(struct scrub_stripe *stripe)
+{
+	u64 bytenr = stripe->logical;
+
+	if (bytenr == BTRFS_RAID5_P_STRIPE || bytenr == BTRFS_RAID6_Q_STRIPE)
+		return 0;
+	return 1;
+}
+
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
+
diff --git a/disk-io.c b/disk-io.c
index f24567b..2750e6e 100644
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
index 6efd75b..f8a2cff 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -113,6 +113,8 @@ static inline struct extent_buffer* read_tree_block(
 			parent_transid);
 }
 
+int check_tree_block(struct btrfs_fs_info *fs_info,
+		     struct extent_buffer *buf);
 int read_extent_data(struct btrfs_root *root, char *data, u64 logical,
 		     u64 *len, int mirror);
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-- 
2.10.1



