From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v6 2/8] btrfs: Cancel filesystem balance
Date: Mon, 2 May 2011 17:45:31 +0200
Message-ID: <20110502154531.GM12709@twin.jikos.cz>
References: <1304173443-29159-1-git-send-email-hugo@carfax.org.uk>
 <1304173443-29159-3-git-send-email-hugo@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304173443-29159-3-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was thinking about the EINTR or ECANCELED retcode from balance:

CANCELED is returned from ioctl call if a cancel has been already
requested
EINTR is returned from btrfs_balance after all the processing if the
cancel_request is set.

I don't see a reason to have 2 retcodes here, how will this help the
ioctl caller?


david


On Sat, Apr 30, 2011 at 03:23:57PM +0100, Hugo Mills wrote:
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 899ed91..4044ad3 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2497,6 +2497,32 @@ error:
>  	return ret;
>  }
>  
> +/*
> + * Cancel a running balance operation
> + */
> +long btrfs_ioctl_balance_cancel(struct btrfs_fs_info *fs_info)
> +{
> +	int err = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	spin_lock(&fs_info->balance_info_lock);
> +	if (!fs_info->balance_info) {
> +		err = -EINVAL;
> +		goto error;
> +	}
> +	if (fs_info->balance_info->cancel_pending) {
> +		err = -ECANCELED;
                       ^^^^^^^^^

> +		goto error;
> +	}
> +	fs_info->balance_info->cancel_pending = 1;
> +
> +error:
> +	spin_unlock(&fs_info->balance_info_lock);
> +	return err;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8ab70f3..07ff192 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2155,6 +2156,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
>  		       bal_info->completed, bal_info->expected);
>  	}
>  	ret = 0;
> +	if (bal_info->cancel_pending) {
> +		printk(KERN_INFO "btrfs: balance cancelled\n");
> +		ret = -EINTR;
                       ^^^^^

> +	}
>  error:
>  	btrfs_free_path(path);
>  	spin_lock(&dev_root->fs_info->balance_info_lock);
