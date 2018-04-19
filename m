Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39911 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbeDSKTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 06:19:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 04685AEB8
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 10:19:24 +0000 (UTC)
Date: Thu, 19 Apr 2018 12:16:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Do super block verification before writing it
 to disk
Message-ID: <20180419101651.GZ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180419093816.888-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks good, some minor comments below. I'm wondering how to test that.
We'd have to inject either the corruption or to provide a way to
forcibly fail the test. For the latter a debugfs should do, I'll send
something for comments.

On Thu, Apr 19, 2018 at 05:38:16PM +0800, Qu Wenruo wrote:
> @@ -3563,6 +3565,12 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  	sb = fs_info->super_for_commit;
>  	dev_item = &sb->dev_item;
>  
> +	if (btrfs_check_super_valid(fs_info, sb, -1)) {

A comment that this is skipping the bytenr check would be good.

> +		btrfs_err(fs_info,
> +		"superblock corruption detected before transaction commitment");

                                                                   commit


> +		return -EUCLEAN;
> +	}
> +
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>  	head = &fs_info->fs_devices->devices;
>  	max_errors = btrfs_super_num_devices(fs_info->super_copy) - 1;
> @@ -3974,9 +3982,18 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
>  					      level, first_key);
>  }
>  
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
> +/*
> + * Check the validation of btrfs super block.
> + *
> + * @sb:			super block to check
> + * @super_mirror:	the super block number to check its bytenr.
> + * 			0 means the primary (1st) sb, 1 and 2 means 2nd and
> + * 			3rd backup sb, while -1 means to skip bytenr check.
> + */
> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> +				   struct btrfs_super_block *sb,
> +				   int super_mirror)
>  {
> -	struct btrfs_super_block *sb = fs_info->super_copy;
>  	u64 nodesize = btrfs_super_nodesize(sb);
>  	u64 sectorsize = btrfs_super_sectorsize(sb);
>  	int ret = 0;
> @@ -4019,7 +4036,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>  	 * Check sectorsize and nodesize first, other check will need it.
>  	 * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
>  	 */
> -	if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
> +	if (!is_power_of_2(sectorsize) || sectorsize < SZ_4K ||

No unrelated changes please. There are some remaining raw values, send a
separate patch if you want to convert them.

>  	    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>  		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
>  		ret = -EINVAL;
> @@ -4088,9 +4105,10 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>  		ret = -EINVAL;
>  	}
>  
> -	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
> -		btrfs_err(fs_info, "super offset mismatch %llu != %u",
> -			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
> +	if (super_mirror >= 0 && btrfs_super_bytenr(sb) !=
> +	    btrfs_sb_offset(super_mirror)) {
> +		btrfs_err(fs_info, "super offset mismatch %llu != %llu",
> +			btrfs_super_bytenr(sb), btrfs_sb_offset(super_mirror));
>  		ret = -EINVAL;
>  	}
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
