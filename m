From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 10/21] Btrfs: devid subset filter
Date: Fri,  6 Jan 2012 16:30:58 +0200
Message-ID: <1325860269-15013-11-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
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
index d52cfde..a5a2d65 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2167,6 +2167,45 @@ static int chunk_devid_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
+/* [pstart, pend) */
+static int chunk_drange_filter(struct extent_buffer *leaf,
+			       struct btrfs_chunk *chunk,
+			       u64 chunk_offset,
+			       struct btrfs_balance_args *bargs)
+{
+	struct btrfs_stripe *stripe;
+	int num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	u64 stripe_offset;
+	u64 stripe_length;
+	int factor;
+	int i;
+
+	BUG_ON(!(bargs->flags & BTRFS_BALANCE_ARGS_DEVID));
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
+		if (btrfs_stripe_devid(leaf, stripe) != bargs->devid)
+			continue;
+
+		stripe_offset = btrfs_stripe_offset(leaf, stripe);
+		stripe_length = btrfs_chunk_length(leaf, chunk);
+		do_div(stripe_length, factor);
+
+		if (stripe_offset < bargs->pend &&
+		    stripe_offset + stripe_length > bargs->pstart)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int should_balance_chunk(struct btrfs_root *root,
 				struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2206,6 +2245,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* drange filter, makes sense only with devid filter */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_DRANGE) &&
+	    chunk_drange_filter(leaf, chunk, chunk_offset, bargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7007a31..75fb5f2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -202,6 +202,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
 #define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
 #define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
+#define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 
 struct btrfs_balance_args;
 struct btrfs_balance_control {
-- 
1.7.6.3

