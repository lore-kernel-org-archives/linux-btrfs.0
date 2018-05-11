Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:43242 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbeEKQZv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 12:25:51 -0400
Received: by mail-ua0-f196.google.com with SMTP id d4-v6so3972018ual.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 09:25:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180511155754.27084-1-dsterba@suse.com>
References: <20180511155754.27084-1-dsterba@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 11 May 2018 17:25:50 +0100
Message-ID: <CAL3q7H7=hGCnbsVvst-+shPj3rNqkkNZkr1kQaSjB4miTr_4mA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use kvzalloc for EXTENT_SAME temporary data
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 4:57 PM, David Sterba <dsterba@suse.com> wrote:
> The dedupe range is 16 MiB, with 4KiB pages and 8 byte pointers, the
> arrays can be 32KiB large. To avoid allocation failures due to
> fragmented memory, use the allocation with fallback to vmalloc.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>
> This depends on the patches that remove the 16MiB restriction in the
> dedupe ioctl, but contextually can be applied to the current code too.
>
> https://patchwork.kernel.org/patch/10374941/
>
>  fs/btrfs/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b572e38b4b64..a7f517009cd7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3178,8 +3178,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>          * locking. We use an array for the page pointers. Size of the array is
>          * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
>          */
> -       cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> -       cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> +       cmp.src_pages = kvzalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> +       cmp.dst_pages = kvzalloc(num_pages, sizeof(struct page *), GFP_KERNEL);

Kvzalloc should take 2 parameters and not 3.
Also, aren't the corresponding kvfree() calls missing?

>         if (!cmp.src_pages || !cmp.dst_pages) {
>                 kfree(cmp.src_pages);
>                 kfree(cmp.dst_pages);
> --
> 2.16.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
