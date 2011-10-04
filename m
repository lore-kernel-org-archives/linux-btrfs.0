From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: break out of orphan cleanup if we can't make progress V2
Date: Tue,  4 Oct 2011 11:54:52 -0400
Message-ID: <1317743692-10794-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed while running xfstests 83 that if we didn't have enough space to
delete our inode the orphan cleanup would just loop.  This is because it keeps
finding the same orphan item and keeps trying to kill it but can't because we
don't get an error back from iput for deleting the inode.  So keep track of the
last guy we tried to kill, if it's the same as the one we're trying to kill
currently we know we are having problems and can just error out.  I don't have a
way to test this so look hard and make sure it's right.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: set last_objectid properly

 fs/btrfs/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 446531a..595a807 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2230,6 +2230,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	struct btrfs_key key, found_key;
 	struct btrfs_trans_handle *trans;
 	struct inode *inode;
+	u64 last_objectid = 0;
 	int ret = 0, nr_unlink = 0, nr_truncate = 0;
 
 	if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEANUP_STARTED))
@@ -2281,6 +2282,16 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * crossing root thing.  we store the inode number in the
 		 * offset of the orphan item.
 		 */
+
+		if (found_key.offset == last_objectid) {
+			printk(KERN_ERR "btrfs: Error removing orphan entry, "
+			       "stopping orphan cleanup\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		last_objectid = found_key.offset;
+
 		found_key.objectid = found_key.offset;
 		found_key.type = BTRFS_INODE_ITEM_KEY;
 		found_key.offset = 0;
-- 
1.7.5.2

