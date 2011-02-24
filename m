From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: fix return value of setflags ioctl
Date: Thu, 24 Feb 2011 11:33:35 +0100
Message-ID: <20110224103335.GA17108@twin.jikos.cz>
References: <4D662708.2020700@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D662708.2020700@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 24, 2011 at 05:38:16PM +0800, liubo wrote:
> 
> setflags ioctl should return error when any checks fail.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 02d224e..e397da4 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -213,9 +213,11 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	btrfs_end_transaction(trans, root);
>  
>  	mnt_drop_write(file->f_path.mnt);
> +
> +	ret = 0;

Technically speaking, this assignment is not necessary as any non-zero
value is caught above as a BUG_ON, but assigning it to zero definetely
helps readability.

>   out_unlock:
>  	mutex_unlock(&inode->i_mutex);
> -	return 0;
> +	return ret;

Good cacth.

Reviewed-by: David Sterba <dsterba@suse.cz>

>  }
>  
>  static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
> -- 
