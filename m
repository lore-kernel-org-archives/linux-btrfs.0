Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45923 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753441AbdFLQYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 12:24:10 -0400
Date: Mon, 12 Jun 2017 18:22:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs: flush error also accounts for its send error
Message-ID: <20170612162254.GS25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170609065229.8188-1-anand.jain@oracle.com>
 <20170609065229.8188-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170609065229.8188-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 02:52:29PM +0800, Anand Jain wrote:
> So remove the static check of send error

Please improve the changelog text.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d8151839bb3d..682c494dbc7f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3534,14 +3534,11 @@ static int wait_dev_flush(struct btrfs_device *device)
>  
>  static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
>  {
> -	int submit_flush_error = 0;
>  	int dev_flush_error = 0;
>  	struct btrfs_device *dev;
> -	int tolerance;
>  
>  	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
>  		if (!dev->bdev) {
> -			submit_flush_error++;
>  			dev_flush_error++;
>  			continue;
>  		}
> @@ -3549,8 +3546,8 @@ static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
>  			dev_flush_error++;
>  	}
>  
> -	tolerance = fsdevs->fs_info->num_tolerated_disk_barrier_failures;
> -	if (submit_flush_error > tolerance || dev_flush_error > tolerance)
> +	if (dev_flush_error >
> +		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
>  		return -EIO;
>  
>  	return 0;
> @@ -3564,7 +3561,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int errors_send = 0;
>  	int errors_wait = 0;
>  	int ret;
>  
> @@ -3573,10 +3569,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  	list_for_each_entry_rcu(dev, head, dev_list) {
>  		if (dev->missing)
>  			continue;
> -		if (!dev->bdev) {
> -			errors_send++;
> +		if (!dev->bdev)
>  			continue;
> -		}
> +
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
>  
> @@ -3602,7 +3597,11 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  		}
>  	}
>  
> -	if (errors_send || errors_wait) {
> +	/*
> +	 * By checking errors_wait here it avoids traverse through
> +	 * the device loop for normal healthy case
> +	 */

I think the code makes it obvious that we skip the barrier check, the
comment does not bring any new information, please drop it.

> +	if (errors_wait) {
>  		/*
>  		 * At some point we need the status of all disks
>  		 * to arrive at the volume status. So error checking
