Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750937AbeGJHAU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 03:00:20 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD803AE80
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 07:00:18 +0000 (UTC)
Subject: Re: [PATCH RFC 1/2] btrfs: scrub: Don't use inode page cache in
 scrub_handle_errored_block()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180710055751.13309-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1565461a-2079-5236-0db7-efd9953e122a@suse.com>
Date: Tue, 10 Jul 2018 10:00:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180710055751.13309-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 08:57, Qu Wenruo wrote:
> When we need to fixup error blocks during scrub/dev-replace for
> nodatasum extents, we still goes through the inode page cache and write
> them back onto disk.
> 
> It's already proved that such usage of on-disk data could lead to
> serious data corruption for compressed extent.
> So here we also need to avoid such case, so avoid any calling to
> scrub_fixup_nodatasum().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Is this patch supposed to replace the 'if (0 ...' one that is in 4.18 -
if not, then the small fix should be reverted as we are introducing a
regression in 4.18 and then your full fix should go into 4.19.

I kind of lost the end of the whole nodatasum mess but your references
are really vague, if you have described somewhere (i.e in a mailing list
post or another, merged patch) how the corruption happens if we use the
page cache then put a reference in the changelog - either with a commit
id or use the Link: tag for the email thread.
> ---
>  fs/btrfs/scrub.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 572306036477..328232fa5646 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1151,11 +1151,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  		return ret;
>  	}
>  
> -	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
> -		sblocks_for_recheck = NULL;
> -		goto nodatasum_case;
> -	}
> -
>  	/*
>  	 * read all mirrors one after the other. This includes to
>  	 * re-read the extent or metadata block that failed (that was
> @@ -1268,13 +1263,20 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  		goto out;
>  	}
>  
> -	if (!is_metadata && !have_csum) {
> +	/*
> +	 * NOTE: Even for nodatasum data case, it's still possible that it's
> +	 * compressed data extent, thus scrub_fixup_nodatasum(), which
> +	 * write inode page cache onto disk, could cause serious data
> +	 * corruption.
> +	 *
> +	 * So here we could only read from disk, and hopes our recovery
> +	 * could reach disk before newer write.

If this code relies on 'hope' then I NACK it since hope cannot be
quantified hence the effect of this patch cannot be quantified. It
either fixes the problem or doesn't fix it. Sorry but this, coupled with
the vague changelog I'd rather not have it committed.

> +	 */
> +	if (0 && !is_metadata && !have_csum) {
>  		struct scrub_fixup_nodatasum *fixup_nodatasum;
>  
>  		WARN_ON(sctx->is_dev_replace);
>  
> -nodatasum_case:
> -
>  		/*
>  		 * !is_metadata and !have_csum, this means that the data
>  		 * might not be COWed, that it might be modified
> 
