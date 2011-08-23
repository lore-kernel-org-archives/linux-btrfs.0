From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 08/21] Btrfs: soft profile changing mode (aka soft convert)
Date: Tue, 23 Aug 2011 23:01:49 +0300
Message-ID: <1314129722-31601-9-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

When doing convert from one profile to another if soft mode is on
restriper won't touch chunks that already have the profile we are
converting to.  This is useful if e.g. half of the fs was converted
earlier.

The soft mode switch is per-type (like everything else).  This means
that we can convert for example meta chunks the "hard" way while
converting data chunks selectively with soft switch.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   26 ++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    5 ++++-
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 95c6310..ff252ef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2175,6 +2175,26 @@ static void unset_restripe_control(struct btrfs_fs_info *fs_info)
 	kfree(rctl);
 }
 
+/*
+ * Restripe filters.  Return 1 if chunk should be 'filtered out',
+ * ie should not be restriped.
+ */
+static int chunk_soft_convert_filter(u64 chunk_profile,
+				     struct btrfs_restripe_args *rargs)
+{
+	BUG_ON(!(rargs->flags & BTRFS_RESTRIPE_ARGS_CONVERT));
+
+	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	if (chunk_profile == 0)
+		chunk_profile = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (rargs->target & chunk_profile)
+		return 1;
+
+	return 0;
+}
+
 static int should_restripe_chunk(struct btrfs_root *root,
 				 struct extent_buffer *leaf,
 				 struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2196,6 +2216,12 @@ static int should_restripe_chunk(struct btrfs_root *root,
 	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
 		rargs = &rctl->meta;
 
+	/* soft profile changing mode */
+	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
+	    chunk_soft_convert_filter(chunk_type, rargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f40227e..1852f69 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -183,9 +183,12 @@ struct map_lookup {
 #define BTRFS_RESTRIPE_FORCE		(1ULL << 3)
 
 /*
- * Profile changing flags
+ * Profile changing flags.  When SOFT is set we won't relocate chunk if
+ * it already has the target profile (even though it may be
+ * half-filled).
  */
 #define BTRFS_RESTRIPE_ARGS_CONVERT	(1ULL << 8)
+#define BTRFS_RESTRIPE_ARGS_SOFT	(1ULL << 9)
 
 struct btrfs_restripe_args;
 struct restripe_control {
-- 
1.7.5.4

