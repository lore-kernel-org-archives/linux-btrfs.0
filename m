Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaK2HaK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 02:30:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XucTo-0002LR-9J
	for linux-btrfs@vger.kernel.org; Sat, 29 Nov 2014 08:30:08 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 08:30:08 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 08:30:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Sat, 29 Nov 2014 07:29:54 +0000 (UTC)
Message-ID: <pan$40148$39c282ee$365818$9e1ebdba@cox.net>
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
	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
	<CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 28 Nov 2014 00:10:40 -0700 as excerpted:

> On Thu, Nov 27, 2014 at 2:08 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> So, umm... kinda late now, but read that "copy" as if it had a footnote
>> attached, saying "Yes, I know it's not actual copy, it's two views of
>> the same thing using COW, but my point is, from the btrfs perspective
>> it's a copy, the "universally UNIQUE ID" no longer looks "unique" and
>> thus no longer can be properly called a UUID at all."
> 
> The copy is sort of a misnomer anyway because up until the computer age
> the copy was a derivative, a facsimile, like a photocopy. But a copy of
> a digital file is actually another original. Therein lies the problem
> with the LVM snapshot in this context, we don't want another original.
> We want a copy, as in we want something we know has been derived from
> something else, and therefore can be discriminated.

Very good point.  I had all the pieces but hadn't put them together yet, 
so thanks. =:^)

> Well RFC 4122 I don't think would say it's not a UUID, the uniqueness is
> only guaranteed at the time of UUID creation. And duplication isn't
> creation so it's not going to say these things are no longer UUIDs,
> they're just UUIDs that have been recycled. That RFC doesn't specify
> workflow, but if it did, I think it'd basically say "oh crap, why'd you
> go and do that?" After all a major point of UUIDs is that they are
> effectively unlimited in quantity, therefore a.) we don't need central
> registry to avoid (unintended) collisions because they're so uncommon,
> b.) we're encouraged to not be attached to specific UUIDs when in doubt
> just create another one.

Another good point.  One common and less RFC/technical way of putting it, 
that I had thought about a few times but hadn't actually posted yet IIRC, 
is the old "If it hurts when you bang your head against the wall, quit 
banging!" =:^)

IOW, LVM could change the UUIDs in its "copies", COWing that bit in 
ordered to do so.  While that wouldn't change the same UUIDs embedded in 
for instance btrfs internals it would provide a mechanism to keep initial 
scans from confusing things, and filesystems or other UUID applications 
that duplicated the number for their own internals would then need to 
provide tools that rewrote them to match the LVM-changed master location 
UUID.  Those that failed to do so would fail to function unless/until the 
master location version was changed back, but the tools and likely would 
eventually be provided, as I expect they will be here, but the difference 
would be at least it'd keep mixups like this from happening.

> A very good example of WTF reusage of a UUID that irks me to no end is
> GNU parted devs decided to recycle the Microsoft Windows Basic Data
> partition type GUID for Linux partitions. It's like watching someone get
> run over by a zamboni with 50 feet of advance notice...

At least I don't have to worry about that one, since I no longer agree to 
"WE REFUSE TO TELL YOU SPECIFICALLY WHAT THIS SOFTWARE DOES AS WE DON'T 
SUPPLY THE SOURCES, BUT YOU ARE STILL REQUIRED TO ACCEPT ALL 
RESPONSIBILITY FOR IT, REGARDLESS OF WHAT IT DOES AND REGARDLESS OF 
WHETHER WE'VE BEEN WARNED" style EULAs, which is basically all of them, 
which means I have no legal way to run that software, so I don't.  Note 
that the GPL among others has similar liability disclaimer wording (and 
to be fair it'd be hard not to, since the sources are there and the 
original author can hardly be held responsible for later modifications to 
them), but because it actually gives you the sources too, it allows you 
to fairly make your own decision about the responsibility you're about to 
take on.

Since I can't/won't run pretty much anything proprietary, there's little 
chance of it being taken as anything but Linux, here.  (Tho I actually 
use (c)gdisk for partitioning here and it appears to use a different GUID. 
(0700 in its short form which AFAIK is gdisk specific, for MS basic data, 
while it uses 8300 for general Linux filesystems.  I could look up the 
long form GUIDs, but meh...)


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

