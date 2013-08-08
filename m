Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35928 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964997Ab3HHKZA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 06:25:00 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so616278bkb.35
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 03:24:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1375938259-5015-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1375938259-5015-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Date: Thu, 8 Aug 2013 11:24:59 +0100
Message-ID: <CAL3q7H77CCD9saViLZukwHtmi3=PHkxiOy4rc+z1ftvHfOuK=w@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: catch error return value from find_extent_in_eb()
From: Filipe David Manana <fdmanana@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 8, 2013 at 6:04 AM, Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
> find_extent_in_eb() may return ENOMEM, catch this error return value.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/backref.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 54e7610..f7781e6 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -934,6 +934,10 @@ again:
>                                 }
>                                 ret = find_extent_in_eb(eb, bytenr,
>                                                         *extent_item_pos, &eie);
> +                               if (ret) {
> +                                       free_extent_buffer(eb);
> +                                       goto out;
> +                               }
>                                 ref->inode_list = eie;
>                                 free_extent_buffer(eb);
>                         }

Hello, this is a duplicate of:  https://patchwork.kernel.org/patch/2835989/

thanks
