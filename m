Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60145 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbaLJMrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 07:47:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xygfl-0004Lm-K3
	for linux-btrfs@vger.kernel.org; Wed, 10 Dec 2014 13:47:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 13:47:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 13:47:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Wed, 10 Dec 2014 12:47:05 +0000 (UTC)
Message-ID: <pan$db978$7628430b$4f067ceb$13d468cb@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878A65.2080403@pobox.com> <54878D3E.8020809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Tue, 09 Dec 2014 16:01:02 -0800 as excerpted:

> On 12/09/2014 03:48 PM, Robert White wrote:
>> On 12/09/2014 02:29 PM, Patrik Lundquist wrote:
>>> (stuff depicting a nearly full file system).
>>
>> Having taken another look at it all, I'd bet (there is not sufficient
>> information to be _sure_ from the output you've provided) that you
>> don't have the necessary 1Gb free on your disk slice to allocate
>> another data extent.

[snip most of both quote levels]

> Full filesystems always get into corner cases.

But, from the content you snipped from his post, this from btrfs fi show:

>>> Label: none  uuid: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
>>>    Total devices 1 FS bytes used 1.35TiB
>>>    devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1

Device 2.73 TiB, used only 1.36 TiB.

That's over a TiB of entirely unallocated space, so a mere 1 GiB chunk 
allocation shouldn't be a problem.


I'm sticking with my original hypothesis (assuming this is a continuation 
from the thread I think it was), that there's something about the 
conversion from ext* that didn't work correctly; most likely a file 
larger than the btrfs 1 GiB data-chunk size, that has an extent larger 
than that size as well.  Btrfs balance couldn't do anything with that, as 
it's larger than the native 1 GiB data-chunk size and balance alone 
doesn't know how to split it up.

The recursive btrfs defrag after deleting the saved ext* subvolume 
_should_ have split up any such > 1 GiB extents so balance could deal 
with them, but either it failed for some reason on at least one such 
file, or there's some other weird corner-case going on, very likely 
something else having to do with the conversion.

Patrik, assuming no btrfs snapshots yet, can you do a du --all --block-
size=1M | sort -n (or similar), then take a look at all results over 1024 
(1 GiB since the du specified 1 MiB blocks), and see if it's reasonable 
to move all those files out of the filesystem and back?  Assuming there's 
not too many of them, the idea is to kill the copy in the filesystem by 
moving them elsewhere, then move them back so they get recreated using 
native btrfs semantics -- no extents larger than the native btrfs data 
chunk size of 1 GiB.

If you have lots of memory to work with, one method would be to create a 
tmpfs, then /copy/ the files to tmpfs and /move/ them back to a temporary 
tree on the btrfs, deleting the originals on btrfs only after the move 
back from tmpfs and a sync (or btrfs fi sync) so there's always a 
permanent copy if the machine should crash and take down the tmpfs with 
it.  After all the files have been processed and the originals deleted 
you can then move the contents of the temporary tree back into the 
original location.

That should ensure no more > 1 GiB file extents and will I hope get rid 
of the problem, as this workaround has been demonstrated to fix problems 
other people had with converted-from-ext* btrfs, generally where they had 
failed to run the defrag right after the conversion, and now had a bunch 
more data on the filesystem and didn't want to have to defrag it too.  
Obviously it works best when there's only a handful of > 1 GiB files, 
however, and snapshots containing references to the affected files will 
prevent the file delete from actually deleting the problematic extents.

With luck that'll allow a full 100% balance without error.  If not, at 
least it should eliminate the > 1 GiB file extents possibility, and the 
focus can move to something else.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

