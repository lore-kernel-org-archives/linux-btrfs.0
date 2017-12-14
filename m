Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:37517 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdLNNhu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 08:37:50 -0500
Received: by mail-it0-f65.google.com with SMTP id d137so11146128itc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 05:37:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171214133546.28609-1-nefelim4ag@gmail.com>
References: <20171214133546.28609-1-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 14 Dec 2017 16:37:08 +0300
Message-ID: <CAGqmi76GhdUEJy=YxAN1RiZZkJeSoh6EYVO4RRp4n51Pge9ZZA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: make should_defrag_range() understood compressed extents
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Compile tested and "battle" tested

2017-12-14 16:35 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> Both, defrag ioctl and autodefrag - call btrfs_defrag_file()
> for file defragmentation.
>
> Kernel target extent size default is 256KiB
> Btrfs progs by default, use 32MiB.
>
> Both bigger then max (not fragmented) compressed extent size 128KiB.
> That lead to rewrite all compressed data on disk.
>
> Fix that and also make should_defrag_range() understood
> if requested target compression are same as current extent compression type.
> To avoid useless recompression of compressed extents.
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index be5bd81b3669..12d4fa5d6dec 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1008,7 +1008,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
>
>  static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
>                                u64 *last_len, u64 *skip, u64 *defrag_end,
> -                              int compress)
> +                              int compress, int compress_type)
>  {
>         struct extent_map *em;
>         int ret = 1;
> @@ -1043,8 +1043,29 @@ static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
>          * real extent, don't bother defragging it
>          */
>         if (!compress && (*last_len == 0 || *last_len >= thresh) &&
> -           (em->len >= thresh || (!next_mergeable && !prev_mergeable)))
> +           (em->len >= thresh || (!next_mergeable && !prev_mergeable))) {
>                 ret = 0;
> +               goto out;
> +       }
> +
> +
> +       /*
> +        * Try not recompress compressed extents
> +        * thresh >= BTRFS_MAX_UNCOMPRESSED will lead to
> +        * recompress all compressed extents
> +        */
> +       if (em->compress_type != 0 && thresh >= BTRFS_MAX_UNCOMPRESSED) {
> +               if (!compress) {
> +                       if (em->len == BTRFS_MAX_UNCOMPRESSED)
> +                               ret = 0;
> +               } else {
> +                       if (em->compress_type != compress_type)
> +                               goto out;
> +                       if (em->len == BTRFS_MAX_UNCOMPRESSED)
> +                               ret = 0;
> +               }
> +       }
> +
>  out:
>         /*
>          * last_len ends up being a counter of how many bytes we've defragged.
> @@ -1342,7 +1363,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>
>                 if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
>                                          extent_thresh, &last_len, &skip,
> -                                        &defrag_end, do_compress)){
> +                                        &defrag_end, do_compress,
> +                                        compress_type)){
>                         unsigned long next;
>                         /*
>                          * the should_defrag function tells us how much to skip
> --
> 2.15.1
>



-- 
Have a nice day,
Timofey.
