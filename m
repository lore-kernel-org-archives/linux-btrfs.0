Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbeHTRdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 13:33:05 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12BACAFCF
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 14:17:15 +0000 (UTC)
Date: Mon, 20 Aug 2018 16:17:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: extent-tree: refactor find_free_extent()
Message-ID: <20180820141704.GZ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180725081242.8327-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180725081242.8327-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2018 at 04:12:42PM +0800, Qu Wenruo wrote:
> extent-tree.c::find_free_extent() could be one of the most
> ill-structured function, it has at least 4 non-exit tags and jumps
> between them.
> 
> To make it a little easier to understand, extract that big functions
> into 4 parts:
> 
> 1) find_free_extent()
>    Do the block group iterations, still the main function.
> 
> 2) find_free_extent_clustered()
>    Do the clustered allocation and cluster refill if needed.
> 
> 3) find_free_extent_unclustered()
>    Do the unclustered allocation and free space cache update if needed.
> 
> 4) find_free_extent_update_loop()
>    Do the corner-case black magic handling, like allocating new chunk
>    and update loop condition.
> 
> Also, for internal communication, created a new internal structure
> find_free_extent_ctrl, to make the parameter list shorter for function
> 2~4.
> 
> Please note that this patch will try to avoid any functional/logical
> modification during the refactor, so still a lot of bad practice like in
> find_free_extent() we still use search/have_block_group/loop tags to
> implement a custom loop.
> 
> But at least, this should provide the basis for later cleanup.

I'd prefer to do the cleanup in smaller pieces, this patch is too big
for review.

> ---
> I know such large patch is not a good practice, and there is choice to
> split the patch into 4 patches (one patch for each helper function), but
> that will make later rebase more error prone since new function will never
> conflict with newer changes.

Small patches can be refreshed and updated easily, also each refresh
reviewed that the change is still correct.

The big blob patches are the worst thing one can find in git history,
hunting a clustered allocation bug and ending up in a cleanup patch. No
amount of written assurance or "it worked on my machine" can change
that.

Finding the right way to split the patch and isolate nice and reviewable
changes requires more thinking which is not a bad thing on itself.

I know everybody hates that because it's more work for them, but
consider the work on both sides.
