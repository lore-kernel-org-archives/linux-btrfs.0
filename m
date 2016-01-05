Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49767 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbcAEOlL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 09:41:11 -0500
Date: Tue, 5 Jan 2016 15:41:07 +0100
From: David Sterba <dave@jikos.cz>
To: sam tygier <samtygier@yahoo.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: Check metadata redundancy on balance
Message-ID: <20160105144107.GS26112@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <n467lf$t3g$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <n467lf$t3g$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 09:25:03AM +0000, sam tygier wrote:
> Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>
> 
> From: Sam Tygier <samtygier@yahoo.co.uk>
> Date: Sat, 3 Oct 2015 16:43:48 +0100
> Subject: [PATCH] Btrfs: Check metadata redundancy on balance
> 
> When converting a filesystem via balance check that metadata mode
> is at least as redundant as the data mode. For example give warning
> when:
> -dconvert=raid1 -mconvert=single

Missing signed-off-by

> ---
>  fs/btrfs/volumes.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6fc73586..40247e9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3584,6 +3584,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		}
>  	} while (read_seqretry(&fs_info->profiles_lock, seq));
>  
> +	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
> +		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
> +		btrfs_info(fs_info,
> +			"Warning: metatdata has lower redundancy than data\n");

If it's a warning then please use btrfs_warn. The message gets a higher
priority and would be caught by log scanners as an issue worth attention.

Also, explicitly mentioning the profiles for data and metadata would be
better.

And sorry that it takes so long to get this patch merged.
