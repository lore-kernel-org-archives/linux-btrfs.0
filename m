Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:35257 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755223AbcK2FvN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 00:51:13 -0500
Received: by mail-yw0-f178.google.com with SMTP id i145so131963411ywg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 21:51:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it> <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 28 Nov 2016 22:51:12 -0700
Message-ID: <CAJCQCtR==9wadS=9swcUhHJ77tGksvHMvNd3ZJrpt3+-U779tA@mail.gmail.com>
Subject: Re: RFC: raid with a variable stripe size
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2016 at 5:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 11/19/2016 02:15 AM, Goffredo Baroncelli wrote:
>>
>> Hello,
>>
>> these are only my thoughts; no code here, but I would like to share it
>> hoping that it could be useful.
>>
>> As reported several times by Zygo (and others), one of the problem of
>> raid5/6 is the write hole. Today BTRFS is not capable to address it.
>
>
> I'd say, no need to address yet, since current soft RAID5/6 can't handle it
> yet.
>
> Personally speaking, Btrfs should implementing RAID56 support just like
> Btrfs on mdadm.
> See how badly the current RAID56 works?
>
> The marginally benefit of btrfs RAID56 to scrub data better than tradition
> RAID56 is just a joke in current code base.

Btrfs is subject to the write hole problem on disk, but any read or
scrub that needs to reconstruct from parity that is corrupt results in
a checksum error and EIO. So corruption is not passed up to user
space. Recent versions of md/mdadm support a write journal to avoid
the write hole problem on disk in case of a crash.

>> The problem is that the stripe size is bigger than the "sector size" (ok
>> sector is not the correct word, but I am referring to the basic unit of
>> writing on the disk, which is 4k or 16K in btrfs).
>> So when btrfs writes less data than the stripe, the stripe is not filled;
>> when it is filled by a subsequent write, a RMW of the parity is required.
>>
>> On the best of my understanding (which could be very wrong) ZFS try to
>> solve this issue using a variable length stripe.
>
>
> Did you mean ZFS record size?
> IIRC that's file extent minimum size, and I didn't see how that can handle
> the write hole problem.
>
> Or did ZFS handle the problem?

ZFS isn't subject to the write hole. My understanding is they get
around this because all writes are COW, there is no RMW. But the
variable stripe size means they don't have to do the usual (fixed)
full stripe write for just, for example a 4KiB change in data for a
single file. Conversely Btrfs does do RMW in such a case.


> Anyway, it should be a low priority thing, and personally speaking,
> any large behavior modification involving  both extent allocator and bg
> allocator will be bug prone.

I tend to agree. I think the non-scalability of Btrfs raid10, which
makes it behave more like raid 0+1, is a higher priority because right
now it's misleading to say the least; and then the longer term goal
for scaleable huge file systems is how Btrfs can shed irreparably
damaged parts of the file system (tree pruning) rather than
reconstruction.



-- 
Chris Murphy
