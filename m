Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:58590 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750938AbeDDFP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 01:15:58 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Status of RAID5/6
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org> <20180403003102.GI2446@hungrycats.org>
 <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
 <20180403225742.GJ2446@hungrycats.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cfae662a-d64d-6fd8-9ca3-9892fc349747@inwind.it>
Date: Wed, 4 Apr 2018 07:15:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180403225742.GJ2446@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/2018 12:57 AM, Zygo Blaxell wrote:
>> I have to point out that in any case the extent is physically
>> interrupted at the disk-stripe size. Assuming disk-stripe=64KB, if
>> you want to write 128KB, the first half is written in the first disk,
>> the other in the 2nd disk.  If you want to write 96kb, the first 64
>> are written in the first disk, the last part in the 2nd, only on a
>> different BG.
> The "only on a different BG" part implies something expensive, either
> a seek or a new erase page depending on the hardware.  Without that,
> nearby logical blocks are nearby physical blocks as well.

In any case it happens on a different disk

> 
>> So yes there is a fragmentation from a logical point of view; from a
>> physical point of view the data is spread on the disks in any case.

> What matters is the extent-tree point of view.  There is (currently)
> no fragmentation there, even for RAID5/6.  The extent tree is unaware
> of RAID5/6 (to its peril).

Before you pointed out that the non-contiguous block written has an impact on performance. I am replaying  that the switching from a different BG happens at the stripe-disk boundary, so in any case the block is physically interrupted and switched to another disk

However yes: from an extent-tree point of view there will be an increase of number extents, because the end of the writing is allocated to another BG (if the size is not stripe-boundary)

> If an application does a loop writing 68K then fsync(), the multiple-BG
> solution adds two seeks to read every 68K.  That's expensive if sequential
> read bandwidth is more scarce than free space.

Why you talk about an additional seeks? In any case (even without the additional BG) the read happens from another disks

>> * c),d),e) are applied only for the tail of the extent, in case the
> size is less than the stripe size.
> 
> It's only necessary to split an extent if there are no other writes
> in the same transaction that could be combined with the extent tail
> into a single RAID stripe.  As long as everything in the RAID stripe
> belongs to a single transaction, there is no write hole

May be that a more "simpler" optimization would be close the transaction when the data reach the stripe boundary... But I suspect that it is not so simple to implement.

> Not for d.  Balance doesn't know how to get rid of unreachable blocks
> in extents (it just moves the entire extent around) so after a balance
> the writes would still be rounded up to the stripe size.  Balance would
> never be able to free the rounded-up space.  That space would just be
> gone until the file was overwritten, deleted, or defragged.

If balance is capable to move the extent, why not place one near the other during a balance ? The goal is not to limit the the writing of the end of a extent, but avoid writing the end of an extent without further data (e.g. the gap to the stripe has to be filled in the same transaction)

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
