From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 10/21] Btrfs: usage filter
Date: Tue, 23 Aug 2011 23:01:51 +0300
Message-ID: <1314129722-31601-11-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks that are less than X percent full.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   33 +++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f045615..b49ecfa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2193,6 +2193,33 @@ static int chunk_profiles_filter(u64 chunk_profile,
 	return 1;
 }
 
+static u64 div_factor_fine(u64 num, int factor)
+{
+	if (factor == 100)
+		return num;
+	num *= factor;
+	do_div(num, 100);
+	return num;
+}
+
+static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+			      struct btrfs_restripe_args *rargs)
+{
+	struct btrfs_block_group_cache *cache;
+	u64 chunk_used, user_thresh;
+	int ret = 1;
+
+	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	chunk_used = btrfs_block_group_used(&cache->item);
+
+	user_thresh = div_factor_fine(cache->key.offset, rargs->usage);
+	if (chunk_used < user_thresh)
+		ret = 0;
+
+	btrfs_put_block_group(cache);
+	return ret;
+}
+
 static int chunk_soft_convert_filter(u64 chunk_profile,
 				     struct btrfs_restripe_args *rargs)
 {
@@ -2236,6 +2263,12 @@ static int should_restripe_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* usage filter */
+	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_USAGE) &&
+	    chunk_usage_filter(rctl->fs_info, chunk_offset, rargs)) {
+		return 0;
+	}
+
 	/* soft profile changing mode */
 	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
 	    chunk_soft_convert_filter(chunk_type, rargs)) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9f96ad8..c6baf4b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -186,6 +186,7 @@ struct map_lookup {
  * Restripe filters
  */
 #define BTRFS_RESTRIPE_ARGS_PROFILES	(1ULL << 0)
+#define BTRFS_RESTRIPE_ARGS_USAGE	(1ULL << 1)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
1.7.5.4

