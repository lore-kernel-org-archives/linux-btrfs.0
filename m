Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57994 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751649AbdHPOCC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 10:02:02 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Chris Mason <clm@fb.com>, Christoph Anton Mitterer <calestyo@scientia.net>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <20170816131230.GA28619@clm-mbp.thefacebook.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <51e051fa-3731-d2fe-7eab-cb324fd38576@gmx.com>
Date: Wed, 16 Aug 2017 22:01:48 +0800
MIME-Version: 1.0
In-Reply-To: <20170816131230.GA28619@clm-mbp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月16日 21:12, Chris Mason wrote:
> On Mon, Aug 14, 2017 at 09:54:48PM +0200, Christoph Anton Mitterer wrote:
>> On Mon, 2017-08-14 at 11:53 -0400, Austin S. Hemmelgarn wrote:
>>> Quite a few applications actually _do_ have some degree of secondary
>>> verification or protection from a crash.  Go look at almost any
>>> database
>>> software.
>> Then please give proper references for this!
>>
>> This is from 2015, where you claimed this already and I looked up all
>> the bigger DBs and they either couldn't do it at all, didn't to it per
>> default, or it required application support (i.e. from the programs
>> using the DB)
>> https://www.spinics.net/lists/linux-btrfs/msg50258.html
>>
>>
>>> It usually will not have checksumming, but it will almost
>>> always have support for a journal, which is enough to cover the
>>> particular data loss scenario we're talking about (unexpected
>>> unclean
>>> shutdown).
>>
>> I don't think we talk about this:
>> We talk about people wanting checksuming to notice e.g. silent data
>> corruption.
>>
>> The crash case is only the corner case about what happens then if data
>> is written correctly but csums not.
> 
> We use the crcs to catch storage gone wrong, both in terms of simple 
> things like cabling, bus errors, drives gone crazy or exotic problems 
> like every time I reboot the box a handful of sectors return EFI 
> partition table headers instead of the data I wrote.  You don't need 
> data center scale for this to happen, but it does help...
> 
> So, we do catch crc errors in prod and they do keep us from replicating 
> bad data over good data.  Some databases also crc, and all drives have 
> correction bits of of some kind.  There's nothing wrong with crcs 
> happening at lots of layers.
> 
> Btrfs couples the crcs with COW because it's the least complicated way 
> to protect against:
> 
> * bits flipping
> * IO getting lost on the way to the drive, leaving stale but valid data 
> in place
> * IO from sector A going to sector B instead, overwriting valid data 
> with other valid data.
> 
> It's possible to protect against all three without COW, but all 
> solutions have their own tradeoffs and this is the setup we chose.  It's 
> easy to trust and easy to debug and at scale that really helps.
> 
> In general, production storage environments prefer clearly defined 
> errors when the storage has the wrong data.  EIOs happen often, and you 
> want to be able to quickly pitch the bad data and replicate in good data.

Btrfs csum is really good, specially for case like RAID1/5/6 where csum 
can provide extra info about which mirror/stripe/parity can be trusted, 
with minimal space wasted.

DM layer should really have the ability to verify its data at that 
timing like btrfs.

> 
> My real goal is to make COW fast enough that we can leave it on for the 
> database applications too.

Yes, most of the complexity of nodatasum/nodatacow comes from those 
special workload.

BTW, when Fujitsu tested the postgresql workload on btrfs, the result is 
quite interesting.

For HDD, when number of clients is low, btrfs shows obvious performance 
drop.
And the problem seems to be mandatory metadata COW, which leads to 
superblock FUA updates.
And when number of clients grow, difference between btrfs and other fses 
gets much smaller, the bottleneck is the HDD itself.

While for SSD, when number of clients is low, btrfs is almost the same 
performance as other fses, nodatacow/nodatasum only provides marginal 
difference.
But when number of clients grows, btrfs falls far behind other fses.
The reason seems to be related to how postgresql commit its transaction, 
which always fsync its journal sequentially without concurrency.
While Btrfs needs to wait its data write before updating its log tree, 
this makes most of its time wasted on waiting data IO.
In that case, nodatacow does improves the performance, by allowing btrfs 
to update its log tree without waiting data IO.

But in both case, CoW itself, like allocating new extent, or calculating 
csum, is not the main cause to slow down btrfs.
That's to say, nodatacow is not as important as we used to think.

If we can get rid of nodatacow/nodatasum, there will be much less thing 
to consider for us developers, and less related bugs.

Thanks,
Qu

>  Obviously I haven't quite finished that one 
> yet ;) But I'd rather keep the building block of all the other btrfs 
> features in place than try to do crcs differently.
> 
> -chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
