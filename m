Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35551 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdDKNZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 09:25:38 -0400
Received: by mail-lf0-f66.google.com with SMTP id i3so7567408lfh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 06:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170411000904.GF2455@edanaher.net>
References: <20170411000904.GF2455@edanaher.net>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 11 Apr 2017 09:24:56 -0400
Message-ID: <CADfjVrg793+_eb21OpX0ps5Fat6a=2SxED87meuMabXQjSyT=A@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: send-dump: always print a space after path
To: Evan Danaher <github@edanaher.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 10, 2017 at 8:09 PM, Evan Danaher <github@edanaher.net> wrote:
> I was shocked to discover that 'btrfs receive --dump' doesn't print a
> space after long filenames, so it runs together into the metadata; for
> example:
>
> truncate        ./20-00-03/this-name-is-32-characters-longsize=0
>
> This is a trivial patch to add a single space unconditionally, so the
> result is the following:
>
> truncate        ./20-00-03/this-name-is-32-characters-long size=0
>
> I suppose this is technically a breaking change, but it seems unlikely
> to me that anyone would depend on the existing behavior given how
> unfriendly it is.
>
>
> Signed-off-by: Evan Danaher <github@edanaher.net>
> ---
> diff --git a/send-dump.c b/send-dump.c
> index 67f7977..493389f 100644
> --- a/send-dump.c
> +++ b/send-dump.c
> @@ -116,9 +116,10 @@ static int __print_dump(int subvol, void *user, const char *path,
>                 putchar('\n');
>                 return 0;
>         }
> -       /* Short paths ale aligned to 32 chars */
> -       while (ret++ < 32)
> +       /* Short paths are aligned to 32 chars; longer paths get a single space */
> +       do {
>                 putchar(' ');
> +       } while (ret++ < 32);

while (++ret < 32);

Since we're performing the check after the put, we need to
pre-increment to count the space already added.

>         va_start(args, fmt);
>         /* Operation specified ones */
>         vprintf(fmt, args);
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
