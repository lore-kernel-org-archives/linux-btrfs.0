Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56079 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbaK0JJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 04:09:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xtv4Y-0004zE-C8
	for linux-btrfs@vger.kernel.org; Thu, 27 Nov 2014 10:09:10 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 10:09:10 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 10:09:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Thu, 27 Nov 2014 09:08:58 +0000 (UTC)
Message-ID: <pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net> <54764F4E.80405@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 26 Nov 2014 14:08:14 -0800 as excerpted:

> On 11/25/2014 07:22 PM, Duncan wrote:
>>>From my perspective, however, btrfs is simply incompatible with lvm
>> snapshots, because the basic assumptions are incompatible.  Btrfs
>> assumes UUIDs will be exactly what they say on the label, /unique/,
>> while lvm's snapshot feature directly breaks that uniqueness by copying
>> the (former) UUID, thus making the former UUID no longer unique and
>> thus no longer truly UUID.  Thus, part of the lvm /feature/ of
>> snapshots is in direct contradiction to a basic assumption of btrfs,
>> that UUIDs are exactly that, unique, making that feature directly
>> incompatible with btrfs on a very basic level.
> 
> A finer point here. LVM doesn't "copy" the UUID. AN LVM snapshot is a
> copy-on-write entity so it _exposes_ the single sector(s) of the
> superblock(s) in both views of the underlying storage.

I /hate/ it when this happens, which is why my posts often end up so 
long.  People keep saying shorten them, but when I try, invariably I end 
up shortcutting something like this and get called on it! =:^(

So, umm... kinda late now, but read that "copy" as if it had a footnote 
attached, saying "Yes, I know it's not actual copy, it's two views of the 
same thing using COW, but my point is, from the btrfs perspective it's a 
copy, the "universally UNIQUE ID" no longer looks "unique" and thus no 
longer can be properly called a UUID at all."

Which kinda makes most of the rest of what you said, which I agree with 
in general were it the case that I actually thought of it as a literal 
copy, unnecessary...

Tho I can't fault you for catching and pointing out my shortcut as an 
error, because you're absolutely correct in that case, and I'd almost 
certainly be doing the same thing were the situation reversed.

> So while you may have a point about btrfs being unprepared for LVM,
> neither party is particularly "at fault" in any way.
> 
> The "damn you photocopier for making photocopies so identically" nature
> of your problem with LVM seems to be leading you to misplaced
> conclusions.

Well, to the extent that I tried to take an unwarranted logical shortcut 
and didn't properly describe it...

But... I'd still say LVM is "at fault" to the extent that anyone is, as 
it /knows/ it's dealing with UUIDs because after all that's part of 
what's /on/ what it's snapshotting, and it doesn't make any effort to 
deal with the situation, despite the at least theoretical (and now in 
fact) confusion that may occur when former UUIDs are no longer unique and 
thus no longer UUIDs.

However, the point remains, they are pretty much incompatible, in that 
one assumes "unique" means that a second one won't pop up elsewhere and 
depends on exactly that, while the functionality of the other is exactly 
that, to make another view of the same thing, including the otherwise 
unique ID, pop up elsewhere, with COW semantics.

> If you are waiting for someone to "code it up" perhaps you should do so.

I'm not sure if that was the singular or plural "you", but in any case, 
it won't be /me/, because I'm not a coder, simply another sysadmin 
willing to guinea-pig this fascinating new filesystem toy. =:^)

> As previously stated XFS solved this problem by providing a tool that
> would change the UUID of a file system. This tool cold then be pointed
> at either (or both) the original and/or snapshot volumes as needed.

I think that'll eventually happen.  Actually, I see it's on the wiki 
project ideas page, now (see 1.2.25 and 1.2.26, online/offline UUID 
changes, respectively):

https://btrfs.wiki.kernel.org/index.php/Project_ideas

There's even POC code. =:^)  Wiki page history says Kdave added that on 
06 Oct. 2014, so the entry is reasonably new, and the POC's encouraging, 
but will it go anywhere from there?

> Given that BTRFS want's to play in the same level of abstraction as LVM,
> its kind of a given that they'll butt heads over things like conflicting
> definitions of what it means to take a snapshot.

Agreed.

Actually, given btrfs is already doing much of it, it'd be interesting if 
it eventually got the ability to specify where subvolumes went and limit 
them in size (ideally more directly than the existing btrfs quotas 
related functionality does, etc, thus avoiding having to rely on LVM for 
that and eliminating the need for it in scenarios where that's desired.  
Couple that with the better snapshot handling that is already in the 
works, and would there /still/ be a need for LVM under btrfs then; for 
what if so, and could it too be integrated into btrfs?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

