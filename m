Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50064 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761238AbcALCGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 21:06:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aIoLV-0005Xe-FP
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 03:06:05 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 03:06:05 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 03:06:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Date: Tue, 12 Jan 2016 02:05:58 +0000 (UTC)
Message-ID: <pan$e4bd0$7510e31$e1a9f49b$f50f8e00@cox.net>
References: <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
	<CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
	<20160109202659.GC6060@carfax.org.uk>
	<CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
	<20160109210429.GD6060@carfax.org.uk>
	<CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
	<20160111090318.GG6060@carfax.org.uk>
	<CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
	<20160111221056.GD422@carfax.org.uk>
	<CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
	<20160111223017.GE422@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 11 Jan 2016 22:30:17 +0000 as excerpted:

> On Mon, Jan 11, 2016 at 03:20:36PM -0700, Chris Murphy wrote:
>> On Mon, Jan 11, 2016 at 3:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >
>> > There is, as far as I can tell from some years of seeing reports of
>> > this bug, no correlation with RAID level, hardware, OS, kernel
>> > version, FS size, usage of the FS at failure, or allocation level of
>> > either data or metadata at failure.
>> >
>> > I haven't tried correlating with the phase of the moon or the
>> > losses on Lloyds Register yet.
>> 
>> Huh. So it's goofy cakes.
>> 
>> This is specifically where btrfs_free_extent produces errno -28 no
>> space left, and then the fs goes read-only?
> 
> The symptoms I'm using for a diagnosis of this bug are that the FS
> runs out of (usually data) space when there's still unallocated space
> remaining that it could use for another block group.
> 
> Forced RO isn't usually a symptom, although the FS can get into a
> state where you can't modify it (as distinct from being explicitly
> read-only).
> 
> Block-group level operations, like balance, device delete, device
> add sometimes seem to have some kind of (usually small) effect on the
> point at which the error occurs. If you hit the problem and run a
> balance, you might end up making things worse by a couple of gigabytes,
> or making things better by the same amount, or having no effect at all.

I had the problem for some kernels on my 256 MiB mixed-mode dup (so 128 
MiB capacity) /boot and its backup on my other ssd, when I'd recreate 
them to eliminate any hidden historic issues and take advantage of newer 
btrfs features, as I do all my btrfs from time to time, as an extension 
of my regular backups procedures.

My newly mkfs.btrfsed /boot or backup would NOT go read-only, but would 
ENOSPC as I attempted to copy files over from the older one -- same size 
and both btrfs so obviously the files should all fit.

The problem was obviously due to btrfs refusing to create a new chunk 
when the existing chunk (mixed-mode, so both data and metadata, at this 
size filesystem we're talking 16 MiB chunks or so) ran out of space.

The first time it happened I think I fiddled with balance, etc, maybe 
umount/remount, and eventually was able to copy the files.  I don't 
remember exactly.

The second time, I had been copying everything over in one go, and some 
of it copied while some didn't.  In particular, it was the grub2 modules 
subdir, grub/modules, that failed with some copied and some not.  So in mc 
I did a directory diff between source and destination, which selected the 
files that hadn't copied in the source.  I then tried copying them again, 
and I think a few copied before I got another ENOSPC.  At some point I 
think I fell back to trying one at a time.

Eventually they all copied.  Apparently, under some conditions a file 
copy that crosses the chunk threshold will trigger an ENOSPC instead of 
creation of another chunk, despite free space being available for 
creation of those chunks.  But by trying smaller files first, that would 
fit into the existing chunks, then trying a file that would force 
creation of a new chunk again, I eventually no longer triggered the 
failure to create chunk problem, and it created one as it should of, 
thereby allowing me to continue copying files normally.  But I'm not sure 
if it was simply chance based (maybe a race between the chunk creation 
and the attempt to copy data into it) and I tried enough times that 
eventually one succeeded, or if it was some filesystem condition that 
somehow eventually changed and let the new chunk be created, or if, 
perhaps, it was time based and the chunk creation eventually 
"registered", so files could then copy without issue.

But the last time I redid my /boot, perhaps 3.16 or 3.18 timeframe, the 
problem didn't occur at all, so I thought it must have been fixed.  Now 
I'm reading that no, it's still triggering for many.

Anyway, you can add really small (256 MiB) mixed-mode dup btrfs to the 
list of btrfs where it is known to sometimes trigger, if that combination 
wasn't on the list already.

I've not had the problem occur on my other btrfs.


One thing that occurs to me is that given that it seems to be a 
relatively straightforward failure under certain conditions to allocate a 
new chunk, the fact that btrfs post 3.17 or whatever now cleans up empty 
chunks, should in turn mean that btrfs has to create new chunks to 
accommodate new or growing files much more often, which should mean that 
people run into this issue much more frequently as well... unless there's 
some other limiting characteristic that keeps it from happening in the 
same proportion of chunk creations now, that it did back when empty 
chunks were kept around and thus fewer chunk creations were needed.


Meanwhile, this case seems to have the additional complication of forcing 
the btrfs to read-only, something that doesn't seem to occur in many case 
and certainly didn't happen in mine.  With the USB resets and etc, it 
could be considered a different bug, but it could also be that they 
simply create an environment much more likely to trigger the bug than 
normally working hardware.  If so, it could be some clue to grasp at to 
try (again) to track this thing down.


Meanwhile(2), on a personal note, I'm not particularly happy to find that 
this bug still exists, and that my last /boot remake simply didn't 
trigger it for some reason, while the previous two did.  That means I 
have to look forward to the possibility of it happening again.  And I can 
tell you from experience, it's a pretty frustrating bug, particularly 
when you're copying from a btrfs of the exact same size and 
configuration, so you KNOW the files fit!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

