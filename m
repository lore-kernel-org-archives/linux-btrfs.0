Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:38336 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423963AbeCBKqs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 05:46:48 -0500
Received: by mail-vk0-f65.google.com with SMTP id s1so5492163vke.5
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Mar 2018 02:46:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180302052254.7059-3-wqu@suse.com>
References: <20180302052254.7059-1-wqu@suse.com> <20180302052254.7059-3-wqu@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 2 Mar 2018 10:46:46 +0000
Message-ID: <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 2, 2018 at 5:22 AM, Qu Wenruo <wqu@suse.com> wrote:
> Normally when specifying max_inline, we should normally limit it by
> uncompressed extent size, as it's the only thing user can control.

Why does it matter that users can control it? Will they write less (or
more) data to files because stuff won't get inlined?
Why do they care about stuff getting inlined or not? That's an
implementation detail of btrfs to speed up access to file data and
save some space.

> (Control the algorithm and compressed data is almost impossible)
>
> Since btrfs is providing *TRANSPARENT* compression, max_inline should
> behave the same for both plain and compress data.

Taking away the benefits of compression for. So now some cases that
ended up getting the benefits of inlining won't get them anymore.

I don't agree with this change.

>
> So this patch will use @inline_len instead of @data_len in
> cow_file_range_inline() so user will know their max_inline mount option
> works exactly the same for both plain and compressed data extent.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e1a7f3cb5be9..48472509239b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -303,7 +303,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
>             (!compressed_size &&
>             (actual_end & (fs_info->sectorsize - 1)) == 0) ||
>             end + 1 < isize ||
> -           data_len > fs_info->max_inline) {
> +           inline_len > fs_info->max_inline) {
>                 return 1;
>         }
>
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
