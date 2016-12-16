Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gum.cmpxchg.org ([85.214.110.215]:52948 "EHLO gum.cmpxchg.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756742AbcLPRg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 12:36:59 -0500
Date: Fri, 16 Dec 2016 12:31:51 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Nils Holland <nholland@tisys.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/2] mm, oom: do not enfore OOM killer for __GFP_NOFAIL
 automatically
Message-ID: <20161216173151.GA23182@cmpxchg.org>
References: <20161216073941.GA26976@dhcp22.suse.cz>
 <20161216155808.12809-1-mhocko@kernel.org>
 <20161216155808.12809-3-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161216155808.12809-3-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2016 at 04:58:08PM +0100, Michal Hocko wrote:
> @@ -1013,7 +1013,7 @@ bool out_of_memory(struct oom_control *oc)
>  	 * make sure exclude 0 mask - all other users should have at least
>  	 * ___GFP_DIRECT_RECLAIM to get here.
>  	 */
> -	if (oc->gfp_mask && !(oc->gfp_mask & (__GFP_FS|__GFP_NOFAIL)))
> +	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS))
>  		return true;

This makes sense, we should go back to what we had here. Because it's
not that the reported OOMs are premature - there is genuinely no more
memory reclaimable from the allocating context - but that this class
of allocations should never invoke the OOM killer in the first place.

> @@ -3737,6 +3752,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		 */
>  		WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER);
>  
> +		/*
> +		 * Help non-failing allocations by giving them access to memory
> +		 * reserves but do not use ALLOC_NO_WATERMARKS because this
> +		 * could deplete whole memory reserves which would just make
> +		 * the situation worse
> +		 */
> +		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_HARDER, ac);
> +		if (page)
> +			goto got_pg;
> +

But this should be a separate patch, IMO.

Do we observe GFP_NOFS lockups when we don't do this? Don't we risk
premature exhaustion of the memory reserves, and it's better to wait
for other reclaimers to make some progress instead? Should we give
reserve access to all GFP_NOFS allocations, or just the ones from a
reclaim/cleaning context? All that should go into the changelog of a
separate allocation booster patch, I think.
