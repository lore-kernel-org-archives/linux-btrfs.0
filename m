From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: account for space we may use in fallocate
Date: Fri, 19 Jun 2009 15:06:28 -0400
Message-ID: <20090619190627.GB2257@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Using Eric Sandeen's xfstest for fallocate, you can easily trigger a ENOSPC
panic on btrfs.  This is because we do not account for data we may use when
doing the fallocate.  This patch fixes the problem by properly reserving space,
and then just freeing it when we are done.  The reservation stuff was made with
delalloc in mind, so its a little crude for this case, but it keeps the box from
panicing.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 inode.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5b68330..1eacc78 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5103,6 +5103,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
 	struct extent_map *em;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
 	int ret;
 
 	alloc_start = offset & ~mask;
@@ -5121,6 +5122,13 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 			goto out;
 	}
 
+	root = BTRFS_I(inode)->root;
+
+	ret = btrfs_check_data_free_space(root, inode,
+					  alloc_end - alloc_start);
+	if (ret)
+		goto out;
+
 	locked_end = alloc_end - 1;
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
@@ -5128,7 +5136,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
 		if (!trans) {
 			ret = -EIO;
-			goto out;
+			goto out_free;
 		}
 
 		/* the extent lock is ordered inside the running
@@ -5189,6 +5197,8 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		      GFP_NOFS);
 
 	btrfs_end_transaction(trans, BTRFS_I(inode)->root);
+out_free:
+	btrfs_free_reserved_data_space(root, inode, alloc_end - alloc_start);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
