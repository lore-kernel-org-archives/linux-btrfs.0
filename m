Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35480 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbcEQMqN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 08:46:13 -0400
Received: by mail-io0-f195.google.com with SMTP id i75so3204819ioa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 05:46:13 -0700 (PDT)
Subject: Re: [RCF - PATCH] btrfs: do not ignore errors from primary superblock
To: Alex Lyakas <alex@zadarastorage.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7AF66DC0FE0640D1A4E007C4DAC16AC4@alyakaslap>
Cc: Ron Mandel <ron@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>,
        Shyam Kaushik <shyam@zadarastorage.com>,
        Lev Vainblat <lev@zadarastorage.com>,
        Yaron Presente <yaron@zadarastorage.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b361ded3-c5fe-0020-35d3-856c1b9d46de@gmail.com>
Date: Tue, 17 May 2016 08:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <7AF66DC0FE0640D1A4E007C4DAC16AC4@alyakaslap>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-17 07:24, Alex Lyakas wrote:
> RFC: This patch not for merging, but only for review and discussion.
>
> When mounting, we consider only the primary superblock on each device.
> But when writing the superblocks, we might silently ignore errors
> from the primary superblock, if we succeeded to write secondary
> superblocks. In such case, the primary superblock was not updated
> properly, and if we crash at this point, later mount will use
> an out-of-date superblock.
>
> This patch changes the behavior to NOT IGNORING any errors on the
> primary superblock,
> and IGNORING any errors on secondary superblocks. This way, we always
> insist on having
> an up-to-date primary superblock.
I don't entirely agree with this reasoning.  We absolutely should not be 
ignoring errors when writing to the primary superblock, but there is no 
reason we should be ignoring them when writing backup superblocks 
either.  Ideally, all superblocks should be up-to-date and consistent 
with each other, as we can't be certain which (if any) of them will be 
readable without errors the next time we mount the filesystem.  We can't 
really provide this consistency guarantee though, because of how modern 
storage devices work (we can't atomically update all three superblocks 
at the same time), but that doesn't mean we shouldn't retry writing a 
backup superblock if there's an error doing so the first time.
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 4e47849..0ae9f7c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3357,11 +3357,13 @@ static int write_dev_supers(struct btrfs_device
> *device,
>             bh = __find_get_block(device->bdev, bytenr / 4096,
>                           BTRFS_SUPER_INFO_SIZE);
>             if (!bh) {
> -                errors++;
> +                /* we only care about primary superblock errors */
> +                if (i == 0)
> +                    errors++;
>                 continue;
>             }
>             wait_on_buffer(bh);
> -            if (!buffer_uptodate(bh))
> +            if (!buffer_uptodate(bh) && i == 0)
>                 errors++;
>
>             /* drop our reference */
> @@ -3388,9 +3390,10 @@ static int write_dev_supers(struct btrfs_device
> *device,
>                       BTRFS_SUPER_INFO_SIZE);
>             if (!bh) {
>                 btrfs_err(device->dev_root->fs_info,
> -                    "couldn't get super buffer head for bytenr %llu",
> -                    bytenr);
> -                errors++;
> +                    "couldn't get super buffer head for bytenr %llu (sb
> copy %d)",
> +                    bytenr, i);
> +                if (i == 0)
> +                    errors++;
>                 continue;
>             }
>
> @@ -3413,10 +3416,10 @@ static int write_dev_supers(struct btrfs_device
> *device,
>             ret = btrfsic_submit_bh(WRITE_FUA, bh);
>         else
>             ret = btrfsic_submit_bh(WRITE_SYNC, bh);
> -        if (ret)
> +        if (ret && i == 0)
>             errors++;
>     }
> -    return errors < i ? 0 : -1;
> +    return errors ? -1 : 0;
> }
>
> /*
>
>
> P.S.: when reviewing the code of write_dev_supers(), I also noticed that
> when wait==0 and we hit an error in one __getblk(), then the caller
> (write_all_supers) will not properly wait for submitted buffer-heads to
> complete, and we won't do the additional "brelse(bh);", which wait==0
> case does. Is this a problem?

