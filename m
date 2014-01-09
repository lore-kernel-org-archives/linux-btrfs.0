Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaAIMmW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 07:42:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1EwF-0001eE-GA
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 13:42:19 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 13:42:19 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 13:42:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does btrfs handle bad blocks in raid1?
Date: Thu, 9 Jan 2014 12:41:56 +0000 (UTC)
Message-ID: <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	<20140109104247.GH15634@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 09 Jan 2014 10:42:47 +0000 as excerpted:

> On Thu, Jan 09, 2014 at 11:26:26AM +0100, Clemens Eisserer wrote:
>> Hi,
>> 
>> I am running write-intensive (well sort of, one write every 10s)
>> workloads on cheap flash media which proved to be horribly unreliable.
>> A 32GB microSDHC card reported bad blocks after 4 days, while a usb pen
>> drive returns bogus data without any warning at all.
>> 
>> So I wonder, how would btrfs behave in raid1 on two such devices? Would
>> it simply mark bad blocks as "bad" and continue to be operational, or
>> will it bail out when some block can not be read/written anymore on one
>> of the two devices?
> 
> If a block is read and fails its checksum, then the other copy (in
> RAID-1) is checked and used if it's good. The bad copy is rewritten to
> use the good data.

This is why I'm (semi-impatiently, but not being a coder, I have little 
choice, and I do see advances happening) so looking forward to the 
planned N-way-mirroring, aka true-raid-1, feature, as opposed to btrfs' 
current 2-way-only mirroring.  Having checksumming is good, and a second 
copy in case one fails the checksum is nice, but what if they BOTH do?
I'd love to have the choice of (at least) three-way-mirroring, as for me 
that seems the best practical hassle/cost vs. risk balance I could get, 
but it's not yet possible. =:^(

For (at least) year now, the roadmap has had N-way-mirroring on the list 
for after raid5/6 as they want to build on its features, but (like much 
of the btrfs work) raid5/6 took about three kernels longer to introduce 
than originally thought, and even when introduced, the raid5/6 feature 
lacked some critical parts (like scrub) and wasn't considered real-world 
usable as integrity over a crash and/or device failure, the primary 
feature of raid5/6, couldn't be assured.  That itself was about three 
kernels ago now, and the raid5/6 functionality remains partial -- it 
writes the data and parities as it should, but scrub and recovery remain 
only partially coded, so it looks like that'll /still/ be a few more 
kernels before that's fully implemented and most bugs worked out, with 
very likely a similar story to play out for N-way-mirroring after that, 
thus placing it late this year for introduction and early next for 
actually usable stability.

But it remains on the roadmap and btrfs should have it... eventually.  
Meanwhile, I keep telling myself that this is filesystem code which a LOT 
of folks including me stake the survival of their data on, and I along 
with all the others definitely prefer it done CORRECTLY, even if it takes 
TEN years longer than intended, than have it sloppily and unreliably 
implemented sooner.

But it's still hard to wait, when sometimes I begin to think of it like 
that carrot suspended in front of the donkey, never to actually be 
reached.  Except... I *DO* see changes, and after originally taking off 
for a few months after my original btrfs investigation, finding it 
unusable in its then-current state, upon coming back about 5 months 
later, actual usability and stability on current features had improved to 
the point that I'm actually using it now, so there's certainly progress 
being made, and the fact that I'm actually using it now attests to that 
progress *NOT* being a simple illusion.  So it'll come, even if it /does/ 
sometimes seem it's Duke-Nukem-Forever.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

