Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaBHGfW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 01:35:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WC1VZ-0007u4-1R
	for linux-btrfs@vger.kernel.org; Sat, 08 Feb 2014 07:35:21 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 07:35:21 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 07:35:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Are nocow files snapshot-aware
Date: Sat, 8 Feb 2014 06:34:57 +0000 (UTC)
Message-ID: <pan$51b87$4be6129$a0bf434c$9a827758@cox.net>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com>
	<20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de>
	<pan$9252f$8363907a$3eaa17a6$f558018@cox.net>
	<r5mdsa-hng.ln1@hurikhan77.spdns.de>
	<CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com>
	<6C86A9EB-75D7-4783-B055-8D509F695412@colorremedies.com>
	<qhufsa-27u.ln1@hurikhan77.spdns.de>
	<D3E4553E-C9D8-4D94-A124-506961946360@colorremedies.com>
	<r53gsa-d85.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Fri, 07 Feb 2014 23:26:34 +0100 as excerpted:

> So the question is: Do btrfs snapshots give the same guarantees on the
> filesystem level that write-barriers give on the storage level which
> exactly those processes rely upon? The cleanest solution would be if
> processes could give btrfs hints about what belongs to their
> transactions so in the moment of a snapshot the data file would be in
> clean state. I guess snapshots are atomic in that way, that pending
> writes will never reach the snapshots just taken, which is good.

Keep in mind that btrfs' metadata is COW-based also.  Like reiser4 in 
this way, in theory at least, commits are atomic -- they've ether made it 
to disk or they haven't, there's no half there.  Commits at the leaf 
level propagate up the tree, and are not finalized until the top-level 
root node is written.  AFAIK if there's dirty data to write, btrfs 
triggers a root node commit every 30 seconds.  Until that root is 
rewritten, it points to the last consistent-state written root node.  
Once it's rewritten, it points to the new one and a new set of writes are 
started, only to be finalized at the next root node write.

And I believe that final write simply updates a pointer to point at the 
latest root node.  There's also a history of root nodes, which is what 
the btrfs-find-root tool uses in combination with btrfs restore, if 
necessary, to find a valid root from the root node pointer log if the 
system crashed in the middle of that final update so the pointer ends up 
pointing at garbage.

Meanwhile, I'm a bit blurry on this but if I understand things correctly, 
between root node writes/full-filesystem-commits there's a log of 
transaction completions at the atomic individual transaction level, such 
that even transactions completed between root node writes can normally be 
replayed.  Of course this is only ~30 seconds worth of activity max, 
since the root node writes should occur every 30 seconds, but this is 
what btrfs-zero-log zeroes out, if/when needed.  You'll lose that few 
seconds of log replay since the last root node write, but if it was 
garbage data due to it being written when the system actually went down, 
dropping those few extra seconds of log can allow the filesystem to mount 
properly from the last full root node commit, where it couldn't, 
otherwise.

It's actually those metadata trees and the atomic root-node commit 
feature that btrfs snapshots depend on, and why they're normally so fast 
to create.  When a snapshot is taken, btrfs simply keeps a record of the 
current root node instead of letting it recede into history and fall off 
the end of the root node log, labeling that record with the name of the 
snapshot for humans as well as the object-ID that btrfs uses.  That root 
node is by definition a record of the filesystem in a consistent state, 
so any snapshot that's a reference to it is similarly by definition in a 
consistent state.

So normally, files in the process of being written out (created) simply 
wouldn't appear in the snapshot.  Of course preexisting files will appear 
(and fallocated files are simply the blanked-out-special-case of 
preexisting), but again, with normal COW-based files at least, will exist 
in a state either before the latest transaction started, or after it 
finished, which of course is where fsync comes in, since that's how 
userspace apps communicate file transactions to the filesystem.

And of course in addition to COW, btrfs normally does checksumming as 
well, and again, the filesystem including that checksumming will be self-
consistent when a root-node is written, or it won't be written until the 
filesystem /is/ self-consistent.  If for whatever reason there's garbage 
when btrfs attempts to read the data back, which is exactly what btrfs 
defines it as if it doesn't pass checksum, btrfs will refuse to use that 
data.  If there's a second copy somewhere (as with raid1 mode), it'll try 
to restore from that second copy.  If it can't, btrfs will return an 
error and simply won't let you access that file.

So one way or another, a snapshot is deterministic and atomic.  No 
partial transactions, at least on ordinary COW and checksummed files.

Which brings us to NOCOW files, where for btrfs NOCOW also turns off 
checksumming.  Btrfs will write these files in-place, and as a result 
there's not the transaction integrity guarantee on these files that there 
is on ordinary files.

*HOWEVER*, the situation isn't as bad as it might seem, because most 
files where NOCOW is recommended, database files, VM images, pre-
allocated torrent files, etc, are created and managed by applications 
that already have their own data integrity management/verification/repair 
methods, since they're designed to work on filesystems without the data 
integrity guarantees btrfs normally provides.

In fact, it's possible, even likely in case of a crash, that the 
application's own data integrity mechanisms can fight with those of 
btrfs, and letting btrfs scrub restore what it thinks is a good copy can 
actually interfere with the application's own data integrity and repair 
functionality because it often goes to quite some lengths to repair 
damage or simply revert to a checkpoint position if it has to, but it 
doesn't expect the filesystem to be making such changes and isn't 
prepared to deal with filesystems that do so!  There have in fact been 
several reports to the list of what appears to be exactly that happening!

So in fact it's often /better/ to turn off both COW and checksumming via 
NOCOW, if you know your application manages such things.  That way the 
filesystem doesn't try to repair the damage in case of a crash, which 
leaves the application's own functionality to handle it and repair or 
roll back as it is designed to do.

That's with crashes.  The one quirk that's left to deal with is how 
snapshots deal with NOCOW files.  As explained earlier, snapshots leave a 
NOCOW file as-is initially, but will COW it ONCE, the first time a 
snapshotted NOCOW file-block is written to in that snapshot, thus 
diverging it from the shared version.

A snapshot thus looks much like a crash in terms of NOCOW file integrity 
since the blocks of a NOCOW file are simply snapshotted in-place, and 
there's already no checksumming or file integrity verification on such 
files -- they're simply directly written in-place (with the exception of 
a single COW write when a writable snapshottted NOCOW file diverges from 
the shared snapshot version).

But as I said, the applications themselves are normally designed to 
handle and recover from crashes, and in fact, having btrfs try to manage 
it too only complicates things and can actually make it impossible for 
the app to recover what it would have otherwise recovered just fine.

So it should be with these NOCOW in-place snapshotted files, too.  If a 
NOCOW file is put back into operation from a snapshot, and the file was 
being written to at snapshot time, it'll very likely trigger exactly the 
same response from the application as a crash while writing would have 
triggered, but, the point is, such applications are normally designed to 
deal with just that, and thus, they should recover just as they would 
from a crash.  If they could recover from a crash, it shouldn't be an 
issue.  If they couldn't, well...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

