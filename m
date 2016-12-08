Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34074 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcLHUrB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 15:47:01 -0500
Received: by mail-io0-f196.google.com with SMTP id y124so2537349iof.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 12:47:00 -0800 (PST)
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: Jeff Mahoney <jeffm@suse.com>,
        =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>
 <808d0394-db2a-0a15-d084-309accc04ff9@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <cad63831-e8d5-a21c-3a6e-9ed2faca09b4@gmail.com>
Date: Thu, 8 Dec 2016 15:46:55 -0500
MIME-Version: 1.0
In-Reply-To: <808d0394-db2a-0a15-d084-309accc04ff9@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-08 15:07, Jeff Mahoney wrote:
> On 12/8/16 10:42 AM, Austin S. Hemmelgarn wrote:
>> On 2016-12-08 10:11, Swâmi Petaramesh wrote:
>>> Hi, Some real world figures about running duperemove deduplication on
>>> BTRFS :
>>>
>>> I have an external 2,5", 5400 RPM, 1 TB HD, USB3, on which I store the
>>> BTRFS backups (full rsync) of 5 PCs, using 2 different distros,
>>> typically at the same update level, and all of them more of less sharing
>>> the entirety or part of the same set of user files.
>>>
>>> For each of these PCs I keep a series of 4-5 BTRFS subvolume snapshots
>>> for having complete backups at different points in time.
>>>
>>> The HD was full to 93% and made a good testbed for deduplicating.
>>>
>>> So I ran duperemove on this HD, on a machine doing "only this", using a
>>> hashfile. The machine being an Intel i5 with 6 GB of RAM.
>>>
>>> Well, the damn thing has been running for 15 days uninterrupted !
>>> ...Until I [Ctrl]-C it this morning as I had to move with the machine (I
>>> wasn't expecting it to last THAT long...).
>>>
>>> It took about 48 hours just for calculating the files hashes.
>>>
>>> Then it took another 48 hours just for "loading the hashes of duplicate
>>> extents".
>>>
>>> Then it took 11 days deduplicating until I killed it.
>>>
>>> At the end, the disk that was 93% full is now 76% full, so I saved 17%
>>> of 1 TB (170 GB) by deduplicating for 15 days.
>>>
>>> Well the thing "works" and my disk isn't full anymore, so that's a very
>>> partial success, but still l wonder if the gain is worth the effort...
>> So, some general explanation here:
>> Duperemove hashes data in blocks of (by default) 128kB, which means for
>> ~930GB, you've got about 7618560 blocks to hash, which partly explains
>> why it took so long to hash.  Once that's done, it then has to compare
>> hashes for all combinations of those blocks, which totals to
>> 58042456473600 comparisons (hence that taking a long time).  The block
>> size thus becomes a trade-off between performance when hashing and
>> actual space savings (smaller block size makes hashing take longer, but
>> gives overall slightly better results for deduplication).
>
> IIRC, the core of the duperemove duplicate matcher isn't an O(n^2)
> algorithm.  I think Mark used a bloom filter to reduce the data set
> prior to matching, but I haven't looked at the code in a while.
>
You're right, I had completely forgotten about that.

Regardless of that though, it's still a lot of processing that needs done.

