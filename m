From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: remove the improper comment for
 btrfs_ioctl_resize()
Date: Mon, 04 May 2009 11:11:56 -0400
Message-ID: <1241449916.7244.15.camel@think.oraclecorp.com>
References: <3a3680030905032205u2c3490e8r62e66c48aff97fee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com,
	linux-kernel@vger.kernel.org
To: Li Hong <lihong.hi@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a3680030905032205u2c3490e8r62e66c48aff97fee@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-05-04 at 01:05 -0400, Li Hong wrote:
> In Li Zefan's commit dae7b665cf6d6e6e733f1c9c16cf55547dd37e33,
> a combination call of kmalloc() and copy_from_user() is replaced by
> memdup_user(). So btrfs_ioctl_resize() doesn't use GFP_NOFS any more.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> ---
>  fs/btrfs/ioctl.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5e94ea6..2624b53 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -437,10 +437,6 @@ out_unlock:
>  	return 0;
>  }
> 
> -/*
> - * Called inside transaction, so use GFP_NOFS
> - */
> -
>  static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
>  {
>  	u64 new_size;

Thanks, I've queued this one up.

-chris


