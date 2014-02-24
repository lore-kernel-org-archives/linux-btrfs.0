Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57410 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaBXXD4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 18:03:56 -0500
Received: by mail-ob0-f178.google.com with SMTP id va2so4808307obc.23
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 15:03:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393242914-21867-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1393242914-21867-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Date: Mon, 24 Feb 2014 17:03:55 -0600
Message-ID: <CAKcLGm8v=1JwxrJ4JAiiGoZLTLon-ttRzrVBTsHgf_U1Lx9_Ng@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: fsck: fix wrong return value in check_block()
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 5:55 AM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> We found btrfsck will output backrefs mismatch while the filesystem
> is defenitely ok.
>
> The problem is that check_block() don't return right value,which
> makes btrfsck won't walk all tree blocks thus we don't get a consistent
> filesystem, we will fail to check extent refs etc.
>
> Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index a2afae6..253569f 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2477,7 +2477,7 @@ static int check_block(struct btrfs_trans_handle *trans,
>         struct cache_extent *cache;
>         struct btrfs_key key;
>         enum btrfs_tree_block_status status;
> -       int ret = 1;
> +       int ret = 0;
>         int level;
>
>         cache = lookup_cache_extent(extent_cache, buf->start, buf->len);
> --

I tried this fix on a broken btrfs volume I've been trying to repair,
and it seemed to put me in an infinite loop.

I agree that something seems wrong with the way the caller of
check_block uses the return value, and I also noticed that it seemed
to exit before walking all the tree blocks.

But I think the problem is more subtle than flipping the default ret
value from 1 to 0.
