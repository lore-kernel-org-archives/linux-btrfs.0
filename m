From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 12/21] Btrfs: devid subset filter
Date: Tue, 23 Aug 2011 23:01:53 +0300
Message-ID: <1314129722-31601-13-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks which have at least one byte of at least one stripe
located on a device with devid X in a given [pstart,pend) physical
address range.

This filter only works when devid filter is turned on.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce2a9e0..4393f6d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2237,6 +2237,45 @@ static int chunk_devid_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
+/* [pstart, pend) */
+static int chunk_drange_filter(struct extent_buffer *leaf,
+			       struct btrfs_chunk *chunk,
+			       u64 chunk_offset,
+			       struct btrfs_restripe_args *rargs)
+{
+	struct btrfs_stripe *stripe;
+	int num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	u64 stripe_offset;
+	u64 stripe_length;
+	int factor;
+	int i;
+
+	BUG_ON(!(rargs->flags & BTRFS_RESTRIPE_ARGS_DEVID));
+
+	if (btrfs_chunk_type(leaf, chunk) & (BTRFS_BLOCK_GROUP_DUP |
+	     BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10))
+		factor = 2;
+	else
+		factor = 1;
+	factor = num_stripes / factor;
+
+	for (i = 0; i < num_stripes; i++) {
+		stripe = btrfs_stripe_nr(chunk, i);
+		if (btrfs_stripe_devid(leaf, stripe) != rargs->devid)
+			continue;
+
+		stripe_offset = btrfs_stripe_offset(leaf, stripe);
+		stripe_length = btrfs_chunk_length(leaf, chunk);
+		do_div(stripe_length, factor);
+
+		if (stripe_offset < rargs->pend &&
+		    stripe_offset + stripe_length > rargs->pstart)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int chunk_soft_convert_filter(u64 chunk_profile,
 				     struct btrfs_restripe_args *rargs)
 {
@@ -2292,6 +2331,12 @@ static int should_restripe_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* drange filter, makes sense only with devid filter */
+	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_DRANGE) &&
+	    chunk_drange_filter(leaf, chunk, chunk_offset, rargs)) {
+		return 0;
+	}
+
 	/* soft profile changing mode */
 	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
 	    chunk_soft_convert_filter(chunk_type, rargs)) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1b8dc3e..8d4bbcb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -188,6 +188,7 @@ struct map_lookup {
 #define BTRFS_RESTRIPE_ARGS_PROFILES	(1ULL << 0)
 #define BTRFS_RESTRIPE_ARGS_USAGE	(1ULL << 1)
 #define BTRFS_RESTRIPE_ARGS_DEVID	(1ULL << 2)
+#define BTRFS_RESTRIPE_ARGS_DRANGE      (1ULL << 3)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
1.7.5.4

