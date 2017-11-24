Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751536AbdKXGxL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 01:53:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50AC5AC6F
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 06:53:10 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: Introduce macros to handle bytes and sector
 conversion
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171124041008.32656-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>
Date: Fri, 24 Nov 2017 08:53:09 +0200
MIME-Version: 1.0
In-Reply-To: <20171124041008.32656-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.11.2017 06:10, Qu Wenruo wrote:
> Since block I/O is always done in unit of 512 bytes, add BI_SECTOR_SIZE
> and BI_SECTOR_SHIFT macros and to_sector() and to_bytes() for later
> use.
> 
> Although the best position to define such things should be bvec.h, and
> to_sector() to_bytes() are also defined in device-mapper.h, there are
> a lot of code defining their own SECTOR_SIZE and to_bytes() in
> device-mapper is not using u64 (unsigned long long) but unsigned long,
> which doesn't fit btrfs usage.
> 
> So define btrfs' own macros and inlined converters.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8fc690384c58..8f6f57167661 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3734,4 +3734,17 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>  #endif
>  	return 0;
>  }
> +
> +#define BI_SECTOR_SHIFT		(9)
> +#define BI_SECTOR_SIZE		(1 << BI_SECTOR_SHIFT)
> +
> +static inline u64 to_bytes(sector_t n)
> +{
> +	return ((u64)n << BI_SECTOR_SHIFT);
> +}
> +
> +static inline sector_t to_sector(u64 n)
> +{
> +	return (n >> BI_SECTOR_SHIFT);
> +}

nit: I don't like the naming, I'd rather have something similar to what
xfs has for its conversion macros i.e:

XFS_FSS_TO_BB - filesystem sector to basic block (bb in this case is 512
bytes)

so why not - BTRFS_B_TO_BB or BTRFS_B_TO_S and BTRFS_S_TO_B. Or
something like that but just to_bytes and to_sector look a bit silly.
It's not a big paint point but more of a "let's get the good ideas from
other fsses"

>  #endif
> 
