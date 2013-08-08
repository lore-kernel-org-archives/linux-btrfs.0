Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:51239 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061Ab3HHKz2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 06:55:28 -0400
Received: by mail-bk0-f45.google.com with SMTP id mx11so615207bkb.18
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 03:55:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1375959099-30488-1-git-send-email-sbehrens@giantdisaster.de>
References: <1375959099-30488-1-git-send-email-sbehrens@giantdisaster.de>
Date: Thu, 8 Aug 2013 11:55:26 +0100
Message-ID: <CAL3q7H7n4iisnZ7gmObEVVoskaX11Yv5cFfWn+=Tg-wK8sY+Cg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: fix a regression in mkfs.btrfs
From: Filipe David Manana <fdmanana@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 8, 2013 at 11:51 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> Commit 55061a98 adds a cut & paste error that makes mkfs.btrfs fail
> if leafsize != sectorsize.
>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  utils.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/utils.c b/utils.c
> index 15b991f..691b075 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -430,7 +430,7 @@ int make_btrfs(int fd, const char *device, const char *label,
>         ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
>         if (ret < 0)
>                 return -errno;
> -       else if (ret != leafsize)
> +       else if (ret != sectorsize)
>                 return -EIO;

Reviewed-by: Filipe Manana <fdmanana@gmail.com>

>
>         free(buf);
> --
> 1.8.3.4
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
