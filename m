Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35996 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752810AbdF0LAV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 07:00:21 -0400
Received: by mail-it0-f67.google.com with SMTP id 185so2321531itv.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 04:00:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20170621154624.28365-1-dsterba@suse.com>
References: <20170621154624.28365-1-dsterba@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 27 Jun 2017 12:00:14 +0100
Message-ID: <CAL3q7H6ncxZgaw2Y+G6y382Rq4kcFtEOPpyoJxYMBm5Gqq-9yg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix validation of XATTR_ITEM dir items
To: David Sterba <dsterba@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        suy.fnst@cn.fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 4:46 PM, David Sterba <dsterba@suse.com> wrote:
> The XATTR_ITEM is a type of a directory item so we use the common
> validator helper. We have to adjust the limits because of potential
> data_len (ie. the xattr value), which is otherwise 0 for other directory
> items.

Did you run fstests?

This breaks test btrfs/053, as changes to send.c that call this
validation function are meant to validate that we don't go beyond
boundaries either when reading the name or the value of a xattr - it's
a bit counter-intuitive since the name of the function refers to name
length validation only, but it was correct in the context of send at
least.

thanks

>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/dir-item.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 2b00dd746118..a48d496e63e4 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -498,6 +498,7 @@ bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
>  {
>         struct btrfs_fs_info *fs_info = leaf->fs_info;
>         struct btrfs_key key;
> +       struct btrfs_dir_item *di;
>         u32 read_start;
>         u32 read_end;
>         u32 item_start;
> @@ -515,8 +516,17 @@ bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
>         btrfs_item_key_to_cpu(leaf, &key, slot);
>
>         switch (key.type) {
> -       case BTRFS_DIR_ITEM_KEY:
>         case BTRFS_XATTR_ITEM_KEY:
> +               /*
> +                * XATTR_ITEM could contain data so the item_end would not
> +                * match read_end as for other item types. Artificially lower
> +                * the upper bound so we check just name_len. We have to trust
> +                * the data_len value here, but if it's too big the validation
> +                * fails so it's safer than increasing read_end.
> +                */
> +               di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
> +               item_end -= btrfs_dir_data_len(leaf, di);
> +       case BTRFS_DIR_ITEM_KEY:
>         case BTRFS_DIR_INDEX_KEY:
>                 size = sizeof(struct btrfs_dir_item);
>                 break;
> --
> 2.13.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
