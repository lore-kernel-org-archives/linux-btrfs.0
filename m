Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37314 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2IJHYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 03:24:46 -0400
MIME-Version: 1.0
In-Reply-To: <504D8AEB.9090401@gmail.com>
References: <504D8AEB.9090401@gmail.com>
Date: Mon, 10 Sep 2012 01:24:45 -0600
Message-ID: <CAE5mzvih-huz__tw=QFaMHe8UD6Uajhez99hm6jEYvKUpdp_3A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix disk-io.c/btrfs_read_dev_super with
 BTRFS_SUPER_MIRROR_MAX to control the loops
From: cwillu <cwillu@cwillu.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2012 at 12:38 AM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> To check the duplicated super blocks, use BTRFS_SUPER_MIRROR_MAX
> as the loops limit.
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 22e98e0..a431144 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2723,7 +2723,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>          * So, we need to add a special mount option to scan for
>          * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>          */
> -       for (i = 0; i < 1; i++) {
> +       for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>                 bytenr = btrfs_sb_offset(i);
>                 if (bytenr + 4096 >= i_size_read(bdev->bd_inode))
>                         break;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Please fix the comment as well; if we check all the supers, then
mounting as btrfs _will_ succeed after a different (non-btrfs)
filesystem is created on the partition/device, pretty much
guaranteeing it will be corrupted.
