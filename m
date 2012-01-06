From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 08/21] Btrfs: usage filter
Date: Fri,  6 Jan 2012 16:30:56 +0200
Message-ID: <1325860269-15013-9-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks that are less than X percent full.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 315a6c2..e252cf2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2120,6 +2120,36 @@ static int chunk_profiles_filter(u64 chunk_profile,
 	return 1;
 }
 
+static u64 div_factor_fine(u64 num, int factor)
+{
+	if (factor <= 0)
+		return 0;
+	if (factor >= 100)
+		return num;
+
+	num *= factor;
+	do_div(num, 100);
+	return num;
+}
+
+static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+			      struct btrfs_balance_args *bargs)
+{
+	struct btrfs_block_group_cache *cache;
+	u64 chunk_used, user_thresh;
+	int ret = 1;
+
+	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	chunk_used = btrfs_block_group_used(&cache->item);
+
+	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
+	if (chunk_used < user_thresh)
+		ret = 0;
+
+	btrfs_put_block_group(cache);
+	return ret;
+}
+
 static int should_balance_chunk(struct btrfs_root *root,
 				struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2147,6 +2177,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* usage filter */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
+	    chunk_usage_filter(bctl->fs_info, chunk_offset, bargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9c95c13..23b53bb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -200,6 +200,7 @@ struct map_lookup {
  * Balance filters
  */
 #define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
+#define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
 
 struct btrfs_balance_args;
 struct btrfs_balance_control {
-- 
1.7.6.3

