Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56485 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab2JEUGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:06:32 -0400
Date: Fri, 5 Oct 2012 22:06:17 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup pages properly when ENOMEM in compression
Message-ID: <20121005200617.GA15720@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349459359-2298-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349459359-2298-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 05, 2012 at 01:49:19PM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -577,6 +577,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	u64 em_start;
>  	struct extent_map *em;
>  	int ret = -ENOMEM;
> +	int faili = 0;
>  	u32 *sums;
>  
>  	tree = &BTRFS_I(inode)->io_tree;
> @@ -626,8 +627,11 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
>  		cb->compressed_pages[pg_index] = alloc_page(GFP_NOFS |
>  							      __GFP_HIGHMEM);
> -		if (!cb->compressed_pages[pg_index])
> +		if (!cb->compressed_pages[pg_index]) {
> +			faili = pg_index - 1;
> +			ret = -ENOMEM;
>  			goto fail2;
> +		}
>  	}
>  	cb->nr_pages = nr_pages;
>  
> @@ -713,8 +717,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	return 0;
>  
>  fail2:
> -	for (pg_index = 0; pg_index < nr_pages; pg_index++)
> -		free_page((unsigned long)cb->compressed_pages[pg_index]);
> +	while (faili >= 0) {
> +		__free_page(cb->compressed_pages[pg_index]);
                                                 ^^^^^^^^

s/pg_index/faili/

Also, faili (how do you pronounce that?) is initialized to 0, the while
loop will always fire (and burn a page), initialize it to -1.

Other than that, I like the fix, thanks.

> +		faili--;
> +	}
>  
>  	kfree(cb->compressed_pages);
>  fail1:

david
