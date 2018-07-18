Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:55898 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbeGRN2Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 09:28:16 -0400
Received: by mail-it0-f65.google.com with SMTP id 16-v6so3938708itl.5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 05:50:28 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 64-v6sm910485iou.36.2018.07.18.05.50.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jul 2018 05:50:27 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6901a05c-d71b-bf2e-b66f-69b02aee527d@gmail.com>
Date: Wed, 18 Jul 2018 08:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-18 03:20, Duncan wrote:
> Goffredo Baroncelli posted on Wed, 18 Jul 2018 07:59:52 +0200 as
> excerpted:
> 
>> On 07/17/2018 11:12 PM, Duncan wrote:
>>> Goffredo Baroncelli posted on Mon, 16 Jul 2018 20:29:46 +0200 as
>>> excerpted:
>>>
>>>> On 07/15/2018 04:37 PM, waxhead wrote:
>>>
>>>> Striping and mirroring/pairing are orthogonal properties; mirror and
>>>> parity are mutually exclusive.
>>>
>>> I can't agree.  I don't know whether you meant that in the global
>>> sense,
>>> or purely in the btrfs context (which I suspect), but either way I
>>> can't agree.
>>>
>>> In the pure btrfs context, while striping and mirroring/pairing are
>>> orthogonal today, Hugo's whole point was that btrfs is theoretically
>>> flexible enough to allow both together and the feature may at some
>>> point be added, so it makes sense to have a layout notation format
>>> flexible enough to allow it as well.
>>
>> When I say orthogonal, It means that these can be combined: i.e. you can
>> have - striping (RAID0)
>> - parity  (?)
>> - striping + parity  (e.g. RAID5/6)
>> - mirroring  (RAID1)
>> - mirroring + striping  (RAID10)
>>
>> However you can't have mirroring+parity; this means that a notation
>> where both 'C' ( = number of copy) and 'P' ( = number of parities) is
>> too verbose.
> 
> Yes, you can have mirroring+parity, conceptually it's simply raid5/6 on
> top of mirroring or mirroring on top of raid5/6, much as raid10 is
> conceptually just raid0 on top of raid1, and raid01 is conceptually raid1
> on top of raid0.
> 
> While it's not possible today on (pure) btrfs (it's possible today with
> md/dm-raid or hardware-raid handling one layer), it's theoretically
> possible both for btrfs and in general, and it could be added to btrfs in
> the future, so a notation with the flexibility to allow parity and
> mirroring together does make sense, and having just that sort of
> flexibility is exactly why Hugo made the notation proposal he did.
> 
> Tho a sensible use-case for mirroring+parity is a different question.  I
> can see a case being made for it if one layer is hardware/firmware raid,
> but I'm not entirely sure what the use-case for pure-btrfs raid16 or 61
> (or 15 or 51) might be, where pure mirroring or pure parity wouldn't
> arguably be a at least as good a match to the use-case.  Perhaps one of
> the other experts in such things here might help with that.
> 
>>>> Question #2: historically RAID10 is requires 4 disks. However I am
>>>> guessing if the stripe could be done on a different number of disks:
>>>> What about RAID1+Striping on 3 (or 5 disks) ? The key of striping is
>>>> that every 64k, the data are stored on a different disk....
>>>
>>> As someone else pointed out, md/lvm-raid10 already work like this.
>>> What btrfs calls raid10 is somewhat different, but btrfs raid1 pretty
>>> much works this way except with huge (gig size) chunks.
>>
>> As implemented in BTRFS, raid1 doesn't have striping.
> 
> The argument is that because there's only two copies, on multi-device
> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
> alternate device pairs, it's effectively striped at the macro level, with
> the 1 GiB device-level chunks effectively being huge individual device
> strips of 1 GiB.
Actually, it also behaves like LVM and MD RAID10 for any number of 
devices greater than 2, though the exact placement may diverge because 
of BTRFS's concept of different chunk types.  In LVM and MD RAID10, each 
block is stored as two copies, and what disks it ends up on is dependent 
on the block number modulo the number of disks (so, for 3 disks A, B, 
and C, block 0 is on A and B, block 1 is on C and A, and block 2 is on B 
and C, with subsequent blocks following the same pattern).  In an 
idealized model of BTRFS with only one chunk type, you get exactly the 
same behavior (because BTRFS allocates chunks based on disk utilization, 
and prefers lower numbered disks to higher ones in the event of a tie).
> 
> At 1 GiB strip size it doesn't have the typical performance advantage of
> striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
> strips/chunks.
>
