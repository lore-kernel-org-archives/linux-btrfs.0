Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B26C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6302081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:21:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F6302081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387493AbeKFBl3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:41:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:50066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387438AbeKFBl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:41:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9DFE3B043
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 16:21:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 57152DAF91; Mon,  5 Nov 2018 17:20:46 +0100 (CET)
Date:   Mon, 5 Nov 2018 17:20:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] btrfs: Remove extent_io_ops::fill_delalloc
Message-ID: <20181105162044.GY9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-2-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:46PM +0200, Nikolay Borisov wrote:
> This callback is called only from writepage_delalloc which in turn
> is guaranteed to be called from the data page writeout path. In the end
> there is no reason to have the call to this function to be indrected
> via the extent_io_ops structure. This patch removes the callback
> definition, exports the function and calls it directly. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h     |  3 +++
>  fs/btrfs/extent_io.c | 14 ++++++--------
>  fs/btrfs/extent_io.h |  5 -----
>  fs/btrfs/inode.c     | 10 +++++-----
>  4 files changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 68ca41dbbef3..dbeb5b2486d5 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3186,6 +3186,9 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
>  				    struct btrfs_trans_handle *trans, int mode,
>  				    u64 start, u64 num_bytes, u64 min_size,
>  				    loff_t actual_len, u64 *alloc_hint);
> +int run_delalloc_range(void *private_data, struct page *locked_page, u64 start,

Functions exported in .h should have the btrfs_prefix, updated in the
patch.

> +		       u64 end, int *page_started, unsigned long *nr_written,
> +		       struct writeback_control *wbc);
>  extern const struct dentry_operations btrfs_dentry_operations;
>  
>  /* ioctl.c */
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 6877a74c7469..2e6191aa25f3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3205,7 +3205,7 @@ static void update_nr_written(struct writeback_control *wbc,
>  /*
>   * helper for __extent_writepage, doing all of the delayed allocation setup.
>   *
> - * This returns 1 if our fill_delalloc function did all the work required
> + * This returns 1 if run_delalloc_range function did all the work required
>   * to write the page (copy into inline extent).  In this case the IO has
>   * been started and the page is already unlocked.
>   *
> @@ -3226,7 +3226,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>  	int ret;
>  	int page_started = 0;
>  
> -	if (epd->extent_locked || !tree->ops || !tree->ops->fill_delalloc)
> +	if (epd->extent_locked)
>  		return 0;
>  
>  	while (delalloc_end < page_end) {
> @@ -3239,15 +3239,13 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>  			delalloc_start = delalloc_end + 1;
>  			continue;
>  		}
> -		ret = tree->ops->fill_delalloc(inode, page,
> -					       delalloc_start,
> -					       delalloc_end,
> -					       &page_started,
> -					       nr_written, wbc);
> +		ret = run_delalloc_range(inode, page, delalloc_start,
> +					 delalloc_end, &page_started,
> +					 nr_written, wbc);
>  		/* File system has been set read-only */
>  		if (ret) {
>  			SetPageError(page);
> -			/* fill_delalloc should be return < 0 for error
> +			/* run_delalloc_range should return < 0 for error

Please don't use this style of comments, fixed.
