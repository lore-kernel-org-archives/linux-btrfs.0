Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33553 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdHNT2l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 15:28:41 -0400
Received: by mail-vk0-f48.google.com with SMTP id j189so34737764vka.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 12:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e4506812-53a8-7a95-61e6-279af20c8303@inwind.it>
References: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
 <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com> <e4506812-53a8-7a95-61e6-279af20c8303@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 Aug 2017 13:28:40 -0600
Message-ID: <CAJCQCtTTgdyfMzZKGqMo+LyA2dW+Csq+xp6TqoGyqEmsQ-j8eQ@mail.gmail.com>
Subject: Re: [RFC] Checksum of the parity
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 8:12 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> On 08/13/2017 08:45 PM, Chris Murphy wrote:
>> [2]
>> Is Btrfs subject to the write hole problem manifesting on disk? I'm
>> not sure, sadly I don't read the code well enough. But if all Btrfs
>> raid56 writes are full stripe CoW writes, and if the prescribed order
>> guarantees still happen: data CoW to disk > metadata CoW to disk >
>> superblock update, then I don't see how the write hole happens. Write
>> hole requires: RMW of a stripe, which is a partial stripe overwrite,
>> and a crash during the modification of the stripe making that stripe
>> inconsistent as well as still pointed to by metadata.
>
>
> RAID5 is *single* failure prof. And in order to have the write hole bug we need two failure:
> 1) a transaction is aborted (e.g. due to a power failure) and the results is that data and parity are mis-aligned
> 2) a disk disappears
>
> These two events may happen even in different moment.
>
> The key is that when a disk disappear, all remaining ones are used to rebuild the missing one. So if data and parity are mis-aligned the rebuild disk is wrong.
>
> Let me to show an example
>
> Disk 1            Disk 2         Disk 3  (parity)
> AAAAAA            BBBBBB         CCCCCC
>
> where CCCCCC = AAAAA ^ BBBBB
>
> Note1: AAAAA is a valid data
>
> Supposing to update B and due to a power failure you can't update parity, you have:
>
>
> Disk 1            Disk 2         Disk 3  (parity)
> AAAAAA            DDDDDDD        CCCCCC
>
> Of course CCCCCC != AAAAA ^ DDDDD  (data and parity are misaligned).
>
>
> Pay attention that AAAAAA is still valid data.
>
> Now suppose to loose disk1. If you want to read from it, you have to perform a read of disk2 and disk3 to compute disk1.
>
> However Disk2 and disk3 are misaligned, so doing a DDDDD ^ CCCCC you don't got AAAAA anymore.
>
>
> Note that it is not important if DDDDDD or BBBBB are valid or invalid data.


Doesn't matter on Btrfs. Bad reconstruction due to wrong parity
results in csum mismatch. This I've tested.

I vaguely remember a while ago doing a dd conv=notrunc modification of
a file that's raid5, and there was no RMW, what happened is the whole
stripe was CoW'd and had the modification. So that would, hardware
behaving correctly, mean that the raid5 data CoW succeeds, then there
is a metadata CoW to point to it, then the super block is updated to
point to the new tree.

At any point, if there's an interruption, we have the old super
pointing to the old tree which points to premodified data.

Anyway, I do wish I read the code better, so I knew exactly where, if
at all, the RMW code was happening on disk rather than just in memory.
There very clearly is RMW in memory code as a performanc optimizer,
before a stripe gets written out it's possible to RMW it to add in
more changes or new files, that way raid56 isn't dog slow CoW'ing
literally a handful of 16KiB leaves each time, that then translate
into a minimum of 384K of writes.

But yeah, Qu just said in another thread that Liu is working on a
journal for the raid56 write hole problem. Thing is I don't see when
it happens in the code or in practice (so far, it's really tedious to
poke a file system with a stick).




-- 
Chris Murphy
