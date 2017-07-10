Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35315 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754233AbdGJU5j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 16:57:39 -0400
From: Nick Terrell <terrelln@fb.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
CC: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Date: Mon, 10 Jul 2017 20:57:26 +0000
Message-ID: <1CBA39CA-0144-4508-B438-007C0F380479@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <20170706163225.xbluc2gi2nlaafzo@angband.pl>
 <A077809C-5D3A-4F3C-B859-E6C371A6EA4F@fb.com>
 <20170707234018.syyfaktjxyxvwglc@angband.pl>
 <20170708030706.tle2mpfe376jneft@angband.pl>
 <046c7611-be6d-ec4d-6489-e8f49a4453f6@gmail.com>
In-Reply-To: <046c7611-be6d-ec4d-6489-e8f49a4453f6@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/10/17, 5:36 AM, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
> On 2017-07-07 23:07, Adam Borowski wrote:
>> On Sat, Jul 08, 2017 at 01:40:18AM +0200, Adam Borowski wrote:
>>> On Fri, Jul 07, 2017 at 11:17:49PM +0000, Nick Terrell wrote:
>>>> On 7/6/17, 9:32 AM, "Adam Borowski" <kilobyte@angband.pl> wrote:
>>>>> Got a reproducible crash on amd64:
>>>
>>>> Thanks for the bug report Adam! I'm looking into the failure, and haven't
>>>> been able to reproduce it yet. I've built my kernel from your tree, and
>>>> I ran your script with the kernel.tar tarball 100 times, but haven't gotten
>>>> a failure yet.
>>>
>>>> I have a few questions to guide my debugging.
>>>>
>>>> - How many cores are you running with? Iâ€™ve run the script with 1, 2, and 4 cores.
>>>> - Which version of gcc are you using to compile the kernel? Iâ€™m using gcc-6.2.0-5ubuntu12.
>>>> - Are the failures always in exactly the same place, and does it fail 100%
>>>>    of the time or just regularly?
>>>
>>> 6 cores -- all on bare metal.  gcc-7.1.0-9.
>>> Lemme try with gcc-6, a different config or in a VM.
>> 
>> I've tried the following:
>> * gcc-6, defconfig (+btrfs obviously)
>> * gcc-7, defconfig
>> * gcc-6, my regular config
>> * gcc-7, my regular config
>> * gcc-7, debug + UBSAN + etc
>> * gcc-7, defconfig, qemu-kvm with only 1 core
>>
>> Every build with gcc-7 reproduces the crash, every with gcc-6 does not.
>>
> Got a GCC7 tool-chain built, and I can confirm this here too, tested 
> with various numbers of cores ranging from 1-32 in a QEMU+KVM VM, with 
> various combinations of debug options and other config switches.

I was running in an Ubuntu 16.10 VM on a MacBook Pro. I built with gcc-6.2
with KASAN, and couldn't trigger it, as expected. I built with gcc-7.1.0
built from source, and couldn't reproduce it. However, when I set up
qemu-kvm on another device, and compiled with gcc-7.1.0 built from source,
I was able to reproduce the bug. Now that I can reproduce it, I'll look
into a fix. Thanks Adam and Austin for finding, reproducing, and verifying
the bug.
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
