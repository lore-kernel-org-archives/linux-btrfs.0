From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 09/21] Btrfs: devid filter
Date: Fri,  6 Jan 2012 16:30:57 +0200
Message-ID: <1325860269-15013-10-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Relocate chunks which have at least one stripe located on a device with
devid X.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   23 +++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e252cf2..d52cfde 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2150,6 +2150,23 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 	return ret;
 }
 
+static int chunk_devid_filter(struct extent_buffer *leaf,
+			      struct btrfs_chunk *chunk,
+			      struct btrfs_balance_args *bargs)
+{
+	struct btrfs_stripe *stripe;
+	int num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	int i;
+
+	for (i = 0; i < num_stripes; i++) {
+		stripe = btrfs_stripe_nr(chunk, i);
+		if (btrfs_stripe_devid(leaf, stripe) == bargs->devid)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int should_balance_chunk(struct btrfs_root *root,
 				struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2183,6 +2200,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* devid filter */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_DEVID) &&
+	    chunk_devid_filter(leaf, chunk, bargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 23b53bb..7007a31 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -201,6 +201,7 @@ struct map_lookup {
  */
 #define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
 #define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
+#define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
 
 struct btrfs_balance_args;
 struct btrfs_balance_control {
-- 
1.7.6.3

