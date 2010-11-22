From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure new inode size is ok in fallocate
Date: Mon, 22 Nov 2010 13:55:39 -0500
Message-ID: <1290452139-8606-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have been failing xfstest 228 forever, because we don't check to make sure
the new inode size is acceptable as far as RLIMIT is concerned.  Just check to
make sure it's ok to create a inode with this new size and error out if not.
With this patch we now pass 228.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d83f288..25a8fa2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6945,6 +6945,10 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
 
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, alloc_end);
+	if (ret)
+		goto out;
+
 	if (alloc_start > inode->i_size) {
 		ret = btrfs_cont_expand(inode, alloc_start);
 		if (ret)
-- 
1.6.6.1

