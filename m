From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 09/21] Btrfs: profiles filter
Date: Tue, 23 Aug 2011 23:01:50 +0300
Message-ID: <1314129722-31601-10-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks based on a given profile mask.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   20 ++++++++++++++++++++
 fs/btrfs/volumes.h |    5 +++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ff252ef..f045615 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2179,6 +2179,20 @@ static void unset_restripe_control(struct btrfs_fs_info *fs_info)
  * Restripe filters.  Return 1 if chunk should be 'filtered out',
  * ie should not be restriped.
  */
+static int chunk_profiles_filter(u64 chunk_profile,
+				 struct btrfs_restripe_args *rargs)
+{
+	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	if (chunk_profile == 0)
+		chunk_profile = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (rargs->profiles & chunk_profile)
+		return 0;
+
+	return 1;
+}
+
 static int chunk_soft_convert_filter(u64 chunk_profile,
 				     struct btrfs_restripe_args *rargs)
 {
@@ -2216,6 +2230,12 @@ static int should_restripe_chunk(struct btrfs_root *root,
 	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
 		rargs = &rctl->meta;
 
+	/* profiles filter */
+	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_PROFILES) &&
+	    chunk_profiles_filter(chunk_type, rargs)) {
+		return 0;
+	}
+
 	/* soft profile changing mode */
 	if ((rargs->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
 	    chunk_soft_convert_filter(chunk_type, rargs)) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1852f69..9f96ad8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -183,6 +183,11 @@ struct map_lookup {
 #define BTRFS_RESTRIPE_FORCE		(1ULL << 3)
 
 /*
+ * Restripe filters
+ */
+#define BTRFS_RESTRIPE_ARGS_PROFILES	(1ULL << 0)
+
+/*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
  * it already has the target profile (even though it may be
  * half-filled).
-- 
1.7.5.4

