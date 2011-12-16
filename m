From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs fixes
Date: Fri, 16 Dec 2011 13:20:40 -0500
Message-ID: <20111216182040.GA25457@shiny>
References: <20111216175344.GW18252@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111216175344.GW18252@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2011 at 12:53:44PM -0500, Chris Mason wrote:
> Hi everyone,
> 
> This pull request is bigger than I wanted it to be, but Josef has
> commits in here for some long running ENOSPC bugs in btrfs.  This is
> a few weeks of tracing our delalloc reservations from Josef, and then
> fixing up the related bugs.
> 
> Outside of Josef's patches we have some assorted fixes.  Arne figured
> out we were orphaning whole snapshots if you unmounted enough times
> while the snapshot was being deleted.

Sorry, this part is missing:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

> 
> Josef Bacik (6) commits (+212/-117):
>     Btrfs: fix how we do delalloc reservations and how we free reservations on error (+44/-13)
>     Btrfs: fix num_workers_starting bug and other bugs in async thread (+83/-78)
>     Btrfs: only set cache_generation if we setup the block group (+1/-1)
>     Btrfs: deal with enospc from dirtying inodes properly (+80/-22)
>     Btrfs: don't panic if orphan item already exists (+1/-1)
>     Btrfs: fix leaked space in truncate (+3/-2)
> 
> Chris Mason (4) commits (+10/-4):
>     Btrfs: fix btrfs_end_bio to deal with write errors to a single mirror (+1/-1)
>     Btrfs: deal with NULL srv_rsv in the delalloc inode reservation code (+2/-2)
>     Btrfs: add a cond_resched() into the worker loop (+1/-1)
>     Btrfs: unplug every once and a while (+6/-0)
> 
> Miao Xie (3) commits (+29/-13):
>     Btrfs: fix wrong i_size when truncating a file to a larger size (+12/-6)
>     Btrfs: fix inaccurate available space on raid0 profile (+13/-6)
>     Btrfs: fix wrong disk space information of the files (+4/-1)
> 
> Casey Schaufler (1) commits (+26/-5):
>     BTRFS: Establish i_ops before calling d_instantiate
> 
> Arne Jansen (1) commits (+32/-0):
>     btrfs: keep orphans for subvolume deletion
> 
> Li Zefan (1) commits (+2/-2):
>     Btrfs: fix ctime update of on-disk inode
> 
> Total: (16) commits (+309/-140)
> 
>  fs/btrfs/async-thread.c  |  117 ++++++++++++++----------------
>  fs/btrfs/async-thread.h  |    4 +-
>  fs/btrfs/ctree.h         |    3 +-
>  fs/btrfs/delayed-inode.c |    4 +-
>  fs/btrfs/disk-io.c       |   34 ++++++----
>  fs/btrfs/extent-tree.c   |   45 ++++++++----
>  fs/btrfs/file.c          |    6 ++-
>  fs/btrfs/inode.c         |  180 +++++++++++++++++++++++++++++++++++++---------
>  fs/btrfs/ioctl.c         |    6 +-
>  fs/btrfs/relocation.c    |    2 +
>  fs/btrfs/scrub.c         |    8 ++-
>  fs/btrfs/super.c         |   32 +++++++--
>  fs/btrfs/volumes.c       |    8 ++-
>  13 files changed, 309 insertions(+), 140 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
