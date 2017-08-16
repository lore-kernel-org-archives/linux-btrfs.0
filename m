Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53530 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdHPAN6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 20:13:58 -0400
Subject: Re: btrfs-progs-v4.12: cross compiling
To: Eric Sandeen <sandeen@redhat.com>, dsterba@suse.cz,
        Hallo32 <Hallo32@gmx.net>, kreijack@inwind.it,
        linux-btrfs@vger.kernel.org
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
 <20170814130608.GS2866@twin.jikos.cz>
 <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
 <20170814140341.GU2866@suse.cz>
 <159b3db0-6eae-7cff-d166-3c4b0c2513ac@gmx.com>
 <20170814151052.GV2866@twin.jikos.cz>
 <340e3677-4abd-5390-58bb-a64160a31862@libero.it>
 <880007a9-4882-e4a6-7411-a262e5296ab0@gmx.com>
 <082833d5-8f2a-6ed6-fa22-042a161a0dec@gmx.net>
 <20170815124807.GZ2866@twin.jikos.cz>
 <0f50ee70-d546-6aff-b57d-1283eadefa15@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b2cd316f-5678-1461-0040-60f6a59ae88a@gmx.com>
Date: Wed, 16 Aug 2017 08:13:39 +0800
MIME-Version: 1.0
In-Reply-To: <0f50ee70-d546-6aff-b57d-1283eadefa15@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月16日 01:28, Eric Sandeen wrote:
> On 8/15/17 7:48 AM, David Sterba wrote:
>> On Tue, Aug 15, 2017 at 02:44:07PM +0200, Hallo32 wrote:
> 
> ...
> 
>>>>> How the kernel deals with this kind of problem ?
>>>>> Looking at the source of btrfs Makefile, it is more simple to replace
>>>>>
>>>>>     mktables: kernel-lib/mktables.c
>>>>>           @echo "    [CC]     $@"
>>>>>           $(Q)$(CC) $(CFLAGS) $< -o $@
>>>>>
>>>>> with
>>>>>
>>>>>
>>>>>     mktables: kernel-lib/mktables.c
>>>>>           @echo "    [HOSTCC] $@"
>>>>>           $(Q)$(HOSTCC) $(CFLAGS) $< -o $@
>>>>>
>>>>> where HOSTCC is defined as
>>>>>
>>>>> HOSTCC=gcc
>>>>>
>>>>>
>>>>> (may be the same applied also to CFLAGS <-> HOSTCFLAGS ?)
>>>>
>>>> If using HOSTCC then I'm fine with it.
>>>
>>> CFLAGS needs also be replaced by something like HOSTCFLAGS, because if
>>> you use something like mips/architecture specific CFLAGS, they may be
>>> not applicably on the host system.
>>
>> Good point. Without a regular/automated cross-compilation build testing
>> I think we could break it quite easily. I'm going to keep the
>> pregenerated file in git.
> 
> Isn't using the host compiler for some binaries during a cross-compile
> a very standard thing to do?
> 
> The kernel manages it, as shown above.  xfsprogs does it (see libxfs/Makefile
> for the crc32table.h and crc32selftest targets), e2fsprogs does it (see
> gen_crc32ctable target in lib/ext2fs/Makefile), etc.

Only if I can find it earlier.

> 
> Seems that checking in a generated file would be more prone to eventual
> errors, no?

Also my concern.

> 
> I guess it's harder to do in btrfs-progs since it's not using autotools...

And your patch does do a better job, especially for BUILD_CFLAGS and 
build cc detection.

Thanks,
Qu

> 
> -Eric
> 
