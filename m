Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54360 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaALPgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 10:36:08 -0500
Received: by mail-bk0-f45.google.com with SMTP id v16so318430bkz.4
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 07:36:06 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1389533914-2272-4-git-send-email-wangshilong1991@gmail.com>
References: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
	<1389533914-2272-4-git-send-email-wangshilong1991@gmail.com>
Date: Sun, 12 Jan 2014 15:36:06 +0000
Message-ID: <CAL3q7H66_b9qZFtT6sU7Ao0-xGbQJncmGFJ8h6x=8jHF9uMpUw@mail.gmail.com>
Subject: Re: [PATCH 3/3] Btrfs: fix missing inline refs when walking backrefs
From: Filipe David Manana <fdmanana@gmail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 12, 2014 at 1:38 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> If @slot=0, we may have an expected item in the previous leaf,
> So we should handle that case, otherwise, we will miss inline refs
> ,fix it.

Hi Shilong.

How can this happen exactly?

So the search key, regardless of having an BTRFS_EXTENT_ITEM_KEY or  a
BTRFS_METADATA_ITEM_KEY type, always has an offset set to (u64)-1.
This means the btrfs_search_slot call will always return 1 (not found,
as expected) or an error.

And btrfs_search_slot, when it doesn't find a key and if that key
should be the first item in a leaf, it makes the path point to the
previous leaf with a "path->slots[0] ==
btrfs_header_nritems(path->nodes[0])" (see [1]), otherwise to some
value > 0. The only cases I can imagine getting "path->slots[0] == 0"
is if we hit the first, i.e. left most, leaf in the btree or if the
btree consists only of 1 leaf (no nodes) - in these cases there's
isn't a previous leaf.

Did I miss something here?

thanks

[1] - https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/ctree.c?id=refs/tags/v3.13-rc8#n2629

>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/backref.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 964679c..4ccd726 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -893,14 +893,13 @@ again:
>                 spin_unlock(&delayed_refs->lock);
>         }
>
> -       if (path->slots[0]) {
> -               struct extent_buffer *leaf;
> -               int slot;
> +       ret = btrfs_previous_extent_item(fs_info->extent_root, path,
> +                                        key.objectid);
> +       if (ret < 0)
> +               goto out;
>
> -               path->slots[0]--;
> -               leaf = path->nodes[0];
> -               slot = path->slots[0];
> -               btrfs_item_key_to_cpu(leaf, &key, slot);
> +       if (ret == 0) {
> +               btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>                 if (key.objectid == bytenr &&
>                     (key.type == BTRFS_EXTENT_ITEM_KEY ||
>                      key.type == BTRFS_METADATA_ITEM_KEY)) {
> --
> 1.8.4
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
