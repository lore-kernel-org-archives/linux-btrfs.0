Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34053 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751294AbdH0U3F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Aug 2017 16:29:05 -0400
Received: by mail-oi0-f65.google.com with SMTP id k77so4024477oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Aug 2017 13:29:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170827200616.17799-1-nefelim4ag@gmail.com>
References: <20170827200616.17799-1-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 27 Aug 2017 23:28:24 +0300
Message-ID: <CAGqmi77XA84Z=cF5Aa4y6dmtGh=Oypo3re1JB9m8cDTuSAwBzw@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-08-27 23:06 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> At now btrfs_dedupe_file_range() restricted to 16MiB range for
> limit locking time and memory requirement for dedup ioctl()
>
> For too big input rage code silently set range to 16MiB
>
> Let's remove that restriction by do iterating over dedup range.
> That's backward compatible and will not change anything for request
> less then 16MiB.
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ae8fbf9d3de2..7e77d192776f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3226,11 +3226,9 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
>         struct inode *src = file_inode(src_file);
>         struct inode *dst = file_inode(dst_file);
>         u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> +       u64 i, tail_len, chunk_count;
>         ssize_t res;
>
> -       if (olen > BTRFS_MAX_DEDUPE_LEN)
> -               olen = BTRFS_MAX_DEDUPE_LEN;
> -
>         if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
>                 /*
>                  * Btrfs does not support blocksize < page_size. As a
> @@ -3240,7 +3238,23 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
>                 return -EINVAL;
>         }
>
> -       res = btrfs_extent_same(src, loff, olen, dst, dst_loff);
> +       tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
> +       chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
> +
> +       for (i = 0; i < chunk_count; i++) {
> +               res = btrfs_extent_same(src, loff, BTRFS_MAX_DEDUPE_LEN,
> +                                       dst, dst_loff);
> +               if (res)
> +                       return res;
> +
> +               loff += BTRFS_MAX_DEDUPE_LEN;
> +               dst_loff += BTRFS_MAX_DEDUPE_LEN;
> +       }
> +
> +       if (tail_len > 0)
> +               res = btrfs_extent_same(src, loff, tail_len,
> +                                       dst, dst_loff);
> +
>         if (res)
>                 return res;
>         return olen;
> --
> 2.14.1

P.S.
Also, if that acceptable, it's possible to decrease BTRFS_MAX_DEDUPE_LEN
to 1MiB or 128KiB, if inode use compression to make
btrfs_extent_same() more time/cpu/lock/io сheap
-- 
Have a nice day,
Timofey.
