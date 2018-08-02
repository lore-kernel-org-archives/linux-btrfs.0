Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727079AbeHBScF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 14:32:05 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01B3AAD4C
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Aug 2018 16:40:09 +0000 (UTC)
Date: Thu, 2 Aug 2018 18:40:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs: Enhanced validation check for fuzzed images
Message-ID: <20180802164004.GR3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180801023721.32143-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180801023721.32143-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2018 at 10:37:15AM +0800, Qu Wenruo wrote:
> The branch can be fetched from the following git repo:
> https://github.com/adam900710/linux/tree/tree_checker_enhance
> 
> It's based on v4.18-rc1, with 3 patches already merged into misc-next.
> 
> This patchset introduced the following enhanced validation check:
> 1) chunk/block group/dev extent cross check
>    Unlike extent tree, such cross check can be implemented pretty easy
>    with minimal mount time impact.
>    Now the kernel could do chunk/bg/dev extent check as good as btrfs
>    check.
> 
> 2) Locking test to avoid possible deadlock due to extent tree corruption
>    Unfortunately, for extent tree we can't do really much cross check.
>    Instead we use the selftest from btrfs_tree_lock() to detect and
>    avoid deadlock caused by corrupted extent tree.

Great, thanks.

> The 3rd patch "btrfs: Remove unused function btrfs_account_dev_extents_size()"
> has also been merged into misc-next.
> 
> changelog:
> v2:
>   Added reviewed-by tags from Gu and Nikolay.
>   Address comment from David for the 4th patch
>   Address comment from Gu for the 2nd patch.

Please rather write what did you fix and not who suggested that. There
are many patches and iterations and I don't remember everything.

> 
> Qu Wenruo (6):
>   btrfs: Check each block group has corresponding chunk at mount time
>   btrfs: Verify every chunk has corresponding block group at mount time
>   btrfs: Remove unused function btrfs_account_dev_extents_size()
>   btrfs: Introduce mount time chunk <-> dev extent mapping check
>   btrfs: Exit gracefully when failed to add chunk map

The above merged, with some adjustments of changelogs or the error
messages.

>   btrfs: locking: Allow btrfs_tree_lock() to return error to avoid
>     deadlock

I need to read and understand the explanation you posted, so this patch
is not in misc-next, I'll add it to for-next after I'll do the first
pass review.
