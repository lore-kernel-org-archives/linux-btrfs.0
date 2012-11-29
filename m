Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40975 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2K2Iyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 03:54:50 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so11671816iea.19
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 00:54:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
References: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Date: Thu, 29 Nov 2012 09:54:49 +0100
Message-ID: <CAB9VWqASM9E4pwbJbgFC4ZQFSJxbpYMrV-Opn73CyuZk_FDXrg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: send - sparse file support for btrfs-send mechanism
From: Alexander Block <ablock84@gmail.com>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 29, 2012 at 4:11 AM, Chen Yang <chenyang.fnst@cn.fujitsu.com> wrote:
> when send/receive a sparse file, the holes of the original file
> will be filled with zero. The holes will be sent as ZERO streams,
> and it's unnecessary.
>
> So, I improved this by skipping the hole of file while sending.
>
> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/send.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e78b297..1e1d59a 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3718,6 +3718,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
>         u64 pos = 0;
>         u64 len;
>         u32 l;
> +       u64 bytenr;
>         u8 type;
>
>         ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
> @@ -3732,6 +3733,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
>                  */
>                 len = PAGE_CACHE_ALIGN(len);
>         } else {
> +               bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
> +               if (bytenr == 0) {
> +                       ret = 0;
> +                       goto out;
> +               }
>                 len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
>         }
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This won't work for incremental sends if I understand it correctly. If
the hole got punched into the file after the initial send, the data
will be unchanged on the receiving side when receiving incrementally.
