Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33782 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759983AbdEOI2K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 04:28:10 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <hurikhan77@gmail.com>
Subject: [PATCH 1/5] btrfs-progs: Cleanup open-coded btrfs_chunk_item_size
Date: Mon, 15 May 2017 16:27:38 +0800
Message-ID: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_check_chunk_valid() we calculates chunk item using open code.

use btrfs_chunk_item_size() to replace them.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/volumes.c b/volumes.c
index b350e259..62e23aee 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1685,6 +1685,7 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 	u16 num_stripes;
 	u16 sub_stripes;
 	u64 type;
+	u32 chunk_ondisk_size;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -1724,16 +1725,16 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 			BTRFS_BLOCK_GROUP_PROFILE_MASK) & type);
 		return -EIO;
 	}
+
+	chunk_ondisk_size = btrfs_chunk_item_size(num_stripes);
 	/*
 	 * Btrfs_chunk contains at least one stripe, and for sys_chunk
 	 * it can't exceed the system chunk array size
 	 * For normal chunk, it should match its chunk item size.
 	 */
 	if (num_stripes < 1 ||
-	    (slot == -1 && sizeof(struct btrfs_stripe) * num_stripes >
-	     BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) ||
-	    (slot >= 0 && sizeof(struct btrfs_stripe) * (num_stripes - 1) >
-	     btrfs_item_size_nr(leaf, slot))) {
+	    (slot == -1 && chunk_ondisk_size > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) ||
+	    (slot >= 0 && chunk_ondisk_size > btrfs_item_size_nr(leaf, slot))) {
 		error("invalid num_stripes: %u", num_stripes);
 		return -EIO;
 	}
-- 
2.12.2



