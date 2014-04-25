Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:64750 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaDYKvh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:51:37 -0400
Received: by mail-la0-f47.google.com with SMTP id pn19so2900943lab.6
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 03:51:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1398422643-6741-1-git-send-email-bo.li.liu@oracle.com>
References: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
	<1398422643-6741-1-git-send-email-bo.li.liu@oracle.com>
Date: Fri, 25 Apr 2014 11:51:36 +0100
Message-ID: <CAL3q7H6Lxjz8TkLkFXhwUas3VO75nRNuZfBpT2Ns8A2xOdjEQw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs-progs: set string end sing '\0' for property
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 11:44 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Set string "xattr_name" 's end with '\0' so that it won't be
> violated in memory.
>
> With this fix, xfstest/btrfs/048 can pass on my box.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Filipe Manana <fdmanana@gmail.com>

> ---
> v2: avoid buffer overflow of malloc().
>
>  props.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/props.c b/props.c
> index 9ff63ca..cc87454 100644
> --- a/props.c
> +++ b/props.c
> @@ -131,13 +131,14 @@ static int prop_compression(enum prop_object_type type,
>                 goto out;
>         }
>
> -       xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name));
> +       xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name) + 1);
>         if (!xattr_name) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
>         memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
>         memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
> +       xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
>
>         if (value)
>                 sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
> --
> 1.7.7
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
