From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't call btrfs_throttle in file write
Date: Thu, 12 Jan 2012 18:16:31 -0500
Message-ID: <1326410191-1168-1-git-send-email-josef@redhat.com>
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs_throttle will make us wait if there is a currently committing transaction
until we can open new transactions, which is ridiculous since we don't actually
start any transactions within the file write path anyway, so all this does is
introduce big latencies if we have a sync/fsync heavy workload going on while
somebody else is trying to do work.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 97fbe93..57c4b24 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1273,7 +1273,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						   dirty_pages);
 		if (dirty_pages < (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
 			btrfs_btree_balance_dirty(root, 1);
-		btrfs_throttle(root);
 
 		pos += copied;
 		num_written += copied;
-- 
1.7.6.4

