Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:51456 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751913AbeDBPSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Apr 2018 11:18:24 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Status of RAID5/6
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
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
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
Date: Mon, 2 Apr 2018 17:18:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180402054521.GC28769@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2018 07:45 AM, Zygo Blaxell wrote:
[...]
> It is possible to combine writes from a single transaction into full
> RMW stripes, but this *does* have an impact on fragmentation in btrfs.
> Any partially-filled stripe is effectively read-only and the space within
> it is inaccessible until all data within the stripe is overwritten,
> deleted, or relocated by balance.
>
> btrfs could do a mini-balance on one RAID stripe instead of a RMW stripe
> update, but that has a significant write magnification effect (and before
> kernel 4.14, non-trivial CPU load as well).
> 
> btrfs could also just allocate the full stripe to an extent, but emit
> only extent ref items for the blocks that are in use.  No fragmentation
> but lots of extra disk space used.  Also doesn't quite work the same
> way for metadata pages.
> 
> If btrfs adopted the ZFS approach, the extent allocator and all higher
> layers of the filesystem would have to know about--and skip over--the
> parity blocks embedded inside extents.  Making this change would mean
> that some btrfs RAID profiles start interacting with stuff like balance
> and compression which they currently do not.  It would create a new
> block group type and require an incompatible on-disk format change for
> both reads and writes.

I thought that a possible solution is to create BG with different number of data disks. E.g. supposing to have a raid 6 system with 6 disks, where 2 are parity disk; we should allocate 3 BG

BG #1: 1 data disk, 2 parity disks
BG #2: 2 data disks, 2 parity disks,
BG #3: 4 data disks, 2 parity disks

For simplicity, the disk-stripe length is assumed = 4K.

So If you have a write with a length of 4 KB, this should be placed in BG#1; if you have a write with a length of 4*3KB, the first 8KB, should be placed in in BG#2, then in BG#1.

This would avoid space wasting, even if the fragmentation will increase (but shall the fragmentation matters with the modern solid state disks ?).

Time to time, a re-balance should be performed to empty the BG #1, and #2. Otherwise a new BG should be allocated.

The cost should be comparable to the logging/journaling (each data shorter than a full-stripe, has to be written two times); the implementation should be quite easy, because already NOW btrfs support BG with different set of disks.

BR 
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
