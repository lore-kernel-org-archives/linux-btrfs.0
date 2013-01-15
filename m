Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3AOG0n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 01:26:43 -0500
Message-ID: <50F4F6CD.8070402@cn.fujitsu.com>
Date: Tue, 15 Jan 2013 14:27:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: dsterba@suse.cz
Subject: [PATCH V2 11/11] Btrfs: Add ACCESS_ONCE() to transaction->abort accesses
References: <50EEB9AF.2010301@cn.fujitsu.com> <20130110173800.GH20089@twin.jikos.cz>
In-Reply-To: <20130110173800.GH20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We may access and update transaction->aborted on the different CPUs without
lock, so we need ACCESS_ONCE() wrapper to prevent the compiler from creating
unsolicited accesses and make sure we can get the right value.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- modify the changelog
- split the old patch into two patches, this is the first one - just add
  ACCESS_ONCE() wrapper.
---
 fs/btrfs/super.c       | 2 +-
 fs/btrfs/transaction.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

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
index a950d48..7dbfe2c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1468,7 +1468,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 	}
 
-	if (cur_trans->aborted) {
+	/* Stop the commit early if ->aborted is set */
+	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
 		goto cleanup_transaction;
 	}
-- 
1.7.11.7

