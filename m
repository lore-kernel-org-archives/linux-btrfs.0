Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60040 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932584AbbGJTPs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 15:15:48 -0400
Date: Fri, 10 Jul 2015 15:15:42 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150710191542.GB10320@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.2

This is an assortment of fixes.  Most of the commits are from Filipe
(fsync, the inode allocation cache and a few others).  Mark kicked in a
series fixing corners in the extent sharing ioctls, and everyone else
fixed up on assorted other problems.

Filipe Manana (9) commits (+375/-36):
    Btrfs: fix race between caching kthread and returning inode to inode cache (+11/-4)
    Btrfs: fix memory corruption on failure to submit bio for direct IO (+52/-18)
    Btrfs: fix crash on close_ctree() if cleaner starts new transaction (+29/-0)
    Btrfs: fix fsync after truncate when no_holes feature is enabled (+108/-0)
    Btrfs: fix race between balance and unused block group deletion (+58/-6)
    Btrfs: fix a comment in inode.c:evict_inode_truncate_pages() (+3/-2)
    Btrfs: use kmem_cache_free when freeing entry in inode cache (+1/-1)
    Btrfs: fix fsync xattr loss in the fast fsync path (+104/-0)
    Btrfs: fix fsync data loss after append write (+9/-5)

Mark Fasheh (4) commits (+193/-58):
    btrfs: fix deadlock with extent-same and readpage (+117/-31)
    btrfs: don't update mtime/ctime on deduped inodes (+14/-10)
    btrfs: pass unaligned length to btrfs_cmp_data() (+2/-1)
    btrfs: allow dedupe of same inode (+60/-16)

Liu Bo (2) commits (+15/-6):
    Btrfs: fix hang when failing to submit bio of directIO (+0/-3)
    Btrfs: fix warning of bytes_may_use (+15/-3)

Zhao Lei (2) commits (+21/-20):
    btrfs: cleanup noused initialization of dev in btrfs_end_bio() (+1/-1)
    btrfs: add error handling for scrub_workers_get() (+20/-19)

Yang Dongsheng (1) commits (+41/-8):
    btrfs: qgroup: allow user to clear the limitation on qgroup

Shilong Wang (1) commits (+1/-1):
    Btrfs: fix wrong check for btrfs_force_chunk_alloc()

Total: (19) commits (+646/-129)

 fs/btrfs/btrfs_inode.h  |   2 +
 fs/btrfs/ctree.h        |   1 +
 fs/btrfs/disk-io.c      |  41 +++++++-
 fs/btrfs/extent-tree.c  |   3 +
 fs/btrfs/inode-map.c    |  17 +++-
 fs/btrfs/inode.c        |  89 ++++++++++++------
 fs/btrfs/ioctl.c        | 241 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.c |   5 +
 fs/btrfs/qgroup.c       |  49 ++++++++--
 fs/btrfs/relocation.c   |   2 +-
 fs/btrfs/scrub.c        |  39 ++++----
 fs/btrfs/tree-log.c     | 226 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c      |  50 ++++++++--
 13 files changed, 641 insertions(+), 124 deletions(-)
