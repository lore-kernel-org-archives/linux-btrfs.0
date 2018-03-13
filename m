Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:35034 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbeCMB43 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:29 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 4/7] btrfs-progs: check/original mode: Check inline extent size
Date: Tue, 13 Mar 2018 09:56:13 +0800
Message-Id: <20180313015616.6574-5-wqu@suse.com>
In-Reply-To: <20180313015616.6574-1-wqu@suse.com>
References: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For inline compressed file extent, kernel doesn't allow inline extent
ram size larger than sector size and on-disk inline extent size should
not exceed BTRFS_MAX_INLINE_DATA_SIZE().

For inline uncompressed file extent, kernel doesn't allow inline extent
ram and on-disk size larger than either BTRFS_MAX_INLINE_DATA_SIZE() or
sector size.

Check it in original mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c          | 16 ++++++++++++++++
 check/mode-original.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/check/main.c b/check/main.c
index 97baae583f04..7821faa929a3 100644
--- a/check/main.c
+++ b/check/main.c
@@ -560,6 +560,8 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		fprintf(stderr, ", bad file extent");
 	if (errors & I_ERR_FILE_EXTENT_OVERLAP)
 		fprintf(stderr, ", file extent overlap");
+	if (errors & I_ERR_FILE_EXTENT_TOO_LARGE)
+		fprintf(stderr, ", inline file extent too large");
 	if (errors & I_ERR_FILE_EXTENT_DISCOUNT)
 		fprintf(stderr, ", file extent discount");
 	if (errors & I_ERR_DIR_ISIZE_WRONG)
@@ -1433,6 +1435,8 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 disk_bytenr = 0;
 	u64 extent_offset = 0;
 	u64 mask = root->fs_info->sectorsize - 1;
+	u32 max_inline_size = min_t(u32, mask,
+				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
 	int extent_type;
 	int ret;
 
@@ -1458,9 +1462,21 @@ static int process_file_extent(struct btrfs_root *root,
 	extent_type = btrfs_file_extent_type(eb, fi);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+		u8 compression = btrfs_file_extent_compression(eb, fi);
+		struct btrfs_item *item = btrfs_item_nr(slot);
+
 		num_bytes = btrfs_file_extent_inline_len(eb, slot, fi);
 		if (num_bytes == 0)
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
+		if (compression) {
+			if (btrfs_file_extent_inline_item_len(eb, item) >
+			    max_inline_size ||
+			    num_bytes > root->fs_info->sectorsize)
+				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
+		} else {
+			if (num_bytes > max_inline_size)
+				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
+		}
 		rec->found_size += num_bytes;
 		num_bytes = (num_bytes + mask) & ~mask;
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG ||
diff --git a/check/mode-original.h b/check/mode-original.h
index f859af478f0f..368de692fdd1 100644
--- a/check/mode-original.h
+++ b/check/mode-original.h
@@ -185,6 +185,7 @@ struct file_extent_hole {
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
 #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
 #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
+#define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
 
 struct inode_record {
 	struct list_head backrefs;
-- 
2.16.2

