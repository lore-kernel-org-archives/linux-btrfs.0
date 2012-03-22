From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 11/35] btrfs: Simplify btrfs_submit_bio_hook
Date: Wed, 21 Mar 2012 21:11:15 -0400
Message-ID: <20120322011134.511321146@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_submit_bio_hook currently calls btrfs_bio_wq_end_io in either case
of an if statement that determines one of the arguments.

This patch moves the function call outside of the if statement and uses it
to only determine the different argument. This allows us to catch an
error in one place in a more visually obvious way.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/inode.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 892b347..f0dfd7d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1479,13 +1479,14 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;
 	int skip_sum;
+	int metadata = 0;
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	if (btrfs_is_free_space_inode(root, inode))
-		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 2);
-	else
-		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+		metadata = 2;
+
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
 	BUG_ON(ret);
 
 	if (!(rw & REQ_WRITE)) {
-- 
1.7.9



