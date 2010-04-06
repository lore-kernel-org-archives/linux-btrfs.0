From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Tue, 6 Apr 2010 11:40:47 -0400
Message-ID: <20100406154047.GE5413@think>
References: <20100405193637.GC21620@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100405193637.GC21620@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 05, 2010 at 03:36:37PM -0400, Chris Mason wrote:
> Hello everyone,
> 
> The master branch of the btrfs-unstable repo has a collection of fixes:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> 

That pull request was missing another enospc fix from Josef, and Yan
Zheng noticed we were sometimes trying to allocate zero sized chunks
from the disk pool.  I've updated the git tree with two new commits,
here is the corrected shortlog:

Josef Bacik (5) commits (+47/-96):
    Btrfs: fail to mount if we have problems reading the block groups (+12/-4)
    Btrfs: fix small race with delalloc flushing waitqueue's (+4/-5)
    Btrfs: fix chunk allocate size calculation (+3/-1)
    Btrfs: fix data enospc check overflow (+15/-5)
    Btrfs: kill max_extent mount option (+13/-81)

Zhao Lei (3) commits (+9/-12):
    Btrfs: Simplify num_stripes's calculation logical for __btrfs_alloc_chunk() (+2/-2)
    Btrfs: Add error handle for btrfs_search_slot() in btrfs_read_chunk_tree() (+2/-0)
    Btrfs: Remove unnecessary finish_wait() in wait_current_trans() (+5/-10)

Dan Carpenter (3) commits (+5/-1):
    Btrfs: handle kmalloc() failure in inode lookup ioctl (+3/-0)
    Btrfs: check btrfs_get_extent return for IS_ERR() (+1/-1)
    Btrfs: dereferencing freed memory (+1/-0)

Chris Mason (2) commits (+10/-0):
    Btrfs: make sure the chunk allocator doesn't create zero length chunks (+6/-0)
    Btrfs: add check for changed leaves in setup_leaf_for_split (+4/-0)

Sage Weil (1) commits (+31/-66):
    Btrfs: create snapshot references in same commit as snapshot

Andrea Gelmini (1) commits (+0/-1):
    Btrfs: remove duplicate include in ioctl.c

Miao Xie (1) commits (+4/-1):
    Btrfs: add NULL check for do_walk_down()

Nick Piggin (1) commits (+5/-32):
    Btrfs: use add_to_page_cache_lru, use __page_cache_alloc

Total: (17) commits

 fs/btrfs/transaction.c  |  112 +++++++++++++++---------------------------------
 fs/btrfs/inode.c        |   59 +------------------------
 fs/btrfs/extent-tree.c  |   43 ++++++++++++------
 fs/btrfs/super.c        |   23 +--------
 fs/btrfs/compression.c  |   22 +--------
 fs/btrfs/volumes.c      |   16 +++++-
 fs/btrfs/extent_io.c    |   15 ------
 fs/btrfs/disk-io.c      |   12 +++--
 fs/btrfs/ioctl.c        |    7 ++-
 fs/btrfs/ordered-data.c |    6 +-
 fs/btrfs/ctree.c        |    4 +
 fs/btrfs/ctree.h        |    1 
 12 files changed, 111 insertions(+), 209 deletions(-)
