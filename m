Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:52403 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753202AbeFTOfK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:35:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] btrfs: use monotonic time for transaction handling
Date: Wed, 20 Jun 2018 16:34:32 +0200
Message-Id: <20180620143448.44388-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_seconds() is deprecated because of the overflow of 32-bit times,
and it's not the best choice for measuring time intervals because it
can go backwards or jump due to settimeofday() or leap seconds.

This changes the transaction handling to instead use ktime_get_seconds(),
which returns a CLOCK_MONOTONIC timestamp that has neither of those
problems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/disk-io.c     | 4 ++--
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/transaction.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 205092dc9390..bf0717f2824d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1803,7 +1803,7 @@ static int transaction_kthread(void *arg)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_transaction *cur;
 	u64 transid;
-	unsigned long now;
+	time64_t now;
 	unsigned long delay;
 	bool cannot_commit;
 
@@ -1819,7 +1819,7 @@ static int transaction_kthread(void *arg)
 			goto sleep;
 		}
 
-		now = get_seconds();
+		now = ktime_get_seconds();
 		if (cur->state < TRANS_STATE_BLOCKED &&
 		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ff5f6c719976..ebe50dfb8947 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -241,7 +241,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	refcount_set(&cur_trans->use_count, 2);
 	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
-	cur_trans->start_time = get_seconds();
+	cur_trans->start_time = ktime_get_seconds();
 
 	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 94439482a0ec..4cbb1b55387d 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -48,7 +48,7 @@ struct btrfs_transaction {
 	int aborted;
 	struct list_head list;
 	struct extent_io_tree dirty_pages;
-	unsigned long start_time;
+	time64_t start_time;
 	wait_queue_head_t writer_wait;
 	wait_queue_head_t commit_wait;
 	wait_queue_head_t pending_wait;
-- 
2.9.0

