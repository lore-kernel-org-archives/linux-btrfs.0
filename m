Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41717 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOJJX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 05:09:23 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so6614625lbj.17
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 02:09:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1397545492-3054-4-git-send-email-quwenruo@cn.fujitsu.com>
References: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1397545492-3054-4-git-send-email-quwenruo@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 10:09:21 +0100
Message-ID: <CAL3q7H7Wvgs0ejnd6iAVJMf6mi98tHGcCKu52+FMY98rMrBeHQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] btrfs-progs: Fix the return value when executing
 'btrfs pro get' on a uncompress file.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 8:04 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> When executing 'btrfs pro get' on a file which is not compressed, return
> value will always be 50 since prop_compress() return -ENOATTR.
>
> But this should be ignored and other prop_XXX() returns 0, so when
> prop_compress() is executed on uncompress file, it should return 0.
>
> Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>
> ---
>  props.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/props.c b/props.c
> index 4d0aeea..49ee982 100644
> --- a/props.c
> +++ b/props.c
> @@ -146,6 +146,7 @@ static int prop_compression(enum prop_object_type type,
>                         fprintf(stderr,
>                                 "ERROR: failed to %s compression for %s. %s\n",
>                                 value ? "set" : "get", object, strerror(-ret));
> +               ret = 0;
>                 goto out;

Hi Qu,

So this should set ret to 0 if error ==  -ENOATTR. And of course the
check above should be against  -ENOATTR and not -ENODATA.

thanks


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
