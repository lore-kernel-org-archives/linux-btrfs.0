Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19961 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbbIYRfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:35:42 -0400
Date: Fri, 25 Sep 2015 13:35:37 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150925173537.GG25218@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.3 branch has a few fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3

This is an assorted set I've been queuing up:

Jeff Mahoney tracked down a tricky one where we ended up starting IO on
the wrong mapping for special files in btrfs_evict_inode.  A few people
reported this one on the list.

Filipe found (and provided a test for) a difficult bug in reading
compressed extents, and Josef fixed up some quota record keeping with
snapshot deletion.  Chandan killed off an accounting bug during DIO that
lead to WARN_ONs as we freed inodes.

Filipe Manana (3) commits (+58/-16):
    Btrfs: remove unnecessary locking of cleaner_mutex to avoid deadlock (+0/-4)
    Btrfs: don't initialize a space info as full to prevent ENOSPC (+1/-4)
    Btrfs: fix read corruption of compressed and shared extents (+57/-8)

Josef Bacik (1) commits (+37/-2):
    Btrfs: keep dropped roots in cache until transaction commit

Jeff Mahoney (1) commits (+2/-1):
    btrfs: skip waiting on ordered range for special files

chandan (1) commits (+21/-23):
    Btrfs: Direct I/O: Fix space accounting

Total: (6) commits (+118/-42)

 fs/btrfs/btrfs_inode.h |  2 --
 fs/btrfs/disk-io.c     |  2 --
 fs/btrfs/extent-tree.c |  7 ++----
 fs/btrfs/extent_io.c   | 65 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/inode.c       | 45 +++++++++++++++++-----------------
 fs/btrfs/super.c       |  2 --
 fs/btrfs/transaction.c | 32 +++++++++++++++++++++++++
 fs/btrfs/transaction.h |  5 +++-
 8 files changed, 118 insertions(+), 42 deletions(-)
