From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 07/21] Btrfs: profiles filter
Date: Fri,  6 Jan 2012 16:30:55 +0200
Message-ID: <1325860269-15013-8-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks based on a given profile mask.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   24 ++++++++++++++++++++++++
 fs/btrfs/volumes.h |    4 ++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e6cddd..315a6c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2102,6 +2102,24 @@ static void unset_balance_control(struct btrfs_fs_info *fs_info)
 	kfree(bctl);
 }
 
+/*
+ * Balance filters.  Return 1 if chunk should be filtered out
+ * (should not be balanced).
+ */
+static int chunk_profiles_filter(u64 chunk_profile,
+				 struct btrfs_balance_args *bargs)
+{
+	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	if (chunk_profile == 0)
+		chunk_profile = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (bargs->profiles & chunk_profile)
+		return 0;
+
+	return 1;
+}
+
 static int should_balance_chunk(struct btrfs_root *root,
 				struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2123,6 +2141,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
 		bargs = &bctl->meta;
 
+	/* profiles filter */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_PROFILES) &&
+	    chunk_profiles_filter(chunk_type, bargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7a78051..9c95c13 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -196,6 +196,10 @@ struct map_lookup {
 #define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
 					 BTRFS_BALANCE_SYSTEM |	    \
 					 BTRFS_BALANCE_METADATA)
+/*
+ * Balance filters
+ */
+#define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
 
 struct btrfs_balance_args;
 struct btrfs_balance_control {
-- 
1.7.6.3

