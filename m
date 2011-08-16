From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: reserve sufficient space for ioctl clone
Date: Tue, 16 Aug 2011 10:09:31 +0800
Message-ID: <4E49D15B.8010209@cn.fujitsu.com>
References: <1312911997-5075-1-git-send-email-sage@newdream.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312911997-5075-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 9 Aug 2011 10:46:37 -0700, Sage Weil wrote:
> Fix a crash/BUG_ON in the clone ioctl due to insufficient reservation. We
> need to reserve space for:
> 
>  - adjusting the old extent (possibly splitting it)
>  - adding the new extent
>  - updating the inode
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/ioctl.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a3c4751..f038d4a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2320,7 +2320,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  			else
>  				new_key.offset = destoff;
>  
> -			trans = btrfs_start_transaction(root, 1);
> +			/*
> +			 * 1 - adjusting old extent (we may have to split it)

I don't think it is enough. If we have lots of file extents and their extent items are stored
in many contiguous leaves, the drop operation may cause those leaves to be COWed. So I think we
must calculate the number of leaves which will be COWed at first.

Thanks
Miao

> +			 * 1 - add new extent
> +			 * 1 - inode update
> +			 */
> +			trans = btrfs_start_transaction(root, 3);
>  			if (IS_ERR(trans)) {
>  				ret = PTR_ERR(trans);
>  				goto out;

