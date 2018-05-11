Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35517 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751649AbeEKJos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 05:44:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 60492ADA1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 09:44:46 +0000 (UTC)
Date: Fri, 11 May 2018 11:42:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] btrfs: Do super block verification before writing
 it to disk
Message-ID: <20180511094208.GP6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511053527.28378-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:35:27PM +0800, Qu Wenruo wrote:
> There are already 2 reports about strangely corrupted super blocks,
> where csum still matches but extra garbage gets slipped into super block.
> 
> The corruption would looks like:
> ------
> superblock: bytenr=65536, device=/dev/sdc1
> ---------------------------------------------------------
> csum_type               41700 (INVALID)
> csum                    0x3b252d3a [match]
> bytenr                  65536
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> ...
> incompat_flags          0x5b22400000000169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA |
>                           unknown flag: 0x5b22400000000000 )
> ...
> ------
> Or
> ------
> superblock: bytenr=65536, device=/dev/mapper/x
> ---------------------------------------------------------
> csum_type              35355 (INVALID)
> csum_size              32
> csum                   0xf0dbeddd [match]
> bytenr                 65536
> flags                  0x1
>                        ( WRITTEN )
> magic                  _BHRfS_M [match]
> ...
> incompat_flags         0x176d200000000169
>                        ( MIXED_BACKREF |
>                          COMPRESS_LZO |
>                          BIG_METADATA |
>                          EXTENDED_IREF |
>                          SKINNY_METADATA |
>                          unknown flag: 0x176d200000000000 )
> ------
> 
> Obviously, csum_type and incompat_flags get some garbage, but its csum
> still matches, which means kernel calculates the csum based on corrupted
> super block memory.
> And after manually fixing these values, the filesystem is completely
> healthy without any problem exposed by btrfs check.
> 
> Although the cause is still unknown, at least detect it and prevent further
> corruption.
> 
> Reported-by: Ken Swenson <flat@imo.uto.moe>
> Reported-by: Ben Parsons <9parsonsb@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b981ecc4b6f9..985695074c51 100644
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

I think you need (unsigned long long) here as
BTRFS_FEATURE_INCOMPAT_SUPP do not have a type. I'll fix that.

Reviewed-by: David Sterba <dsterba@suse.com>
