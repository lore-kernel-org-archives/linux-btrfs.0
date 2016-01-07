Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbcAGN0c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jan 2016 08:26:32 -0500
Date: Thu, 7 Jan 2016 14:24:10 +0100
From: David Sterba <dsterba@suse.cz>
To: sam tygier <samtygier@yahoo.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: Check metadata redundancy on balance
Message-ID: <20160107132409.GD4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <568CD827.3060601@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <568CD827.3060601@yahoo.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 06, 2016 at 09:02:31AM +0000, sam tygier wrote:
> From: Sam Tygier <samtygier@yahoo.co.uk>
> Date: Wed, 6 Jan 2016 08:46:12 +0000
> Subject: [PATCH] Btrfs: Check metadata redundancy on balance
> 
> When converting a filesystem via balance check that metadata mode
> is at least as redundant as the data mode. For example give warning
> when:
> -dconvert=raid1 -mconvert=single
> 
> Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>
> ---
> v3:
>   Use btrfs_warn()
>   Mention profiles in message
> v2:
>   Use btrfs_get_num_tolerated_disk_barrier_failures()
> ---
>  fs/btrfs/volumes.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a23399e..be91458 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3756,6 +3756,14 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		}
>  	} while (read_seqretry(&fs_info->profiles_lock, seq));
>  
> +	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
> +		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
> +		btrfs_warn(fs_info,
> +			"Warning: metatdata profile %llu has lower redundancy "
> +		        "than data profile %llu\n", bctl->meta.target,

Thanks. FYI, I made some minor adjustments to the message ("warning" is
not necessary, numer format looks better in hexa, no ending \n).
