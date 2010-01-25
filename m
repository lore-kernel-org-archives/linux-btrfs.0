From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix another orphan cleanup problem
Date: Mon, 25 Jan 2010 16:01:47 -0500
Message-ID: <20100125210147.GB2204@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because orphan cleanup now happens well after the fs is all initialized and
such, we can run into this problem where we find orphan entries that were just
added to the fs, not ones that were added previously during a crash.  This does
not bode well for the system, and results in a couple of odd things happening,
like truncate being run on non-regular files.  In order to fix this we just
check and see if the inode has been added to the in-memory orphan list, and if
it has, set the key to it's inode number - 1 so we don't find this orphan entry
again, and continue searching.

This problem kept popping up while running xfs tests, and was 100%
reproduceable.  With this patch the problem no longer happens.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c7fbfaa..067f4b5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2202,6 +2202,17 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * the proper thing when we hit it
 		 */
 		spin_lock(&root->list_lock);
+		if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+			/*
+			 * This inode is on the in-memory list, which means we
+			 * shouldn't be cleaning it up, move on to the next
+			 * orphan item.
+			 */
+			spin_unlock(&root->list_lock);
+			key.offset = inode->i_ino - 1;
+			iput(inode);
+			continue;
+		}
 		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
 		spin_unlock(&root->list_lock);
 
-- 
1.5.4.3

