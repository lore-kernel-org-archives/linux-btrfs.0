From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [2.6.38-rc6] create->rebalance->mount crash...
Date: Thu, 24 Feb 2011 09:35:32 -0500
Message-ID: <1298557709-sup-774@think>
References: <AANLkTik-WE+1FYAE6D--fN9GJpThCXwxgejiOsiTk_3k@mail.gmail.com> <4D665396.2040105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D665396.2040105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-02-24 07:48:22 -0500:
> On 02/24/2011 04:13 PM, Daniel J Blueman wrote:
> > When creating a filesystem (single or redundant) with BTRFS and
> > subsequently executing a balance [1], we see a kernel oops at the next
> > mount [2].
> > 
> 
> Hi, Daniel,
> 
> After digging this, I've come up with a patch on this, would you please test
> it on your box?  Hopes that this is helpful, Thanks.
> 
> From: Liu Bo <liubo2009@cn.fujitsu.com>
> 
> [PATCH] btrfs: fix OOPS of empty filesystem after balance
> 
> btrfs will exclude unused block groups via a thread.
> When a empty filesystem is balanced, the block group with tag "DATA" may be dropped,
> and after umount, this will lead to OOPS when we mount it again.

Thanks for tracking this down!  Comment below:

> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 100e409..4749ab0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3856,10 +3856,14 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
>      spin_unlock(&block_rsv->lock);
>  }
>  
> -static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
> +static int init_global_block_rsv(struct btrfs_fs_info *fs_info)
>  {
>      struct btrfs_space_info *space_info;
>  
> +    space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
> +    if (!space_info)
> +        return -EAGAIN;
> +
>      space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
>      fs_info->chunk_block_rsv.space_info = space_info;
>      fs_info->chunk_block_rsv.priority = 10;
> @@ -3884,6 +3888,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
>      btrfs_add_durable_block_rsv(fs_info, &fs_info->delalloc_block_rsv);
>  
>      update_global_block_rsv(fs_info);
> +
> +    return 0;
>  }
>  
>  static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
> @@ -8514,7 +8520,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>              set_block_group_ro(cache);
>      }
>  
> -    init_global_block_rsv(info);
> +again:
> +    ret = init_global_block_rsv(info);
> +    if (ret == -EAGAIN) {
> +        update_space_info(info, BTRFS_BLOCK_GROUP_DATA, 0, 0,
> +                  &space_info);
> +        goto again;
> +    }
>      ret = 0;

Are we looping here because we expect the init_global_block_rsv to fail
more than once?  If so we need a cond_resched or something in there.

But if the EAGAIN is only returned once we should avoid the loop and
open code the call again.

-chris
