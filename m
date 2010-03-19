From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix data enospc check overflow
Date: Fri, 19 Mar 2010 10:38:13 -0400
Message-ID: <20100319143813.GB2314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because we account for reserved space we get from the allocator before we
actually account for allocating delalloc space, we can have a small window where
the amount of "used" space in a space_info is more than the total amount of
space in the space_info.  This will cause a overflow in our check, so it will
seem like we have _tons_ of free space, and we'll allow reservations to occur
that will end up larger than the amount of space we have.  I've seen users
report ENOSPC panic's in cow_file_range a few times recently, so I tried to
reproduce this problem and found I could reproduce it if I ran one of my tests
in a loop for like 20 minutes.  With this patch my test ran all night without
issues.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7bb97de..1860969 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3234,7 +3234,8 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
-	int ret = 0, committed = 0;
+	u64 used;
+	int ret = 0, committed = 0, flushed = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
@@ -3246,12 +3247,21 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 again:
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
-	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
-	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
-	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
-	    data_sinfo->bytes_may_use - data_sinfo->bytes_super < bytes) {
+	used = data_sinfo->bytes_used + data_sinfo->bytes_delalloc +
+		data_sinfo->bytes_reserved + data_sinfo->bytes_pinned +
+		data_sinfo->bytes_readonly + data_sinfo->bytes_may_use +
+		data_sinfo->bytes_super;
+
+	if (used + bytes > data_sinfo->total_bytes) {
 		struct btrfs_trans_handle *trans;
 
+		if (!flushed) {
+			spin_unlock(&data_sinfo->lock);
+			flush_delalloc(root, data_sinfo);
+			flushed = 1;
+			goto again;
+		}
+
 		/*
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
-- 
1.6.6

