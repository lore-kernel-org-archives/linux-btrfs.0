Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59153 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaDOJ1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 05:27:44 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so6581475lbv.38
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 02:27:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1397553744-24465-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1397553744-24465-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 10:27:43 +0100
Message-ID: <CAL3q7H78SRZZYyRY9PRj+LnQG_VO+hPuWb8A_2GNJx43m1Z3AA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] btrfs-progs: Fix the return value when executing
 'btrfs pro get' on a uncompress file.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 10:22 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> When executing 'btrfs pro get' on a file which is not compressed, return
> value will always be 50 since prop_compress() return -ENOATTR.
>
> But the codes have already check the errno to avoid unnecessary error
> message, so the return value should also set to 0.
>
> Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>
Reviewed-by: Filipe Manana <fdmanana@gmail.com>

Thanks Qu

> ---
>  props.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/props.c b/props.c
> index 4d0aeea..c09865b 100644
> --- a/props.c
> +++ b/props.c
> @@ -142,10 +142,12 @@ static int prop_compression(enum prop_object_type type,
>                 sret = fgetxattr(fd, xattr_name, NULL, 0);
>         if (sret < 0) {
>                 ret = -errno;
> -               if (ret != -ENODATA)
> +               if (ret != -ENOATTR)
>                         fprintf(stderr,
>                                 "ERROR: failed to %s compression for %s. %s\n",
>                                 value ? "set" : "get", object, strerror(-ret));
> +               else
> +                       ret = 0;
>                 goto out;
>         }
>         if (!value) {
> --
> 1.9.2
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
