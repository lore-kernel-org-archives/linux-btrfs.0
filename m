Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57715 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBZX03 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 18:26:29 -0500
Received: by mail-vc0-f179.google.com with SMTP id lh14so1739639vcb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 15:26:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391029564-24160-1-git-send-email-fdmanana@gmail.com>
References: <1391029564-24160-1-git-send-email-fdmanana@gmail.com>
Date: Wed, 26 Feb 2014 23:26:28 +0000
Message-ID: <CALOYprW7Y2FW31EbpmDb5EidMPO8JakvZV8a_5_vur3uBCgpMA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: use btrfs_crc32c everywhere instead of libcrc32c
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 January 2014 21:06, Filipe David Borba Manana <fdmanana@gmail.com> wrote:
> After the commit titled "Btrfs: fix btrfs boot when compiled as built-in",
> LIBCRC32C requirement was removed from btrfs' Kconfig. This made it not
> possible to build a kernel with btrfs enabled (either as module or built-in)
> if libcrc32c is not enabled as well. So just replace all uses of libcrc32c
> with the equivalent function in btrfs hash.h - btrfs_crc32c.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/check-integrity.c |    4 ++--
>  fs/btrfs/disk-io.c         |    4 ++--
>  fs/btrfs/send.c            |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 160fb50..39bfd56 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -92,11 +92,11 @@
>  #include <linux/slab.h>
>  #include <linux/buffer_head.h>
>  #include <linux/mutex.h>
> -#include <linux/crc32c.h>
>  #include <linux/genhd.h>
>  #include <linux/blkdev.h>
>  #include "ctree.h"
>  #include "disk-io.h"
> +#include "hash.h"
>  #include "transaction.h"
>  #include "extent_io.h"
>  #include "volumes.h"
> @@ -1823,7 +1823,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
>                 size_t sublen = i ? PAGE_CACHE_SIZE :
>                                     (PAGE_CACHE_SIZE - BTRFS_CSUM_SIZE);
>
> -               crc = crc32c(crc, data, sublen);
> +               crc = btrfs_crc32c(crc, data, sublen);
>         }
>         btrfs_csum_final(crc, csum);
>         if (memcmp(csum, h->csum, state->csum_size))
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7619147..3903bd3 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -26,7 +26,6 @@
>  #include <linux/workqueue.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> -#include <linux/crc32c.h>
>  #include <linux/slab.h>
>  #include <linux/migrate.h>
>  #include <linux/ratelimit.h>
> @@ -35,6 +34,7 @@
>  #include <asm/unaligned.h>
>  #include "ctree.h"
>  #include "disk-io.h"
> +#include "hash.h"
>  #include "transaction.h"
>  #include "btrfs_inode.h"
>  #include "volumes.h"
> @@ -244,7 +244,7 @@ out:
>
>  u32 btrfs_csum_data(char *data, u32 seed, size_t len)
>  {
> -       return crc32c(seed, data, len);
> +       return btrfs_crc32c(seed, data, len);
>  }
>
>  void btrfs_csum_final(u32 crc, char *result)
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 04c07ed..31b76d0 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -24,12 +24,12 @@
>  #include <linux/xattr.h>
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/radix-tree.h>
> -#include <linux/crc32c.h>
>  #include <linux/vmalloc.h>
>  #include <linux/string.h>
>
>  #include "send.h"
>  #include "backref.h"
> +#include "hash.h"
>  #include "locking.h"
>  #include "disk-io.h"
>  #include "btrfs_inode.h"
> @@ -620,7 +620,7 @@ static int send_cmd(struct send_ctx *sctx)
>         hdr->len = cpu_to_le32(sctx->send_size - sizeof(*hdr));
>         hdr->crc = 0;
>
> -       crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
> +       crc = btrfs_crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
>         hdr->crc = cpu_to_le32(crc);
>
>         ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

Ever since this patch was committed (git ref
0b947aff1599afbbd2ec07ada87b05af0f94cf10), the btrfs module
(presumably intentionally) no longer depends on the crc32c module.
However, this means that this module is not pulled in during initrd
creation (at least using mkinitcpio on Arch Linux), and as a result,
the btrfs module cannot be loaded. Instead modprobe complains with:
"Unknown symbol in module, or unknown parameter (see dmesg)".

Unfortunately there is no accompanying message in dmesg, so I can't
provide much more information. However, I have bisected the commit to
confirm that this problem was introduced by this patch. The following
is a grep of btrfs module's dependencies before and after this was
committed:

$ grep btrfs pkg/lib/modules/3.13.0-ARCH-00150-g8101c8d/modules.dep
kernel/fs/btrfs/btrfs.ko: kernel/lib/raid6/raid6_pq.ko
kernel/lib/libcrc32c.ko kernel/crypto/xor.ko

$ grep btrfs pkg/lib/modules/3.13.0-ARCH-00151-g0b947af/modules.dep
kernel/fs/btrfs/btrfs.ko: kernel/lib/raid6/raid6_pq.ko kernel/crypto/xor.ko

As you can see, the dependency on kernel/lib/libcrc32c.ko was removed.

However, if crc32c.ko is manually added to the initrd, the btrfs
module loads fine, which suggests that it should still be a
dependency. If it shouldn't be a dependency any more, then something
is wrong somewhere, but I don't understand enough about kernel modules
to find out why right now. :(

I hope that this information is enough to help you discover the
problem. I've tried adding back in the linux/crc32c.h include
statements in the affected files, but this hasn't changed the
situation, so I guess a full revert would be necessary. Unfortunately
I have to sleep now, so I can't do any further investigation tonight.
I'll try to find time tomorrow to investigate further.

Please let me know if any parts of this message don't make sense, or
require further investigation.

Also, apologies for the late reporting of this problem, I was
previously explicitly including the crc32c module it my initrd, I was
only made aware of the problem after another mainline kernel Arch user
pointed the problem out here:
https://aur.archlinux.org/packages/linux-mainline/

Also, apologies if this has already been reported. I searched the
mailing list, but couldn't find anything.

Cheers,


WorMzy
