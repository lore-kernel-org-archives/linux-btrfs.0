Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42822 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaA3NSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 08:18:07 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so1403751bkh.20
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 05:18:06 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140130031135.GA8796@birch.djwong.org>
References: <1389475651-19179-1-git-send-email-fdmanana@gmail.com>
	<1389493366-15264-1-git-send-email-fdmanana@gmail.com>
	<20140130031135.GA8796@birch.djwong.org>
Date: Thu, 30 Jan 2014 13:18:04 +0000
Message-ID: <CAL3q7H7fT9Mz6m=a2iqHgSyGgYO28aRt_BFc95gQYOh4gaRA2A@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Filipe David Manana <fdmanana@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 30, 2014 at 3:11 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sun, Jan 12, 2014 at 02:22:46AM +0000, Filipe David Borba Manana wrote:
>> After the change titled "Btrfs: add support for inode properties", if
>> btrfs was built-in the kernel (i.e. not as a module), it would cause a
>> kernel panic, as reported recently by Fengguang:
>>
>> [    2.024722] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [    2.027814] IP: [<ffffffff81501594>] crc32c+0xc/0x6b
>> [    2.028684] PGD 0
>> [    2.028684] Oops: 0000 [#1] SMP
>> [    2.028684] Modules linked in:
>> [    2.028684] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7-04795-ga7b57c2 #1
>> [    2.028684] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> [    2.028684] task: ffff88000edba100 ti: ffff88000edd6000 task.ti: ffff88000edd6000
>> [    2.028684] RIP: 0010:[<ffffffff81501594>]  [<ffffffff81501594>] crc32c+0xc/0x6b
>> [    2.028684] RSP: 0000:ffff88000edd7e58  EFLAGS: 00010246
>> [    2.028684] RAX: 0000000000000000 RBX: ffffffff82295550 RCX: 0000000000000000
>> [    2.028684] RDX: 0000000000000011 RSI: ffffffff81efe393 RDI: 00000000fffffffe
>> [    2.028684] RBP: ffff88000edd7e60 R08: 0000000000000003 R09: 0000000000015d20
>> [    2.028684] R10: ffffffff81ef225e R11: ffffffff811b0222 R12: ffffffffffffffff
>> [    2.028684] R13: 0000000000000239 R14: 0000000000000000 R15: 0000000000000000
>> [    2.028684] FS:  0000000000000000(0000) GS:ffff88000fa00000(0000) knlGS:0000000000000000
>> [    2.028684] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    2.028684] CR2: 0000000000000000 CR3: 000000000220c000 CR4: 00000000000006f0
>> [    2.028684] Stack:
>> [    2.028684]  ffffffff82295550 ffff88000edd7e80 ffffffff8238af62 ffffffff8238ac05
>> [    2.028684]  0000000000000000 ffff88000edd7e98 ffffffff8238ac0f ffffffff8238ac05
>> [    2.028684]  ffff88000edd7f08 ffffffff810002ba ffff88000edd7f00 ffffffff810e2404
>> [    2.028684] Call Trace:
>> [    2.028684]  [<ffffffff8238af62>] btrfs_props_init+0x4f/0x96
>> [    2.028684]  [<ffffffff8238ac05>] ? ftrace_define_fields_btrfs_space_reservation+0x145/0x145
>> [    2.028684]  [<ffffffff8238ac0f>] init_btrfs_fs+0xa/0xf0
>> [    2.028684]  [<ffffffff8238ac05>] ? ftrace_define_fields_btrfs_space_reservation+0x145/0x145
>> [    2.028684]  [<ffffffff810002ba>] do_one_initcall+0xa4/0x13a
>> [    2.028684]  [<ffffffff810e2404>] ? parse_args+0x25f/0x33d
>> [    2.028684]  [<ffffffff8234cf75>] kernel_init_freeable+0x1aa/0x230
>> [    2.028684]  [<ffffffff8234c785>] ? do_early_param+0x88/0x88
>> [    2.028684]  [<ffffffff819f61b5>] ? rest_init+0x89/0x89
>> [    2.028684]  [<ffffffff819f61c3>] kernel_init+0xe/0x109
>>
>> The issue here is that the initialization function of btrfs (super.c:init_btrfs_fs)
>> started using crc32c (from lib/libcrc32c.c). But when it needs to call crc32c (as
>> part of the properties initialization routine), the libcrc32c is not yet initialized,
>> so crc32c derreferenced a NULL pointer (lib/libcrc32c.c:tfm), causing the kernel
>> panic on boot.
>>
>> The approach to fix this is to use crypto component directly to use its crc32c (which
>> is basically what lib/libcrc32c.c is, a wrapper around crypto). This is what ext4 is
>> doing as well, it uses crypto directly to get crc32c functionality.
>
> Sorry, I didn't even see this until your other patch today...
>
> Yes, ext4 bypasses libcrc32c, but notice how ext4/jbd2 only call
> crypto_alloc_shash() when you mount the filesystem.  This silly trick enables
> ext4 to take advantage of faster crc32c implementations that don't get loaded
> until after the initial insmod, just in case you do this:
>
> # modprobe btrfs
> # mount /dev/X /                <-- / uses software crc32c implementation
> # modprobe crc32c-intel
> # mount /dev/Y /home            <-- /home still uses software crc32c, because
>                                     *tfm still points to the sw implementation!
>
> Of course, one could argue that this is a distro problem, and that the
> initramfs or kernel config should take care to load the appropriate hardware
> accelerated drivers /before/ btrfs.
>
> On the other hand, btrfs might as well always enjoy the fastest implementation
> that it can get its hands on.

Thanks Darrick, that's very useful information.

So, if I understood it correctly, before this change btrfs was using
libcrc32c, which is initialized only once and therefore it's possible
it wouldn't use crc32c-intel - if crc32c-intel was built as a module
and not loaded before libcrc32c is initialized.

Also that ext4 approach, of using crypto_alloc_shash() on each mount
(and make the result accessible via super block structure) doesn't
solve the case where the partition is mounted before crc32c-intel is
loaded but then it's never unmounted and mounted again (like a root or
home partition). By solve I mean not profiting from intel's hardware
based crc32c.

I suppose that if crc32c-intel is built-in (i.e. not as a module) that
either with the current approach (after this patch) or with the old
approach, we'll be using crc32c-intel. Is there any way to verify
this?

>
> (Also I suppose metadata_csum is optional in ext4/jbd2...)
>
> --D
>
>>
>> Verified this works both when btrfs is built-in and when it's loadable kernel module.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>
>> V2: Removed unnecessary __exit qualifier.
>>
>>  fs/btrfs/Kconfig       |    3 ++-
>>  fs/btrfs/Makefile      |    2 +-
>>  fs/btrfs/extent-tree.c |    6 +++---
>>  fs/btrfs/hash.c        |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/hash.h        |   11 ++++++++---
>>  fs/btrfs/super.c       |   10 +++++++++-
>>  6 files changed, 72 insertions(+), 9 deletions(-)
>>  create mode 100644 fs/btrfs/hash.c
>>
>> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
>> index aa976ec..a66768e 100644
>> --- a/fs/btrfs/Kconfig
>> +++ b/fs/btrfs/Kconfig
>> @@ -1,6 +1,7 @@
>>  config BTRFS_FS
>>       tristate "Btrfs filesystem support"
>> -     select LIBCRC32C
>> +     select CRYPTO
>> +     select CRYPTO_CRC32C
>>       select ZLIB_INFLATE
>>       select ZLIB_DEFLATE
>>       select LZO_COMPRESS
>> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
>> index af7f000..f341a98 100644
>> --- a/fs/btrfs/Makefile
>> +++ b/fs/btrfs/Makefile
>> @@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
>>          export.o tree-log.o free-space-cache.o zlib.o lzo.o \
>>          compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
>>          reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
>> -        uuid-tree.o props.o
>> +        uuid-tree.o props.o hash.o
>>
>>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
>>  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 77acc08..db19ed7 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -1072,11 +1072,11 @@ static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
>>       __le64 lenum;
>>
>>       lenum = cpu_to_le64(root_objectid);
>> -     high_crc = crc32c(high_crc, &lenum, sizeof(lenum));
>> +     high_crc = btrfs_crc32c(high_crc, &lenum, sizeof(lenum));
>>       lenum = cpu_to_le64(owner);
>> -     low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
>> +     low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
>>       lenum = cpu_to_le64(offset);
>> -     low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
>> +     low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
>>
>>       return ((u64)high_crc << 31) ^ (u64)low_crc;
>>  }
>> diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
>> new file mode 100644
>> index 0000000..ab3a938
>> --- /dev/null
>> +++ b/fs/btrfs/hash.c
>> @@ -0,0 +1,49 @@
>> +/*
>> + * Copyright (C) 2014 Filipe David Borba Manana <fdmanana@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <crypto/hash.h>
>> +#include "hash.h"
>> +
>> +static struct crypto_shash *tfm;
>> +
>> +int __init btrfs_hash_init(void)
>> +{
>> +     tfm = crypto_alloc_shash("crc32c", 0, 0);
>> +     if (IS_ERR(tfm))
>> +             return PTR_ERR(tfm);
>> +
>> +     return 0;
>> +}
>> +
>> +void btrfs_hash_exit(void)
>> +{
>> +     crypto_free_shash(tfm);
>> +}
>> +
>> +u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
>> +{
>> +     struct {
>> +             struct shash_desc shash;
>> +             char ctx[crypto_shash_descsize(tfm)];
>> +     } desc;
>> +     int err;
>> +
>> +     desc.shash.tfm = tfm;
>> +     desc.shash.flags = 0;
>> +     *(u32 *)desc.ctx = crc;
>> +
>> +     err = crypto_shash_update(&desc.shash, address, length);
>> +     BUG_ON(err);
>> +
>> +     return *(u32 *)desc.ctx;
>> +}
>> diff --git a/fs/btrfs/hash.h b/fs/btrfs/hash.h
>> index 1d98281..118a231 100644
>> --- a/fs/btrfs/hash.h
>> +++ b/fs/btrfs/hash.h
>> @@ -19,10 +19,15 @@
>>  #ifndef __HASH__
>>  #define __HASH__
>>
>> -#include <linux/crc32c.h>
>> +int __init btrfs_hash_init(void);
>> +
>> +void btrfs_hash_exit(void);
>> +
>> +u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length);
>> +
>>  static inline u64 btrfs_name_hash(const char *name, int len)
>>  {
>> -     return crc32c((u32)~1, name, len);
>> +     return btrfs_crc32c((u32)~1, name, len);
>>  }
>>
>>  /*
>> @@ -31,7 +36,7 @@ static inline u64 btrfs_name_hash(const char *name, int len)
>>  static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
>>                                   int len)
>>  {
>> -     return (u64) crc32c(parent_objectid, name, len);
>> +     return (u64) btrfs_crc32c(parent_objectid, name, len);
>>  }
>>
>>  #endif
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 461e41c..f44cc6a 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -48,6 +48,7 @@
>>  #include "transaction.h"
>>  #include "btrfs_inode.h"
>>  #include "print-tree.h"
>> +#include "hash.h"
>>  #include "props.h"
>>  #include "xattr.h"
>>  #include "volumes.h"
>> @@ -1866,11 +1867,15 @@ static int __init init_btrfs_fs(void)
>>  {
>>       int err;
>>
>> +     err = btrfs_hash_init();
>> +     if (err)
>> +             return err;
>> +
>>       btrfs_props_init();
>>
>>       err = btrfs_init_sysfs();
>>       if (err)
>> -             return err;
>> +             goto free_hash;
>>
>>       btrfs_init_compress();
>>
>> @@ -1945,6 +1950,8 @@ free_cachep:
>>  free_compress:
>>       btrfs_exit_compress();
>>       btrfs_exit_sysfs();
>> +free_hash:
>> +     btrfs_hash_exit();
>>       return err;
>>  }
>>
>> @@ -1963,6 +1970,7 @@ static void __exit exit_btrfs_fs(void)
>>       btrfs_exit_sysfs();
>>       btrfs_cleanup_fs_uuids();
>>       btrfs_exit_compress();
>> +     btrfs_hash_exit();
>>  }
>>
>>  module_init(init_btrfs_fs)
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
