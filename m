From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't set current->journal_info for ioctl trans
	handles
Date: Tue, 3 Nov 2009 10:01:16 -0500
Message-ID: <20091103150115.GA5541@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We use journal_info to tell if we're in a nested transaction to make sure we
don't commit the transaction within a nested transaction.  We use another
method to see if there are any outstanding ioctl trans handles, so if we're
starting one do not set current->journal_info, since it will screw with other
filesystems.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bca82a4..3d3dcea 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -186,7 +186,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	h->alloc_exclude_start = 0;
 	h->delayed_ref_updates = 0;
 
-	if (!current->journal_info)
+	if (!current->journal_info && wait != 2)
 		current->journal_info = h;
 
 	root->fs_info->running_transaction->use_count++;
-- 
1.5.4.3

