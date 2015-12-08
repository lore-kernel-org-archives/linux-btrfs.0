Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56587 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbbLHOPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 09:15:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6J3E-0007wU-W8
	for linux-btrfs@vger.kernel.org; Tue, 08 Dec 2015 15:15:33 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 15:15:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 15:15:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub on btrfs single device only to detect errors, not correct
 them?
Date: Tue, 8 Dec 2015 14:15:16 +0000 (UTC)
Message-ID: <pan$d0979$6427a753$f82297ce$e6f16134@cox.net>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
	<CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
	<pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
	<CA+pSGYeYwC=eWmSuC4MXsSz1qVvWqzxxv7KzxkhQ84BKUDO-MA@mail.gmail.com>
	<56659F48.6000800@gmail.com>
	<CA+pSGYdE8FxCGjR_=gU58jej6AuMMZ-wn6EzyE_g0n7Trqb_Hw@mail.gmail.com>
	<5665A819.9030804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Mon, 07 Dec 2015 10:39:05 -0500 as
excerpted:

> On 2015-12-07 10:12, Jon Panozzo wrote:
>> This is what I was thinking as well.  In my particular use-case, parity
>> is only really used today to reconstruct an entire device due to a
>> device failure.  I think if btrfs scrub detected errors on a single
>> device, I could do a "reverse reconstruct" where instead of syncing TO
>> the parity disk, I sync FROM the parity disk TO the btrfs single device
>> with the error, replacing physical blocks that are out of sync with
>> parity (thus repairing the scrub-found errrors).  The downside to this
>> approach is I would have to perform the reverse-sync against the entire
>> btrfs block device, which could be much more time-consuming than if I
>> could single out the specific block addresses and just sync those. 
>> That said, I guess option A is better than no option at all.
>>
>> I would be curious if any of the devs or other members of this mailing
>> list have tried to correlate btrfs internal block addresses to a true
>> block-address on the device being used.  Any interesting articles /
>> links that show how to do this?  Not expecting much, but if someone
>> does know, I'd be very grateful.

> I think there is a tool in btrfs-progs to do it, but I've never used it,
> and you would still need to get scrub to spit out actual error addresses
> for you.

btrfs-debug-tree is what you're looking for. =:^)

As I understand things, the complexity is due to btrfs' chunk 
abstraction, along with the multi-device feature.

On a normal filesystem, byte or block addresses are mapped linearly to 
absolute filesystem byte address and there's just the one device to worry 
about, so there's effectively little or no translation to be done.

On btrfs by contrast, block addresses map into chunks, also known as 
block groups, which are designed to be more or less arbitrarily 
relocatable within the filesystem using balance (originally called the 
restriper).  Further, these block groups can be single, striped across 
multiple devices (raid0 and the 0 side of raid10, duplicated on the same 
device (dup) or across multiple devices (only two devices currently, N-
way-mirroring is on the roadmap, raid1 and the 1 side of raid10), or 
striped with parity (raid5 and 6).

So while block addresses can map more or less linearly into block groups, 
btrfs has to maintain an entirely new layer of abstraction mapping in 
addition, that tells the filesystem where to look for that block group, 
that is, on what device (or across what devices if striped), and at what 
absolute bytenr offset into the device.

And again, keep in mind that even with a constant single/dup/raid mapping 
and even in the simplest single mode on single device, balance can and 
does more or less arbitrarily dynamically relocate block groups within 
the filesystem, so the mapping you see today may or may not be the 
mapping you see tomorrow, depending on whether a balance was run in the 
mean time.

Obviously the devs are going to need a tool to help them debug this 
additional complexity, and that's where btrfs-debug-tree comes in. =:^)

But for "ordinary mortal admins", yes, btrfs is open source and
btrfs-debug-tree is available for those that want to use it, but once 
they realize the complexity, most (including me) are going to simply be 
content to treat it as a black box and not worry too much about 
investigating its innards.

So while specific block and/or byte mapping can be done and there's tools 
available for and appropriate to the task, it's the type of thing most 
admins are very content to treat as a black box and leave well enough 
alone, once they understand the complexities involved.

"Btrfs, while he might use it, it ain't your grandfather's 
filesystem!" (TM) =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

