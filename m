From: Josef Bacik <josef@redhat.com>
Subject: [GIT PULL] Btrfs updates for -rc1
Date: Wed, 16 Mar 2011 12:14:03 -0400
Message-ID: <20110316161403.GA2510@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git for-chris

It is based on v2.6.38.  Mostly just cleanups and fixes, the biggest actual
change would be moving us to the new truncate sequence.  Here is the shortlog
and such

Josef Bacik (13):
      Btrfs: fix formatting in file.c
      Btrfs: simplify our write path
      Btrfs: fix how we deal with the pages array in the write path
      Btrfs: change reserved_extents to an atomic_t
      Btrfs: use a slab for the free space entries
      Btrfs: convert to the new truncate sequence
      Btrfs: cleanup error handling in the truncate path
      Btrfs: handle errors in btrfs_orphan_cleanup
      Btrfs: make sure to remove the orphan item from the in-memory list
      Btrfs: only add orphan items when truncating
      Btrfs: use mark_inode_dirty when expanding the file
      Btrfs: add a comment explaining what btrfs_cont_expand does
      Btrfs: return error if the range we want to map is bogus

 fs/btrfs/btrfs_inode.h      |    3 +-
 fs/btrfs/ctree.h            |    5 +-
 fs/btrfs/disk-io.c          |   15 ++-
 fs/btrfs/extent-tree.c      |   45 +++--
 fs/btrfs/extent_io.c        |    1 +
 fs/btrfs/file.c             |  385 ++++++++++++++++++++++---------------------
 fs/btrfs/free-space-cache.c |   34 ++--
 fs/btrfs/inode.c            |  241 +++++++++++++++------------
 fs/btrfs/ioctl.c            |    4 +-
 fs/btrfs/relocation.c       |    2 +-
 10 files changed, 399 insertions(+), 336 deletions(-)

Thanks,

Josef
