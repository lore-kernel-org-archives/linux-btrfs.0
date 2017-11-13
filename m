Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36178 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751526AbdKMCWU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 21:22:20 -0500
Subject: Re: btrfs check lowmem vs original
To: Chris Murphy <chris@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
 <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
 <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
 <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
 <f4bc7f4a-d11c-6887-f148-286c1f0e7cd2@cn.fujitsu.com>
 <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com>
Date: Mon, 13 Nov 2017 10:25:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On 11/11/2017 07:16 AM, Chris Murphy wrote:
> Resurrecting this old thread because I'm still seeing these errors.
> 
> On Thu, Mar 16, 2017 at 6:54 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 03/17/2017 07:22 AM, Chris Murphy wrote:
>>>
>>> With kernel 4.10.3, and btrfs-progs 4.10, I'm still seeing the
>>> following errors only with --mode=lowmem with a single device volume.
>>>
>>>
>>> ERROR: data extent[16913485824 7577600] backref lost
>>> (hundreds of lines of the same thing)
>>>
>>> btrfs-image (no errors reported during capture) 518MiB
>>> https://drive.google.com/open?id=0B7NttHfq6wAJd3ZXM3AxS0dVQlU
>>
>>
>> Thanks a lot for the image.
>>
>> Turns out to be that, lowmem mode only checks EXTENT_DATA_REF key, and
>> doesn't check SHARED_DATA_REF_KEY, this leads to the error message.
>>
>> Fix will be sent out soon.
> 
> 
> I'm using btrfs-progs 4.13.3 and still see these errors. Do you need
> an updated sanitized image, or newer version or patchset to test?
> 
Actually, lowmem mode in 4.13.3 still has some problem while checking
extent-tree.

I have some patches for lowmem mode. But they are not fully tested and
unstable.
It will be so nice if you can provide some images.

Thanks,
Su

> This example error is happening on a single device volume with DUP
> metadata, and also ends in a crash:.
> 
> ERROR: data extent[16913485824 7577600] backref lost
> ...
> backref.c:466: __add_missing_keys: Assertion `ref->root_id` failed, value 0
> ...
> 
> Complete output, with filtered btrfs-debug-tree info for extent
> address 16913485824
> https://drive.google.com/open?id=1WgHdIz7zu_bO6evUBkG4wPxpJfwaFCxv
> 
> ------
> 
> This example error is happening on a two device raid1 data and raid1
> metadata volume:
> 
> ERROR: extent[366498091008, 134217728] referencer count mismatch
> (root: 827, owner: 73782, offset: 134217728) wanted: 4, have: 26
> 
> Complete output, with filtered btrfs-debug-tree info for extent
> address 366498091008.
> https://drive.google.com/open?id=1LUMtLIc1LcXhYN3twFcxTyFuJ6ScMlyQ
> 
> 
> Both examples have multiple extents reported in the error but I've
> only included debug tree info for the first extent listed by lowmem
> check. So it's an incomplete report. I can provide sanitized
> btrfs-image on request, or test with patches.
> 



