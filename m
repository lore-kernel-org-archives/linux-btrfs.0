From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 13/21] Btrfs: virtual address space subset filter
Date: Tue, 23 Aug 2011 23:01:54 +0300
Message-ID: <1314129722-31601-14-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks which have at least one byte located inside a given
[vstart, vend) virtual address space range.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   20 ++++++++++++++++++++
 fs/btrfs/volumes.h |    3 ++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4393f6d..eccd458 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2276,6 +2276,20 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
+/* [vstart, vend) */
+static int chunk_vrange_filter(struct extent_buffer *leaf,
+			       struct btrfs_chunk *chunk,
+			       u64 chunk_offset,
+			       struct btrfs_restripe_args *rargs)
+{
+	if (chunk_offset < rargs->vend &&
+	    chunk_offset + btrfs_chunk_length(leaf, chunk) > rargs->vstart)
+		/* at least part of the chunk is inside this vrange */
+		return 0;
+
+	return 1;
+}
+
 static int chunk_soft_convert_filter(u64 chunk_profile,
 				     struct btrfs_restripe_args *rargs)
 {
@@ -2337,6 +2351,12 @@ static int should_restripe_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* vrange filter */
+	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_VRANGE) &&
+	    chunk_vrange_filter(leaf, chunk, chunk_offset, rargs)) {
+		return 0;
+	}
+
 	/* soft profile changing mode */
 	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
 	    chunk_soft_convert_filter(chunk_type, rargs)) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8d4bbcb..9726180 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -188,7 +188,8 @@ struct map_lookup {
 #define BTRFS_RESTRIPE_ARGS_PROFILES	(1ULL << 0)
 #define BTRFS_RESTRIPE_ARGS_USAGE	(1ULL << 1)
 #define BTRFS_RESTRIPE_ARGS_DEVID	(1ULL << 2)
-#define BTRFS_RESTRIPE_ARGS_DRANGE      (1ULL << 3)
+#define BTRFS_RESTRIPE_ARGS_DRANGE	(1ULL << 3)
+#define BTRFS_RESTRIPE_ARGS_VRANGE	(1ULL << 4)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
1.7.5.4

