From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 11/21] Btrfs: devid filter
Date: Tue, 23 Aug 2011 23:01:52 +0300
Message-ID: <1314129722-31601-12-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Relocate chunks which have at least one stripe located on a device with
devid X.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   23 +++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b49ecfa..ce2a9e0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2220,6 +2220,23 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 	return ret;
 }
 
+static int chunk_devid_filter(struct extent_buffer *leaf,
+			      struct btrfs_chunk *chunk,
+			      struct btrfs_restripe_args *rargs)
+{
+	struct btrfs_stripe *stripe;
+	int num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	int i;
+
+	for (i = 0; i < num_stripes; i++) {
+		stripe = btrfs_stripe_nr(chunk, i);
+		if (btrfs_stripe_devid(leaf, stripe) == rargs->devid)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int chunk_soft_convert_filter(u64 chunk_profile,
 				     struct btrfs_restripe_args *rargs)
 {
@@ -2269,6 +2286,12 @@ static int should_restripe_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* devid filter */
+	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_DEVID) &&
+	    chunk_devid_filter(leaf, chunk, rargs)) {
+		return 0;
+	}
+
 	/* soft profile changing mode */
 	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
 	    chunk_soft_convert_filter(chunk_type, rargs)) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c6baf4b..1b8dc3e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -187,6 +187,7 @@ struct map_lookup {
  */
 #define BTRFS_RESTRIPE_ARGS_PROFILES	(1ULL << 0)
 #define BTRFS_RESTRIPE_ARGS_USAGE	(1ULL << 1)
+#define BTRFS_RESTRIPE_ARGS_DEVID	(1ULL << 2)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
1.7.5.4

