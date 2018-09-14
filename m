Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbeINVMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:12:40 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91559AD65
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 15:57:32 +0000 (UTC)
Date: Fri, 14 Sep 2018 17:57:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 1/2] btrfs: Enhance btrfs_trim_fs function to handle
 error better
Message-ID: <20180914155732.GP5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180907061624.20604-1-wqu@suse.com>
 <20180907061624.20604-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180907061624.20604-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 02:16:23PM +0800, Qu Wenruo wrote:
> Function btrfs_trim_fs() doesn't handle errors in a consistent way, if
> error happens when trimming existing block groups, it will skip the
> remaining blocks and continue to trim unallocated space for each device.
> 
> And the return value will only reflect the final error from device
> trimming.
> 
> This patch will fix such behavior by:
> 
> 1) Recording last error from block group or device trimming
>    So return value will also reflect the last error during trimming.
>    Make developer more aware of the problem.
> 
> 2) Continuing trimming if we can
>    If we failed to trim one block group or device, we could still try
>    next block group or device.
> 
> 3) Report number of failures during block group and device trimming
>    So it would be less noisy, but still gives user a brief summary of
>    what's going wrong.
> 
> Such behavior can avoid confusion for case like failure to trim the
> first block group and then only unallocated space is trimmed.
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> -			ret = btrfs_trim_block_group(cache,
> -						     &group_trimmed,
> -						     start,
> -						     end,
> -						     range->minlen);
> +			ret = btrfs_trim_block_group(cache, &group_trimmed,
> +						start, end, range->minlen);

No unrealted changes please, this just reformats the argument list.
