Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63775 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3LNOyR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 09:54:17 -0500
Received: by mail-bk0-f41.google.com with SMTP id v15so1773791bkz.14
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 06:54:15 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1387006051-17067-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1387006051-17067-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Date: Sat, 14 Dec 2013 14:54:15 +0000
Message-ID: <CAL3q7H64Eo=afiu_RxEBSFafM1wOoVPUOJNVmrj80kArafdk+A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix a warning when iput a file
From: Filipe David Manana <fdmanana@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 14, 2013 at 7:27 AM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> See the warning below:
>
> [ 1209.102076]  [<ffffffffa04721b9>] remove_extent_mapping+0x69/0x70 [btrfs]
> [ 1209.102084]  [<ffffffffa0466b06>] btrfs_evict_inode+0x96/0x4d0 [btrfs]
> [ 1209.102089]  [<ffffffff81073010>] ? wake_atomic_t_function+0x40/0x40
> [ 1209.102092]  [<ffffffff8118ab2e>] evict+0x9e/0x190
> [ 1209.102094]  [<ffffffff8118b313>] iput+0xf3/0x180
> [ 1209.102101]  [<ffffffffa0461fd1>] btrfs_run_delayed_iputs+0xb1/0xd0 [btrfs]
> [ 1209.102107]  [<ffffffffa045d358>] __btrfs_end_transaction+0x268/0x350 [btrfs]
>
> clear extent bit here to avoid triggering WARN_ON() in remove_extent_mapping()
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Thank you Wang for reporting and fix attempt.
While this removes the warning about the pinned flag, it will cause
another warning later. See the patch I just sent as an alternative:

https://patchwork.kernel.org/patch/3348711/

Do you agree?

Also, can you easily trigger that warning, what are the steps to
trigger it? I haven't found yet a way to trigger it.
And did you got one for the logging flag too?

thanks

> ---
>  fs/btrfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e889779..c0f0f9d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4515,6 +4515,8 @@ static void evict_inode_truncate_pages(struct inode *inode)
>
>                 node = rb_first(&map_tree->map);
>                 em = rb_entry(node, struct extent_map, rb_node);
> +               clear_bit(EXTENT_FLAG_PINNED, &em->flags);
> +               clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
>                 remove_extent_mapping(map_tree, em);
>                 free_extent_map(em);
>         }
> --
> 1.8.3.1
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
