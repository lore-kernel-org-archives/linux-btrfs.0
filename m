Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gremlin.yadt.uk ([149.255.108.98]:41507 "EHLO gremlin.yadt.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933358AbaLLJQW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 04:16:22 -0500
Date: Fri, 12 Dec 2014 09:06:48 +0000
From: David Taylor <davidt@yadt.co.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Message-ID: <20141212090647.GA5574@yadt.co.uk>
References: <5488C6CF.1080608@pobox.com>
 <20141212035651.GD22023@hungrycats.org>
 <548A84A2.4000501@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <548A84A2.4000501@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Dec 2014, Robert White wrote:

>On 12/11/2014 07:56 PM, Zygo Blaxell wrote:
>>
>>RAID5 with even parity and two devices should be exactly the same as
>>RAID1 (i.e. disk1 ^ disk2 == 0, therefore disk1 == disk2, the striping
>>is irrelevant because there is no difference in disk contents so the
>>disks are interchangeable), except with different behavior when more
>>devices are added (RAID1 will mirror chunks on pairs of disks, RAID5
>>should start writing new chunks with N stripes instead of two).
>
>That's not correct. A RAID5 with three elements presents two 
>_different_ sectors in each stripe. When one element is lost, it would 
>still present two different sectors, but the safety is gone.

The above quote is discussing two device RAID5, you are discussing
three device RAID5.

>I understand that the XOR collapses into a mirror if only two datum 
>are involved, but that's a mathematical fact that is irrelevant to the 
>definition of a RAID5 layout. When you take a wheel off of a tricycle 
>it doesn't just become a bike. And you can't make a bicycle into a 
>trike by just welding on a wheel somewhere. The infrastructure of the 
>two is completely different.

True.  A two-device RAID5 is not the same as a degraded three-device 
RAID5.

>So RAID5 with three media M is
>
>M    MM   MMM
>D1   D2   P(a)
>D3   P(b) D4
>P(c) D5   D6
>
>If MMM is lost D1, D2, D3, and D5 are intact
>D4 and D6 can be recreated via D3^P(b) and P(c)^D5
>
>M    MM   X
>D1   D2   .
>D3   P(b) .
>P(c) D5   .

>So under _no_ circumstances would a two-disk RAID5 be the same as a 
>RAID1 since a two disk RAID5 functionally implies disk three because 
>the _minimum_ arity of a RAID5 is 3. A two-disk RAID5 has _zero_ data 
>protection because the minimum third element is a computational 
>phantom.

You again seem to be treating a "two disk RAID5" as synonymous with your 
degraded three disk RAID5 above.  It is not.

RAID5 with two media M would be:

M    MM
D1   P(a)
P(b) D2
D3   P(c)

[and each P would be identical to its corresponding D]

>In short it is irrational to have a "two disk" RAID5 that is "not 
>degraded" in the same way you cannot have a two-wheeled tricycle 
>without scraping some part of something along the asphalt.

There is nothing irrational about it at all, except that it is
exactly equivalent to two disk RAID1.

>A RAID1 with two elements presents one sector along the "stripe".

A RAID5 with N elements presents N-1 sectors along the "stripe",
so I'm not sure what the problem is with setting N=2.

>I realize that what has been implemented is what you call a two drive 
>RAID5, and done so by really implementing a RAID1, but it's nonsense.

It's not really, it's merely an argument of semantics if you want
to define it as nonsense.

>I mean I understand what you are saying you've done, but it makes no 
>sense according to the definitions of RAID5. There is no circumstance 
>where RAID5 falls back to mirroring. Trying to implement RAID5 as an 
>extension of a mirroring paradigm would involve a fundamental conflict 
>in definitions. Especially when you reached a failure mode.

I have no idea what you mean by "a fundamental conflict in definition".

>This is so fundamental to the design that the "fast" way to assemble a 
>RAID5 of N-arity (minimum N being 3) is to just connect the first N-1 
>elements, declare the raid valid-but-degraded using (N-1) of the 
>media, and then "replacing" the Nth phantom/missing/failed element 
>with the real disk and triggering a rebuild. This only works if you 
>don't need the initial contents of the array to have a specific value 
>like zero. (This involves fewest reads and the array is instantly 
>available while it builds.)

There is no reason you could not do exactly this with N=2.

>As soon as you start writing to the array, the stripes you write 
>"repair" the extents if the repair process hadn't gotten to them yet.
>
>Its basically impossible to turn a mirror into a RAID5 if you _ever_ 
>expect the code base to to be able to recover an array that's lost an 
>element.

Again, I'm not really sure what you mean.

>Uh, no. A raid 6 with three drives, or even two drives, is also 
>degraded because the minimum is four.

You're doing your weird semantic dance again.  Just because you
define the minimum to be four does not mean that someone talking
about a three device RAID6 is talking about a degraded four device
RAID6, they're not.

As above, a non-degraded three-device RAID6 can be perfectly
sensibly defined.  Once again, it has exactly the same failure
properties as a three device RAID1 (any two of the devices can
fail), so it's a bit pointless.  But not "impossible"...

>
>A   B   C   D
>D1  D2  Pa  Qa
>D3  Pb  Qb  D4
>Pc  Qc  D5  D6
>Qd  D7  D8  Pd
>
>
>You can lose one or two media but the minimum stripe is again [X1,X2] 
>for any read (ABCD)(ABC.)(AB..)(A..D) etc.
>
>Minimum arity for RAID6 is 4, maximum lost-but-functional 
>configuration is arity-minus-two.

A   B   C
D1  Pa  Qa
Pb  Qb  D2
Qc  D3  Pc
D4  Pd  Qd

>>They're only missing if you believe the minimum number of RAID5 disks
>>is not two and the minimum number of RAID6 disks is not three.
>
>I do believe that, because that's what the terms are universally taken 
>to mean.
>

Apparently not universally.

-- 
David Taylor
