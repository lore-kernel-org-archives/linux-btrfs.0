Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64226 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3AJMw0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:52:26 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0ACqP6J022177
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 20:52:25 +0800
Message-ID: <50EEB9AF.2010301@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 20:53:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/11] Btrfs: Add ACCESS_ONCE() to transaction->abort accesses
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We may access and update transaction->abort on the different CPUs without lock,
so we need ACCESS_ONCE() wrapper to make sure we can get the new value.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c       | 2 +-
 fs/btrfs/transaction.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f714379..0d88513 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -267,7 +267,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			     function, line, errstr);
 		return;
 	}
-	trans->transaction->aborted = errno;
+	ACCESS_ONCE(trans->transaction->aborted) = errno;
 	__btrfs_std_error(root->fs_info, function, line, errno, NULL);
 }
 /*
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a950d48..ee6cf27 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1468,11 +1468,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 	}
 
-	if (cur_trans->aborted) {
-		ret = cur_trans->aborted;
-		goto cleanup_transaction;
-	}
-
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
 	 */
@@ -1574,6 +1569,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	wait_event(cur_trans->writer_wait,
 		   atomic_read(&cur_trans->num_writers) == 1);
 
+	if (ACCESS_ONCE(cur_trans->aborted)) {
+		ret = cur_trans->aborted;
+		goto cleanup_transaction;
+	}
 	/*
 	 * the reloc mutex makes sure that we stop
 	 * the balancing code from coming in and moving
-- 
1.7.11.7
