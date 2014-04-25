Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34003 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaDYKHu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:07:50 -0400
Received: by mail-la0-f44.google.com with SMTP id b8so2962649lan.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 03:07:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
References: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
Date: Fri, 25 Apr 2014 11:07:49 +0100
Message-ID: <CAL3q7H5jR5xDWi=jKTu_HthUpjzp9hFEByueXBru0Edj=o1o6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: set string end sing '\0' for property
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 7:29 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Set string "xattr_name" 's end with '\0' so that it won't be
> violated in memory.
>
> With this fix, xfstest/btrfs/048 can pass on my box.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  props.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/props.c b/props.c
> index 4d0aeea..53223a3 100644
> --- a/props.c
> +++ b/props.c
> @@ -135,6 +135,7 @@ static int prop_compression(enum prop_object_type type,
>         }
>         memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
>         memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
> +       xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';

Buffer overrun. You need to sum + 1 to the malloc argument above.

Thanks Liu.

>
>         if (value)
>                 sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
> --
> 1.8.2.1
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
