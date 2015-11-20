Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34655 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493AbbKTQJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 11:09:03 -0500
Received: by ioir85 with SMTP id r85so128165140ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 08:09:02 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <564B0F9C.6060707@googlemail.com>
References: <564B0F9C.6060707@googlemail.com>
Date: Fri, 20 Nov 2015 16:09:02 +0000
Message-ID: <CAL3q7H5obzQQ26658LXLXKLXDyAi0MsfGrrv4vAWKyZ0ML0cMw@mail.gmail.com>
Subject: Re: [PATCH] Fix balance regression in 4.4-rc
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 17, 2015 at 11:29 AM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> There's a regression in 4.4-rc since commit bc3094673f22
> (btrfs: extend balance filter usage to take minimum and maximum) in that
> existing (non-ranged) balance with -dusage=x no longer works; all chunks
> are skipped.
>
> After staring at the code for a while and wondering why a non-ranged
> balance would even need min and max thresholds (..which then were not
> set correctly, leading to the bug) I realized that the only problem
> was the fact that the filter functions were named wrong, thanks to
> patching copypasta. Simply renaming both functions lets the existing
> btrfs-progs call balance with -dusage=x and now the non-ranged filter
> function is invoked, properly using only a single chunk limit.
>
> Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
> Fixes: bc3094673f22 ("btrfs: extend balance filter usage to take minimum and maximum")

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Besides prefixing the title with "Btrfs: " as correctly pointed by
Duncan, a better title would be like "Btrfs: fix broken balance usage
filters", as it's a problem in the filters and not the balance code
itself.

Thanks for chasing and fixing this.

> ---
> --- linux-4.1.13/fs/btrfs/volumes.c     2015-11-16 22:34:27.475045363 +0100
> +++ linux-4.1.13-filters/fs/btrfs/volumes.c     2015-11-17 12:08:41.308898665 +0100
> @@ -3189,7 +3189,7 @@
>         return 1;
>  }
>
> -static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> +static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
>                               struct btrfs_balance_args *bargs)
>  {
>         struct btrfs_block_group_cache *cache;
> @@ -3222,7 +3222,7 @@
>         return ret;
>  }
>
> -static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info,
> +static int chunk_usage_filter(struct btrfs_fs_info *fs_info,
>                 u64 chunk_offset, struct btrfs_balance_args *bargs)
>  {
>         struct btrfs_block_group_cache *cache;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
