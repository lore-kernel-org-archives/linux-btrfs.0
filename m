Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54244 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2Iz5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 03:55:57 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so11672812iea.19
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 00:55:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B6FB48.9060300@cn.fujitsu.com>
References: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
	<50B6FB48.9060300@cn.fujitsu.com>
Date: Thu, 29 Nov 2012 09:55:56 +0100
Message-ID: <CAB9VWqBGboHX0sWdOVGVpPg+9Ek3kFeepSc8V5wHAOr79msYpg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: send - pre-allocated file support for btrfs-send mechanism
From: Alexander Block <ablock84@gmail.com>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 29, 2012 at 7:06 AM, Chen Yang <chenyang.fnst@cn.fujitsu.com> wrote:
> From 4222aa3a32cf4db161fcbbb87ad29b714f1bfaf2 Mon Sep 17 00:00:00 2001
> From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
> Date: Thu, 29 Nov 2012 13:22:09 +0800
> Subject: [PATCH] Btrfs: send - pre-allocated file  support for btrfs-send
>  mechanism
>
> when send or receive a file which has pre-allocated part,
> the pre-allocated parts of the file will be sent as ZERO streams,
> and it's unnecessary.
>
> So we can improve this by skip these EMPTY parts.
>
> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
> ---
> this patch is based on
> "Btrfs: send - sparse file support for btrfs-send mechanism"
> ---
>  fs/btrfs/send.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 1e1d59a..2d23184 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3732,13 +3732,18 @@ static int send_write_or_clone(struct send_ctx *sctx,
>                  * sure to send the whole thing
>                  */
>                 len = PAGE_CACHE_ALIGN(len);
> -       } else {
> +       } else if (type == BTRFS_FILE_EXTENT_REG) {
>                 bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
>                 if (bytenr == 0) {
>                         ret = 0;
>                         goto out;
>                 }
>                 len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
> +       } else if (type == BTRFS_FILE_EXTENT_PREALLOC) {
> +               ret = 0;
> +               goto out;
> +       } else {
> +               BUG();
>         }
>
>         if (offset + len > sctx->cur_inode_size)
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The same as in my previous mail applies here.
