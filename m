Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36315 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbeDRRMh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 13:12:37 -0400
MIME-Version: 1.0
In-Reply-To: <20180418131731.11519-1-dsterba@suse.com>
References: <20180418131731.11519-1-dsterba@suse.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Wed, 18 Apr 2018 10:12:35 -0700
Message-ID: <CANQeFDAqm7xZodAxexU9y+Y+BaiNKZkh91U2x5ocDTJ6AaVHnA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix unaligned access in readdir
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 6:17 AM, David Sterba <dsterba@suse.com> wrote:
> The last update to readdir introduced a temporary buffer to store the
> emitted readdir data, but as there are file names of variable length,
> there's a lot of unaligned access.
>
> This was observed on a sparc64 machine:
>
>   Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
>

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo
> Fixes: 23b5ec74943 ("btrfs: fix readdir deadlock with pagefault")
> CC: stable@vger.kernel.org # 4.14+
> Reported-and-tested-by: René Rebe <rene@exactcode.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e064c49c9a9a..d241285a0d2a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -31,6 +31,7 @@
>  #include <linux/uio.h>
>  #include <linux/magic.h>
>  #include <linux/iversion.h>
> +#include <asm/unaligned.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -5905,11 +5906,13 @@ static int btrfs_filldir(void *addr, int entries, struct dir_context *ctx)
>                 struct dir_entry *entry = addr;
>                 char *name = (char *)(entry + 1);
>
> -               ctx->pos = entry->offset;
> -               if (!dir_emit(ctx, name, entry->name_len, entry->ino,
> -                             entry->type))
> +               ctx->pos = get_unaligned(&entry->offset);
> +               if (!dir_emit(ctx, name, get_unaligned(&entry->name_len),
> +                                        get_unaligned(&entry->ino),
> +                                        get_unaligned(&entry->type)))
>                         return 1;
> -               addr += sizeof(struct dir_entry) + entry->name_len;
> +               addr += sizeof(struct dir_entry) +
> +                       get_unaligned(&entry->name_len);
>                 ctx->pos++;
>         }
>         return 0;
> @@ -5999,14 +6002,15 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>                 }
>
>                 entry = addr;
> -               entry->name_len = name_len;
> +               put_unaligned(name_len, &entry->name_len);
>                 name_ptr = (char *)(entry + 1);
>                 read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
>                                    name_len);
> -               entry->type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
> +               put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
> +                               &entry->type);
>                 btrfs_dir_item_key_to_cpu(leaf, di, &location);
> -               entry->ino = location.objectid;
> -               entry->offset = found_key.offset;
> +               put_unaligned(location.objectid, &entry->ino);
> +               put_unaligned(found_key.offset, &entry->offset);
>                 entries++;
>                 addr += sizeof(struct dir_entry) + name_len;
>                 total_len += sizeof(struct dir_entry) + name_len;
> --
> 2.16.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
