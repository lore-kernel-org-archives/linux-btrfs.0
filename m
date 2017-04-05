Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755421AbdDEOJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 10:09:50 -0400
Date: Wed, 5 Apr 2017 16:09:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: check if the device is flush capable
Message-ID: <20170405140904.GI4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170404104144.9414-1-anand.jain@oracle.com>
 <20170405034834.20503-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170405034834.20503-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 05, 2017 at 11:48:34AM +0800, Anand Jain wrote:
> The blkdev_issue_flush() will check if the write cache is enabled
> before submitting the flush. This will add a code to fail fast if
> its not.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1:
>   This patch will replace
>   [PATCH] btrfs: delete unused member nobarriers
> 
> v2:
>   - This patch will now _not_ replace the below patch and this patch
>   should be applied on top of it.
>     [PATCH] btrfs: delete unused member nobarriers
>   That's because, Q wc flag is not static, so we can't save its
>   state into nobarries.

Now I'm confused what's the last version of the device flush patches,
please, this one is marked as V2 and has the same subject, yet does
something completely different. Please resend the relevant patches in a
series, we might need another round of review afterward.

>   - commit log is updated.
> 
>  fs/btrfs/disk-io.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b6d047250ce2..bb5816c7f5c4 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3517,6 +3517,11 @@ static void btrfs_dev_issue_flush(struct work_struct *work)
>   */
>  static int write_dev_flush(struct btrfs_device *device, int wait)
>  {
> +	struct request_queue *q = bdev_get_queue(device->bdev);
> +
> +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> +		return 0;
> +
>  	if (wait) {
>  		int ret;
>  
> -- 
> 2.10.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
