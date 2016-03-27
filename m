Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34438 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbcC0XMR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 19:12:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akJqw-0000ss-Je
	for linux-btrfs@vger.kernel.org; Mon, 28 Mar 2016 01:12:14 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 01:12:14 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 01:12:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Sun, 27 Mar 2016 23:12:06 +0000 (UTC)
Message-ID: <pan$a3a61$a4d50d7e$975a399f$abd2a6a2@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSw_+PQEjAiHJkk03ec=J3ti9t9VCOD-zJSi=rP4dPnsjQ@mail.gmail.com>
	<pan$a7a0b$d1f1da3$f3b73157$2f7e8e17@cox.net> <1476912.bqJXGglCVP@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 27 Mar 2016 14:10:07 +0200 as excerpted:

> On Freitag, 4. März 2016 12:31:44 CEST Duncan wrote:
>> Dāvis Mosāns posted on Thu, 03 Mar 2016 17:39:12 +0200 as excerpted:
>> > 2016-03-03 6:57 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
>> >> You're issue isn't the same, because all your space was allocated,
>> >> leaving only 1 MiB unallocated, which isn't normally enough to
>> >> allocate a new chunk to rewrite the data or metadata from the old
>> >> chunks into.
>> >> 
>> >> That's a known issue, with known workarounds as dealt with in the
>> >> FAQ.
>> > 
>> > Ah, thanks, well it was surprising for me that balance failed with
>> > out of space when both data and metadata had not all been used and I
>> > thought it could just use space from those...
>> > 
>> > especially as from FAQ:
>> >> If there is a lot of allocated but unused data or metadata chunks,
>> >> a balance may reclaim some of that allocated space. This is the main
>> >> reason for running a balance on a single-device filesystem.
>> > 
>> > so I think regular balance should be smart enough that it could solve
>> > this on own and wouldn't need to specify any options.
>> 
>> Well it does solve the problem on its own... to the extent that it
>> eliminates empty chunks (kernel 3.17+, it didn't before that).  But if
>> there's even a single 4 KiB file block used in the (nominal 1 GiB sized
>> data) chunk, it's no longer empty and thus not eliminated by the empty
>> chunk cleanup routines.
> 
> It could theoretically copy part of one almost empty chunk into another
> chunk to free it up, couldn´t it? This way it can free some chunks
> completely and then start the regular balance?

To be clear here, as unfortunately I wasn't in the previous reply, "it" 
in this case refers to the kernel's general btrfs handling -- IOW, the 
kernel, since 3.17, routinely deletes entirely empty chunks.

(Tho apparently there are cases when it misses some, as we've had a few 
reports lately of a balance with usage=0 cleaning up more than the 
trivial one or two chunks that could arguably have been "in transit" at 
the time the balance was run... but that would be a bug.)

For the kernel to routinely and automatically move content from one 
partially filled chunk to another in ordered to free the one is a *MUCH* 
higher level of complexity and thus a *MUCH* higher chance of serious 
show-stopping bugs; certainly nothing /I/'d wish to touch, were I a btrfs 
dev.  

It should be noted that btrfs is in general a COW (copy-on-write) 
filesystem, so simply moving content from one chunk into another isn't 
the way it works.  At the individual node level if not at the chunk 
level, the COW nature of btrfs means that modification of the existing 
data in both chunks would require copying the node elsewhere in ordered 
to rewrite it to include the new/modified information, and this must be 
handled atomically such that in the event of a crash, either the old 
version or the new version survives, not a mix of half of one and half of 
the other.  While btrfs is already designed from the ground up with that 
in mind, normal file and metadata updates would handle that within single 
chunks, and coordinating that atomicity across chunks really does add in 
geometric proportion to the complexity of the situation.

Which means there's much more wisdom than might be first appreciated in 
having balance simply stick to the chunk level COW that is its designed 
scope, instead of having it try to do cross-chunk node-level COW, which 
is what you're effectively proposing.  (Of course the complexity is in 
fact rather higher than I'm explaining here, but the fact remains, to the 
extent possible, keeping node level atomic operations to the node level, 
and chunk level atomic operations to the chunk level, **GREATLY** 
simplifies things, and deliberately crossing that level barrier where 
it's not absolutely required is an invitation to bugs so complex and 
severe that they could ultimately collapse the entire filesystem!)

> In either case, its unintuitive for the user to fail this. The
> filesystem tools should allow a balance in *any* case without needing
> special treatment by the user.

In fairness, there's a reason btrfs isn't claiming full stability and 
maturity just yet -- it's stabilizing, but exactly this sort of problems 
need to be worked out, before it can really be called fully stable.  
Meanwhile, as the (borrowed from Latin) saying goes "caveat emptor", "let 
the buyer beware."[1]  It remains the user's responsibility to ensure 
that btrfs is an appropriate filesystem for their use-case, and if so and 
once installed, that it remains within healthy operating parameters, 
enough unallocated space is kept available to complete balances, backups 
are kept in case some bug kills the filesystem, etc.

I think what ultimately needs to and probably will happen, is they'll 
create a new kind of global reserve that will come from unallocated space 
(instead of already allocated metadata chunks, which is where the current 
global reserve comes from, providing the same sort of reserve-COW-space 
functionality to more ordinary metadata fuctions), reserving enough of it 
to allocate at least one more full-size data chunk and one more full size 
metadata chunk, with only balance allowed to actually use that new global 
reserve space.  That way, balance will always have enough space to do 
what it needs to do.

Of course, it may well be necessary to let users tweak this reserve 
space, say at mkfs.btrfs time, so users creating for instance smaller 
mixed-data/metadata-chunk mode filesystems (like the 256 MiB /boot I have 
on one device, with a parallel 256 MiB backup /boot on a second device) 
can use all the space if it's more convenient for them to backup and do a 
new mkfs.btrfs than it is to reserve additional otherwise unusable space 
on tiny filesystems for balances they don't intend to do anyway.  
Similarly, users at the TB scale might want to reserve say 100 GiB 
instead of the default 1.5 GiB or so, and people doing large multi-device 
filesystems might want to do say 20 or 50 GiB per device.  Etc.  But the 
default reserve from unallocated would be enough for at least 1 chunk 
each of data and metadata, two chunks for dup mode on a single device, on 
each device.

---
[1] Caveat Emptor:  https://en.wikipedia.org/wiki/Caveat_emptor

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

