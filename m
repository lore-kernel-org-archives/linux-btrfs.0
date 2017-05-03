Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752090AbdECIg0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 04:36:26 -0400
Date: Wed, 3 May 2017 10:36:15 +0200
From: Jan Kara <jack@suse.cz>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: clm@fb.com, dsterba@suse.com, jack@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suze.cz>, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH] btrfs: always write superblocks synchronously
Message-ID: <20170503083615.GC10084@quack2.suse.cz>
References: <20170502162813.4299-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502162813.4299-1-dave@stgolabs.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 02-05-17 09:28:13, Davidlohr Bueso wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_FUA implementation.
> Since REQ_FUA and REQ_FLUSH flags are stripped from submitted IO
> when the disk doesn't have volatile write cache and thus effectively
> make the write async. This was seen to cause performance hits up
> to 90% regression in disk IO related benchmarks such as reaim and
> dbench[1].
> 
> Fix the problem by making sure the first superblock write is also
> treated as synchronous since they can block progress of the
> journalling (commit, log syncs) machinery and thus the whole filesystem.
> 
> [1] https://www.spinics.net/lists/linux-ext4/msg56238.html
> 
> Fixes: b685d3d65ac (block: treat REQ_FUA and REQ_PREFLUSH as synchronous)
> Cc: stable <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suze.cz>
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

I wasn't patient enough and already sent the fix as part of my series
fixing other filesystems [1]. It also fixes one more place in btrfs that
needs REQ_SYNC to return to the original behavior.

[1] https://www.spinics.net/lists/linux-btrfs/msg65022.html

								Honza

> ---
>  fs/btrfs/disk-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 061c1d1f774f..51b2fd8ceccb 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3468,7 +3468,7 @@ static int write_dev_supers(struct btrfs_device *device,
>  		 * to go down lazy.
>  		 */
>  		if (i == 0)
> -			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_FUA, bh);
> +			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_FUA | REQ_SYNC, bh);
>  		else
>  			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
>  		if (ret)
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
