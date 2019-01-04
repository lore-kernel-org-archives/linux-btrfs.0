Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54715C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2345D2087F
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfADPAG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:00:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:51776 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbfADPAG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:00:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A05DFAF4A
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 15:00:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B930DA7CE; Fri,  4 Jan 2019 15:59:35 +0100 (CET)
Date:   Fri, 4 Jan 2019 15:59:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: Refactor btrfs_get_extent_fiemap
Message-ID: <20190104145935.GM23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212074234.20613-1-nborisov@suse.com>
 <20181212074234.20613-3-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212074234.20613-3-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 09:42:33AM +0200, Nikolay Borisov wrote:
> Make btrfs_get_extent_fiemap a bit more friendly. First step is to
> rename the closely related, yet arbitrary named
> range_start/found_end/found variables. They define the delalloc range
> that is found in case a real extent wasn't found. Subsequently remove
> an unnecessary check for hole_em since it's guaranteed to be set i.e the
> check is always true. Top it off by giving all comments a refresh.
> 
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/inode.c | 84 ++++++++++++++++++++++++++----------------------
>  1 file changed, 45 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 67eee4d345c9..95eb18779c19 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6965,10 +6965,10 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
>  {
>  	struct extent_map *em;
>  	struct extent_map *hole_em = NULL;
> -	u64 range_start = start;
> +	u64 delalloc_start = start;
>  	u64 end;
> -	u64 found;
> -	u64 found_end;
> +	u64 delalloc_len;
> +	u64 delalloc_end;
>  	int err = 0;
>  
>  	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
> @@ -6996,37 +6996,42 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
>  	em = NULL;
>  
>  	/* ok, we didn't find anything, lets look for delalloc */
> -	found = count_range_bits(&inode->io_tree, &range_start,
> +	delalloc_len = count_range_bits(&inode->io_tree, &delalloc_start,
>  				 end, len, EXTENT_DELALLOC, 1);
> -	found_end = range_start + found;
> -	if (found_end < range_start)
> -		found_end = (u64)-1;
> +	delalloc_end = delalloc_start + delalloc_len;
> +	if (delalloc_end < delalloc_start)
> +		delalloc_end = (u64)-1;
>  
>  	/*
> -	 * we didn't find anything useful, return
> -	 * the original results from get_extent()
> +	 * we didn't find anything useful, return the original results from
> +	 * get_extent()
>  	 */
> -	if (range_start > end || found_end <= start) {
> +	if (delalloc_start > end || delalloc_end <= start) {
>  		em = hole_em;
>  		hole_em = NULL;
>  		goto out;
>  	}
>  
> -	/* adjust the range_start to make sure it doesn't
> -	 * go backwards from the start they passed in
> +	/*
> +	 * adjust the delalloc_start to make sure it doesn't go backwards from
> +	 * the start they passed in
>  	 */
> -	range_start = max(start, range_start);
> -	found = found_end - range_start;
> +	delalloc_start = max(start, delalloc_start);
> +	delalloc_len = delalloc_end - delalloc_start;
>  
> -	if (found > 0) {
> -		u64 hole_start = start;
> +	if (delalloc_len) {
> +		u64 hole_start;
>  		u64 hole_len = len;
> +		u64 hole_end = extent_map_end(hole_em);
>  
>  		em = alloc_extent_map();
>  		if (!em) {
>  			err = -ENOMEM;
>  			goto out;
>  		}
> +		em->bdev = NULL;
> +
> +		ASSERT(hole_em);
>  		/*
>  		 * when btrfs_get_extent can't find anything it
>  		 * returns one huge hole
> @@ -7035,41 +7040,42 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
>  		 * adjust to make sure it is based on the start from
>  		 * the caller
>  		 */
> -		if (hole_em) {
> -			u64 calc_end = extent_map_end(hole_em);
> -
> -			if (calc_end <= start || (hole_em->start > end)) {
> -				free_extent_map(hole_em);
> -				hole_em = NULL;
> -			} else {
> -				hole_start = max(hole_em->start, start);
> -				hole_len = calc_end - hole_start;
> -			}
> +		if (hole_end <= start || (hole_em->start > end)) {
> +		       free_extent_map(hole_em);
> +		       hole_em = NULL;
> +		} else {
> +		       hole_start = max(hole_em->start, start);
> +		       hole_len = hole_end - hole_start;
>  		}
> -		em->bdev = NULL;
> -		if (hole_em && range_start > hole_start) {
> -			/* our hole starts before our delalloc, so we
> -			 * have to return just the parts of the hole
> -			 * that go until  the delalloc starts
> +
> +		if (hole_em && delalloc_start > hole_start) {
> +			/*
> +			 * our hole starts before our delalloc, so we have to
> +			 * return just the parts of the hole that go until the
> +			 * delalloc starts
>  			 */
> -			em->len = min(hole_len,
> -				      range_start - hole_start);
> +			em->len = min(hole_len, delalloc_start - hole_start);
>  			em->start = hole_start;
>  			em->orig_start = hole_start;
>  			/*
> -			 * don't adjust block start at all,
> -			 * it is fixed at EXTENT_MAP_HOLE
> +			 * don't adjust block start at all, it is fixed at
> +			 * EXTENT_MAP_HOLE
>  			 */
>  			em->block_start = hole_em->block_start;
>  			em->block_len = hole_len;
>  			if (test_bit(EXTENT_FLAG_PREALLOC, &hole_em->flags))
>  				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
>  		} else {
> -			em->start = range_start;
> -			em->len = found;
> -			em->orig_start = range_start;
> +
> +			/*
> +			 * Hole is out of passed range or it starts after
> +			 * delalloc range
> +			 */
> +			em->start = delalloc_start;
> +			em->len = delalloc_len;
> +			em->orig_start = delalloc_start;
>  			em->block_start = EXTENT_MAP_DELALLOC;
> -			em->block_len = found;
> +			em->block_len = delalloc_len;
>  		}
>  	} else {
>  		return hole_em;
> -- 
> 2.17.1
