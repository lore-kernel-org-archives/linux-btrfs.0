Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49483 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbaIREWW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 00:22:22 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8I4MRtP012947
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 12:22:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs: Add btrfsck support for nocow compressed prealloc write.
Date: Thu, 18 Sep 2014 12:22:18 +0800
Message-ID: <1411014138-20124-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1411014138-20124-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1411014138-20124-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support for nocow compressed write into preallocated range.

The main change is the following:
1) use disk_bytenr + data_offset to search csum
2) use offset + num_bytes - data_offset to judge if this is a valid
file extent.
3) add file extent item size check,
Since now regular file extent has 2 sizes(one with appended members
and the old one),

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 19 ++++++++++++++++---
 ctree.h      |  1 -
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 268e588..7a18ad4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1175,12 +1175,17 @@ static int process_file_extent(struct btrfs_root *root,
 		num_bytes = (num_bytes + mask) & ~mask;
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG ||
 		   extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		u32 item_size = btrfs_item_size_nr(eb, slot);
 		num_bytes = btrfs_file_extent_num_bytes(eb, fi);
-		disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
+		/* data_offset will fallback to 0 on normal extent */
+		disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi) +
+			      btrfs_ondemand_file_extent_data_offset(eb,
+							slot, fi);
 		extent_offset = btrfs_file_extent_offset(eb, fi);
 		if (num_bytes == 0 || (num_bytes & mask))
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
-		if (num_bytes + extent_offset >
+		if (num_bytes + extent_offset -
+		    btrfs_ondemand_file_extent_data_offset(eb, slot, fi) >
 		    btrfs_file_extent_ram_bytes(eb, fi))
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
@@ -1190,6 +1195,13 @@ static int process_file_extent(struct btrfs_root *root,
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
 		if (disk_bytenr > 0)
 			rec->found_size += num_bytes;
+		if (item_size != BTRFS_FILE_EXTENT_SIZE_NORMAL &&
+		    item_size != BTRFS_FILE_EXTENT_SIZE_MAX)
+			rec->errors |= I_ERR_BAD_FILE_EXTENT;
+		if (!btrfs_fs_incompat(root->fs_info,
+				       BTRFS_FEATURE_INCOMPAT_COMPPREALLOC) &&
+		    (item_size == BTRFS_FILE_EXTENT_SIZE_MAX))
+			rec->errors |= I_ERR_BAD_FILE_EXTENT;
 	} else {
 		rec->errors |= I_ERR_BAD_FILE_EXTENT;
 	}
@@ -1198,7 +1210,8 @@ static int process_file_extent(struct btrfs_root *root,
 	if (disk_bytenr > 0) {
 		u64 found;
 		if (btrfs_file_extent_compression(eb, fi))
-			num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+			num_bytes = btrfs_ondemand_file_extent_data_len(eb,
+					slot, fi);
 		else
 			disk_bytenr += extent_offset;
 
diff --git a/ctree.h b/ctree.h
index ab87133..e11e4d8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -834,7 +834,6 @@ struct __compprealloc_data {
 	__le64 data_len;
 
 } __attribute__ ((__packed__));
-
 #define BTRFS_FILE_EXTENT_SIZE_NORMAL (sizeof(struct btrfs_file_extent_item))
 #define BTRFS_FILE_EXTENT_SIZE_MAX (sizeof(struct btrfs_file_extent_item) + \
 				    sizeof(struct __compprealloc_data))
-- 
2.1.0

