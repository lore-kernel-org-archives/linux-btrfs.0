Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51605 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbcGDVRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 17:17:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bKBEe-0002NH-SC
	for linux-btrfs@vger.kernel.org; Mon, 04 Jul 2016 23:16:56 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 23:16:56 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 23:16:56 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs defrag questions
Date: Mon, 4 Jul 2016 23:16:50 +0200
Message-ID: <20160704231650.58fc253c@jupiter.sol.kaishome.de>
References: <5776CF08.5040601@mail.ru>
	<20160703123341.7c297efa@jupiter.sol.kaishome.de>
	<CAPmG0jZ3RMuDX-fzK7WyuNH+NeSyZw8zhWerTo7ve-CgTADSPw@mail.gmail.com>
	<20160703213020.GA23178@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 3 Jul 2016 23:30:20 +0200
schrieb Adam Borowski <kilobyte@angband.pl>:

> On Sun, Jul 03, 2016 at 04:15:02PM +0200, Henk Slager wrote:
>  [...]  
> > >
> > > That is probably true. Files that are mapped into memory (like
> > > running executables) cannot be changed on disk. You could make a
> > > copy of that file, remove the original, and rename the new into
> > > place. As long as the executable is running it will stay on disk
> > > but you can now defragment the file and next time dropbox is
> > > started it will use the new one.  
> > 
> > I get:
> > ERROR: cannot open ./dropbox: Text file busy
> > 
> > when I run:
> > btrfs fi defrag -v ./dropbox
> > 
> > This is with kernel 4.6.2 and progs 4.6.1, dropbox running and mount
> > option compress=lzo  
> 
> This is the same thing as with dedupe: the kernel requires you to
> have the file opened for writing despite there being no direct
> reasons for this. Defragging is not a write operation in POSIX sense:
> it doesn't alter the file's contents in any way.
> 
> I think it'd be good to relax this requirement to check whether the
> user _could_ open the file for writing (ie, cap or w permissions).

I don't think that works because the file is mapped into memory while
it is executed. The kernel doesn't actively load an executable. It is
just mapped into memory and acts like a mini swap file: Blocks are
paged into RAM as soon as the CPU encounters them. Executing a file
involves page faults. And this is why you cannot rearrange it on disk:
The kernel holds a lock while the file's contents are mapped, it needs
consistent 1:1 block mapping determined at time of mapping the file.

You can however manipulate the file name. If you move the file, then
_copy_ it back into place, then remove the old file, the contents
become orphan. The contents will be unlinked from storage if the file
mapping is closed. If your PC is rebooted while the orphan exists, the
file system will do an orphan cleanup at reboot (you will see such
messages in dmesg then). The fact that you made a copy and moved it in
place of the original filename, however, allows you to now modify the
file contents - as this copy is not mapped. That won't touch the
original orphan contents. I think this should also be possible with a
reflink copy (cp -b) but I'm not sure.

You simply cannot change on-disk layout of mapped files. In addition,
you cannot write to executables mapped into memory - it would destroy
consistency of what the memory manager swapped into RAM and what is on
disk. The error message here is "text file busy". In the context of
executables, "text" is the program text - read: the binary instructions
for the CPU. It has nothing to do with an ordinary text file humans
can read (the common meaning is just "read" as in "CPUs can read" and
"humans can read").

So in other words: There is a direct reason, and you actually change
contents on disk from kernel perspective just because their layout is
changed. Think of it like this: If you defrag the file, it's contents
do not change, yes, just the layout. The blocks are moved somewhere
else. Next time, the kernel tries to page a block from disk of the
previously learned mapping (which is now invalid), the block may have
changed because you added new files to the disk. Thus, the content of
the block has changed, the executable would crash. I think this has
nothing to do with POSIX - the Linux kernel isn't even pure POSIX
conform (it just tries to stay as close as possible). This is just how
running executables works and this needs protection against tampering
or other attacks.

Other OSes like Windows act in the same way (executables are mapped
into memory, not loaded). But Windows/NTFS doesn't support the concept
of orphans (at least not that I know of) which makes mapped executables
(DLL, EXE) immutable while they are mapped. One reason why Windows
needs a reboot for everything and Unix OSes don't.

If OSes would load todays executables program text into memory (thus
making a complete copy of it into RAM), like good old DOS did, they
would become pretty slow. Binary executables are paged into RAM on
demand.

http://stackoverflow.com/questions/8506865/when-a-binary-file-runs-does-it-copy-its-entire-binary-data-into-memory-at-once

-- 
Regards,
Kai

Replies to list-only preferred.

