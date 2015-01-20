Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbbATJHo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 04:07:44 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH RFC v2 0/5] Fix bugs introduced by the new pending changes
Date: Tue, 20 Jan 2015 17:05:32 +0800
Message-ID: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 572d9ab7845ea0e0 ("btrfs: add support for processing pending
changes") introduced several bugs which will eventually cause a
deadlock.

The deadlock can be triggered by fstests/generic/068 with inode_cache
mount option.

The deadlock happens in the following flow:
moutn with inode_cache -> freeze fs -> sync -> unfreeze.

Sync_fs stack:				Thaw_fs stack:
(Holding s_umount)			(Waiting s_umount)
|- btrfs_sync_fs()
   |- start_transaction()
      (Waiting thaw_fs to unfreeze the fs)

The problem has several causes:
1) Cmpxchg in btrfs_apply_pending_changes() doesn't work
Cmpxchg in btrfs_apply_pending_changes() will only clear
fs_info->pending_changes if it is already 0.
So fs_info->pending_changes will never cleared, and every sync_fs() on
frozen btrfs will try to start a new transaction and deadlock.

So patch 1 fixes it by using xchg() other than cmpxchg().

2) btrfs_freeze() doesn't handle and clear pending_changes
If btrfs start a transaction if there are pending changes but no running
transaction, sync should never start a transaction on frozen fs.
(Except the following sysfs case)

So patch 2~3 fixes it by adding pending changes handler in
btrfs_freeze().

3) Changes through sysfs interface can create pending changes without
   waiting for unfreezing.
Since sysfs changes doesn't go through normal open routine,
which will initiate sb_start_*write() and waiting for unfreezing,
changes through sysfs like changing label will set
fs_info->pending_changes to non-zero, and later sync_fs will deadlock
again.

So patch 4~5 reverts the commits relating patches to fix such problem.

Qu Wenruo (5):
  btrfs: Fix the bug that fs_info->pending_changes is never cleared.
  btrfs: Add btrfs_start_transaction_freeze() to start transaction in   
     btrfs_freeze()
  btrfs: Handle pending changes in btrfs_freeze().
  Revert "btrfs: move commit out of sysfs when changing label"
  Revert "btrfs: move commit out of sysfs when changing features"

 fs/btrfs/super.c       | 52 ++++++++++++++++++++++++--------------------------
 fs/btrfs/sysfs.c       | 34 ++++++++++++++++++++-------------
 fs/btrfs/transaction.c | 10 +++++++++-
 fs/btrfs/transaction.h |  2 ++
 4 files changed, 57 insertions(+), 41 deletions(-)

-- 
2.2.2

