Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:55790 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbeDBPtq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 11:49:46 -0400
Received: by mail-it0-f53.google.com with SMTP id 142-v6so19313048itl.5
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Apr 2018 08:49:46 -0700 (PDT)
Subject: Re: Status of RAID5/6
To: kreijack@inwind.it, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
Date: Mon, 2 Apr 2018 11:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-02 11:18, Goffredo Baroncelli wrote:
> On 04/02/2018 07:45 AM, Zygo Blaxell wrote:
> [...]
>> It is possible to combine writes from a single transaction into full
>> RMW stripes, but this *does* have an impact on fragmentation in btrfs.
>> Any partially-filled stripe is effectively read-only and the space within
>> it is inaccessible until all data within the stripe is overwritten,
>> deleted, or relocated by balance.
>>
>> btrfs could do a mini-balance on one RAID stripe instead of a RMW stripe
>> update, but that has a significant write magnification effect (and before
>> kernel 4.14, non-trivial CPU load as well).
>>
>> btrfs could also just allocate the full stripe to an extent, but emit
>> only extent ref items for the blocks that are in use.  No fragmentation
>> but lots of extra disk space used.  Also doesn't quite work the same
>> way for metadata pages.
>>
>> If btrfs adopted the ZFS approach, the extent allocator and all higher
>> layers of the filesystem would have to know about--and skip over--the
>> parity blocks embedded inside extents.  Making this change would mean
>> that some btrfs RAID profiles start interacting with stuff like balance
>> and compression which they currently do not.  It would create a new
>> block group type and require an incompatible on-disk format change for
>> both reads and writes.
> 
> I thought that a possible solution is to create BG with different number of data disks. E.g. supposing to have a raid 6 system with 6 disks, where 2 are parity disk; we should allocate 3 BG
> 
> BG #1: 1 data disk, 2 parity disks
> BG #2: 2 data disks, 2 parity disks,
> BG #3: 4 data disks, 2 parity disks
> 
> For simplicity, the disk-stripe length is assumed = 4K.
> 
> So If you have a write with a length of 4 KB, this should be placed in BG#1; if you have a write with a length of 4*3KB, the first 8KB, should be placed in in BG#2, then in BG#1.
> 
> This would avoid space wasting, even if the fragmentation will increase (but shall the fragmentation matters with the modern solid state disks ?).
Yes, fragmentation _does_ matter even with storage devices that have a 
uniform seek latency (such as SSD's), because less fragmentation means 
fewer I/O requests have to be made to load the same amount of data. 
Contrary to popular belief uniform seek-time devices do still perform 
better doing purely sequential I/O to random I/O because larger requests 
can be made, the difference is just small enough that it only matters if 
you're constantly using all the disk bandwidth.

Also, you're still going to be wasting space, it's just that less space 
will be wasted, and it will be wasted at the chunk level instead of the 
block level, which opens up a whole new set of issues to deal with, most 
significantly that it becomes functionally impossible without 
brute-force search techniques to determine when you will hit the 
common-case of -ENOSPC due to being unable to allocate a new chunk.
> 
> Time to time, a re-balance should be performed to empty the BG #1, and #2. Otherwise a new BG should be allocated.
> 
> The cost should be comparable to the logging/journaling (each data shorter than a full-stripe, has to be written two times); the implementation should be quite easy, because already NOW btrfs support BG with different set of disks.

