Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59468 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaB0MnX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 07:43:23 -0500
Received: by mail-ee0-f43.google.com with SMTP id e53so1215529eek.30
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 04:43:22 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CALOYprW7Y2FW31EbpmDb5EidMPO8JakvZV8a_5_vur3uBCgpMA@mail.gmail.com>
References: <1391029564-24160-1-git-send-email-fdmanana@gmail.com>
	<CALOYprW7Y2FW31EbpmDb5EidMPO8JakvZV8a_5_vur3uBCgpMA@mail.gmail.com>
Date: Thu, 27 Feb 2014 12:43:21 +0000
Message-ID: <CAL3q7H6oMHuXumCgDjKT_X3Pc8ufZ-Yb_T3XTcAMV5yZa51g6Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: use btrfs_crc32c everywhere instead of libcrc32c
From: Filipe David Manana <fdmanana@gmail.com>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 26, 2014 at 11:26 PM, WorMzy Tykashi
<wormzy.tykashi@gmail.com> wrote:
> On 29 January 2014 21:06, Filipe David Borba Manana <fdmanana@gmail.com> wrote:
>> After the commit titled "Btrfs: fix btrfs boot when compiled as built-in",
>> LIBCRC32C requirement was removed from btrfs' Kconfig. This made it not
>> possible to build a kernel with btrfs enabled (either as module or built-in)
>> if libcrc32c is not enabled as well. So just replace all uses of libcrc32c
>> with the equivalent function in btrfs hash.h - btrfs_crc32c.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>  fs/btrfs/check-integrity.c |    4 ++--
>>  fs/btrfs/disk-io.c         |    4 ++--
>>  fs/btrfs/send.c            |    4 ++--
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
>> index 160fb50..39bfd56 100644
>> --- a/fs/btrfs/check-integrity.c
>> +++ b/fs/btrfs/check-integrity.c
>> @@ -92,11 +92,11 @@
>>  #include <linux/slab.h>
>>  #include <linux/buffer_head.h>
>>  #include <linux/mutex.h>
>> -#include <linux/crc32c.h>
>>  #include <linux/genhd.h>
>>  #include <linux/blkdev.h>
>>  #include "ctree.h"
>>  #include "disk-io.h"
>> +#include "hash.h"
>>  #include "transaction.h"
>>  #include "extent_io.h"
>>  #include "volumes.h"
>> @@ -1823,7 +1823,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
>>                 size_t sublen = i ? PAGE_CACHE_SIZE :
>>                                     (PAGE_CACHE_SIZE - BTRFS_CSUM_SIZE);
>>
>> -               crc = crc32c(crc, data, sublen);
>> +               crc = btrfs_crc32c(crc, data, sublen);
>>         }
>>         btrfs_csum_final(crc, csum);
>>         if (memcmp(csum, h->csum, state->csum_size))
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 7619147..3903bd3 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -26,7 +26,6 @@
>>  #include <linux/workqueue.h>
>>  #include <linux/kthread.h>
>>  #include <linux/freezer.h>
>> -#include <linux/crc32c.h>
>>  #include <linux/slab.h>
>>  #include <linux/migrate.h>
>>  #include <linux/ratelimit.h>
>> @@ -35,6 +34,7 @@
>>  #include <asm/unaligned.h>
>>  #include "ctree.h"
>>  #include "disk-io.h"
>> +#include "hash.h"
>>  #include "transaction.h"
>>  #include "btrfs_inode.h"
>>  #include "volumes.h"
>> @@ -244,7 +244,7 @@ out:
>>
>>  u32 btrfs_csum_data(char *data, u32 seed, size_t len)
>>  {
>> -       return crc32c(seed, data, len);
>> +       return btrfs_crc32c(seed, data, len);
>>  }
>>
>>  void btrfs_csum_final(u32 crc, char *result)
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 04c07ed..31b76d0 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -24,12 +24,12 @@
>>  #include <linux/xattr.h>
>>  #include <linux/posix_acl_xattr.h>
>>  #include <linux/radix-tree.h>
>> -#include <linux/crc32c.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/string.h>
>>
>>  #include "send.h"
>>  #include "backref.h"
>> +#include "hash.h"
>>  #include "locking.h"
>>  #include "disk-io.h"
>>  #include "btrfs_inode.h"
>> @@ -620,7 +620,7 @@ static int send_cmd(struct send_ctx *sctx)
>>         hdr->len = cpu_to_le32(sctx->send_size - sizeof(*hdr));
>>         hdr->crc = 0;
>>
>> -       crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
>> +       crc = btrfs_crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
>>         hdr->crc = cpu_to_le32(crc);
>>
>>         ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Hi,

Hi

>
> Ever since this patch was committed (git ref
> 0b947aff1599afbbd2ec07ada87b05af0f94cf10), the btrfs module
> (presumably intentionally) no longer depends on the crc32c module.

To be more clear, it no longer depends on LIBCRC32C (which is just a
convenience library to access crypto's crc32c).
It still depends on CRYPTO and CRYPTO_CRC32C (which is what LIBCRC32C uses).

> However, this means that this module is not pulled in during initrd
> creation (at least using mkinitcpio on Arch Linux), and as a result,
> the btrfs module cannot be loaded. Instead modprobe complains with:
> "Unknown symbol in module, or unknown parameter (see dmesg)".

That is weird. On debian creating the initrd via kernel's makefile
(make modules_install && make install) works for me (don't know if it
uses mkinitcpio or something else).

>
> Unfortunately there is no accompanying message in dmesg, so I can't
> provide much more information. However, I have bisected the commit to
> confirm that this problem was introduced by this patch. The following
> is a grep of btrfs module's dependencies before and after this was
> committed:
>
> $ grep btrfs pkg/lib/modules/3.13.0-ARCH-00150-g8101c8d/modules.dep
> kernel/fs/btrfs/btrfs.ko: kernel/lib/raid6/raid6_pq.ko
> kernel/lib/libcrc32c.ko kernel/crypto/xor.ko
>
> $ grep btrfs pkg/lib/modules/3.13.0-ARCH-00151-g0b947af/modules.dep
> kernel/fs/btrfs/btrfs.ko: kernel/lib/raid6/raid6_pq.ko kernel/crypto/xor.ko
>
> As you can see, the dependency on kernel/lib/libcrc32c.ko was removed.

Yep, it is intentional.

>
> However, if crc32c.ko is manually added to the initrd, the btrfs
> module loads fine, which suggests that it should still be a
> dependency. If it shouldn't be a dependency any more, then something
> is wrong somewhere, but I don't understand enough about kernel modules
> to find out why right now. :(

So crc32c.ko isn't libcrc32c (which is libcrc32c.ko). It's crypto's
crc32c, and that's a correct module dependency:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/Kconfig?id=refs/tags/v3.14-rc4

>
> I hope that this information is enough to help you discover the
> problem. I've tried adding back in the linux/crc32c.h include
> statements in the affected files, but this hasn't changed the
> situation, so I guess a full revert would be necessary. Unfortunately
> I have to sleep now, so I can't do any further investigation tonight.
> I'll try to find time tomorrow to investigate further.
>
> Please let me know if any parts of this message don't make sense, or
> require further investigation.

So the intention of this patch was to remove calls to libcrc32c, which
isn't a dependency anymore. Without this patch, you would get linker
errors when building btrfs unless libcrc32c is built-in (i.e. only
compiled if CONFIG_LIBCRC32C=y). Several people reported this issue
and this patch fixed the problem for them, e.g.
https://lkml.org/lkml/2014/2/1/165

Another issue that got fixed in 3.14-rc2, but possibly unrelated to
your issue, is http://www.spinics.net/lists/linux-btrfs/msg31276.html

Can you try 3.14-rc4? Maybe it's some arch specific issue, but
crc32c.ko (or crc32c-intel.ko) isn't definitely the same as
libcrc32c.ko.

Hope it helps, thanks.

>
> Also, apologies for the late reporting of this problem, I was
> previously explicitly including the crc32c module it my initrd, I was
> only made aware of the problem after another mainline kernel Arch user
> pointed the problem out here:
> https://aur.archlinux.org/packages/linux-mainline/
>
> Also, apologies if this has already been reported. I searched the
> mailing list, but couldn't find anything.
>
> Cheers,
>
>
> WorMzy



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
