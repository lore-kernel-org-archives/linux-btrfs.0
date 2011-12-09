From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix leaked space in truncate
Date: Fri,  9 Dec 2011 13:27:20 -0500
Message-ID: <1323455240-8126-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We were occasionaly leaking space when running xfstest 269.  This is because if
we failed to start the transaction in the truncate loop we'd just goto out, but
we need to break so that the inode is removed from the orphan list and the space
is properly freed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3e3ca2..ae5b354a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6581,8 +6581,9 @@ static int btrfs_truncate(struct inode *inode)
 			/* Just need the 1 for updating the inode */
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
-				err = PTR_ERR(trans);
-				goto out;
+				ret = err = PTR_ERR(trans);
+				trans = NULL;
+				break;
 			}
 		}
 
-- 
1.7.5.2

