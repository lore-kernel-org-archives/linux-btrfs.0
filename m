From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/4] Btrfs: fix reservation code for mixed block groups
Date: Fri, 15 Oct 2010 17:28:32 -0400
Message-ID: <1287178115-18229-2-git-send-email-josef@redhat.com>
References: <1287178115-18229-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287178115-18229-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

The global reservation stuff tries to add together DATA and METADATA used in
order to figure out how much to reserve for everything, but this doesn't work
right for mixed block groups.  Instead if we have mixed block groups just set
data used to 0.  Also with mixed block groups we will use bytes_may_use for
keeping track of delalloc bytes, so we need to take that into account in our
reservation calculations.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 72c3d5f..d532f00 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3444,7 +3444,8 @@ static int reserve_metadata_bytes(struct btrfs_block_rsv *block_rsv,
 
 	spin_lock(&space_info->lock);
 	unused = space_info->bytes_used + space_info->bytes_reserved +
-		 space_info->bytes_pinned + space_info->bytes_readonly;
+		 space_info->bytes_pinned + space_info->bytes_readonly +
+		 space_info->bytes_may_use;
 
 	if (unused < space_info->total_bytes)
 		unused = space_info->total_bytes - unused;
@@ -3738,6 +3739,8 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 
 	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 	spin_lock(&sinfo->lock);
+	if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA)
+		data_used = 0;
 	meta_used = sinfo->bytes_used;
 	spin_unlock(&sinfo->lock);
 
@@ -3765,7 +3768,8 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	block_rsv->size = num_bytes;
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
-		    sinfo->bytes_reserved + sinfo->bytes_readonly;
+		    sinfo->bytes_reserved + sinfo->bytes_readonly +
+		    sinfo->bytes_may_use;
 
 	if (sinfo->total_bytes > num_bytes) {
 		num_bytes = sinfo->total_bytes - num_bytes;
-- 
1.6.6.1

