Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38828 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaQAM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 12:00:12 -0400
Subject: Re: [PATCH] btrfs: drop the nossd flag when remounting with -o ssd
To: Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
References: <0939c5df-3abd-ec68-16ef-538ad04251aa@mendix.com>
 <20170331151904.4091-1-kilobyte@angband.pl>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b289c1a8-d0d4-c147-ca65-7c954f05a7e5@mendix.com>
Date: Fri, 31 Mar 2017 18:00:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170331151904.4091-1-kilobyte@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/31/2017 05:19 PM, Adam Borowski wrote:
> The opposite case was already handled right in the very next switch entry.
> 
> Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> Not sure if setting NOSSD should also disable SSD_SPREAD, there's currently
> no way to disable that option once set.
> 
>  fs/btrfs/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 06bd9b332e18..7342399951ad 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -549,11 +549,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  		case Opt_ssd:
>  			btrfs_set_and_info(info, SSD,
>  					   "use ssd allocation scheme");
> +			btrfs_clear_opt(info->mount_opt, NOSSD);
>  			break;
>  		case Opt_ssd_spread:
>  			btrfs_set_and_info(info, SSD_SPREAD,
>  					   "use spread ssd allocation scheme");
>  			btrfs_set_opt(info->mount_opt, SSD);
> +			btrfs_clear_opt(info->mount_opt, NOSSD);
>  			break;
>  		case Opt_nossd:
>  			btrfs_set_and_info(info, NOSSD,

How did you test this?

This was also my first thought, but here's a weird thing:

-# mount -o nossd /dev/sdx /mnt/btrfs/

BTRFS info (device sdx): not using ssd allocation scheme

-# mount -o remount,ssd /mnt/btrfs/

BTRFS info (device sdx): use ssd allocation scheme

-# mount -o remount,nossd /mnt/btrfs/

BTRFS info (device sdx): use ssd allocation scheme

That means that the case Opt_nossd: is never reached when doing this?

And... what should be the result of doing:
-# mount -o remount,nossd,ssd /mnt/btrfs/

I guess it should be that the last one in the sequence wins?

The fact that nossd,ssd,ssd_spread are different options complicates the
whole thing, compared to e.g. autodefrag, noautodefrag.

-- 
Hans van Kranenburg
