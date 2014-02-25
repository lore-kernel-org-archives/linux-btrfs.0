Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:47265 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaBYSjI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:39:08 -0500
Received: by mail-bk0-f43.google.com with SMTP id v15so371609bkz.16
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 10:39:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <6bb080ca89f018139b4cb6d515f93a2f23ed9b46.1393352970.git.dsterba@suse.cz>
References: <cover.1393352970.git.dsterba@suse.cz>
	<6bb080ca89f018139b4cb6d515f93a2f23ed9b46.1393352970.git.dsterba@suse.cz>
Date: Tue, 25 Feb 2014 18:39:06 +0000
Message-ID: <CAL3q7H6_mR9+cDR-sBF1ASmQNJct1KXgW3j-koUQ9sZ63_dqZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: send: fix old buffer length in fs_path_ensure_buf
From: Filipe David Manana <fdmanana@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 25, 2014 at 6:32 PM, David Sterba <dsterba@suse.cz> wrote:
> In "btrfs: send: lower memory requirements in common case" the code to
> save the old_buf_len was incorrectly moved to a wrong place and broke
> the original logic.
>
> Reported-by: Filipe David Manana <fdmanana@gmail.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Filipe David Manana <fdmanana@gmail.com>

Thanks David.

> ---
>  fs/btrfs/send.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index b6d416ce6b3b..613f4bc93571 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -288,6 +288,9 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
>         if (p->buf_len >= len)
>                 return 0;
>
> +       path_len = p->end - p->start;
> +       old_buf_len = p->buf_len;
> +
>         /*
>          * First time the inline_buf does not suffice
>          */
> @@ -310,9 +313,6 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
>                 p->buf_len = ksize(p->buf);
>         }
>
> -       path_len = p->end - p->start;
> -       old_buf_len = p->buf_len;
> -
>         if (p->reversed) {
>                 tmp_buf = p->buf + old_buf_len - path_len - 1;
>                 p->end = p->buf + p->buf_len - 1;
> --
> 1.7.9
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
