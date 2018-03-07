Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933442AbeCGPdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:33:37 -0500
Date: Wed, 7 Mar 2018 16:31:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: Add nossd_spread mount option
Message-ID: <20180307153116.GF23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180221233140.23196-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180221233140.23196-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 03:31:40PM -0800, Howard McLauchlan wrote:
> Btrfs has two mount options for SSD optimizations: ssd and ssd_spread.
> Presently there is an option to disable all SSD optimizations, but there
> isn't an option to disable just ssd_spread.
> 
> This patch adds a mount option nossd_spread that disables ssd_spread
> only.
> 
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> ---
>  fs/btrfs/super.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 6e71a2a78363..4c0fcf5b3e7e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -310,10 +310,10 @@ static void btrfs_put_super(struct super_block *sb)
>  enum {
>  	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
>  	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
> -	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
> -	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
> -	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
> -	Opt_space_cache, Opt_space_cache_version, Opt_clear_cache,
> +	Opt_nossd, Opt_ssd_spread, Opt_nossd_spread, Opt_thread_pool, Opt_noacl,
> +	Opt_compress, Opt_compress_type, Opt_compress_force,
> +	Opt_compress_force_type, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
> +	Opt_discard, Opt_space_cache, Opt_space_cache_version, Opt_clear_cache,
>  	Opt_user_subvol_rm_allowed, Opt_enospc_debug, Opt_subvolrootid,
>  	Opt_defrag, Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
>  	Opt_skip_balance, Opt_check_integrity,
> @@ -353,6 +353,7 @@ static const match_table_t tokens = {
>  	{Opt_ssd, "ssd"},
>  	{Opt_ssd_spread, "ssd_spread"},
>  	{Opt_nossd, "nossd"},
> +	{Opt_nossd_spread, "nossd_spread"},
>  	{Opt_acl, "acl"},
>  	{Opt_noacl, "noacl"},
>  	{Opt_notreelog, "notreelog"},
> @@ -582,6 +583,10 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			btrfs_clear_and_info(info, SSD_SPREAD,
>  					     "not using spread ssd allocation scheme");
>  			break;
> +		case Opt_nossd_spread:
> +			btrfs_clear_and_info(info, SSD_SPREAD,
> +					     "not using spread ssd allocation scheme");

The message is the same as above adn the 2 cases can be merged.

> +			break;
>  		case Opt_barrier:
>  			btrfs_clear_and_info(info, NOBARRIER,
>  					     "turning on barriers");
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
