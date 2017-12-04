Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:39608 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbdLDOY0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 09:24:26 -0500
Received: by mail-it0-f68.google.com with SMTP id 68so6965213ite.4
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 06:24:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171023222948.10648-1-nefelim4ag@gmail.com>
References: <20171023222948.10648-1-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 4 Dec 2017 17:23:45 +0300
Message-ID: <CAGqmi76U11jLP8H9cdfFXQHpOom7H=6nBBv347oikPXKjc=B5g@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: compress_file_range() change page dirty status once
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gentle ping

2017-10-24 1:29 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> We need to call extent_range_clear_dirty_for_io()
> on compression range to prevent application from changing
> page content, while pages compressing.
>
> extent_range_clear_dirty_for_io() run on each loop iteration,
> "(end - start)" can be much (up to 1024 times) bigger
> then compression range (BTRFS_MAX_UNCOMPRESSED).
>
> That produce extra calls to page managment code.
>
> Fix that behaviour by call extent_range_clear_dirty_for_io()
> only once.
>
> v1 -> v2:
>  - Make that more obviously and more safeprone
>
> v2 -> v3:
>  - Rebased on:
>    Btrfs: compress_file_range() remove dead variable num_bytes
>  - Update change log
>  - Add comments
>
> v3 -> v4:
>  - Rebased on: kdave for-next
>  - To avoid dirty bit clear/set behaviour change
>    call clear_bit once, istead of per compression range
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/inode.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b93fe05a39c7..5816dd3cb6e6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -536,8 +536,10 @@ static noinline void compress_file_range(struct inode *inode,
>                  * If the compression fails for any reason, we set the pages
>                  * dirty again later on.
>                  */
> -               extent_range_clear_dirty_for_io(inode, start, end);
> -               redirty = 1;
> +               if (!redirty) {
> +                       extent_range_clear_dirty_for_io(inode, start, end);
> +                       redirty = 1;
> +               }
>
>                 /* Compression level is applied here and only here */
>                 ret = btrfs_compress_pages(
> --
> 2.14.2



-- 
Have a nice day,
Timofey.
