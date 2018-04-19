Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbeDSKME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 06:12:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72ECEAC43
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 10:12:03 +0000 (UTC)
Date: Thu, 19 Apr 2018 12:09:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: Add csum type check for
 btrfs_check_super_valid()
Message-ID: <20180419100931.GY21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180419093816.888-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 05:38:15PM +0800, Qu Wenruo wrote:
> Just like incompat flags check, although we have already done super csum
> type check before calling btrfs_check_super_valid(), we can still add
> such check for later write time check.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index ec123158f051..b189ec086bc2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3981,6 +3981,15 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>  	u64 sectorsize = btrfs_super_sectorsize(sb);
>  	int ret = 0;
>  
> +	/*
> +	 * For write time check, as for mount time we have checked csum before
> +	 * calling btrfs_check_super_valid(), so it must be a corruption
> +	 */
> +	if (btrfs_super_csum_type(sb) >= ARRAY_SIZE(btrfs_csum_sizes)) {
> +		btrfs_err(fs_info, "corrupted csum type %u",
> +			  btrfs_super_csum_type(sb));
> +		ret = -EINVAL;
> +	}
>  	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {

The test for magic should be IMO the first one, that's how the
filesystem type is identified before anything else. Granted that the
magic must be correct before it can be even mounted, but the code should
follow that logic too. Otherwise ok.
