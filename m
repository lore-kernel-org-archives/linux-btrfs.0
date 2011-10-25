From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 43/66] btrfs: Simplify btrfs_submit_bio_hook
Date: Mon, 24 Oct 2011 21:03:19 -0400
Message-ID: <20111025010855.500998289@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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
index 59c681b..c0dc599 100644
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



