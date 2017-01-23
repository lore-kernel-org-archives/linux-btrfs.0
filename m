Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37167 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750948AbdAWR2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 12:28:54 -0500
Date: Mon, 23 Jan 2017 18:28:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/6] btrfs-progs: utils: Introduce basic set
 operations for range
Message-ID: <20170123172835.GO11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161219065642.25078-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219065642.25078-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 02:56:38PM +0800, Qu Wenruo wrote:
> Introduce basic set operations: is_subset() and is_intersection().
> 
> This is quite useful to check if a range [start, start + len) subset or
> intersection of another range.
> So we don't need to use open code to do it, which I sometimes do it
> wrong.
> 
> Also use these new facilities in btrfs-convert, to check if a range is a
> subset or intersects with btrfs convert reserved ranges.

I see the range helpers used only inside convert so I don't think we
need to export them into utils. Then you could introduce a helper
structure with start and len members and use that instead of 2 arrays

> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -97,11 +97,16 @@ enum btrfs_read_sb_flags {
>  	SBREAD_PARTIAL		= (1 << 1),
>  };
>  
> +/*
> + * Use macro to define mirror super block position
> + * So we can use it in static array initializtion
> + */
> +#define BTRFS_SB_MIRROR_OFFSET(mirror)	((u64)(16 * 1024) << \
> +					 (BTRFS_SUPER_MIRROR_SHIFT * (mirror)))

This is unrelated change and should go separately.

>  static inline u64 btrfs_sb_offset(int mirror)
>  {
> -	u64 start = 16 * 1024;
>  	if (mirror)
> -		return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
> +		return BTRFS_SB_MIRROR_OFFSET(mirror);
>  	return BTRFS_SUPER_INFO_OFFSET;
>  }
>  
