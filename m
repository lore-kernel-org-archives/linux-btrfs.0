Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60135 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934158AbeCHH2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 02:28:42 -0500
Subject: Re: [PATCH] Improve error stats message
To: Diego <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
References: <1588327.cr4xlG2VNd@archlinux>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <00d811d6-d309-d10e-91d2-bdad5a8ad0e3@suse.com>
Date: Thu, 8 Mar 2018 09:28:39 +0200
MIME-Version: 1.0
In-Reply-To: <1588327.cr4xlG2VNd@archlinux>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.03.2018 19:37, Diego wrote:
> A typical notification of filesystem errors looks like this:
> 
> BTRFS error (device sda2): bdev /dev/sda2 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> 
> The device name is being printed twice. Also, these abbreviatures
> feel unnecesary. Make the message look like this instead:
> 
> BTRFS error (device sda2): errors: write 0, read 1, flush 0, corrupt 0, generation 0
> 
> 
> Signed-off-by: Diego Calleja <diegocg@gmail.com>
> ---
>  fs/btrfs/volumes.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2ceb924ca0d6..52fee5bb056f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7238,9 +7238,8 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
>  {
>  	if (!dev->dev_stats_valid)
>  		return;
> -	btrfs_err_rl_in_rcu(dev->fs_info,
> -		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
> -			   rcu_str_deref(dev->name),
> +	btrfs_err_rl(dev->fs_info,
> +		"errors: write %u, read %u, flush %u, corrupt %u, generation %u",
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),

I think what would be better is to expose the btrfs_dev_name functino in
a header file and instead of open-coding rcu_str_deref use that function
instead. Also I agree that write/read/ are better than wr/rd.

> 
