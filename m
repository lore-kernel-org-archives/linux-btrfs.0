Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaCWLzB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 07:55:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WRgzS-0003QK-NY
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 12:54:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 12:54:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 12:54:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fresh btrfs filesystem, out of disk space, hundreds of gigs
 free
Date: Sun, 23 Mar 2014 11:54:33 +0000 (UTC)
Message-ID: <pan$f067e$207e78c5$5a4bdc21$cc0fba96@cox.net>
References: <CAKuK5J05tCf55T1X_ENNdP4oXCiODXSR48coQ0rgkihcb9EUSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jon Nelson posted on Sat, 22 Mar 2014 18:21:02 -0500 as excerpted:

>>> # btrfs fi df /
>>> Data, single: total=1.80TiB, used=832.22GiB
>>> System,  DUP: total=8.00MiB, used=204.00KiB
>>> Metadata, DUP: total=5.50GiB, used=5.00GiB

[The 0-used single listings left over from filesystem creation omitted.]

>> Metadata is the red-flag here.  Metadata chunks are 256 MiB in size,
>> but in default DUP mode, two are allocated at once, thus 512 MiB at a
>> time. And you're [below that so close to needing more allocated].
> 
> The size of the chunks allocated is especially useful information. I've
> not seen that anywhere else, and does explain a fair bit.

I actually had to dig a little bit for that information, but like you I 
found it quite useful, so the digging was worth it. =:^)

>> But for a complete picture you need the filesystem show output, below,
>> as well...
>>
>>> # btrfs fi show Label: none  uuid: [...]
>>>         Total devices 1 FS bytes used 837.22GiB
>>>         devid 1 size 1.81TiB used 1.81TiB path /dev/sda3
>>
>> OK.  Here we see the root problem.  Size 1.81 TiB, used 1.81 TiB.  No
>> unallocated space at all.  Whichever runs out of space first, data or
>> metadata, you'll be stuck.
> 
> Now it's at this point that I am unclear. I thought the above said:

> "1 device on this filesystem, 837.22 GiB used."

> and

> [devID #1, /dev/sda3, is 1.81TiB in size, with btrfs using it all.]
> 
> Which I interpret differently. Can you go into more detail as to how
> (from btrfs fi show) we can say "the _filesystem_ (not the device) is
> full"?

FWIW, there has been some discussion about changing the way both df and 
show present their information, giving a bit more than they are now and 
ideally presenting the core information you need both commands to see 
now, in one.  I expect that to eventually happen, but meanwhile, the 
output of filesystem show in particular /is/ a bit confusing.  I actually 
think they need to omit or change the size displayed on the total devices 
line entirely, as the information it gives, without the information from 
filesystem df as well, really isn't useful on its own, and is an 
invitation to confusion and misinterpretation, much like you found 
yourself with, because it really isn't related to the numbers given (in 
show) for the individual devices at all, and is only useful in the 
context of filesystem df, which is where it belongs, NOT in show!  My 
opinion, of course. =:^)

Anyway, if you compare the numbers from filesystem df and do the math, 
you'll quickly find what the total size in show is actually telling you:

>From df: data-used + metadata-used + system-used = ...

>From show: filesystem total used.

Given the numbers posted above:

>From df: data-used=     832.22 GiB (out of 1.8 TiB allocated/total data)
         metadata-used=   5.00 GiB (out of 5.5 GiB allocated metadata)
         system-used=   (insignificant, well under a MiB)

>From show, the total:

         total-used=    837.22 GiB

The PROBLEM is that the numbers the REST of show is giving you are 
something entirely different, only tangentially related:

>From show: per device:

1) Total filesystem size on that device.

2) Total of all chunk allocations (*NOT* what's actually used from those 
allocations) on that device, altho it's /labeled/ "used" in show's 
individual device listings).

Again, comparing from df it's quickly apparent where the numbers come 
from, the totals (*NOT* used) of data+metadata+system allocations 
(labeled total in df, but it's the allocated).

Given the posting above, that'd be:

>From df: data-allocated (total) = 1.80 TiB
         metadata-allocated     = 0.005 TiB (5.5 GiB)
         system-allocated       = (trivial, a few MiB)

>From show, adding up all individual devices, in your case just one:

        total-allocated         = 1.81 TiB (obviously rounded slightly)

3) What's *NOT* shown but can be easily deduced by subtracting allocated 
(labeled used) from total is the unallocated, thus still free to allocate.

In this case, that's zero, since the filesystem size on that (single) 
device is 1.81 TiB and 1.81 TiB is allocated.

So there's nothing left available to allocate and you're running out of 
metadata space and need to allocate some more, thus the problem, despite 
the fact that both normal (not btrfs) df and btrfs filesystem show, 
APPEAR to say there's plenty of room left.  Btrfs filesystem show 
ACTUALLY says there's NO room left, at least for further chunk 
allocations, but you really have to understand what information it's 
presenting and how, in ordered to actually get what it's telling you.

Like I said, I really wish show's total used size either wasn't even 
there, or likewise corresponded to the allocation, not what's used from 
that allocation, as all the device lines do.

But that /does/ explain why the total of all the device used (in your 
case just one) doesn't equal the total used of the filesystem -- they're 
reporting two *ENTIRELY* different things!!  No WONDER people are 
confused!


>> To correct that imbalance and free the extra data space to the pool so
>> more metadata can be allocated, you run a balance.
> 
> In fact, I did try a balance - both a data-only and a metadata-only
> balance. The metadata-only balance failed. I cancelled the data-only
> balance early, although perhaps I should have been more patient. I went
> from a running system to working from a rescue environment -- I was
> under a bit of time pressure to get things moving again.

Well, as I explained it may well have failed due to lack of space anyway, 
without trying a rather low -dusage= parameter first.  Tho it's possible 
it would have freed some space in the process, enough so that you could 
run it again and not get the errors the second time.  But since I guess 
you weren't aware of the -dusage= thing, you'd have probably seen the 
balance out of space error and given up anyway, so it's probably just as 
well that you gave up a bit earlier than that, after all.

Meanwhile, I've actually had the two balance thing, the first fail on 
some chunks due to lack of space, the second succeed, happen here.  I was 
not entirely out of space but close, and a first balance didn't have 
enough space to rebalance some of the fuller chunks when it got to them 
so gave an error on them, but a few of the less used chunks were 
consolidated without error on them, and that gave me enough more space 
after the first balance with errors so that I could run a second balance 
and have it complete without error.

(I'm on SSD and have my devices partitioned up into smaller partitions as 
well, my largest btrfs being well under 100 gigs, so between the small 
size and the fast SSD, a full balance on any single btrfs is a couple 
minutes or less, so running that second balance after the first was 
actually rather trivial; nothing at all like the big deal it'd be on a
TiB+ spinning rust device!)

> To be honest, it seems like a lot of hoop-jumping and a maintenance
> burden for the administrator. Not being able to draw from "free space
> pool" for either data or metadata seems like a big bummer. I'm hoping
> that such a limitation will be resolved at some near-term future point.

Well (as I guess you probably understand now), you /can/ draw from the 
free (unallocated) space pool for either, but your problem was that it 
had been drawn dry -- the data chunks were hogging it all!  And as I (and 
Hugo) explained, unfortunately btrfs doesn't automatically reclaim unused 
but allocated chunks to the unallocated pool yet -- you presently have to 
run a balance for that.

But you're right.  Ideally btrfs would be able to automatically reclaim 
chunks TO unallocated just as it can automatically claim them FROM 
unallocated, and as Hugo says, it has been discussed, just not 
implemented yet.  Until then the automatic process is unfortunately only 
one way, and you have to manually run a balance to go the other way. =:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

