Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46233 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaCCMu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 07:50:26 -0500
Received: by mail-ee0-f44.google.com with SMTP id e49so1238352eek.31
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 04:50:25 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CALOYprXj43sqKw7C6Tgh7jRdcYVwJGMGHrnhfarbggvqx43fsA@mail.gmail.com>
References: <1391029564-24160-1-git-send-email-fdmanana@gmail.com>
	<CALOYprW7Y2FW31EbpmDb5EidMPO8JakvZV8a_5_vur3uBCgpMA@mail.gmail.com>
	<CAL3q7H6oMHuXumCgDjKT_X3Pc8ufZ-Yb_T3XTcAMV5yZa51g6Q@mail.gmail.com>
	<CALOYprXj43sqKw7C6Tgh7jRdcYVwJGMGHrnhfarbggvqx43fsA@mail.gmail.com>
Date: Mon, 3 Mar 2014 12:50:24 +0000
Message-ID: <CAL3q7H6dzTGQi_v9QNLq65JHetqZaThk4byUs2o_E0u4wy5=gw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: use btrfs_crc32c everywhere instead of libcrc32c
From: Filipe David Manana <fdmanana@gmail.com>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 1, 2014 at 9:20 PM, WorMzy Tykashi <wormzy.tykashi@gmail.com> wrote:
> On 27 February 2014 12:43, Filipe David Manana <fdmanana@gmail.com> wrote:
>> On Wed, Feb 26, 2014 at 11:26 PM, WorMzy Tykashi
>> <wormzy.tykashi@gmail.com> wrote:
>>>
>>> Hi,
>>
>> Hi
>>
>
> Hi again,
>
> Sorry for the delay in replying, I've not had the time to gather my
> thoughts and write a coherent reply.
>>>
>>> Ever since this patch was committed (git ref
>>> 0b947aff1599afbbd2ec07ada87b05af0f94cf10), the btrfs module
>>> (presumably intentionally) no longer depends on the crc32c module.
>>
>> To be more clear, it no longer depends on LIBCRC32C (which is just a
>> convenience library to access crypto's crc32c).
>> It still depends on CRYPTO and CRYPTO_CRC32C (which is what LIBCRC32C uses).
>>
>
> Thanks for clarifying this, I assumed that libcrc32c and crc32c were
> aliases of the same module. I can see from the modinfo input that
> they're not.
>
>>> However, this means that this module is not pulled in during initrd
>>> creation (at least using mkinitcpio on Arch Linux), and as a result,
>>> the btrfs module cannot be loaded. Instead modprobe complains with:
>>> "Unknown symbol in module, or unknown parameter (see dmesg)".
>
> I've found that mkinitcpio automatically adds crc32c to the initrd if
> lib32crc is needed, so before, even though libcrc32c wasn't actually
> needed, btrfs' dependency on it caused mkinitcpio to include the
> actual dependency (crc32c) in the image.
>
> https://projects.archlinux.org/mkinitcpio.git/tree/functions?id=v16#n398
>
> Now that the dependency is gone, and nothing else necessary to mount
> my root filesystem depends on libcrc32c, crc32c is no longer being
> added to the initrd.
>
>>
>> That is weird. On debian creating the initrd via kernel's makefile
>> (make modules_install && make install) works for me (don't know if it
>> uses mkinitcpio or something else).
>>
>
> Debian uses a different tool, but has a similar workaround to the
> problem. I found this in the comments...
>
> /usr/share/initramfs-tools/hook-functions: line 507:
> ---
> # 'depmod' only looks at symbol dependencies; there is no way for
> # modules to declare explicit dependencies through module information,
> # so dependencies on e.g. crypto providers are hidden.  Until this is
> # fixed, we need to handle those hidden dependencies.
> hidden_dep_add_modules()
> {
>     local modules=
>     for dep in "lib/libcrc32c crc32c" "fs/ubifs/ubifs deflate zlib lzo"; do
>         set -- $dep
>         if [ -f "${DESTDIR}/lib/modules/${version}/kernel/$1.ko" ]; then
>             shift
>             modules="$modules $@"
>         fi
>     done
>     manual_add_modules $modules
> }
> ---
>
> This makes sure that, if libcrc32c is needed, crc32c is added too.

You've made great progress finding this.

>
> Presumably, one or more of the modules being added to your initrd
> still needs libcrc32c, which is why you don't experience this problem.

Possibly, since libcrc32c is used by xfs and ceph, both of which I
have built as modules.

Just remembered now, that ext4 for example depends on crypto's crc32c
as well but not on libcrc32c (just like btrfs in 3.14) -
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/ext4/Kconfig
So it sounds like you could get into the same issue if you build
crypto's crc32c as a module and ext4 as a module too.

>
>
>> So crc32c.ko isn't libcrc32c (which is libcrc32c.ko). It's crypto's
>> crc32c, and that's a correct module dependency:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/Kconfig?id=refs/tags/v3.14-rc4
>>
>
> Right, so the problem is actually that btrfs module doesn't depend on
> the crc32c module. The crc32c module doesn't export any symbols, so
> it's impossible (?) to explicitly depend on it, so initrd creation
> tools have had to hack around the problem to make sure that the crc32c
> module is still added to initrds when it's needed.
>
>>>
>>> I hope that this information is enough to help you discover the
>>> problem. I've tried adding back in the linux/crc32c.h include
>>> statements in the affected files, but this hasn't changed the
>>> situation, so I guess a full revert would be necessary. Unfortunately
>>> I have to sleep now, so I can't do any further investigation tonight.
>>> I'll try to find time tomorrow to investigate further.
>>>
>>> Please let me know if any parts of this message don't make sense, or
>>> require further investigation.
>>
>> So the intention of this patch was to remove calls to libcrc32c, which
>> isn't a dependency anymore. Without this patch, you would get linker
>> errors when building btrfs unless libcrc32c is built-in (i.e. only
>> compiled if CONFIG_LIBCRC32C=y). Several people reported this issue
>> and this patch fixed the problem for them, e.g.
>> https://lkml.org/lkml/2014/2/1/165
>>
>> Another issue that got fixed in 3.14-rc2, but possibly unrelated to
>> your issue, is http://www.spinics.net/lists/linux-btrfs/msg31276.html
>>
>> Can you try 3.14-rc4? Maybe it's some arch specific issue, but
>> crc32c.ko (or crc32c-intel.ko) isn't definitely the same as
>> libcrc32c.ko.
>>
>> Hope it helps, thanks.
>>
>
> Thanks. I think I've learnt a lot in the past few days. And I've typed
> crc32c so many times that I see it when I close my eyes.
>
> It's clear that the removal of the libcrc32c module wasn't the direct
> cause of this bug, but it did remove the crutch that was stopping
> things falling over.
>
> I guess that initrd creation tools have to adapt to this change, and
> include crc32c when btrfs is necessary.
>
> Unless you can see any flaws in my logic, I'll write a patch for
> mkinitcpio and see if the maintainer will include it before 3.14
> proper goes stable, so that not too many Arch users get bitten by this
> problem. I guess someone should do the same for debian's
> initramfs-tools.

Seems ok, but I don't have much expertise in using mkinitcpio and
similar tools directly, as I always rely on the kernel's "make
install" to figure out everything for me (on debian and ubuntu).

Let me know how it goes.

Thanks.

>
>>> Cheers,
>>>
>>>
>>> WorMzy
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."
>
> Cheers again,
>
>
> WorMzy



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
