Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:43397 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab2EWOcy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 10:32:54 -0400
Date: Wed, 23 May 2012 16:32:52 +0200
From: David Sterba <dave@jikos.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] Btrfs: add ioctl to get and reset the device stats
Message-ID: <20120523143252.GO24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <cover.1337682115.git.sbehrens@giantdisaster.de>
 <184b49b6254fcc638e365a98d204ff6284d2963b.1337682115.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <184b49b6254fcc638e365a98d204ff6284d2963b.1337682115.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2012 at 12:53:48PM +0200, Stefan Behrens wrote:
> An ioctl interface is added to get the device statistic counters.
> A second ioctl is added to atomically get and reset these counters.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/ioctl.c   |   26 ++++++++++++++++++++
>  fs/btrfs/ioctl.h   |   28 +++++++++++++++++++++
>  fs/btrfs/volumes.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h |   13 ++++++++++
>  4 files changed, 136 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 14f8e1f..19d2244 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3424,6 +3446,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_balance_ctl(root, arg);
>  	case BTRFS_IOC_BALANCE_PROGRESS:
>  		return btrfs_ioctl_balance_progress(root, argp);
> +	case BTRFS_IOC_GET_DEVICE_STATS:
> +		return btrfs_ioctl_get_device_stats(root, argp, 0);
> +	case BTRFS_IOC_GET_AND_RESET_DEVICE_STATS:
> +		return btrfs_ioctl_get_device_stats(root, argp, 1);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 086e6bd..f1c1196 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -266,6 +266,30 @@ struct btrfs_ioctl_logical_ino_args {
>  	__u64				inodes;
>  };
>  
> +#define BTRFS_IOCTL_GET_DEVICE_STATS_MAX_NR_ITEMS	5

The check at the end of btrfs_get_device_stats() should use this number:

> +       if (stats->nr_items > 5)
> +               stats->nr_items = 5;
> +       return 0;
> +}


> +struct btrfs_ioctl_get_device_stats {
> +	__u64 devid;				/* in */
> +	__u64 nr_items;				/* in/out */
> +
> +	/* out values: */
> +
> +	/* disk I/O failure stats */
> +	__u64 cnt_write_io_errs; /* EIO or EREMOTEIO from lower layers */
> +	__u64 cnt_read_io_errs; /* EIO or EREMOTEIO from lower layers */
> +	__u64 cnt_flush_io_errs; /* EIO or EREMOTEIO from lower layers */
> +
> +	/* stats for indirect indications for I/O failures */
> +	__u64 cnt_corruption_errs; /* checksum error, bytenr error or
> +				    * contents is illegal: this is an
> +				    * indication that the block was damaged
> +				    * during read or write, or written to
> +				    * wrong location or read from wrong
> +				    * location */
> +	__u64 cnt_generation_errs; /* an indication that blocks have not
> +				    * been written */
> +	__u64 unused[121]; /* pad to 1k */
> +};

Padding has landed, and thanks for the explanation in the V3, I see how
the compatibility works.

> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -330,5 +354,9 @@ struct btrfs_ioctl_logical_ino_args {
>  					struct btrfs_ioctl_ino_path_args)
>  #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
>  					struct btrfs_ioctl_ino_path_args)
> +#define BTRFS_IOC_GET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
> +					 struct btrfs_ioctl_get_device_stats)
> +#define BTRFS_IOC_GET_AND_RESET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
> +					 struct btrfs_ioctl_get_device_stats)

I think that 'reset device' should go into the structure, besides the
ioctl number there is no difference.

Then the permission check will look like:

> @@ -3042,6 +3042,28 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
>  	return ret;
>  }
>  
> +static long btrfs_ioctl_get_device_stats(struct btrfs_root *root,
> +					 void __user *arg, int reset_after_read)

					 void __user *arg)

> +{
> +	struct btrfs_ioctl_get_device_stats *sa;
> +	int ret;
> +
> +	sa = memdup_user(arg, sizeof(*sa));
> +	if (IS_ERR(sa))
> +		return PTR_ERR(sa);
> +
> +	if (reset_after_read && !capable(CAP_SYS_ADMIN))

	if (sa->reset_after_read && !capable(CAP_SYS_ADMIN)) {
		kfree(sa);

> +		return -EPERM;

	}
> +
> +	ret = btrfs_get_device_stats(root, sa, reset_after_read);
> +
> +	if (copy_to_user(arg, sa, sizeof(*sa)))
> +		ret = -EFAULT;
> +
> +	kfree(sa);
> +	return ret;
> +}

So the EINVAL could come earlier than EPERM, but I don't think it's a
problem.


david
