Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbcFTLxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 07:53:36 -0400
Date: Mon, 20 Jun 2016 13:54:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [PATCH V19 05/19] Btrfs: subpage-blocksize: Read tree blocks
 whose size is < PAGE_SIZE
Message-ID: <20160620115405.GN4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1465888276-30670-6-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465888276-30670-6-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2016 at 12:41:02PM +0530, Chandan Rajendra wrote:
> In the case of subpage-blocksize, this patch makes it possible to read
> only a single metadata block from the disk instead of all the metadata
> blocks that map into a page.

This patch has a conflict with a next pending patch

"Btrfs: fix eb memory leak due to readpage failure"
https://patchwork.kernel.org/patch/9153927/

in this hunk:

> @@ -5557,10 +5645,32 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  		page = eb_head(eb)->pages[i];
>  		if (!PageUptodate(page)) {
>  			ClearPageError(page);
> -			err = __extent_read_full_page(tree, page,
> -						      get_extent, &bio,
> -						      mirror_num, &bio_flags,
> -						      READ | REQ_META);
> +			if (eb->len < PAGE_SIZE) {
> +				lock_extent_bits(tree, eb->start, eb->start + eb->len - 1,
> +							&cached_state);
> +				err = submit_extent_page(READ | REQ_META, tree,
> +							NULL, page,
> +							eb->start >> 9, eb->len,
> +							eb->start - page_offset(page),
> +							fs_info->fs_devices->latest_bdev,
> +							&bio, -1,
> +							end_bio_extent_buffer_readpage,
> +							mirror_num, bio_flags,
> +							bio_flags, false);
> +			} else {
> +				lock_extent_bits(tree, page_offset(page),
> +						page_offset(page) + PAGE_SIZE - 1,
> +						&cached_state);
> +				err = submit_extent_page(READ | REQ_META, tree,
> +							NULL, page,
> +							page_offset(page) >> 9,
> +							PAGE_SIZE, 0,
> +							fs_info->fs_devices->latest_bdev,
> +							&bio, -1,
> +							end_bio_extent_buffer_readpage,
> +							mirror_num, bio_flags,
> +							bio_flags, false);
> +			}
