Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48124 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753278AbbHFOlS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 10:41:18 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t76EdHTh021421
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 22:39:17 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Add WARN_ON() for double lock in btrfs_tree_lock()
Date: Thu, 6 Aug 2015 22:39:36 +0800
Message-ID: <68cb57b7e339dd1270037d8f6694a5dccf340688.1438871972.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a task trying to double lock a extent buffer, there are no
lockdep warning about it because this lock may be in "blocking_lock"
state, and make us hard to debug.

This patch add a WARN_ON() for above condition, it can not report
all deadlock cases(as lock between tasks), but at least helps us
some.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/locking.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index f8229ef..d7e6baf 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -241,6 +241,7 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  */
 void btrfs_tree_lock(struct extent_buffer *eb)
 {
+	WARN_ON(eb->lock_owner == current->pid);
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
 	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
-- 
1.8.5.1

