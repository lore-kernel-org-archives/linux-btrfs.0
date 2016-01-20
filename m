Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33671 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbcATUsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 15:48:47 -0500
Received: by mail-io0-f194.google.com with SMTP id f81so2617814iof.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 12:48:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
References: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
Date: Wed, 20 Jan 2016 20:48:46 +0000
Message-ID: <CAL3q7H4P5t0X7mw-BSt5H2h2e1U15Y=Wyd5RjtJzqEhQs6ODpQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: Continue write in case of can_not_nocow
From: Filipe Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 6, 2016 at 11:00 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> btrfs failed in xfstests btrfs/080 with -o nodatacow.
>
> Can be reproduced by following script:
>   DEV=/dev/vdg
>   MNT=/mnt/tmp
>
>   umount $DEV &>/dev/null
>   mkfs.btrfs -f $DEV
>   mount -o nodatacow $DEV $MNT
>
>   dd if=/dev/zero of=$MNT/test bs=1 count=2048 &
>   btrfs subvolume snapshot -r $MNT $MNT/test_snap &
>   wait
>   --
>   We can see dd failed on NO_SPACE.
>
> Reason:
>   __btrfs_buffered_write should run cow write when no_cow impossible,
>   and current code is designed with above logic.
>   But check_can_nocow() have 2 type of return value(0 and <0) on
>   can_not_no_cow, and current code only continue write on first case,
>   the second case happened in doing subvolume.
>
> Fix:
>   Continue write when check_can_nocow() return 0 and <0.
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Could you please submit a test case for xfstests as well?
Thanks.

> ---
>  fs/btrfs/file.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 977e715..11fd981 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1516,27 +1516,24 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>
>                 reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
>
> -               if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> -                                            BTRFS_INODE_PREALLOC)) {
> -                       ret = check_can_nocow(inode, pos, &write_bytes);
> -                       if (ret < 0)
> -                               break;
> -                       if (ret > 0) {
> -                               /*
> -                                * For nodata cow case, no need to reserve
> -                                * data space.
> -                                */
> -                               only_release_metadata = true;
> -                               /*
> -                                * our prealloc extent may be smaller than
> -                                * write_bytes, so scale down.
> -                                */
> -                               num_pages = DIV_ROUND_UP(write_bytes + offset,
> -                                                        PAGE_CACHE_SIZE);
> -                               reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> -                               goto reserve_metadata;
> -                       }
> +               if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> +                                             BTRFS_INODE_PREALLOC)) &&
> +                   check_can_nocow(inode, pos, &write_bytes) > 0) {
> +                       /*
> +                        * For nodata cow case, no need to reserve
> +                        * data space.
> +                        */
> +                       only_release_metadata = true;
> +                       /*
> +                        * our prealloc extent may be smaller than
> +                        * write_bytes, so scale down.
> +                        */
> +                       num_pages = DIV_ROUND_UP(write_bytes + offset,
> +                                                PAGE_CACHE_SIZE);
> +                       reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> +                       goto reserve_metadata;
>                 }
> +
>                 ret = btrfs_check_data_free_space(inode, pos, write_bytes);
>                 if (ret < 0)
>                         break;
> --
> 1.8.5.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
