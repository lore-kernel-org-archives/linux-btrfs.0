Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:50225 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751994AbeDDVbg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 17:31:36 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: Status of RAID5/6
Reply-To: kreijack@inwind.it
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org> <20180403003102.GI2446@hungrycats.org>
 <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
 <20180403225742.GJ2446@hungrycats.org>
 <cfae662a-d64d-6fd8-9ca3-9892fc349747@inwind.it>
 <20180404060101.GK2446@hungrycats.org>
Message-ID: <3c7e2da6-0328-5526-9a00-f480086a3935@inwind.it>
Date: Wed, 4 Apr 2018 23:31:33 +0200
MIME-Version: 1.0
In-Reply-To: <20180404060101.GK2446@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/2018 08:01 AM, Zygo Blaxell wrote:
> On Wed, Apr 04, 2018 at 07:15:54AM +0200, Goffredo Baroncelli wrote:
>> On 04/04/2018 12:57 AM, Zygo Blaxell wrote:
[...]
>> Before you pointed out that the non-contiguous block written has
>> an impact on performance. I am replaying  that the switching from a
>> different BG happens at the stripe-disk boundary, so in any case the
>> block is physically interrupted and switched to another disk
> 
> The difference is that the write is switched to a different local address
> on the disk.
> 
> It's not "another" disk if it's a different BG.  Recall in this plan
> there is a full-width BG that is on _every_ disk, which means every
> small-width BG shares a disk with the full-width BG.  Every extent tail
> write requires a seek on a minimum of two disks in the array for raid5,
> three disks for raid6.  A tail that is strip-width minus one will hit
> N - 1 disks twice in an N-disk array.

Below I made a little simulation; my results telling me another thing:

Current BTRFS (w/write hole)

Supposing 5 disk raid 6 and stripe size=64kb*3=192kb (disk stripe=64kb)

Case A.1): extent size = 192kb:
5 writes of 64kb spread on 5 disks (3data + 2 parity)

Case A.2.2): extent size = 256kb: (optimistic case: contiguous space available)
5 writes of 64kb spread on 5 disks (3 data + 2 parity)
2 reads of 64 kb spread on 2 disks (two old data of the stripe) [**]
3 writes of 64 kb spread on 3 disks (data + 2 parity)

Note that the two reads are contiguous to the 5 writes both in term of space and time. The three writes are contiguous only in terms of space, but not in terms of time, because these could happen only after the 2 reads and the consequent parities computations. So we should consider that between these two events, some disk activities happen; this means seeks between the 2 reads and the 3 writes


BTRFS with multiple BG (wo/write hole)

Supposing 5 disk raid 6 and stripe size=64kb*3=192kb (disk stripe=64kb)

Case B.1): extent size = 192kb:
5 writes of 64kb spread on 5 disks

Case B.2): extent size = 256kb:
5 writes of 64kb spread on 5 disks in BG#1
3 writes of 64 kb spread on 3 disks in BG#2 (which requires 3 seeks)

So if I count correctly:
- case B1 vs A1: these are equivalent
- case B2 vs A2.1/A2.2:
	8 writes vs 8 writes
	3 seeks vs 3 seeks
	0 reads vs 2 reads

So to me it seems that the cost of doing a RMW cycle is worse than seeking to another BG.

Anyway I am reaching the conclusion, also thanks of this discussion, that this is not enough. Even if we had solve the problem of the "extent smaller than stripe" write, we still face gain this issue when part of the file is changed.
In this case the file update breaks the old extent and will create a three extents: the first part, the new part, the last part. Until that everything is OK. However the "old" part of the file would be marked as free space. But using this part could require a RMW cycle....

I am concluding that the only two reliable solution are 
a) variable stripe size (like ZFS does) 
or b) logging the RMW cycle of a stripe 


[**] Does someone know if the checksum are checked during this read ?
[...]
 
BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
