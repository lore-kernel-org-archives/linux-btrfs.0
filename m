Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752632AbdKFPgZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:36:25 -0500
Date: Mon, 6 Nov 2017 16:34:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: cleanup btrfs_async_submit_limit to return the
 final limit value
Message-ID: <20171106153432.GK28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031125946.26844-1-anand.jain@oracle.com>
 <20171102060353.7103-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171102060353.7103-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 02, 2017 at 02:03:53PM +0800, Anand Jain wrote:
> We feedback IO progress when it falls below 2/3 times of the limit
> obtained from btrfs_async_submit_limit(), and creates a wait for the
> write process and makes progress during the async submission.
> 
> In general device/transport q depth is 256 and, btrfs_async_submit_limit()
> returns 256 times per device which originally was introduced by [1]. But
> 256 at the device level is for all types of IOs (R/W sync/async) and so
> may be it was possible that entire of 256 could have occupied by async
> writes and, so later patch [2] took only 2/3 times of 256 which seemed to
> work well.
> 
>  [1]
>  cb03c743c648
>  Btrfs: Change the congestion functions to meter the number of async submits as well
> 
>  [2]
>  4854ddd0ed0a
>  Btrfs: Wait for kernel threads to make progress during async submission
> 
> This patch is a cleanup patch, no functional changes. And now as we are taking
> only 2/3 of limit (256), so btrfs_async_submit_limit() will return 170 itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> IMO:
> 1. If the pdflush issue is fixed, we should go back to bdi congestion method,
> as block layer is more appropriate and accurate to tell when the device is
> congested. Device q depth 256 is very generic.
> 2. Consider RAID1 devices at different speed (SSD and iscsi LUN) not too sure
> if this approach would lead to the FS layer IO performance  throttle at the
> speed of the lowest ? wonder how to reliably test it.
> 
>  fs/btrfs/disk-io.c | 6 ++++--
>  fs/btrfs/volumes.c | 1 -
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index dfdab849037b..12702e292007 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -861,7 +861,10 @@ unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
>  	unsigned long limit = min_t(unsigned long,
>  				    info->thread_pool_size,
>  				    info->fs_devices->open_devices);
> -	return 256 * limit;
> +	/*
> +	 * limit:170 is computed as 2/3 * 256.
> +	 */
> +	return 170 * limit;

Please keep it opencoded, the constant will be calculated by compiler
but for code clarity it's better to be written as 2 / 3 and it's
self-documenting, so you can drop the comment.
