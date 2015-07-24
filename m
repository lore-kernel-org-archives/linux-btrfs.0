Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbbGXMe4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 08:34:56 -0400
Date: Fri, 24 Jul 2015 14:34:47 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 4/4] btrfs: convert: Avoid allocating metadata extent
 crossing stripe boundary
Message-ID: <20150724123447.GX6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1437643090-13920-5-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437643090-13920-5-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 05:18:10PM +0800, Qu Wenruo wrote:
> @@ -246,6 +247,14 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
>  			continue;
>  		}
>  
> +		if (metadata) {
> +			BUG_ON(num_bytes != root->nodesize);

This caught my attention and looking at possible values of num_bytes,
this can crash:

1291         for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
1292                 ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);

where sectorsize == num_bytes.

> +			if (check_crossing_stripes(start, num_bytes)) {
> +				last = round_down(start + num_bytes,
> +						  BTRFS_STRIPE_LEN);
> +				continue;
> +			}
> +		}
>  		clear_extent_dirty(&root->fs_info->free_space_cache,
>  				   start, start + num_bytes - 1, 0);
>  
> @@ -1280,7 +1289,7 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
>  	 * special, we can't rely on relocate_extents_range to relocate it.
>  	 */
>  	for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
> -		ret = custom_alloc_extent(root, sectorsize, 0, &key);
> +		ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);

Same here.

> -			ret = custom_alloc_extent(root, sectorsize, 0, &key);
> +			ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);

And here.

I hope there's a way how to avoid the BUG_ON at all.
