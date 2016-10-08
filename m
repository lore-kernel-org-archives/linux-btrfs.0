Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:45023 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753655AbcJHUuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Oct 2016 16:50:10 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com>
 <4f91af54-78ae-5c08-3daa-8a0c16210e5f@profihost.ag>
 <57EBB329.9060009@cn.fujitsu.com>
 <3e429001-020a-748b-c0c5-85b4091599a1@profihost.ag>
 <57ECBAE7.5030807@cn.fujitsu.com>
 <0e556b63-7c85-1e97-00b0-91bfca44e82c@profihost.ag>
 <57ECBF0D.3050609@cn.fujitsu.com>
 <85f85ca6-95c0-1394-9b09-93dcc00c2319@profihost.ag>
 <57F5BF26.9090409@cn.fujitsu.com>
 <23f37454-e24e-5e50-b5dc-99d16c324686@profihost.ag>
 <57F74BF3.9070802@cn.fujitsu.com> <57F76BED.5050004@applied-asynchrony.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <31bc6621-c0d5-1382-6abe-3e92e7fb156c@profihost.ag>
Date: Sat, 8 Oct 2016 22:49:59 +0200
MIME-Version: 1.0
In-Reply-To: <57F76BED.5050004@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

main difference between the system where oom happens is:
- Single Xeon  => no OOM
- Dual Xeon / NUMA => OOM

both 64GB mem.
Am 07.10.2016 um 11:33 schrieb Holger Hoffstätte:
> On 10/07/16 09:17, Wang Xiaoguang wrote:
>> Hi,
>>
>> On 10/07/2016 03:03 PM, Stefan Priebe - Profihost AG wrote:
>>> Dear Wang,
>>>
>>> can't use v4.8.0 as i always get OOMs and total machine crashes.
>>>
>>> Complete traces with your patch and some more btrfs patches applied (in
>>> the hope in fixes the OOM but it did not):
>>> http://pastebin.com/raw/6vmRSDm1
>> I didn't see any such OOMs...
>> Can you try holger's tree with my patches.
> 
> They don't really apply to either 4.4.x (because it has diverged too
> much by now) or 4.8.x because of the initial dedupe support which came
> in as part of 4.9rc1 - there are way too many conflicts all over the
> place and merging them manually took way too much time.
> It would be useful if you could rebase your patches to for-next.
> 
> Stefan, have you tried setting THP to 'madvise' or 'never'?
> Try 'echo madvise > /sys/kernel/mm/transparent_hugepage/enabled'
> or boot with transparent_hugepage=madvise (or never) kernel flag.
> I have no idea if it will help, but it's worth a try.
> 
> -h
> 
