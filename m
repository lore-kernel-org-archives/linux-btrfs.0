Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06D1C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA80E21872
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfADPgO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:36:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:57390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfADPgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:36:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43BC2ABE4
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 15:36:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E7955DA837; Fri,  4 Jan 2019 16:35:43 +0100 (CET)
Date:   Fri, 4 Jan 2019 16:35:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: Refactor shrink_delalloc
Message-ID: <20190104153543.GR23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-8-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103085005.32053-8-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 10:50:05AM +0200, Nikolay Borisov wrote:
> Add a couple of comments regarding the logic flow in shrink_delalloc.
> Then, cease using max_reclaim as a temporary variable when calculating
> nr_pages. Finally give max_reclaim a more becoming name, which
> uneqivocally shows at what this variable really holds. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b15afeae16df..615441f4d458 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4743,7 +4743,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  	struct btrfs_space_info *space_info;
>  	struct btrfs_trans_handle *trans;
>  	u64 delalloc_bytes;
> -	u64 max_reclaim;
> +	u64 async_pages;

This could be int, as it's compared to an atomic_t, otherwise ok.

>  	u64 items;
>  	long time_left;
>  	unsigned long nr_pages;
> @@ -4768,25 +4768,36 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  
>  	loops = 0;
>  	while (delalloc_bytes && loops < 3) {
> -		max_reclaim = min(delalloc_bytes, to_reclaim);
> -		nr_pages = max_reclaim >> PAGE_SHIFT;
> +		nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
> +
> +		/*
> +		 * Triggers inode writeback for up to nr_pages. This will invoke
> +		 * ->writepages callback and trigger delalloc filling
> +		 *  (btrfs_run_delalloc_range()).
> +		 */
>  		btrfs_writeback_inodes_sb_nr(fs_info, nr_pages, items);
> +
>  		/*
> -		 * We need to wait for the async pages to actually start before
> -		 * we do anything.
> +		 * We need to wait for the compressed pages to start before
> +		 * we continue.
>  		 */
> -		max_reclaim = atomic_read(&fs_info->async_delalloc_pages);
> -		if (!max_reclaim)
> +		async_pages = atomic_read(&fs_info->async_delalloc_pages);
> +		if (!async_pages)
>  			goto skip_async;
>  
> -		if (max_reclaim <= nr_pages)
> -			max_reclaim = 0;
> +		/*
> +		 * Calculate how many compressed pages we want to be written
> +		 * before we continue. I.e if there are more async pages than we
> +		 * require wait_event will wait until nr_pages are written.
> +		 */
> +		if (async_pages <= nr_pages)
> +			async_pages = 0;
>  		else
> -			max_reclaim -= nr_pages;
> +			async_pages -= nr_pages;
>  
>  		wait_event(fs_info->async_submit_wait,
>  			   atomic_read(&fs_info->async_delalloc_pages) <=
> -			   (int)max_reclaim);
> +			   (int)async_pages);
>  skip_async:
>  		spin_lock(&space_info->lock);
>  		if (list_empty(&space_info->tickets) &&
> -- 
> 2.17.1
