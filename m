Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaANReU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 12:34:20 -0500
Date: Tue, 14 Jan 2014 18:34:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20140114173419.GA6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
 <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 04:12:55PM +0800, Liu Bo wrote:
> --- a/ctree.h
> +++ b/ctree.h
> @@ -470,6 +470,7 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
>  #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
>  #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
> +#define BTRFS_FEATURE_INCOMPAT_DEDUP		(1ULL << 9)

FYI, this incompat bit is taken by Josef's NO_HOLE feature, now heading
to next merge window, so I've used 10 for dedup in integration branch.

> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -430,6 +430,15 @@ struct btrfs_ioctl_get_dev_stats {
>  	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
>  };
>  
> +/* deduplication control ioctl modes */
> +#define BTRFS_DEDUP_CTL_ENABLE 1
> +#define BTRFS_DEDUP_CTL_DISABLE 2
> +#define BTRFS_DEDUP_CTL_SET_BS 3
> +struct btrfs_ioctl_dedup_args {
> +	__u64 cmd;
> +	__u64 bs;

I've spotted that you did not reserve any space for future extensions of
the ioctl, especially the in-band dedup can be quite heavy, I think
we'll want some tunables in the future.

> +};
> +
>  /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
>  #define BTRFS_QUOTA_CTL_ENABLE	1
>  #define BTRFS_QUOTA_CTL_DISABLE	2
