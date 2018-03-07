Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52967 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933351AbeCGPWe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:22:34 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C6E9AD39
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Mar 2018 15:22:32 +0000 (UTC)
Date: Wed, 7 Mar 2018 16:20:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/5] btrfs: Parse options after node/sector size
 initialized
Message-ID: <20180307152012.GE23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180302052254.7059-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 01:22:50PM +0800, Qu Wenruo wrote:
> This provides the basis for later max_inline enhancement, which needs to
> access fs_info->nodesize.

I've checked if this patch can be applied independently, but no, see the
comment below.

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a8ecccfc36de..f7f985ed5af9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2644,12 +2644,6 @@ int open_ctree(struct super_block *sb,
>  	 */
>  	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
>  
> -	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
> -	if (ret) {
> -		err = ret;
> -		goto fail_alloc;
> -	}
> -
>  	features = btrfs_super_incompat_flags(disk_super) &

We cannot swap the order of btrfs_parse_options and
btrfs_super_incompat_flags as the incompat flags can be set by mount
options. Currently it's for lzo or zstd, that are supported, but int the
future this can be anything and such bug would be hard to catch. If the
nodesize is requred, it would need to be obtained in another way.

>  		~BTRFS_FEATURE_INCOMPAT_SUPP;
>  	if (features) {
> @@ -2692,6 +2686,13 @@ int open_ctree(struct super_block *sb,
>  	fs_info->sectorsize = sectorsize;
>  	fs_info->stripesize = stripesize;
>  
> +	/* Only parse options after node/sector size initialized */
> +	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
> +	if (ret) {
> +		err = ret;
> +		goto fail_alloc;
> +	}
> +
>  	/*
>  	 * mixed block groups end up with duplicate but slightly offset
>  	 * extent buffers for the same range.  It leads to corruptions
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
