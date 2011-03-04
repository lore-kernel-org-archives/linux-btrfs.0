From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add a comment explaining what btrfs_cont_expand does
Date: Fri,  4 Mar 2011 15:47:46 -0500
Message-ID: <1299271666-5952-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Everytime I have to deal with btrfs_cont_expand I stare at it for 20 minutes
trying to remember what exactly it does and why the hell we need it.  So add a
comment to save future-Josef some time.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c19d2df..a650b7c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3557,6 +3557,12 @@ out:
 	return ret;
 }
 
+/*
+ * This function puts in dummy file extents for the area we're creating a hole
+ * for.  So if we are truncating this file to a larger size we need to insert
+ * these file extents so that btrfs_get_extent will return a EXTENT_MAP_HOLE for
+ * the range between oldsize and size
+ */
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 {
 	struct btrfs_trans_handle *trans;
-- 
1.7.2.3

