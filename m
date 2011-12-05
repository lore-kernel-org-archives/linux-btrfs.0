From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Mon, 05 Dec 2011 16:10:49 +0800
Message-ID: <4EDC7C89.6050803@cn.fujitsu.com>
References: <20111201153955.GL5587@shiny>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111201153955.GL5587@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris and Oliva

On thu, 1 Dec 2011 10:39:55 -0500, Chris Mason wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> Has our current set of fixes.  This is fairly small, Alexandre Oliva has
> been chasing problems in our block allocator and kicked out important
> fixes.
> 
> Jan Schmidt fixed a merge error in the raid repair code, we're now
> properly repairing failed blocks (io errors or crc errors) without
> having to run a scrub.
> 
> Alexandre Oliva (5) commits (+8/-8):
>     Btrfs: skip block groups without enough space for a cluster (+1/-1)

This patch introduce a bug that we can not allocate blocks from the cluster
with enough space and it may make the block allocation fail.

This is because the check that the above patch introduced make the allocator
skip the cluster allocation, and jump to the uncluster allocation without
reclaiming all the blocks in the cluster, At this time, if all the free space
is in the cluster, and no space in the block group, the allocation will fail.
(we can trigger this bug on SSD.)

Fortunately, the following patch written by Oliva can fix this bug.

[PATCH 08/20] Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE

Thanks
Miao

>     Btrfs: start search for new cluster at the beginning (+2/-4)
>     Btrfs: reset cluster's max_size when creating bitmap (+1/-0)
>     Btrfs: skip allocation attempt from empty cluster (+3/-3)
>     Btrfs: initialize new bitmaps' list (+1/-0)
> 
> Li Zefan (1) commits (+3/-3):
>     Btrfs: fix oops when calling statfs on readonly device
> 
> Arnd Hannemann (1) commits (+2/-2):
>     Fix URL of btrfs-progs git repository in docs
> 
> Jan Schmidt (1) commits (+20/-7):
>     Btrfs: fix meta data raid-repair merge problem
> 
> Dan Carpenter (1) commits (+5/-0):
>     btrfs scrub: handle -ENOMEM from init_ipath()
> 
> Mike Fleetwood (1) commits (+1/-1):
>     Btrfs: Don't error on resizing FS to same size
> 
> Miao Xie (1) commits (+22/-5):
>     Btrfs: fix deadlock on metadata reservation when evicting a inode
> 
> Total: (11) commits (+60/-25)
> 
>  Documentation/filesystems/btrfs.txt |    4 ++--
>  fs/btrfs/ctree.h                    |    3 +++
>  fs/btrfs/extent-tree.c              |   34 +++++++++++++++++++++++-----------
>  fs/btrfs/extent_io.c                |   27 ++++++++++++++++++++-------
>  fs/btrfs/free-space-cache.c         |    2 ++
>  fs/btrfs/inode.c                    |    2 +-
>  fs/btrfs/ioctl.c                    |    2 +-
>  fs/btrfs/scrub.c                    |    5 +++++
>  fs/btrfs/super.c                    |    6 +++---
>  9 files changed, 60 insertions(+), 25 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

