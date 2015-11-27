Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34828 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbbK0Iq4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 03:46:56 -0500
MIME-Version: 1.0
In-Reply-To: <1448613732-2943-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1448613732-2943-1-git-send-email-linux@rasmusvillemoes.dk>
Date: Fri, 27 Nov 2015 10:46:55 +0200
Message-ID: <CAHp75VfbcLhhi7Rjf=bHYtxQizM6CTbX4MydOiGzdirc-iXVOw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: use kbasename in btrfsic_mount
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 10:42 AM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> This is more readable.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

You missed David's tag.

Anyway, also mine is here

Reviewed-by Andy Shevchenko <andy.shevchenko@gmail.com>

> ---
> v2: make p const char* (thanks 0day).
>
> Original comment:
>
> I think the following strlcpy may be somewhat fragile since obviously
> ds->name and p overlap. It certainly relies on strlcpy doing a forward
> copy, and since different architectures can have their own strlcpy,
> that's hard to verify (and also won't necessarily continue to hold).
>
> Maybe
>
>   if (p != ds->name)
>     memmove(ds->name, p, strlen(p)+1);
>
> instead.
>
>  fs/btrfs/check-integrity.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 0340c57bf377..d6fe77c5b4ac 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -95,6 +95,7 @@
>  #include <linux/genhd.h>
>  #include <linux/blkdev.h>
>  #include <linux/vmalloc.h>
> +#include <linux/string.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "hash.h"
> @@ -3120,7 +3121,7 @@ int btrfsic_mount(struct btrfs_root *root,
>
>         list_for_each_entry(device, dev_head, dev_list) {
>                 struct btrfsic_dev_state *ds;
> -               char *p;
> +               const char *p;
>
>                 if (!device->bdev || !device->name)
>                         continue;
> @@ -3136,11 +3137,7 @@ int btrfsic_mount(struct btrfs_root *root,
>                 ds->state = state;
>                 bdevname(ds->bdev, ds->name);
>                 ds->name[BDEVNAME_SIZE - 1] = '\0';
> -               for (p = ds->name; *p != '\0'; p++);
> -               while (p > ds->name && *p != '/')
> -                       p--;
> -               if (*p == '/')
> -                       p++;
> +               p = kbasename(ds->name);
>                 strlcpy(ds->name, p, sizeof(ds->name));
>                 btrfsic_dev_state_hashtable_add(ds,
>                                                 &btrfsic_dev_state_hashtable);
> --
> 2.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
