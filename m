Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:35041 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbeCHS4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 13:56:36 -0500
Received: by mail-pl0-f66.google.com with SMTP id w22-v6so3821962pll.2
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 10:56:36 -0800 (PST)
Date: Thu, 8 Mar 2018 10:56:33 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2] btrfs: Add nossd_spread mount option
Message-ID: <20180308185633.GA11506@vader.DHCP.thefacebook.com>
References: <20180308184848.12877-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180308184848.12877-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 10:48:48AM -0800, Howard McLauchlan wrote:
> Btrfs has two mount options for SSD optimizations: ssd and ssd_spread.
> Presently there is an option to disable all SSD optimizations, but there
> isn't an option to disable just ssd_spread.
> 
> This patch adds a mount option nossd_spread that disables ssd_spread
> only.
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> ---
> V2:remove duplicate code with fallthrough
> Based on 4.16-rc4
> 
>  fs/btrfs/super.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4b817947e00f..5bfcbf6f7eea 100644
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
> @@ -579,6 +580,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			btrfs_set_opt(info->mount_opt, NOSSD);
>  			btrfs_clear_and_info(info, SSD,
>  					     "not using ssd optimizations");
> +			/* Fallthrough */
> +		case Opt_nossd_spread:
>  			btrfs_clear_and_info(info, SSD_SPREAD,
>  					     "not using spread ssd allocation scheme");
>  			break;
> -- 
> 2.14.1
> 
