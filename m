Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50199 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933734AbeDXNRG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:17:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C20CADE7
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:17:05 +0000 (UTC)
Date: Tue, 24 Apr 2018 15:14:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] btrfs: Do super block verification before writing
 it to disk
Message-ID: <20180424131431.GE21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424044809.29838-5-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 12:48:09PM +0800, Qu Wenruo wrote:
> -static int btrfs_validate_super(struct btrfs_fs_info *fs_info)
> +/*
> + * Check the validation of btrfs super block.
> + *
> + * @sb:			super block to check
> + * @super_mirror:	the super block number to check its bytenr.
> + * 			0 means the primary (1st) sb, 1 and 2 means 2nd and
> + * 			3rd backup sb, while -1 means to skip bytenr check.

Please format the values like:

/*
 * Check the validity of btrfs super block
 *
 * @sb:                        super block to check
 * @super_mirror:      the super block number to check its bytenr:
 *                     0 means the primary (1st) sb,
 *                     1 and 2 means 2nd and 3rd backup copy
 *                     -1 means to skip bytenr check
 */

> + */
> +static int btrfs_validate_super(struct btrfs_fs_info *fs_info,
> +				struct btrfs_super_block *sb,
> +				int super_mirror)
>  {
> -	struct btrfs_super_block *sb = fs_info->super_copy;
>  	u64 nodesize = btrfs_super_nodesize(sb);
>  	u64 sectorsize = btrfs_super_sectorsize(sb);
>  	int ret = 0;
> @@ -4088,9 +4109,10 @@ static int btrfs_validate_super(struct btrfs_fs_info *fs_info)
>  		ret = -EINVAL;
>  	}
>  
> -	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
> -		btrfs_err(fs_info, "super offset mismatch %llu != %u",
> -			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
> +	if (super_mirror >= 0 && btrfs_super_bytenr(sb) !=
> +	    btrfs_sb_offset(super_mirror)) {

The preferred condition split is after the operators, not in the middle
of the expression. Like this:

	if (super_mirror >= 0 &&
	    btrfs_super_bytenr(sb) != btrfs_sb_offset(super_mirror)) {
