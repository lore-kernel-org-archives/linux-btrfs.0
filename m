From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.32-rc
Date: Wed, 11 Nov 2009 16:25:54 -0500
Message-ID: <20091111212554.GA2898@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The master branch of the btrfs-unstable repo has an assortment of fixes
and speedups.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

These are mostly minor fixes, but there is an important fix for using
btrfs and ceph together.  Josef has a block group caching performance
patch that reduces his boot time dramatically, which is the biggest
change in the bunch.

We also now handle enospc with mount -o compress, before this was
actually more likely to fail than uncompressed mounts because mount -o
compress expected to be able to find multi-block contiguous extents on
disk.

I know Linus likes to look for obvious rebases, and I did rebase this
morning before pushing out to drop a small mount option patch that we
don't strictly need for .32.

Chris Mason (1) commits (+2/-2):
    Btrfs: allow more metadata chunk preallocation

Dan Carpenter (1) commits (+1/-1):
    Btrfs: avoid null deref in unpin_extent_cache()

Josef Bacik (7) commits (+180/-45):
    Btrfs: cleanup transaction starting and fix journal_info usage (+13/-6)
    Btrfs: fix panic when trying to destroy a newly allocated (+10/-0)
    Btrfs: fallback on uncompressed io if compressed io fails (+23/-8)
    Btrfs: fix how we set max_size for free space clusters (+1/-1)
    Btrfs: find ideal block group for caching (+86/-23)
    Btrfs: fix some metadata enospc issues (+31/-5)
    Btrfs: fix data allocation hint start (+16/-2)

Li Dongyang (1) commits (+0/-2):
    Btrfs: skip btrfs_release_path in btrfs_update_root and btrfs_del_root

Total: (10) commits

 fs/btrfs/extent-tree.c      |  113 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_map.c       |    2 
 fs/btrfs/free-space-cache.c |    2 
 fs/btrfs/inode.c            |   95 +++++++++++++++++++++++++++++++-----
 fs/btrfs/root-tree.c        |    2 
 fs/btrfs/transaction.c      |   19 +++++--
 6 files changed, 183 insertions(+), 50 deletions(-)

