Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966698AbeEYPe3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 11:34:29 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70862AED4
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 15:34:28 +0000 (UTC)
Date: Fri, 25 May 2018 17:31:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] btrfs: Do super block verification before writing
 it to disk
Message-ID: <20180525153145.GO6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180525044325.3365-1-wqu@suse.com>
 <20180525044325.3365-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180525044325.3365-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 12:43:25PM +0800, Qu Wenruo wrote:
> Reported-by: Ken Swenson <flat@imo.uto.moe>
> Reported-by: Ben Parsons <9parsonsb@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b981ecc4b6f9..d6c0cee627d9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2610,6 +2610,41 @@ static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
>  	return __validate_super(fs_info, fs_info->super_copy, 0);
>  }
>  
> +/*
> + * Check the validation of super block at write time.
> + * Some checks like bytenr check will be skipped as their values will be
> + * overwritten soon.
> + * Extra checks like csum type and incompact flags will be executed here.
> + */
> +static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
> +				      struct btrfs_super_block *sb)
> +{
> +	int ret;
> +
> +	ret = __validate_super(fs_info, sb, -1);

Please note that the patches have been slightly updated in the committed
version. Updates to patches that come that late after the initial
iterations are more convenient as incremental updates.

> +	if (ret < 0)
> +		goto out;
> +	if (btrfs_super_csum_type(sb) != BTRFS_CSUM_TYPE_CRC32) {
> +		ret = -EUCLEAN;
> +		btrfs_err(fs_info, "invalid csum type, has %u want %u",
> +			  btrfs_super_csum_type(sb), BTRFS_CSUM_TYPE_CRC32);
> +		goto out;
> +	}
> +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
> +		ret = -EUCLEAN;
> +		btrfs_err(fs_info,
> +		"invalid incompact flags, has 0x%llu valid mask 0x%llu",
> +			  btrfs_super_incompat_flags(sb),
> +			  BTRFS_FEATURE_INCOMPAT_SUPP);
> +		goto out;
> +	}
> +out:
> +	if (ret < 0)
> +		btrfs_err(fs_info,
> +		"super block corruption detected before writing it to disk");
> +	return ret;
> +}
> +
>  int open_ctree(struct super_block *sb,
>  	       struct btrfs_fs_devices *fs_devices,
>  	       char *options)
> @@ -3770,6 +3805,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  		flags = btrfs_super_flags(sb);
>  		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
>  
> +		ret = btrfs_validate_write_super(fs_info, sb);
> +		if (ret < 0) {
> +			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +			btrfs_handle_fs_error(fs_info, -EUCLEAN,
> +				"unexpected superblock corruption detected");
> +			return -EUCLEAN;

The shortcut from here makes sense but we still have to wait for any
previous superblock writes that could have happened (write_dev_supers).

The sequence would be:

at device 1
	check sb
	write

at device 2
	check sb
	failed write

now the bh from device 1 write would have one more reference.

As the change is only in the 3rd patch, please send only that one and
based on the patch in misc-next. Thanks.

> +		}
> +
>  		ret = write_dev_supers(dev, sb, max_mirrors);

(Here the reference gets incremented.)
