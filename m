Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35369 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbbKADFp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 23:05:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zsixg-0000vI-OH
	for linux-btrfs@vger.kernel.org; Sun, 01 Nov 2015 04:05:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 04:05:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 04:05:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
Date: Sun, 1 Nov 2015 03:05:35 +0000 (UTC)
Message-ID: <pan$9ca99$55d97f97$f1b2b74d$76de8d39@cox.net>
References: <5634DD93.9050605@uni-koeln.de>
	<20151031164112.GF21103@carfax.org.uk> <5634FB01.9030602@uni-koeln.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simon King posted on Sat, 31 Oct 2015 18:31:45 +0100 as excerpted:

> I know that "df" is different from "btrfs fi df". However, I see that df
> shows significantly more free space after balancing. Also, when my
> computer became unusable, the problem disappeared by balancing and
> defragmentation (deleting the old snapshots was not enough).
> 
> Unfortunately, df also shows significantly less free space after
> UNSUCCESSFUL balancing.

On a btrfs, df is hardly relevant at all, except to the extent that if
you're trying to copy a 100 MB file and df says there's only 50 MB of
room, obviously there's going to be problems.

Btrfs actually has two-stage space allocation.

At the first stage, entirely unallocated space is taken in largish chunks,
normally separately for data and metadata, nominally 1 GiB size (tho
larger or smaller is possible depending on the size of the filesystem and
how close to fully chunk-allocated it is) for data chunks,
256 MiB for metadata -- but metadata chunks are normally allocated and
used in dup mode, two at a time, on a single-device btrfs, so 512 MiB at a
time.

At the second stage, space is used from already allocated chunks as needed
for files (data) or metadata.

And particularly on older kernels, this is where the problem arises,
since over time as files are created and deleted, all unallocated space
tends to be allocated as data chunks, such that when the existing metadata
chunks get full, there's no unallocated space left from which to allocate
more metadata chunks, as it's all tied up in data chunks, many of which
might be mostly or entirely empty as the files they once were allocated to
contain have since been deleted or moved (due to btrfs copy-
on-write) elsewhere.

On newer kernels, entirely empty chunks are automatically deleted,
significantly easing the problem, tho it can still happen if there's a lot
of mostly but not entirely empty data chunks.

Which is why df isn't always particularly reliable on btrfs, because it
doesn't know about all this chunk preallocation stuff, and will (again,
at least on older kernels, AFAIK newer ones have improved this to some
extent but it's still not ideal) happily report all that empty data-chunk
space as available for files, not knowing it's out of space to store
metadata.  Often, if you were to have one big file take all the space df
reports, that would work, because tracking a single file uses only a
relatively small bit of metadata space.  But try to use only a tenth of
the space with a thousand much smaller files, and the remaining metadata
space may well be exhausted, allowing no more file creation, even tho df
is still saying there's lots of room left, because it's all in data
chunks!

Which is where balance comes in, since in rewriting the chunks it
consolidates them, eliminating chunks when say 3 2/3 full chunks combine
into only two full chunks, returning the freed space to unallocated, so it
can be allocated for either data or metadata as needed, once again.

As for getting out of the tight spot you're in ATM, with all would-be
unallocated space apparently (you didn't post btrfs fi show and df output,
but this is what the symptoms suggest) gone, tied up in mostly empty data
chunks, without even enough space to easily balance those data chunks to
free up more space by consolidating them...

There's some discussion on the btrfs wiki, in the free-space questions on
the faq, and similarly in the problem-faq (watch the link wrap):

FAQ:

https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21

Also see FAQ sections 4.6-4.9, discussing free space, and 4.12,
discussing balance.

Problem-FAQ:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space


Basically, if filters won't let you do it, you can try deleting large
files -- assuming they're not also referenced by still existing snapshots.
 That might empty a data chunk or two, allowing a balance -dusage=0 to
eliminate it, giving you enough room to try a higher dusage number,
perhaps 5% or 10%, then 20 and 50.  (Above 50% the time will go up while
the possible payback goes down, and it shouldn't be necessary until the
filesystem gets real close to actually full, tho on my ssd, speeds are
fast enough I'll sometimes try upto 70% or so.)

If it's too tight for that or everything's snapshotted on snapshots you
don't want to or can't delete, you can try adding (btrfs device add) a
device temporarily.  The device should be several gigs in size, minimum;
even a few-GiB USB thumbdrive or the like can work, tho access can be
slow.  That should give you enough additional space to do the balance
-dusage= thing, which, assuming it does consolidate nearly empty data
chunks, freeing the extra space they took, should free up enough newly
unallocated space on the original device, to do a btrfs device delete of
the temporarily added device, returning everything that was on it
temporarily, back to the original device.


Meanwhile, that's where btrfs filesystem df (as opposed to normal df)
comes in as well, since it combined with btrfs filesystem show are the two
commands that together give you the needed information that plain df can't
report, that being how much of the filesystem is actually allocated as
data vs. metadata chunks, vs. unallocated free space, and how much of that
allocated data and metadata space is actually used.


So as you see there's a real reason behind the recommendations to use
reasonably current kernels and userspace (btrfs-progs).  While btrfs is no
longer experimental-unstable, it's still stabilizing and maturing, and the
wish to run the real old and stable kernels is generally seen on this list
as incompatible with the stability level of btrfs itself, and is thus not
recommended.  Of course, some distros choose to run older kernels and
support btrfs, but in that case, users should be looking to their distro
for that support, since it's the distro choosing to provide it, and only
the distro that knows what more current btrfs patches have been backported
to their in general older kernel.

On this list, then, the general recommendation is to be no more than one
lts (long-term-support) kernel release series behind the current one.
With 4.1 being the latest lts kernel series, and 3.18 being the second-
latest, that means a current 3.18 kernel series at the earliest.  FWIW,
4.4 has been announced as the next LTS series, and 4.3 is very near
release, so while 3.18 is currently sufficient, people on it should
already be considering upgrading to 4.1 at the earliest opportunity.

As for btrfs userspace (btrfs-progs), in normal runtime (loosely stated,
mounting and operations with a mounted filesystem), userspace primarily
simply makes kernel calls, with the kernel code doing the real work, so
the kernel version is more important than userspace, which can lag a bit
as long as it supports the btrfs features you want to use.  But once
there's a problem and you're running commands such as btrfs check, btrfs
rescue and btrfs restore on the unmounted filesystem, a newer userspace
with all the latest bugfixes becomes critical, as then it's the userspace
code that's working with the filesystem directly.

Meanwhile, btrfs-progs version releases are synced with kernel releases,
and while they should generally work with older and newer kernels, the
issues being addressed in each specific release tend to be the same ones
in the similar kernel release, because they came out at the same time.
So as a general rule of thumb, once you're running a recommended kernel,
either current, or one of the last two LTS kernel series, running a
similar btrfs-progs version, or newer, is best-practice, tho not mandatory
unless you're trying to fix something that only newer versions can fix.

So an LTS series 3.18 or 4.1 kernel, or the current 4.2 or soon to be
released 4.3 kernel, is recommended, along with a similar or newer btrfs
userspace release.

If you prefer to run older kernels and/or userspace, then the support
provided here will be crippled by your choice as that's generally ancient
history for us, and you're probably better off with either the support
provided by your distro if they choose to support btrfs on older kernels,
or choosing a filesystem more appropriate to your stability and maturity
needs, perhaps ext4, xfs, or (my long time favorite, which I still use on
my spinning rust media/archive drives, with btrfs only on the ssds)
reiserfs.

>> You may have more success using mkfs.btrfs --mixed when you create the
>> FS, which puts data and metadata in the same chunks.
> 
> Can I do this in the running system? Or would that only be an option
> during upgrade of openSuse Harlequin to Tumbleweed/Leap? Or even worse:
> Only an option after nuking the old installation and installing a new
> one from scratch?

What mkfs.btrfs --mixed does, is create chunks that are shared data and
metadata both, instead of separate chunks for each.  That way, you don't
have to worry about running out of one before running out of the other.
However, it's not quite as efficient, so for typically large filesystems
spanning pretty much the entire often Terrabyte scale device, it's not
recommended.  But for 1 GiB and smaller btrfs it's the default, and most
regulars here, devs and users alike, would recommend using it on
filesystems upto between 16 GiB and 64 GiB, depending on your specific
needs.

But, it can't be changed in-place.  The filesystem must be blown away and
recreated with a fresh mkfs.btrfs, in ordered to switch between mixed mode
and normal split-chunk mode.

However, as the admin's rule of backups says, valuable data is by
definition backed up data.  If it's not backed up, then by definition,
you care about the time and resources saved by not doing the backup, more
than you care about the data you'd lose if you lost the filesystem,
multiplied by the risk factor of actually needing that backup.  (The risk
factor thus takes care of the N-level backup case, since some data may
indeed be valuable enough to have 100 levels of backup, despite the very
low risk of actually needing that 100th level, while most data is probably
good at 1-3 levels of backup, perhaps with one or more off-site to take
care of flood/fire/etc risk, and some data, internet cache and tmpfiles,
for instance, arguably not worth backing up at all.)

So blowing away the filesystem and recreating it, then restoring from
backups if desired, shouldn't be a big deal, because by definition,
either the data is valuable enough to have those backups, or your actions
are already saying it's not worth worrying about loss due either to
accident or to intentionally blowing it away with a fresh mkfs, in the
first place.  Either way, no big deal, tho it's understandable if you'd
prefer to put it off due to simple time constraints, as long as you're
prepared to risk that the data to go bye-bye in some accident in the mean
time, of course.





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

