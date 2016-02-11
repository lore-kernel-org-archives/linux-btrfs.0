Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34613 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbcBKR3z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:29:55 -0500
Received: by mail-io0-f182.google.com with SMTP id 9so62190115iom.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 09:29:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56BCA188.9070603@gmail.com>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
	<CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
	<56BB41E3.8050906@gmail.com>
	<CAJCQCtS8wDV93Eyb6pDaCJBY7_v8misn1p9e=4KVGdK6=CKL_A@mail.gmail.com>
	<56BB9698.5020203@gmail.com>
	<56BC9734.403@inwind.it>
	<56BCA188.9070603@gmail.com>
Date: Thu, 11 Feb 2016 10:29:54 -0700
Message-ID: <CAJCQCtSoL6VUUw0FD-kLjHKmmcK5aXtf6c0CD=Ux8MsDiSZ+Bg@mail.gmail.com>
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: kreijack@inwind.it, Chris Murphy <lists@colorremedies.com>,
        Mackenzie Meyer <snackmasterx@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 7:58 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-02-11 09:14, Goffredo Baroncelli wrote:
>>
>> On 2016-02-10 20:59, Austin S. Hemmelgarn wrote:
>> [...]
>>>
>>> Again, a torn write to the metadata referencing the block (stripe in
>>> this case I believe) will result in loosing anything written by the
>>> update to the stripe.
>>
>>
>> I think that the order matters: first the data block are written (in a new
>> location, so the old data are untouched), then the metadata, from the leafs
>> up to the upper node (again in a new location), then the superblock which
>> references to the upper node of the tree(s).
>>
>> If you interrupt the writes in any time, the filesystem can survive
>> because the old superblock-metadata-tree and data-block are still valid
>> until the last pieces (the new superblock) is written.
>>
>> And if this last step fails, the checksum shows that the super-block is
>> invalid and the old one is taken in consideration.
>
> You're not understanding what I'm saying.  If a write fails anywhere during
> the process of updating the metadata, up to and including the super-block,
> then you loose the data writes that triggered the metadata update.  This
> doesn't result in a broken filesystem, but it does result in data loss, even
> if it's not what most people think of as data loss.
>
> To make a really simplified example, assume we have a single block of data
> (D) referenced by a single metadata block (M) and a single super-block
> referencing the metadata block (S).  On a COW filesystem, when you write to
> D, it allocates and writes a new block (D2) to store the data, then
> allocates and writes a new metadata block (M2) to point to D2, and then
> updates the superblock in-place to point to M2.  If the write to M2 fails,
> you loose all new data in D2 that wasn't already in D.  There is no way that
> a COW filesystem can avoid this type of data loss without being able to
> force the underlying storage to atomically write out all of D2, M2, and S at
> the same time, it's an inherent issue in COW semantics in general, not just
> filesystems.

Sure but this is not a write hole. This exact same problem happens on
a single device file system. Do you know if raid56 parity strips are
considered part of (D) or (M)? In any case I think the Btrfs write
hole is different than what you're talking about.

The concern about the parity raid write hole is data is written OK,
and only in the event a device goes missing or there's an IO error on
a data containing block, such that reconstruction from parity is
required, if there's a bad or torn write for parity then the
reconstruction is bad and you won't know it. That's the key thing:
silent corruption during reconstruction.

Of all the problems we're having with raid56 in the general sense, let
alone the Btrfs specific case, the raid56 write hole seems like an
astronomically minor issue. What I'm much more curious about is how
these stripes are even being COWd in the first place, and how many
more IOs we're hit with compared to the same transaction on a single
device.




>>

>> The only critical thing, is that the hardware has to not lie about the
>> fact that the data reached the platter. Most of the problem reported in the
>> ML are related to external disk used in USB enclousure, which most of the
>> time lie about this aspect.
>
> That really depends on what you mean by 'lie about the data being on the
> platter'.  All modern hard disks have a write cache, and a decent percentage
> don't properly support flushing the write cache except by waiting for it to
> drain, many of them arbitrarily re-order writes within the cache, and none
> that I've seen have a non-volatile write cache, and therefore all such disks
> arguably lie about when the write is actually complete.  SSD's add yet
> another layer of complexity to this, because the good ones have either a
> non-volatile write cache, or have built-in batteries or super-capacitors to
> make sure they can flush the write cache when power is lost, so some SSD's
> can behave just like HDD's do and claim the write is complete when it hits
> the cache without technically lying, but most SSD's don't document whether
> they do this or not.

Yeah I think the ship of knowing what happens inside these boxes is in
the process of sailing away, if not gone. On the plus side, they do
all of this faster than a HDD would. So there's a better chance of the
command queue in the write cache actually completing to stable media
than is the case for a HDD *IF* the manufacturer has done the work and
testing.

-- 
Chris Murphy
