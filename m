Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751303AbdC0RA2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:00:28 -0400
Date: Mon, 27 Mar 2017 18:59:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: enable repair during read for raid56 profile
Message-ID: <20170327165944.GK4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1490382815-25248-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490382815-25248-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 24, 2017 at 12:13:35PM -0700, Liu Bo wrote:
> Now that scrub can fix data errors with the help of parity for raid56
> profile, repair during read is able to as well.
> 
> Although the mirror num in raid56 senario has different meanings, i.e.

(typo: scenario)

> 0 or 1: read data directly
> > 1:    do recover with parity,
> it could be fit into how we repair bad block during read.

Could we possibly add some symbolic names for the RAID56 case?

> 
> The trick is to use BTRFS_MAP_READ instead of BTRFS_MAP_WRITE to get the
> device and position on it.

Please also document the trick in the code before the following.

> +	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num)) {
> +		/* use BTRFS_MAP_READ to get the phy dev and sector */
> +		ret = btrfs_map_block(fs_info, BTRFS_MAP_READ, logical,
> +				      &map_length, &bbio, 0);
> +		if (ret) {
> +			btrfs_bio_counter_dec(fs_info);
> +			bio_put(bio);
> +			return -EIO;
> +		}
> +		ASSERT(bbio->mirror_num == 1);
> +	} else {
> +		ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
> +				      &map_length, &bbio, mirror_num);
> +		if (ret) {
> +			btrfs_bio_counter_dec(fs_info);
> +			bio_put(bio);
> +			return -EIO;
> +		}
> +		BUG_ON(mirror_num != bbio->mirror_num);
>  	}
> -	BUG_ON(mirror_num != bbio->mirror_num);
> -	sector = bbio->stripes[mirror_num-1].physical >> 9;
> +
> +	sector = bbio->stripes[bbio->mirror_num - 1].physical >> 9;
>  	bio->bi_iter.bi_sector = sector;
> -	dev = bbio->stripes[mirror_num-1].dev;
> +	dev = bbio->stripes[bbio->mirror_num - 1].dev;
>  	btrfs_put_bbio(bbio);
>  	if (!dev || !dev->bdev || !dev->writeable) {
>  		btrfs_bio_counter_dec(fs_info);
