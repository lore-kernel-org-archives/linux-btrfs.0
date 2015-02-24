Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33758 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbBXQBp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 11:01:45 -0500
Received: by lbvp9 with SMTP id p9so26005166lbv.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 08:01:43 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1424792249-26672-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1424792249-26672-1-git-send-email-zhaolei@cn.fujitsu.com>
Date: Tue, 24 Feb 2015 16:01:43 +0000
Message-ID: <CAL3q7H63LBgPvVcggR+fZ3KrfLWH8D7ZJDjUo_orqbrmTVmeNw@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: Remove BUG_ON() when failed searching
 block_group_cache in unpin_extent_range()
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2015 at 3:37 PM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> Above BUG_ON() was triggered only one time in my test, but hadn't
> happened again in same env.
>
> The reason maybe:
> A block group which include pinned space was removed before
> unpin_extent_range(), and no other block_group_cache after
> "start" pos, so the code entered into above BUG_ON().
>
> To support auto-remove-bgs, we can remove above BUG_ON(), and bypass
> removed bgs.

I don't think it's a good idea to remove this BUG_ON().
You're just hiding (potentially dangerous) logical bugs doing that -
we need to understand exactly why that happens and fix it.

I fixed a scenario where this happens recently, and the fix is in 4.0-rc1:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d4b450cd4b33ce7c572e7fdccf33b59c4cdf361c

Were you testing with or without this fix?

Thanks

>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8b51eb5..ef0b40d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5751,7 +5751,8 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end,
>                         if (cache)
>                                 btrfs_put_block_group(cache);
>                         cache = btrfs_lookup_block_group(fs_info, start);
> -                       BUG_ON(!cache); /* Logic error */
> +                       if (!cache)
> +                               break;
>                 }
>
>                 len = cache->key.objectid + cache->key.offset - start;
> --
> 1.8.5.1
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
