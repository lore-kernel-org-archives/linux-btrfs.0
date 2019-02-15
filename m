Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EB3C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 10:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF9721924
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 10:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfBOKAX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:00:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:38850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726159AbfBOKAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 05:00:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E312CAFF8
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 10:00:19 +0000 (UTC)
Subject: Re: [PATCH 1/4] btrfs: Refactor cow_file_range_async
To:     linux-btrfs@vger.kernel.org
References: <20190213155529.31500-1-nborisov@suse.com>
 <20190213155529.31500-2-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <6ba18dd4-0344-682a-6002-2c02130e2925@suse.com>
Date:   Fri, 15 Feb 2019 12:00:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190213155529.31500-2-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.02.19 г. 17:55 ч., Nikolay Borisov wrote:
> This commit changes the implementation of cow_file_range_async in order
> to get rid of the BUG_ON in the middle of the loop. Additionally it
> reworks the inner loop in the hopes of making it more understandable.
> 
> Main change is that the number of chunks required to handle the given
> range is calculated before going into the loop and the logic of the loop
> just iterates the chunk count. Furthermore, the way memory is allocated
> is reworked and now the code does a single kmalloc with enough space to
> handle all chunks. Depending on whether compression is enabled or not
> chunks are either 1 (in non-compress case) or the range divided by 512k.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Scratch that patch since it could lead to deadlocks. It's not enough to
just return an error and hop higher levels will unlock the pages and
whatnot. Other callers (cow_file_range/run_delalloc_nocow) use
extent_clear_unlock_delalloc.
> ---
>  fs/btrfs/inode.c | 75 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 49 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 05bbfd02ea49..c2180f0a5f42 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -375,6 +375,7 @@ struct async_cow {
>  	unsigned int write_flags;
>  	struct list_head extents;
>  	struct btrfs_work work;
> +	atomic_t *pending;
>  };
>  
>  static noinline int add_async_extent(struct async_cow *cow,
> @@ -1181,7 +1182,12 @@ static noinline void async_cow_free(struct btrfs_work *work)
>  	async_cow = container_of(work, struct async_cow, work);
>  	if (async_cow->inode)
>  		btrfs_add_delayed_iput(async_cow->inode);
> -	kfree(async_cow);
> +	/*
> +	 * Since the pointer to 'pending' is at the beginning of the array of
> +	 * async_cow's, freeing it ensures the whole array has been freed.
> +	 */
> +	if (atomic_dec_and_test(async_cow->pending))
> +		kfree(async_cow->pending);
>  }
>  
>  static int cow_file_range_async(struct inode *inode, struct page *locked_page,
> @@ -1193,42 +1199,59 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>  	struct async_cow *async_cow;
>  	unsigned long nr_pages;
>  	u64 cur_end;
> +	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
> +	int i;
> +	bool should_compress;
> +	atomic_t *p;
> +
>  
>  	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
>  			 1, 0, NULL);
> -	while (start < end) {
> -		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
> -		BUG_ON(!async_cow); /* -ENOMEM */
> -		/*
> -		 * igrab is called higher up in the call chain, take only the
> -		 * lightweight reference for the callback lifetime
> -		 */
> -		ihold(inode);
> -		async_cow->inode = inode;
> -		async_cow->fs_info = fs_info;
> -		async_cow->locked_page = locked_page;
> -		async_cow->start = start;
> -		async_cow->write_flags = write_flags;
> -
> -		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
> -		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
> -			cur_end = end;
> -		else
> -			cur_end = min(end, start + SZ_512K - 1);
>  
> -		async_cow->end = cur_end;
> -		INIT_LIST_HEAD(&async_cow->extents);
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
> +	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
> +		num_chunks = 1;
> +		should_compress = false;
> +	} else {
> +		should_compress = true;
> +	}
> +
> +	/* Layout is [atomic_t][async_cow1][async_cowN].... */
> +	async_cow = kmalloc(sizeof(atomic_t) + num_chunks*sizeof(*async_cow),
> +			    GFP_NOFS);
> +	if (!async_cow)
> +		return -ENOMEM;
> +
> +	p = (atomic_t *)async_cow;
> +	async_cow = (struct async_cow *)((char *)async_cow + sizeof(atomic_t));
> +	atomic_set(p, num_chunks);
> +
> +	for (i = 0; i < num_chunks; i++) {
>  
> -		btrfs_init_work(&async_cow->work,
> +		if (should_compress)
> +			cur_end = min(end, start + SZ_512K - 1);
> +		else
> +			cur_end = end;
> +
> +		ihold(inode);
> +		async_cow[i].pending= p;
> +		async_cow[i].inode = inode;
> +		async_cow[i].start = start;
> +		async_cow[i].end = cur_end;
> +		async_cow[i].fs_info = fs_info;
> +		async_cow[i].locked_page = locked_page;
> +		async_cow[i].write_flags = write_flags;
> +		INIT_LIST_HEAD(&async_cow[i].extents);
> +
> +		btrfs_init_work(&async_cow[i].work,
>  				btrfs_delalloc_helper,
>  				async_cow_start, async_cow_submit,
>  				async_cow_free);
>  
> -		nr_pages = (cur_end - start + PAGE_SIZE) >>
> -			PAGE_SHIFT;
> +		nr_pages = DIV_ROUND_UP(cur_end - start, PAGE_SIZE);
>  		atomic_add(nr_pages, &fs_info->async_delalloc_pages);
>  
> -		btrfs_queue_work(fs_info->delalloc_workers, &async_cow->work);
> +		btrfs_queue_work(fs_info->delalloc_workers, &async_cow[i].work);
>  
>  		*nr_written += nr_pages;
>  		start = cur_end + 1;
> 
