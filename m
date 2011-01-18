From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Tue, 18 Jan 2011 11:14:36 +0100
Message-ID: <20110118101436.GA2652@scooter>
References: <1295298216-sup-6206@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295298216-sup-6206@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just slap me if the question is stupid, but when will all those new features be added
to the btrfs-progs?

The last commit is at 
"git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git"
is from oct. 2010?!?


Regards,
Felix


On 17. January 2011 - 16:13, Chris Mason wrote:
> Date:	Mon, 17 Jan 2011 16:13:01 -0500
> From: Chris Mason <chris.mason@oracle.com>
> To: Linus Torvalds <torvalds@linux-foundation.org>, Linux Btrfs
>  <linux-btrfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
> Subject: [GIT PULL] Btrfs updates
> 
> Hi everyone,
> 
> The for-linus branch of the btrfs-unstable git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus
> 
> Has our collection of features and fixes for 2.6.38-rc1.  The git tree
> is actually against 2.6.36 and these commits have been tested against
> .36, .37 and Linus' current git.  There's no particular reason for the
> .36 part, other than it's what one of my build boxes was running.
> 
> The highlights this time around are LZO compression from Li Zefan and a
> large collection of multi-device fixes from Miao Xie.  Liubo kicked in
> the start of our forced-readonly support, which will be the building
> block for ripping out a big collection of BUG_ONs and replacing them
> with kinder gentler error messages.
> 
> Li Zefan also added readonly snapshot support, and I'll have the
> corresponding btrfs-progs changes integrated this week.
> 
> This pull does have a duplicate for the btrfs ctree.c build fix that
> Linus already has in his tree.  Git merge seems to do magic on this one,
> it applies without doing a duplicate #include.
> 
> Li Zefan (9) commits (+1354/-542):
>     Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS ioctls (+85/-0)
>     btrfs: Allow to specify compress method when defrag (+26/-2)
>     btrfs: Allow to add new compression algorithm (+473/-282)
>     btrfs: Extract duplicate decompress code (+115/-194)
>     Btrfs: Refactor btrfs_ioctl_snap_create() (+40/-44)
>     Btrfs: Add readonly snapshots support (+75/-10)
>     btrfs: Add lzo compression support (+527/-8)
>     btrfs: Fix error handling in zlib (+8/-0)
>     btrfs: Fix bugs in zlib workspace (+5/-2)
> 
> Miao Xie (6) commits (+695/-186):
>     btrfs: make the chunk allocator utilize the devices better (+300/-103)
>     btrfs: try to reclaim some space when chunk allocation fails (+7/-2)
>     btrfs: fix wrong free space information of btrfs (+286/-7)
>     btrfs: restructure find_free_dev_extent() (+91/-68)
>     btrfs: fix wrong calculation of stripe size (+8/-2)
>     btrfs: fix wrong data space statistics (+3/-4)
> 
> Jesper Juhl (2) commits (+5/-1):
>     btrfs: Don't pass NULL ptr to func that may deref it. (+2/-0)
>     btrfs: Mem leak in btrfs_get_acl() (+3/-1)
> 
> Tsutomu Itoh (2) commits (+17/-0):
>     btrfs: Fix memory leak in btrfs_read_fs_root_no_radix() (+1/-0)
>     btrfs: check NULL or not (+16/-0)
> 
> Stefan Schmidt (1) commits (+1/-0):
>     fs/btrfs: Fix build of ctree
> 
> Ben Hutchings (1) commits (+4/-0):
>     btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
> 
> Chris Mason (1) commits (+2/-1):
>     Btrfs: fix off by one while setting block groups readonly
> 
> Dave Young (1) commits (+8/-4):
>     btrfs: mount failure return value fix
> 
> liubo (1) commits (+523/-2):
>     Btrfs: forced readonly mounts on errors
> 
> Josef Bacik (1) commits (+0/-5):
>     Btrfs: don't warn if we get ENOSPC in btrfs_block_rsv_check
> 
> Total: (25) commits (+2609/-741)
> 
>  fs/btrfs/Kconfig        |    2 +
>  fs/btrfs/Makefile       |    2 +-
>  fs/btrfs/acl.c          |    4 +-
>  fs/btrfs/btrfs_inode.h  |    2 +-
>  fs/btrfs/compression.c  |  329 ++++++++++++++++++++++++-
>  fs/btrfs/compression.h  |   72 ++++--
>  fs/btrfs/ctree.c        |    8 +
>  fs/btrfs/ctree.h        |   49 ++++-
>  fs/btrfs/disk-io.c      |  412 ++++++++++++++++++++++++++++++-
>  fs/btrfs/disk-io.h      |    1 +
>  fs/btrfs/extent-tree.c  |   90 ++++++-
>  fs/btrfs/extent_io.c    |    7 +-
>  fs/btrfs/extent_io.h    |   17 ++-
>  fs/btrfs/extent_map.c   |    2 +
>  fs/btrfs/extent_map.h   |    3 +-
>  fs/btrfs/file.c         |   13 +
>  fs/btrfs/inode.c        |   90 +++++---
>  fs/btrfs/ioctl.c        |  220 +++++++++++++----
>  fs/btrfs/ioctl.h        |   12 +-
>  fs/btrfs/lzo.c          |  420 +++++++++++++++++++++++++++++++
>  fs/btrfs/ordered-data.c |   18 ++-
>  fs/btrfs/ordered-data.h |    8 +-
>  fs/btrfs/super.c        |  281 ++++++++++++++++++++--
>  fs/btrfs/transaction.c  |   11 +
>  fs/btrfs/transaction.h  |    1 +
>  fs/btrfs/volumes.c      |  626 ++++++++++++++++++++++++++++++++++-------------
>  fs/btrfs/volumes.h      |   27 ++
>  fs/btrfs/xattr.c        |   18 ++
>  fs/btrfs/zlib.c         |  369 ++++++----------------------
>  29 files changed, 2491 insertions(+), 623 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
