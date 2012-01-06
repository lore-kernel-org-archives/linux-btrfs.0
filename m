From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 14/21] Btrfs: soft profile changing mode (aka soft convert)
Date: Fri,  6 Jan 2012 16:31:02 +0200
Message-ID: <1325860269-15013-15-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

When doing convert from one profile to another if soft mode is on
restriper won't touch chunks that already have the profile we are
converting to.  This is useful if e.g. half of the FS was converted
earlier.

The soft mode switch is (like every other filter) per-type.  This means
that we can convert for example meta chunks the "hard" way while
converting data chunks selectively with soft switch.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   22 ++++++++++++++++++++++
 fs/btrfs/volumes.h |    6 ++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ad94f26..d1beac1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2220,6 +2220,22 @@ static int chunk_vrange_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
+static int chunk_soft_convert_filter(u64 chunk_profile,
+				     struct btrfs_balance_args *bargs)
+{
+	BUG_ON(!(bargs->flags & BTRFS_BALANCE_ARGS_CONVERT));
+
+	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	if (chunk_profile == 0)
+		chunk_profile = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (bargs->target & chunk_profile)
+		return 1;
+
+	return 0;
+}
+
 static int should_balance_chunk(struct btrfs_root *root,
 				struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2271,6 +2287,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* soft profile changing mode */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_SOFT) &&
+	    chunk_soft_convert_filter(chunk_type, bargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 13ff08d..9879a31 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -208,7 +208,13 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 
+/*
+ * Profile changing flags.  When SOFT is set we won't relocate chunk if
+ * it already has the target profile (even though it may be
+ * half-filled).
+ */
 #define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
+#define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
 
 struct btrfs_balance_args;
 struct btrfs_balance_control {
-- 
1.7.6.3

