Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6079 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751011AbcFRNBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jun 2016 09:01:41 -0400
Date: Sat, 18 Jun 2016 09:01:35 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160618130135.7ncitkqe3aimaodq@floor.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.7 branch has a few fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7

The most user visible change here is a fix for our recent superblock
validation checks that were causing problems on non-4k pagesized
systems.

David Sterba (2) commits (+1/-6):
    btrfs: use new error message helper in qgroup_account_snapshot (+1/-1)
    btrfs: remove build fixup for qgroup_account_snapshot (+0/-5)

Jeff Mahoney (1) commits (+7/-4):
    btrfs: account for non-CoW'd blocks in btrfs_abort_transaction

Liu Bo (1) commits (+28/-15):
    Btrfs: check if extent buffer is aligned to sectorsize

Heinrich Schuchardt (1) commits (+1/-1):
    btrfs: Use correct format specifier

Zygo Blaxell (1) commits (+12/-15):
    btrfs: avoid blocking open_ctree from cleaner_kthread

Josef Bacik (1) commits (+10/-1):
    Btrfs: don't BUG_ON() in btrfs_orphan_add

Chandan Rajendra (1) commits (+2/-1):
    Btrfs: btrfs_check_super_valid: Allow 4096 as stripesize

Total: (8) commits (+61/-43)

 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/ctree.c           |  7 ++++++-
 fs/btrfs/disk-io.c         | 36 ++++++++++++++++--------------------
 fs/btrfs/extent-tree.c     | 12 +++++++-----
 fs/btrfs/extent_io.c       | 15 ++++++++++++---
 fs/btrfs/inode.c           | 11 ++++++++++-
 fs/btrfs/super.c           |  4 +++-
 fs/btrfs/transaction.c     |  7 +------
 fs/btrfs/transaction.h     |  2 +-
 fs/btrfs/tree-log.c        |  4 ++--
 fs/btrfs/volumes.c         |  4 ++--
 11 files changed, 61 insertions(+), 43 deletions(-)
