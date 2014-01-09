Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48249 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaAIPQG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 10:16:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1HKv-0003Q9-0D
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 16:15:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 16:15:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 16:15:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does btrfs handle bad blocks in raid1?
Date: Thu, 9 Jan 2014 15:15:26 +0000 (UTC)
Message-ID: <pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	<20140109104247.GH15634@carfax.org.uk>
	<pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
	<52CE9B9C.2040006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 09 Jan 2014 07:52:44 -0500 as
excerpted:

> On 2014-01-09 07:41, Duncan wrote:
>> Hugo Mills posted on Thu, 09 Jan 2014 10:42:47 +0000 as excerpted:
>> 
>>> If a [btrfs ]block is read and fails its checksum, then the other
>>> copy (in RAID-1) is checked and used if it's good. The bad copy is
>>> rewritten to use the good data.
>> 
>> This is why I'm so looking forward to the planned N-way-mirroring,
>> aka true-raid-1, feature, as opposed to btrfs' current 2-way-only
>> mirroring.  Having checksumming is good, and a second copy in case
>> one fails the checksum is nice, but what if they BOTH do? I'd love
>> to have the choice of (at least) three-way-mirroring, as for me
>> that seems the best practical hassle/cost vs. risk balance I
>> could get, but it's not yet possible. =:^(
>> 
> Just a thought, you might consider running btrfs on top of LVM in the
> interim, it isn't quite as efficient as btrfs by itself, but it does
> allow N-way mirroring (and the efficiency is much better now that they
> have switched to RAID1 as the default mirroring backend)

Except... AFAIK LVM is like mdraid in that regard -- no checksums, 
leaving the software entirely at the mercy of the hardware's ability to 
detect and properly report failure.

In fact, it's exactly as bad as that, since while both lvm and mdraid 
offer N-way-mirroring, they generally only fetch a single unchecksummed 
copy from whatever mirror they happen to choose to request it from, and 
use whatever they get without even a comparison againt the other copies 
to see if they match or majority vote on which is the valid copy if 
something doesn't match.  The ONLY way they know there's an error (unless 
the hardware reports one) at all is if a deliberate scrub is done.

And the raid5/6 parity-checking isn't any better, as while those parities 
are written, they're never checked or otherwise actually used except in 
recovery.  Normal read operation is just like raid0; only the device(s) 
containing the data itself is(are) read, no parity/checksum checking at 
all, even tho the trouble was taken to calculate and write it out.  When 
I had mdraid6 deployed and realized that, I switched back to raid1 (which 
would have been raid10 on a larger system), because while I considered 
the raid6 performance costs worth it for parity checking, they most 
definitely weren't once I realized all those calculates and writes were 
for nothing unless an actual device died, and raid1 gave me THAT level of 
protection at far better performance.

Which means neither lvm nor mdraid solve the problem at all.  Even btrfs 
on top of them won't solve the problem, while adding all sorts of 
complexity, because btrfs still has only the two-way check, and if one 
device gets corrupted in the underlying mirrors but another actually 
returns the data, btrfs will be entirely oblivious.

What one /could/ in theory do at the moment, altho it's hardly worth it 
due to the complexity[1] and the fact that btrfs itself is still a 
relatively immature filesystem under heavy development, and thus not 
suited to being part of such extreme solutions yet, is layered raid1 
btrfs on loopback over raid1 btrfs, say four devices, separate on-the-
hardware-device raid1 btrfs on two pairs, with a single huge loopback-
file on each lower-level btrfs, with raid1 btrfs layered on top of the 
loopback devices, too, manually creating an effective 4-device btrfs 
raid11.  Or use btrf raid10 at one or the other level and make it an 8-
device btrfs raid101 or raid110.  Tho as I said btrfs maturity level in 
general is a mismatch for such extreme measures, at present.  But in 
theory...

Zfs is arguably a more practically viable solution as it's mature and 
ready for deployment today, tho there's legal/license issues with the 
Linux kernel module and the usual userspace performance issues (tho the 
btrfs-on-loopback-on-btrfs solution above wouldn't be performance issue 
free either) with the fuse alternative.

I'm sure that's why a lot of folks needing multi-mirror checksum-verified 
reliability remain on Solaris/OpenIndiana/ZFS-on-BSD, as Linux simply 
doesn't /have/ a solution for that yet.  Btrfs /will/ have it, but as I 
explained, it's taking awhile.

---
[1] Complexity: Complexity can be the PRIMARY failure factor when an 
admin must understand enough about the layout to reliably manage recovery 
when they're already under the extreme pressure of a disaster recovery 
situation.  If complexity in even an otherwise 100% reliable solution is 
high enough an admin isn't confident of his ability to manage it, then 
the admin themself becomes the week link the the reliability chain!!  
That's the reason I tried and ultimately dropped lvm over mdraid here, 
since I couldn't be confident in my ability to understand both well 
enough to without admin error recover from disaster.  Thus, higher 
complexity really *IS* a SERIOUS negative in this sort of discussion, 
since it can be *THE* failure factor!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

