From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set trans to null in reserve_metadata_bytes if we commit the transaction
Date: Tue, 26 Oct 2010 12:54:30 -0400
Message-ID: <1288112070-2676-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_commit_transaction will free our trans, but because we pass trans to
shrink_delalloc we could possibly have a use after free situation.  So instead
if we commit the transaction, set trans to null and set committed to true so we
don't keep trying to commit a transaction.  This fixes a panic I could reproduce
at will.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 180a501..e2dfd4a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3157,6 +3157,7 @@ static int reserve_metadata_bytes(struct btrfs_trans_handle *trans,
 	int retries = 0;
 	int ret = 0;
 	bool reserved = false;
+	bool committed = false;
 
 again:
 	ret = -ENOSPC;
@@ -3249,17 +3250,19 @@ again:
 		goto out;
 
 	ret = -EAGAIN;
-	if (trans)
+	if (trans || committed)
 		goto out;
 
-
 	ret = -ENOSPC;
 	trans = btrfs_join_transaction(root, 1);
 	if (IS_ERR(trans))
 		goto out;
 	ret = btrfs_commit_transaction(trans, root);
-	if (!ret)
+	if (!ret) {
+		trans = NULL;
+		committed = true;
 		goto again;
+	}
 
 out:
 	if (reserved) {
-- 
1.6.6.1

