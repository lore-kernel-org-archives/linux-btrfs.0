Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50693 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753792AbdEITLM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 15:11:12 -0400
Date: Tue, 9 May 2017 12:09:00 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: Make flush bios explicitely sync
Message-ID: <20170509190900.GD17312@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170502150351.29452-1-jack@suse.cz>
 <20170502150351.29452-7-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502150351.29452-7-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:03:50PM +0200, Jan Kara wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
> definitions.  generic_make_request_checks() however strips REQ_FUA and
> REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
> write cache and thus write effectively becomes asynchronous which can
> lead to performance regressions
> 
> Fix the problem by making sure all bios which are synchronous are
> properly marked with REQ_SYNC.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> CC: David Sterba <dsterba@suse.com>
> CC: linux-btrfs@vger.kernel.org
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/btrfs/disk-io.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index eb1ee7b6f532..af75a9aab81e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3488,10 +3488,12 @@ static int write_dev_supers(struct btrfs_device *device,
>  		 * we fua the first super.  The others we allow
>  		 * to go down lazy.
>  		 */
> -		if (i == 0)
> -			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_FUA, bh);
> -		else
> +		if (i == 0) {
> +			ret = btrfsic_submit_bh(REQ_OP_WRITE,
> +						REQ_SYNC | REQ_FUA, bh);
> +		} else {
>  			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +		}
>  		if (ret)
>  			errors++;
>  	}
> @@ -3555,7 +3557,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>  
>  	bio->bi_end_io = btrfs_end_empty_barrier;
>  	bio->bi_bdev = device->bdev;
> -	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
> +	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
>  	init_completion(&device->flush_wait);
>  	bio->bi_private = &device->flush_wait;
>  	device->flush_bio = bio;
> -- 
> 2.12.0
> 
