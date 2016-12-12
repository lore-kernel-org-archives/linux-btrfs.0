Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750910AbcLLOyw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 09:54:52 -0500
Date: Mon, 12 Dec 2016 15:54:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Maxim Patlasov <mpatlasov@virtuozzo.com>
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: limit async_work allocation and worker func
 duration
Message-ID: <20161212145443.GT12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <148072986343.13061.16191252239168261528.stgit@maxim-thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <148072986343.13061.16191252239168261528.stgit@maxim-thinkpad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 02, 2016 at 05:51:36PM -0800, Maxim Patlasov wrote:
> Problem statement: unprivileged user who has read-write access to more than
> one btrfs subvolume may easily consume all kernel memory (eventually
> triggering oom-killer).
> 
> Reproducer (./mkrmdir below essentially loops over mkdir/rmdir):
> 
> [root@kteam1 ~]# cat prep.sh
> 
> DEV=/dev/sdb
> mkfs.btrfs -f $DEV
> mount $DEV /mnt
> for i in `seq 1 16`
> do
> 	mkdir /mnt/$i
> 	btrfs subvolume create /mnt/SV_$i
> 	ID=`btrfs subvolume list /mnt |grep "SV_$i$" |cut -d ' ' -f 2`
> 	mount -t btrfs -o subvolid=$ID $DEV /mnt/$i
> 	chmod a+rwx /mnt/$i
> done
> 
> [root@kteam1 ~]# sh prep.sh
> 
> [maxim@kteam1 ~]$ for i in `seq 1 16`; do ./mkrmdir /mnt/$i 2000 2000 & done
> 
> [root@kteam1 ~]# for i in `seq 1 4`; do grep "kmalloc-128" /proc/slabinfo | grep -v dma; sleep 60; done
> kmalloc-128        10144  10144    128   32    1 : tunables    0    0    0 : slabdata    317    317      0
> kmalloc-128       9992352 9992352    128   32    1 : tunables    0    0    0 : slabdata 312261 312261      0
> kmalloc-128       24226752 24226752    128   32    1 : tunables    0    0    0 : slabdata 757086 757086      0
> kmalloc-128       42754240 42754240    128   32    1 : tunables    0    0    0 : slabdata 1336070 1336070      0
> 
> The huge numbers above come from insane number of async_work-s allocated
> and queued by btrfs_wq_run_delayed_node.
> 
> The problem is caused by btrfs_wq_run_delayed_node() queuing more and more
> works if the number of delayed items is above BTRFS_DELAYED_BACKGROUND. The
> worker func (btrfs_async_run_delayed_root) processes at least
> BTRFS_DELAYED_BATCH items (if they are present in the list). So, the machinery
> works as expected while the list is almost empty. As soon as it is getting
> bigger, worker func starts to process more than one item at a time, it takes
> longer, and the chances to have async_works queued more than needed is getting
> higher.
> 
> The problem above is worsened by another flaw of delayed-inode implementation:
> if async_work was queued in a throttling branch (number of items >=
> BTRFS_DELAYED_WRITEBACK), corresponding worker func won't quit until
> the number of items < BTRFS_DELAYED_BACKGROUND / 2. So, it is possible that
> the func occupies CPU infinitely (up to 30sec in my experiments): while the
> func is trying to drain the list, the user activity may add more and more
> items to the list.

Nice analysis!

> The patch fixes both problems in straightforward way: refuse queuing too
> many works in btrfs_wq_run_delayed_node and bail out of worker func if
> at least BTRFS_DELAYED_WRITEBACK items are processed.
> 
> Signed-off-by: Maxim Patlasov <mpatlasov@virtuozzo.com>
> ---
>  fs/btrfs/async-thread.c  |    8 ++++++++
>  fs/btrfs/async-thread.h  |    1 +
>  fs/btrfs/delayed-inode.c |    6 ++++--
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index e0f071f..29f6252 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -86,6 +86,14 @@ btrfs_work_owner(struct btrfs_work *work)
>  	return work->wq->fs_info;
>  }
>  
> +bool btrfs_workqueue_normal_congested(struct btrfs_workqueue *wq)
> +{
> +	int thresh = wq->normal->thresh != NO_THRESHOLD ?
> +		wq->normal->thresh : num_possible_cpus();

Why not num_online_cpus? I vaguely remember we should be checking online
cpus, but don't have the mails for reference. We use it elsewhere for
spreading the work over cpus, but it's still not bullet proof regarding
cpu onlining/offlining.

Otherwise looks good to me, as far as I can imagine the possible
behaviour of the various async parameters just from reading the code.
