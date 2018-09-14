Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726900AbeINVZc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:25:32 -0400
Date: Fri, 14 Sep 2018 18:10:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3.1 2/2] btrfs: Ensure btrfs_trim_fs can trim the whole
 fs
Message-ID: <20180914161021.GR5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180907061624.20604-1-wqu@suse.com>
 <20180907061624.20604-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180907061624.20604-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 02:16:24PM +0800, Qu Wenruo wrote:
> [BUG]
> fstrim on some btrfs only trims the unallocated space, not trimming any
> space in existing block groups.
> 
> [CAUSE]
> Before fstrim_range passed to btrfs_trim_fs(), it get truncated to
> range [0, super->total_bytes).
> So later btrfs_trim_fs() will only be able to trim block groups in range
> [0, super->total_bytes).
> 
> While for btrfs, any bytenr aligned to sector size is valid, since btrfs use
> its logical address space, there is nothing limiting the location where
> we put block groups.
> 
> For btrfs with routine balance, it's quite easy to relocate all
> block groups and bytenr of block groups will start beyond super->total_bytes.
> 
> In that case, btrfs will not trim existing block groups.
> 
> [FIX]
> Just remove the truncation in btrfs_ioctl_fitrim(), so btrfs_trim_fs()
> can get the unmodified range, which is normally set to [0, U64_MAX].
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Fixes: f4c697e6406d ("btrfs: return EINVAL if start > total_bytes in fitrim ioctl")
> Cc: <stable@vger.kernel.org> # v4.0+
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
