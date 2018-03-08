Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:45456 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbeCHP0M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 10:26:12 -0500
Received: by mail-vk0-f66.google.com with SMTP id k187so16122vke.12
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 07:26:12 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <0792f4331c42c57426d02f897bc68b7c7820219a.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com> <0792f4331c42c57426d02f897bc68b7c7820219a.1520518876.git.dsterba@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 8 Mar 2018 15:26:11 +0000
Message-ID: <CAL3q7H5ozx0vyDQxY+H7JJNRu2JhuKmR+QS2MLYpXO9=BMjtZQ@mail.gmail.com>
Subject: Re: [PATCH 18/22] btrfs: move allocation after simple tests in tree_mod_log_insert_key
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 8, 2018 at 2:33 PM, David Sterba <dsterba@suse.com> wrote:
> The allocation of tree_mod_elem can be delayed after tree_mod_dont_log.
> In case it causes the function to return, the allocation would be
> redundant. Otherwise it could cause unnecessary failure if there's not
> enough memory.

Nop, the allocation must be made before calling tree_mod_dont_log(),
as that function acquires a write lock.
That's why there's a call to tree_mod_need_log() before the allocation
and a call to tree_mod_dont_log() after (they do the same checks).


>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 30950439731e..da6e2c3ca2d0 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -521,15 +521,13 @@ static noinline int tree_mod_log_insert_key(struct extent_buffer *eb, int slot,
>         if (!tree_mod_need_log(eb->fs_info, eb))
>                 return 0;
>
> +       if (tree_mod_dont_log(eb->fs_info, eb))
> +               return 0;
> +
>         tm = alloc_tree_mod_elem(eb, slot, op, flags);
>         if (!tm)
>                 return -ENOMEM;
>
> -       if (tree_mod_dont_log(eb->fs_info, eb)) {
> -               kfree(tm);
> -               return 0;
> -       }
> -
>         ret = __tree_mod_log_insert(eb->fs_info, tm);
>         write_unlock(&eb->fs_info->tree_mod_log_lock);
>         if (ret)
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
