From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Thu, 2 Jul 2009 15:46:05 -0400
Message-ID: <20090702194605.GB3832@think>
References: <20090702191035.GA3832@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090702191035.GA3832@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 02, 2009 at 03:10:35PM -0400, Chris Mason wrote:
> Hello everyone,
> 
> Here are some btrfs updates.  Most of them are small bug fixes, but the
> large commit from Yan Zheng is step one in getting snapshot deletion
> rolling.  There is also has a nice CPU usage reduction for
> streaming writes to a file.
> 
> Linus, please pull the master branch of btrfs-unstable:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> 

Sorry, I was a two commits off in generating the stats.  The code in the
btrfs-unstable tree hasn't changed, but here are the correct stats:

Chris Mason (3) commits (+15/-9):
    Btrfs: don't log the inode in file_write while growing the file (+4/-1)
    Btrfs: fix the file clone ioctl for preallocated extents (+4/-2)
    Btrfs: honor nodatacow/sum mount options for new files (+7/-6)

Yan Zheng (1) commits (+395/-181):
    Btrfs: update backrefs while dropping snapshot

Josef Bacik (1) commits (+11/-1):
    Btrfs: account for space we may use in fallocate

Jiri Slaby (1) commits (+1/-1):
    Btrfs: fix use after free in btrfs_start_workers fail path

Hu Tao (1) commits (+1/-1):
    Btrfs: fix error message formatting

Total: (7) commits

 fs/btrfs/async-thread.c |    2 
 fs/btrfs/ctree.h        |    3 
 fs/btrfs/extent-tree.c  |  566 +++++++++++++++++++++++++++++++++---------------
 fs/btrfs/file.c         |    5 
 fs/btrfs/inode.c        |   25 +-
 fs/btrfs/ioctl.c        |    6 
 fs/btrfs/relocation.c   |    5 
 fs/btrfs/transaction.c  |    4 
 8 files changed, 423 insertions(+), 193 deletions(-)
