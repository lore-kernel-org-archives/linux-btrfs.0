Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48517 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932495AbcA2SmM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 13:42:12 -0500
Date: Fri, 29 Jan 2016 13:42:07 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160129184207.ys5ag4nj6s5yk7xb@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have some fixes queued up in my for-linus-4.5 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.5

Dave had a small collection of fixes to the new free space tree code,
one of which was keeping our sysfs files more up to date with feature
bits as different things get enabled (lzo, raid5/6, etc).

I should have kept the sysfs stuff for rc3, since we always manage to
trip over something.  This time it was GFP_KERNEL from somewhere that is
NOFS only. Instead of rebasing it out I've put a revert in, and we'll
fix it properly for rc3.

Otherwise, Filipe fixed a btrfs DIO race and Qu Wenruo fixed up a
use-after-free in our tracepoints that Dave Jones reported.

David Sterba (10) commits (+90/-20):
    btrfs: sysfs: check initialization state before updating features (+3/-0)
    btrfs: sysfs: introduce helper for syncing bits with sysfs files (+33/-0)
    btrfs: synchronize incompat feature bits with sysfs files (+17/-0)
    btrfs: sysfs: fix typo in compat_ro attribute definition (+1/-1)
    Revert "btrfs: clear PF_NOFREEZE in cleaner_kthread()" (+0/-1)
    btrfs: add free space tree to the cow-only list (+2/-1)
    btrfs: tweak free space tree bitmap allocation (+16/-2)
    btrfs: sysfs: add free-space-tree bit attribute (+2/-0)
    btrfs: add free space tree to lockdep classes (+1/-0)
    btrfs: tests: switch to GFP_KERNEL (+15/-15)

Chris Mason (2) commits (+1/-18):
    Revert "btrfs: synchronize incompat feature bits with sysfs files" (+0/-17)
    btrfs: don't use GFP_HIGHMEM for free-space-tree bitmap kzalloc (+1/-1)

Filipe Manana (1) commits (+39/-11):
    Btrfs: fix race between fsync and lockless direct IO writes

Qu Wenruo (1) commits (+1/-1):
    btrfs: async-thread: Fix a use-after-free error for trace

Total: (14) commits (+131/-50)

 fs/btrfs/async-thread.c          |  2 +-
 fs/btrfs/disk-io.c               |  2 +-
 fs/btrfs/free-space-tree.c       | 18 ++++++++++++++++--
 fs/btrfs/inode.c                 | 36 ++++++++++++++++++++++++++++--------
 fs/btrfs/relocation.c            |  3 ++-
 fs/btrfs/sysfs.c                 | 35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h                 |  5 ++++-
 fs/btrfs/tests/btrfs-tests.c     | 10 +++++-----
 fs/btrfs/tests/extent-io-tests.c | 12 ++++++------
 fs/btrfs/tests/inode-tests.c     |  8 ++++----
 fs/btrfs/tree-log.c              | 14 +++++++++++---
 11 files changed, 113 insertions(+), 32 deletions(-)
