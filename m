Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33782 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759170AbdEOI2F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 04:28:05 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <hurikhan77@gmail.com>
Subject: [PATCH 3/5] btrfs-progs: check: Reuse btrfs_check_chunk_valid in lowmem mode
Date: Mon, 15 May 2017 16:27:40 +0800
Message-ID: <20170515082742.21363-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
References: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs check lowmem mode manually checks found chunk
item, even we already have the generic chunk validation checker,
btrfs_check_chunk_valid().

This patch will use btrfs_check_chunk_valid() to replace open-coded
chunk validation checker in check_chunk_item().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 17b7efbf..58b73608 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11110,11 +11110,9 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_group_item *bi;
 	struct btrfs_block_group_item bg_item;
 	struct btrfs_dev_extent *ptr;
-	u32 sectorsize = btrfs_super_sectorsize(fs_info->super_copy);
 	u64 length;
 	u64 chunk_end;
 	u64 type;
-	u64 profile;
 	int num_stripes;
 	u64 offset;
 	u64 objectid;
@@ -11126,25 +11124,15 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	chunk = btrfs_item_ptr(eb, slot, struct btrfs_chunk);
 	length = btrfs_chunk_length(eb, chunk);
 	chunk_end = chunk_key.offset + length;
-	if (!IS_ALIGNED(length, sectorsize)) {
-		error("chunk[%llu %llu) not aligned to %u",
-			chunk_key.offset, chunk_end, sectorsize);
-		err |= BYTES_UNALIGNED;
+	ret = btrfs_check_chunk_valid(extent_root, eb, chunk, slot,
+				      chunk_key.offset);
+	if (ret < 0) {
+		error("chunk[%llu %llu) is invalid", chunk_key.offset,
+			chunk_end);
+		err |= BYTES_UNALIGNED | UNKNOWN_TYPE;
 		goto out;
 	}
-
 	type = btrfs_chunk_type(eb, chunk);
-	profile = type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
-	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
-		error("chunk[%llu %llu) has no chunk type",
-			chunk_key.offset, chunk_end);
-		err |= UNKNOWN_TYPE;
-	}
-	if (profile && (profile & (profile - 1))) {
-		error("chunk[%llu %llu) multiple profiles detected: %llx",
-			chunk_key.offset, chunk_end, profile);
-		err |= UNKNOWN_TYPE;
-	}
 
 	bg_key.objectid = chunk_key.offset;
 	bg_key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-- 
2.12.2



