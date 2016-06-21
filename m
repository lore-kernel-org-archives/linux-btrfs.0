Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50346 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbcFUKrS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 06:47:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bFIAY-0002Qr-66
	for linux-btrfs@vger.kernel.org; Tue, 21 Jun 2016 11:40:31 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 11:40:30 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 11:40:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confusing output from fi us/df
Date: Tue, 21 Jun 2016 09:40:03 +0000 (UTC)
Message-ID: <pan$6d3ec$dd29216d$2134ccda$99566f84@cox.net>
References: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
	<4c73e55f-aabb-4ec3-c419-e970b9506d7d@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Tue, 21 Jun 2016 02:25:20 +0200 as
excerpted:

> On 06/21/2016 01:30 AM, Marc Grondin wrote:
>>
>> I have a btrfs filesystem ontop of a 4x1tb mdraid raid5 array and I've
>> been getting confusing output on metadata usage. Seems that even tho
>> both data and metadata are in single profile metadata is reporting
>> double the space(as if it was in dupe profile)
> 
> I guess that's a coincidence.

Yes.

>  From the total amount of space you have (on top of the mdraid), there's
> 3 GiB allocated/reserved for use as metadata. Inside that 3 GiB, 1.53GiB
> of actual metadata is present.
> 
>>[...]
>> Metadata,single: Size:3.00GiB, Used:1.53GiB
>> /dev/mapper/storage2 3.00GiB
> 
>> Metadata, single: total=3.00GiB, used=1.53GiB

[Explaining a bit more than HvK or ST did.]

Btrfs does two-stage allocation.  First it allocates chunks, separately 
for data vs. metadata.  Then it uses the space in those chunks, until it 
needs to allocate more.

It's simply coincidence that the actual used metadata space within the 
allocation happens to be approximately half of the allocated metadata 
chunk space.

Tho unlike data, metadata space should never get completely full -- it'll 
need to to allocate a new chunk before it reports full, because the 
global reserve space (which is always zero usage unless the filesystem is 
in severe straits, if you ever see global reserve usage above zero you 
know the filesystem is in serious trouble, space-wise) comes from 
metadata as well.

So in reality, you have 3 gigs of metadata chunks allocated, 1.53 gigs of 
it used for actual metadata, and half a gig (512 MiB) reserved as global-
reserve (none of which is used =:^), so in actuality, approximately 2.03 
GiB of the 3.00 GiB of metadata chunks are used, with 0.97 GiB of 
metadata free.

Now metadata chunks are nominally 256 MiB (quarter GiB) each, while data 
chunks are nominally 1 GiB each.  However, that's just the _nominal_ 
size.  On TB-scale filesystems they may be larger.

In any case, you could balance the metadata and possibly reclaim a bit of 
space, but with usage including the reserve slightly over 2 GiB, you 
could only get down to 2.25 GiB metadata allocation best-case, and may be 
stuck with 2.5 or even the same 3 GiB, depending on actual metadata chunk 
size.

But I'd not worry about it yet.  Once unallocated space gets down to 
about half a TB, or either data or metadata size becomes multiple times 
actual usage, a balance will arguably be useful.  But the numbers look 
pretty healthy ATM.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

