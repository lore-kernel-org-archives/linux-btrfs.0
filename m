From: Chris Ball <cjb@laptop.org>
Subject: [PATCH] Btrfs: Add an alarm for long-running transactions.
Date: Tue, 10 Mar 2009 12:54:50 -0400
Message-ID: <m3d4cppbc5.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we're waiting for a transaction to end, and it started more than five
minutes ago, emit a warning.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 fs/btrfs/transaction.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f94c2ad..9fa477c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -80,6 +80,7 @@ static noinline int join_transaction(struct btrfs_root *root)
 		root->fs_info->running_transaction = cur_trans;
 		spin_unlock(&root->fs_info->new_trans_lock);
 	} else {
+		WARN_ON_ONCE(get_seconds() - cur_trans->start_time > 300);
 		cur_trans->num_writers++;
 		cur_trans->num_joined++;
 	}
-- 
1.6.1.3
