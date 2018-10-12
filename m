Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90421C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF2E20868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="IrK2hzwk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CF2E20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbeJLVYh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 17:24:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38245 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbeJLVYh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 17:24:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9-v6so13878638qtf.5
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I2jzxmESBIHb38hlufgwLT00WDfMnsqYM2mEeNShipA=;
        b=IrK2hzwkhIIhm2bBq7ynxsquupKS0vnMmEHagxtzwwsww+8N89qopOFLFisX5Fm0qL
         6rqbdz9Y+Fgd/DF2kLiwmx0F4C7T7XW5cbUNhvfsgn+hCt/vMGKVPUSu8kY1ecOa11By
         1S6Njy2OQCxIjjigJyBGEIQE35SpIFRHgqfUPpRD7XmjnXFhLLgjlPQbtZNEolkv4g2O
         9meGe9U5sQok6m3VsIlPeKxiNIPGZSph1qV9llwji/zzryJW22+lGbXRFzbrXouw3s+b
         sL+fpM1LEVhbGNM7U4SWRwASK3Lw4CrNkpfZdYNqFHSKnn2wW1Of8CVzCEZF/X2WTAjE
         WFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I2jzxmESBIHb38hlufgwLT00WDfMnsqYM2mEeNShipA=;
        b=qzYEjuumPcpaHlDvjAU6AKZO6JbUNqupoV7lgDxEzbReJp5pqM2S4TzfLbF55C7jOt
         J8YJ/PNO8fF12PAQgKL32mAXCO2LAr0LLUDHtMqHsHpSKcTsLmKIdQ01tEvuZvsUlwxi
         zdER+cYp7svy8DUbX5naDFA9N5+iqyyWod9rLrbsLYusaoXLzovxkS7Jfz8DqfB0SxQU
         cuj9PmMvV7BeZt7lAP+WRBvQXXcZayFCtFdhdMaoV7nTyMcW8zv03mVgiGy51zTzukJq
         JdlBfBwBUeEC620kkf/R9Bg1DaoGsoFhBUvfIhZmji0jpr9DkJu8HBjDTpO0mt4BPfGP
         43aA==
X-Gm-Message-State: ABuFfoiQZZVHd537YPmv3GOnPfK5/Wq09+2PoZyyL7RQbSqPN8HqKSpJ
        8YshFBHYSUrcAiDOvNRE/HASDw==
X-Google-Smtp-Source: ACcGV62LRT6uedcOTMjZgGllQsrZUvaySSsVqbiH1YwnSe7+pz0ptQdpUkuccX/Iqrs1zkr3Hu9b9Q==
X-Received: by 2002:ac8:3f89:: with SMTP id d9-v6mr5798236qtk.46.1539352323565;
        Fri, 12 Oct 2018 06:52:03 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m2-v6sm502758qkg.92.2018.10.12.06.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 06:52:02 -0700 (PDT)
Date:   Fri, 12 Oct 2018 09:52:01 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] btrfs: Refactor find_free_extent() loops update
 into find_free_extent_update_loop()
Message-ID: <20181012135200.ddo7dhhrwng26lnh@destiny>
References: <20181012061819.19482-1-wqu@suse.com>
 <20181012061819.19482-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012061819.19482-5-wqu@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 02:18:19PM +0800, Qu Wenruo wrote:
> We have a complex loop design for find_free_extent(), that has different
> behavior for each loop, some even includes new chunk allocation.
> 
> Instead of putting such a long code into find_free_extent() and makes it
> harder to read, just extract them into find_free_extent_update_loop().
> 
> With all the cleanups, the main find_free_extent() should be pretty
> barebone:
> 
> find_free_extent()
> |- Iterate through all block groups
> |  |- Get a valid block group
> |  |- Try to do clustered allocation in that block group
> |  |- Try to do unclustered allocation in that block group
> |  |- Check if the result is valid
> |  |  |- If valid, then exit
> |  |- Jump to next block group
> |
> |- Push harder to find free extents
>    |- If not found, re-iterate all block groups
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 217 ++++++++++++++++++++++-------------------
>  1 file changed, 117 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e6bfa91af41c..938569d2c583 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7236,7 +7236,9 @@ struct find_free_extent_ctl {
>  	/* RAID index, converted from flags */
>  	int index;
>  
> -	/* Current loop number */
> +	/*
> +	 * Current loop number, check find_free_extent_update_loop() for details
> +	 */
>  	int loop;
>  
>  	/*
> @@ -7433,6 +7435,117 @@ static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
>  	return 0;
>  }
>  
> +/*
> + * Return >0 means caller needs to re-search for free extent
> + * Return 0 means we have the needed free extent.
> + * Return <0 means we failed to locate any free extent.
> + */
> +static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
> +					struct btrfs_free_cluster *last_ptr,
> +					struct btrfs_key *ins,
> +					struct find_free_extent_ctl *ffe_ctl,
> +					int full_search, bool use_cluster)
> +{
> +	struct btrfs_root *root = fs_info->extent_root;
> +	int ret;
> +
> +	if ((ffe_ctl->loop == LOOP_CACHING_NOWAIT) &&
> +	    ffe_ctl->have_caching_bg && !ffe_ctl->orig_have_caching_bg)
> +		ffe_ctl->orig_have_caching_bg = true;
> +
> +	if (!ins->objectid && ffe_ctl->loop >= LOOP_CACHING_WAIT &&
> +	     ffe_ctl->have_caching_bg)
> +		return 1;
> +
> +	if (!ins->objectid && ++(ffe_ctl->index) < BTRFS_NR_RAID_TYPES)
> +		return 1;
> +
> +	/*
> +	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
> +	 *			caching kthreads as we move along
> +	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
> +	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
> +	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
> +	 *			again
> +	 */
> +	if (!ins->objectid && ffe_ctl->loop < LOOP_NO_EMPTY_SIZE) {
> +		ffe_ctl->index = 0;
> +		if (ffe_ctl->loop == LOOP_CACHING_NOWAIT) {
> +			/*
> +			 * We want to skip the LOOP_CACHING_WAIT step if we
> +			 * don't have any uncached bgs and we've already done a
> +			 * full search through.
> +			 */
> +			if (ffe_ctl->orig_have_caching_bg || !full_search)
> +				ffe_ctl->loop = LOOP_CACHING_WAIT;
> +			else
> +				ffe_ctl->loop = LOOP_ALLOC_CHUNK;
> +		} else {
> +			ffe_ctl->loop++;
> +		}
> +
> +		if (ffe_ctl->loop == LOOP_ALLOC_CHUNK) {
> +			struct btrfs_trans_handle *trans;
> +			int exist = 0;
> +
> +			trans = current->journal_info;
> +			if (trans)
> +				exist = 1;
> +			else
> +				trans = btrfs_join_transaction(root);
> +
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				return ret;
> +			}
> +
> +			ret = do_chunk_alloc(trans, ffe_ctl->flags,
> +					     CHUNK_ALLOC_FORCE);
> +
> +			/*
> +			 * If we can't allocate a new chunk we've already looped
> +			 * through at least once, move on to the NO_EMPTY_SIZE
> +			 * case.
> +			 */
> +			if (ret == -ENOSPC)
> +				ffe_ctl->loop = LOOP_NO_EMPTY_SIZE;
> +
> +			/* Do not bail out on ENOSPC since we can do more. */
> +			if (ret < 0 && ret != -ENOSPC)
> +				btrfs_abort_transaction(trans, ret);
> +			else
> +				ret = 0;
> +			if (!exist)
> +				btrfs_end_transaction(trans);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
> +			/*
> +			 * Don't loop again if we already have no empty_size and
> +			 * no empty_cluster.
> +			 */
> +			if (ffe_ctl->empty_size == 0 &&
> +			    ffe_ctl->empty_cluster == 0)
> +				return -ENOSPC;
> +			ffe_ctl->empty_size = 0;
> +			ffe_ctl->empty_cluster = 0;
> +		}
> +		return 1;
> +	} else if (!ins->objectid) {
> +		ret = -ENOSPC;
> +	} else if (ins->objectid) {
> +		if (!use_cluster && last_ptr) {
> +			spin_lock(&last_ptr->lock);
> +			last_ptr->window_start = ins->objectid;
> +			spin_unlock(&last_ptr->lock);
> +		}
> +		ret = 0;
> +	}
> +	return ret;
> +}

Rework this so the

if (ins->objectid)
	blah

is the first thing, that way you don't have to do the

if (!ins->objectid && <other things>)

for all the other if statements here.  The fast path should be the first thing,
then we can deal with all of the other crap last.  Thanks,

Josef
