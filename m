Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41953 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3CQMeq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Mar 2013 08:34:46 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5A6539A0402
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2013 06:34:46 -0600 (MDT)
Date: Sun, 17 Mar 2013 08:34:44 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20130317123444.GA3300@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has some btrfs fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Eric's rcu barrier patch fixes a long standing problem with our unmount
code hanging on to devices in workqueue helpers.  Liu Bo nailed down a
difficult assertion for in-memory extent mappings.

Liu Bo (4) commits (+9/-7):
    Btrfs: get better concurrency for snapshot-aware defrag work (+3/-0)
    Btrfs: fix warning when creating snapshots (+5/-6)
    Btrfs: fix warning of free_extent_map (+1/-0)
    Btrfs: remove btrfs_try_spin_lock (+0/-1)

Josef Bacik (1) commits (+4/-1):
    Btrfs: return EIO if we have extent tree corruption

Eric Sandeen (1) commits (+6/-0):
    btrfs: use rcu_barrier() to wait for bdev puts at unmount

Wang Shilong (1) commits (+6/-4):
    Btrfs: return as soon as possible when edquot happens

Total: (7) commits (+25/-12)

 fs/btrfs/extent-tree.c |  5 ++++-
 fs/btrfs/file.c        |  1 +
 fs/btrfs/inode.c       |  3 +++
 fs/btrfs/locking.h     |  1 -
 fs/btrfs/qgroup.c      | 10 ++++++----
 fs/btrfs/transaction.c | 11 +++++------
 fs/btrfs/volumes.c     |  6 ++++++
 7 files changed, 25 insertions(+), 12 deletions(-)
