Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38359 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752287AbcLHSAo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 13:00:44 -0500
Received: by mail-wm0-f53.google.com with SMTP id f82so37910672wmf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 10:00:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org> <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 8 Dec 2016 21:00:02 +0300
Message-ID: <CAGqmi74nSHKiPCYHFhMkuUy9x+CXKSoXak6ROnrt5OLWnYQdEw@mail.gmail.com>
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-12-08 18:42 GMT+03:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> On 2016-12-08 10:11, Swâmi Petaramesh wrote:
>>
>> Hi, Some real world figures about running duperemove deduplication on
>> BTRFS :
>>
>> I have an external 2,5", 5400 RPM, 1 TB HD, USB3, on which I store the
>> BTRFS backups (full rsync) of 5 PCs, using 2 different distros,
>> typically at the same update level, and all of them more of less sharing
>> the entirety or part of the same set of user files.
>>
>> For each of these PCs I keep a series of 4-5 BTRFS subvolume snapshots
>> for having complete backups at different points in time.
>>
>> The HD was full to 93% and made a good testbed for deduplicating.
>>
>> So I ran duperemove on this HD, on a machine doing "only this", using a
>> hashfile. The machine being an Intel i5 with 6 GB of RAM.
>>
>> Well, the damn thing has been running for 15 days uninterrupted !
>> ...Until I [Ctrl]-C it this morning as I had to move with the machine (I
>> wasn't expecting it to last THAT long...).
>>
>> It took about 48 hours just for calculating the files hashes.
>>
>> Then it took another 48 hours just for "loading the hashes of duplicate
>> extents".
>>
>> Then it took 11 days deduplicating until I killed it.
>>
>> At the end, the disk that was 93% full is now 76% full, so I saved 17%
>> of 1 TB (170 GB) by deduplicating for 15 days.
>>
>> Well the thing "works" and my disk isn't full anymore, so that's a very
>> partial success, but still l wonder if the gain is worth the effort...
>
> So, some general explanation here:
> Duperemove hashes data in blocks of (by default) 128kB, which means for
> ~930GB, you've got about 7618560 blocks to hash, which partly explains why
> it took so long to hash.  Once that's done, it then has to compare hashes
> for all combinations of those blocks, which totals to 58042456473600
> comparisons (hence that taking a long time).  The block size thus becomes a
> trade-off between performance when hashing and actual space savings (smaller
> block size makes hashing take longer, but gives overall slightly better
> results for deduplication).
>
> As far as the rest, given your hashing performance (which is not
> particularly good I might add, roughly 5.6MB/s), the amount of time it was
> taking to do the actual deduplication is reasonable since the deduplication
> ioctl does a byte-wise comparison of the extents to be deduplicated prior to
> actually ref-linking them to ensure you don't lose data.
>
> Because of this, generic batch deduplication is not all that great on BTRFS.
> There are cases where it can work, but usually they're pretty specific
> cases.  In most cases though, you're better off doing a custom tool that
> knows about how your data is laid out and what's likely to be duplicated
> (I've actually got two tools for this for the two cases where I use
> deduplication, they use knowledge of the data-set itself to figure out
> what's duplicated, then just call the ioctl through a wrapper (previously
> the one included in duperemove, currently xfs_io)).
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Zygo do the good job on this too.
Try:
https://github.com/Zygo/bees

It's cool and can work better on large massive of data, because it
dedup in the same time with scanning phase.
-- 
Have a nice day,
Timofey.
