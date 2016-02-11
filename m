Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34872 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbcBKPAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 10:00:49 -0500
Received: by mail-ig0-f176.google.com with SMTP id hb3so36692399igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 07:00:49 -0800 (PST)
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
To: kreijack@inwind.it, Chris Murphy <lists@colorremedies.com>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
 <CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
 <56BB41E3.8050906@gmail.com>
 <CAJCQCtS8wDV93Eyb6pDaCJBY7_v8misn1p9e=4KVGdK6=CKL_A@mail.gmail.com>
 <56BB9698.5020203@gmail.com> <56BC9734.403@inwind.it>
Cc: Mackenzie Meyer <snackmasterx@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56BCA188.9070603@gmail.com>
Date: Thu, 11 Feb 2016 09:58:16 -0500
MIME-Version: 1.0
In-Reply-To: <56BC9734.403@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-11 09:14, Goffredo Baroncelli wrote:
> On 2016-02-10 20:59, Austin S. Hemmelgarn wrote:
> [...]
>> Again, a torn write to the metadata referencing the block (stripe in
>> this case I believe) will result in loosing anything written by the
>> update to the stripe.
>
> I think that the order matters: first the data block are written (in a new location, so the old data are untouched), then the metadata, from the leafs up to the upper node (again in a new location), then the superblock which references to the upper node of the tree(s).
>
> If you interrupt the writes in any time, the filesystem can survive because the old superblock-metadata-tree and data-block are still valid until the last pieces (the new superblock) is written.
>
> And if this last step fails, the checksum shows that the super-block is invalid and the old one is taken in consideration.
You're not understanding what I'm saying.  If a write fails anywhere 
during the process of updating the metadata, up to and including the 
super-block, then you loose the data writes that triggered the metadata 
update.  This doesn't result in a broken filesystem, but it does result 
in data loss, even if it's not what most people think of as data loss.

To make a really simplified example, assume we have a single block of 
data (D) referenced by a single metadata block (M) and a single 
super-block referencing the metadata block (S).  On a COW filesystem, 
when you write to D, it allocates and writes a new block (D2) to store 
the data, then allocates and writes a new metadata block (M2) to point 
to D2, and then updates the superblock in-place to point to M2.  If the 
write to M2 fails, you loose all new data in D2 that wasn't already in 
D.  There is no way that a COW filesystem can avoid this type of data 
loss without being able to force the underlying storage to atomically 
write out all of D2, M2, and S at the same time, it's an inherent issue 
in COW semantics in general, not just filesystems.
>
>
>> There is no way that _any_ system can avoid
>> this issue without having the ability to truly atomically write out
>> the entire metadata tree after the block (stripe) update.
>
> It is not needed to atomically write the (meta)data in a COW filesystem, because the new data don't owerwrite the old one. The only thing that is needed is that before the last piece is written all the previous (mata)data are already written.\
Even when enforcing ordering, the issue I've outlined above is still 
present.  If a write fails at any point in the metadata updates 
cascading up the tree, then any new data below that point in the tree is 
lost.
>
> For not COW filesystem a journal is required to avoid this kind of problem.
To a certain extent yes, but journals have issues that COW doesn't.  A 
torn write in the journal on most traditional journaling filesystems 
will often result in a broken filesystem.
>
>> Doing so
>> would require a degree of tight hardware level integration that's
>> functionally impossible for any general purpose system (in essence,
>> the filesystem would have to be implemented in the hardware, not
>> software).
>
> To solve the raid-write-hole problem, a checksum system (of data and metadata) is sufficient. However to protect with checksum the data, it seems that a COW filesystem is required.
Either COW, or log structuring, or the ability to atomically write out 
groups of blocks.  Log structuring (like NILFS2, or LogFS, or even LFS 
from *BSD) has performance implications on traditional rotational media, 
and only recently are storage devices appearing that can actually handle 
atomic writes of groups of multiple blocks at the same time, so COW has 
been the predominant model because it works on everything, and doesn't 
have the performance issues of log-structured filesystems (if 
implemented correctly).
>
> The only critical thing, is that the hardware has to not lie about the fact that the data reached the platter. Most of the problem reported in the ML are related to external disk used in USB enclousure, which most of the time lie about this aspect.
That really depends on what you mean by 'lie about the data being on the 
platter'.  All modern hard disks have a write cache, and a decent 
percentage don't properly support flushing the write cache except by 
waiting for it to drain, many of them arbitrarily re-order writes within 
the cache, and none that I've seen have a non-volatile write cache, and 
therefore all such disks arguably lie about when the write is actually 
complete.  SSD's add yet another layer of complexity to this, because 
the good ones have either a non-volatile write cache, or have built-in 
batteries or super-capacitors to make sure they can flush the write 
cache when power is lost, so some SSD's can behave just like HDD's do 
and claim the write is complete when it hits the cache without 
technically lying, but most SSD's don't document whether they do this or 
not.
