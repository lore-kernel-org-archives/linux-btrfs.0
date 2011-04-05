From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only retry transaction reservation once
Date: Tue,  5 Apr 2011 11:57:27 -0400
Message-ID: <1302019047-16939-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I saw a lockup where we kept getting into this start transaction->commit
transaction loop because of enospce.  The fact is if we fail to make our
reservation, we've tried _everything_ several times, so we only need to try and
commit the transaction once, and if that doesn't work then we really are out of
space and need to just exit.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3d73c8d..6b0ba18 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -180,6 +180,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
+	int retries = 0;
 	int ret;
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
@@ -218,10 +219,18 @@ again:
 
 	if (num_items > 0) {
 		ret = btrfs_trans_reserve_metadata(h, root, num_items);
-		if (ret == -EAGAIN) {
+		if (ret == -EAGAIN && !retries) {
+			retries++;
 			btrfs_commit_transaction(h, root);
 			goto again;
+		} else if (ret == -EAGAIN) {
+			/*
+			 * We have already retried and got EAGAIN, so really we
+			 * don't have space, so set ret to -ENOSPC.
+			 */
+			ret = -ENOSPC;
 		}
+
 		if (ret < 0) {
 			btrfs_end_transaction(h, root);
 			return ERR_PTR(ret);
-- 
1.7.2.3

