From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 2/4] Btrfs: add MS_RDONLY to avoid backgroud writeback
Date: Thu, 25 Nov 2010 17:54:32 +0800
Message-ID: <4CEE3258.2090302@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

When the filesystem is readonly, commit transaction is forbiddened.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1fffbc0..45c76b9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1188,6 +1188,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	unsigned long now = get_seconds();
 	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
 
+	/*
+	 * Since some error may force btrfs readonly, this can
+	 * avoid backgroud writeback.
+	 */
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return 0;
+
 	btrfs_run_ordered_operations(root, 0);
 
 	/* make a pass through all the delayed refs we have so far
-- 
1.7.0.1
