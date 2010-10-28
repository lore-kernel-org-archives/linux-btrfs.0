From: Josef Bacik <josef@redhat.com>
Subject: [GIT PULL] space cache and mixed block groups
Date: Thu, 28 Oct 2010 17:06:31 -0400
Message-ID: <20101028210631.GB11684@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here is part 2 of my outstanding patches, they are in 

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git for-chris

and have just the disk space caching stuff and the mixed block groups patches.
It should apply cleanly onto the bug-fixes branch.  I would have combined them
but I screwed up my tree again somehow.  Below is the shortlog and diffstat,
thanks


Josef Bacik (7):
      Btrfs: create special free space cache inode
      Btrfs: write out free space cache
      Btrfs: load free space cache if it exists
      Btrfs: check cache->caching_ctl before returning if caching has started
      Btrfs: add support for mixed data+metadata block groups
      Btrfs: Add a clear_cache mount option
      Btrfs: let the user know space caching is enabled

 fs/btrfs/ctree.h            |   86 +++++-
 fs/btrfs/disk-io.c          |   20 +-
 fs/btrfs/extent-tree.c      |  361 ++++++++++++++++++++-
 fs/btrfs/free-space-cache.c |  750 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |   18 +
 fs/btrfs/inode.c            |  155 ++++++++--
 fs/btrfs/relocation.c       |   91 +++++-
 fs/btrfs/super.c            |   11 +-
 fs/btrfs/transaction.c      |   43 ++-
 fs/btrfs/transaction.h      |    4 +
 10 files changed, 1473 insertions(+), 66 deletions(-)

Josef
