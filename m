From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: protect the pending_snapshots list with trans_lock
Date: Tue, 14 Jun 2011 15:17:47 -0400
Message-ID: <1308079067-20733-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently there is nothing protecting the pending_snapshots list on the
transaction.  We only hold the directory mutex that we are snapshotting and a
read lock on the subvol_sem, so we could race with somebody else creating a
snapshot in a different directory and end up with list corruption.  So protect
this list with the trans_lock.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b793d11..a3c4751 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -482,8 +482,10 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
 	BUG_ON(ret);
 
+	spin_lock(&root->fs_info->trans_lock);
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
+	spin_unlock(&root->fs_info->trans_lock);
 	if (async_transid) {
 		*async_transid = trans->transid;
 		ret = btrfs_commit_transaction_async(trans,
-- 
1.7.5.2

