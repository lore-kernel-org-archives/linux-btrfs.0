Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:38809 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932858AbeFUQE7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:04:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [v2] btrfs: use monotonic time for transaction handling
Date: Thu, 21 Jun 2018 18:04:05 +0200
Message-Id: <20180621160420.139575-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction times were changed to ktime_get_real_seconds to avoid
the y2038 overflow, but they still have a minor problem when they go
backwards or jump due to settimeofday() or leap seconds.

This changes the transaction handling to instead use ktime_get_seconds(),
which returns a CLOCK_MONOTONIC timestamp that has neither of those
problems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: Rebased on top of an earlier patch by Allen Pais, which
    also obsoleted the original patch 2/3
---
 fs/btrfs/disk-io.c     | 2 +-
 fs/btrfs/transaction.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f3224e23d5fa..bf0717f2824d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1819,7 +1819,7 @@ static int transaction_kthread(void *arg)
 			goto sleep;
 		}
 
-		now = ktime_get_real_seconds();
+		now = ktime_get_seconds();
 		if (cur->state < TRANS_STATE_BLOCKED &&
 		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 56c8bab0b816..ebe50dfb8947 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -241,7 +241,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	refcount_set(&cur_trans->use_count, 2);
 	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
-	cur_trans->start_time = ktime_get_real_seconds();
+	cur_trans->start_time = ktime_get_seconds();
 
 	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
 
-- 
2.9.0

