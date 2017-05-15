Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59761 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759967AbdEOI2Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 04:28:16 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <hurikhan77@gmail.com>
Subject: [PATCH 4/5] btrfs-progs: Introduce function to get correct stripe length
Date: Mon, 15 May 2017 16:27:41 +0800
Message-ID: <20170515082742.21363-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
References: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_get_chunk_stripe_len() to get correct
stripe length.
This is very handy for lowmem mode, which checks the mapping between
device extent and chunk item.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 volumes.h |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/volumes.c b/volumes.c
index 1e352869..8f529051 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2284,3 +2284,47 @@ out:
 
 	return ret;
 }
+
+/*
+ * Get stripe length from chunk item and its stripe items
+ *
+ * Caller should only call this function after validating the chunk item
+ * by using btrfs_check_chunk_valid().
+ */
+u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
+			struct extent_buffer *leaf,
+			struct btrfs_chunk *chunk)
+{
+	u64 stripe_len;
+	u64 chunk_len;
+	u32 num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	u64 profile = btrfs_chunk_type(leaf, chunk) &
+		      BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	chunk_len = btrfs_chunk_length(leaf, chunk);
+
+	switch (profile) {
+	case 0: /* Single profile */
+	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_DUP:
+		stripe_len = chunk_len;
+		break;
+	case BTRFS_BLOCK_GROUP_RAID0:
+		stripe_len = chunk_len / num_stripes;
+		break;
+	case BTRFS_BLOCK_GROUP_RAID5:
+		stripe_len = chunk_len / (num_stripes - 1);
+		break;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		stripe_len = chunk_len / (num_stripes - 2);
+		break;
+	case BTRFS_BLOCK_GROUP_RAID10:
+		stripe_len = chunk_len / (num_stripes /
+				btrfs_chunk_sub_stripes(leaf, chunk));
+		break;
+	default:
+		/* Invalid chunk profile found */
+		BUG_ON(1);
+	}
+	return stripe_len;
+}
diff --git a/volumes.h b/volumes.h
index 699b0bae..fc0a775b 100644
--- a/volumes.h
+++ b/volumes.h
@@ -246,4 +246,7 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 			    struct extent_buffer *leaf,
 			    struct btrfs_chunk *chunk,
 			    int slot, u64 logical);
+u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
+			struct extent_buffer *leaf,
+			struct btrfs_chunk *chunk);
 #endif
-- 
2.12.2



