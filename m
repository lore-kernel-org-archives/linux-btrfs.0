Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab3DXOpt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 10:45:49 -0400
Date: Wed, 24 Apr 2013 16:45:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't BUG_ON() in btrfs_num_copies
Message-ID: <20130424144547.GD16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366728893-1529-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366728893-1529-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 10:54:53AM -0400, Josef Bacik wrote:
> A user sent me a btrfs-image that was panicing because of some corruption.  This
> is because we pass in a bogus value to btrfs_num_copies, and it panics.  Instead
> just return 1.  We only call btrfs_num_copies to see if there are other copies
> to try and read for things, so if we just return 1 it will make the callers exit
> out with an appropriate error value.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/volumes.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c8a315d..c1a2217 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4232,9 +4232,25 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  	read_lock(&em_tree->lock);
>  	em = lookup_extent_mapping(em_tree, logical, len);
>  	read_unlock(&em_tree->lock);
> -	BUG_ON(!em);
>  
> -	BUG_ON(em->start > logical || em->start + em->len < logical);
> +	/*
> +	 * We could return errors for these cases, but that could get ugly and
> +	 * we'd probably do the same thing which is just not do anything else
> +	 * and exit, so return 1 so the callers don't try to use other copies.
> +	 */

This is safe on all the repair paths, they bail out if there's only one
copy. In the integrity checker btrfs_num_copies value is used to process
all copies, btrfs(ic)_map_block is called afterwards and bails out
eventually. Both functions fail on the same call to
lookup_extent_mapping(), so it adds only some minor extra work but we're
interested if it's safe to return 1, I think it is.


> +	if (!em) {
> +		btrfs_emerg(fs_info, "No mapping for %Lu-%Lu\n", logical,
> +			    logical+len);

				(unsigned long long)logical,
				(unsigned long long)(logical + len)

> +		return 1;
> +	}
> +
> +	if (em->start > logical || em->start + em->len < logical) {
> +		btrfs_emerg(fs_info, "Invalid mapping for %Lu-%Lu, got "
> +			    "%Lu-%Lu\n", logical, logical+len, em->start,
> +			    em->start + em->len);

dtto

> +		return 1;
> +	}
> +
>  	map = (struct map_lookup *)em->bdev;
>  	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
>  		ret = map->num_stripes;

Reviewed-by: David Sterba <dsterba@suse.cz>
