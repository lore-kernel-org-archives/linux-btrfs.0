From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: zero-length files in snapshots
Date: Thu, 25 Feb 2010 19:57:49 +0100
Message-ID: <201002251957.50034.kreijack@libero.it>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com> <93cdabd21002131126v4b4d3c1ei2a747a7a5de7b1c8@mail.gmail.com> <Pine.LNX.4.64.1002191355490.21676@cobra.newdream.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org, Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1002191355490.21676@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 19 February 2010, Sage Weil wrote:
[...]
> We could trivially make this happen only when there is a new snapshot, to 
> get the behavior you expect (see patch below).  If the goal is to make a 
> perfectly consistent snapshot of the file system, this is better than
> 
> 	sync ; btrfsctl -s snap whatever
> 
> because there wouldn't be a window where metadata changes make it into the 
> snapshot but file data does not.

I don't have the knowledge to say if your patch is good or not from a 
performance point of view, but to me, the behaviour of your patch seems a 
reasonable defaults.
I may accept that a crash can break a supposed sequence of a writing on the 
disk, so data which should be on the disk never reach the disk. But I can 
reduce the risk of this behaviour with an UPS.
Instead the fact that a snapshot may not taken the last data to me seems an 
un-acceptable behaviour.

Worse, this behaviour may lead to write code like

	do_sync(); do_snapshot();

which is difficult to optimise at the kernel level; instead if we put a sync 
before a snapshot in the core of the btrfs, even tough in the present there is 
performance problem, may have (even in a far future) a possible optimisation..

Regards
Goffredo
> Is there really a use case for the sort of 'lazy' snapshots with 
> out-of-sync data and metadata (like 0-byte files)?  If so, we should add 
> another ioctl for a full-blown snapshot so that users who _do_ want a 
> fully consistent snapshot can get it.
> 
> If not, something like the below should be sufficient to make all 
> snapshots fully consistent...
> 
> sage
> 
> ---
> 
> From: Sage Weil <sage@newdream.net>
> Date: Fri, 19 Feb 2010 14:13:50 -0800
> Subject: [PATCH] Btrfs: flush data on snapshot creation
> 
> Flush any delalloc extents when we create a snapshot, so that recently
> written file data is always included in the snapshot.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/transaction.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index e83d4e1..f5b7029 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1084,13 +1084,10 @@ int btrfs_commit_transaction(struct 
btrfs_trans_handle *trans,
>  
>                 mutex_unlock(&root->fs_info->trans_mutex);
>  
> -               if (flush_on_commit) {
> +               if (flush_on_commit || snap_pending) {
>                         btrfs_start_delalloc_inodes(root, 1);
>                         ret = btrfs_wait_ordered_extents(root, 0, 1);
>                         BUG_ON(ret);
> -               } else if (snap_pending) {
> -                       ret = btrfs_wait_ordered_extents(root, 0, 1);
> -                       BUG_ON(ret);
>                 }
>  
>                 /*
> -- 
> 1.6.6.1
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackAtinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
