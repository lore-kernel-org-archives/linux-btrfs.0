Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaGKKio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 06:38:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X5YDx-0007Fk-VD
	for linux-btrfs@vger.kernel.org; Fri, 11 Jul 2014 12:38:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 12:38:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 12:38:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs transaction checksum corruption & losing root of the tree
 & bizarre UUID change.
Date: Fri, 11 Jul 2014 10:38:22 +0000 (UTC)
Message-ID: <pan$47a6b$a35f9006$c974e846$4fb869f0@cox.net>
References: <CAKinxcW7X=tc8GBBjkGNHKL8wM6dD=a9UkWBpXOsAbLpaOBmYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Kusmierz posted on Fri, 11 Jul 2014 00:32:33 +0100 as excerpted:

> So it been some time with btrfs, and so far I was very pleased, but
> since I've upgraded to ubuntu from 13.10 to 14.04 problems started to
> occur (YES I know this might be unrelated).

Many points below; might as well start with this one.

You list the ubuntu version but don't list the kernel or btrfs-tools 
versions.  This is an upstream list, so ubuntu version means little to 
us.  We need kernel and userspace (btrfs-tools) versions.

As the wiki stresses, btrfs is still under heavy development and it's 
particularly vital to run current kernels as they fix known bugs in older 
kernels.  3.16 is on rc4 now so if you're not on the latest 3.15.x stable 
series kernel at minimum, you're missing patches for known bugs.  And by 
rc2 or rc3, many btrfs users have already switched to the development 
kernel series, assuming they're not affected by any of the still active 
regressions in the development kernel.  (FWIW, this is where I am.)  
Further, there's a btrfs-next branch that many run as well, with patches 
not yet in mainline but slated for it, tho that's a bit /too/ bleeding 
edge for my tastes.

Keeping /absolutely/ current with the latest btrfs-tools release isn't 
/quite/ as vital, as the most risky operations are handled by the kernel, 
but keeping somewhere near current is definitely recommended.  Current 
btrfs-tools git-master is 3.14.2, with 3.12.0 the last release before 
3.14, as well as the earliest recommended version.  If you're still on 
0.19-something or 0.20-rc1 or so, please upgrade to at least 3.12 
userspace.

> So in the past I've had problems with btrfs which turned out to be a
> problem caused by static from printer generating some corruption in ram
> causing checksum failures on the file system - so I'm not going to
> assume that there is something wrong with btrfs from the start.

Just as a note, RAM shouldn't be that touchy.  There's buffer capacitors 
and the like that should keep the system core (including RAM) stable even 
in the face of a noisy electronic environment.  While that might have 
been the immediately visible problem, I'd consider it a warning sign that 
you have something else unhealthy going on.

The last time I started having issues like that, it was on an old 
motherboard, and the capacitors were going bad.  By the time I quit using 
it, I could still run it if I kept the room cold enough (60F/15C or so), 
but any warmer and the data buses would start corrupting data on the way 
to and from the drives.  Turned out several of the capacitors were 
bulging and a couple had popped.

As Austin H mentioned, it can also be power supply issues.  In one place 
I lived the wall power simply wasn't stable enough and computers kept 
dying.  That was actually a couple decades ago now, but I've seen other 
people report similar problems more recently.  Another power issue I've 
seen was a UPS that simply wasn't providing the necessary power -- 
replaced and the problem disappeared.

Another thing I've seen happen that fits right in with the upgrade 
coincidence, is that a newer release (or certain distros as opposed to 
others, or one time someone reported it was Linux crashing where MSWindows 
ran fine) might be better optimized for current systems, which can stress 
them more, triggering problems where the less optimized OS ran fine.  
However, that tends to trigger CPU issues due to overheating, not so much 
RAM issues.

There's another possibility too, but more below on that.  Bottom line, 
however, your printer shouldn't be able to destabilize the computer like 
that, and if it is, that's evidence of other problems, which you really 
do need to get to the bottom of.

> Anyway:
> On my server I'm running 6 x 2TB disk in raid 10 for general storage and
> 2 x ~0.5 TB raid 1 for system.

Wait a minute... Btrfs raid10 and raid1 modes, or hardware RAID, or 
software/firmware RAID such as the kernel's mdraid or dmraid?

There's a critical difference here, in that btrfs raid modes are checksum 
protected, while the kernel's software raid, at least, is not.  More 
below.

> Might be unrelated, but after upgrading
> to 14.04 I've started using Own Cloud which uses Apache & MySql for
> backing store - all data stored on storage array, mysql was on system
> array.
> 
> All started with csum errors showing up in mysql data files and in some
> transactions !!!. Generally system imidiatelly was switching to all
> btrfs read only mode due to being forced by kernel (don't have dmesg /
> syslog now). Removed offending files, problem seemed to go away and
> started from scratch. After 5 days problem reapered and now was located
> around same mysql files and in files managed by apache as "cloud". At
> this point since these files are rather dear to me I've decided to pull
> all stops and try to rescue as much as I can.

Just to clarify, btrfs csum errors, right?  Or btrfs saying fine and you 
mean mysql errors?  I'll assume btrfs csum errors...

How large are these files?  I'm not familiar with owncloud internals, but 
does it store its files as files (which would presumably be on btrfs) 
that are simply indexed by the mysql instance, or as database objects 
actually stored in mysql (so in one or more huge database files that are 
themselves presumably on btrfs)?

The reason I'm asking is potential file fragmentation and the additional 
filesystem overhead involved, with a corresponding increased risk of 
corruption due to the increased stress on the filesystem due to the 
additional overhead.  A rather long and detailed discussion of the 
problem and some potential solutions follows.  Feel free to skim or skip 
it (down to the next quote fragment) for now and come back to it later if 
you think it may apply.

Due to the nature of COW (copy-on-write) based filesystems (including 
btrfs) in general, they always find a particular write-pattern 
challenging, and btrfs is no exception.  The write pattern in question is 
modify-in-place (which I often refer to as internal write, since it's 
writes to the middle of a file, not just the end), as opposed to write 
out serially and either truncate/replace or append-only modify.  
Databases and VM images are particularly prone to exactly this sort of 
write pattern, since for them the common operation is modifying some 
chunk of data somewhere in the middle, then writing it back out, without 
modifying either the data before or after that particular chunk.

Normal filesystems modify-in-place with that access pattern, and while 
there's some risk of corruption in particular if the system crashes 
during the modify-write, because modify-in-place-filesystems are the 
common case, and this is the most common write mode for these apps, they 
have evolved to detect and deal with this problem.

Copy-on-write filesystems deal with file modifications differently.  They 
write the new data to a different location, and then update the 
filesystem metadata to map the new location into the existing file at the 
appropriate spot.

For btrfs, this is typically done in 4 KiB (4096 byte) chunks at a time.  
If you have say a 128 MiB file, that's 128 MiB / 4 KiB = 128 * 1024 / 4 = 
32,768 blocks, each 4 KiB long.  Now make that 128 MiB 32,768 block file 
a database file with essentially random writes, copying each block 
elsewhere as soon as it's written to, and the problem quickly becomes 
apparent -- you quickly end up with a HEAVILY fragmented file of tens of 
thousands of extents.  If the file is a GiB or larger, the file may well 
be hundreds of thousands of extents!

Of course particularly on spinning rust hard drives, fragmentation that 
heavy means SERIOUS access time issues as the heads seek back and forth 
and then wait for the appropriate disk segment to spin under the read/
write heads.  SSDs don't have the seek latency, but they have their own 
issues in terms of IOPs limits and erase-block sizes.  And of course 
there's the extra filesystem metadata overhead in tracking all those 
hundreds of thousands of extents, too, that affects both types of storage.

It's all this extra filesystem metadata overhead that eventually seems to 
cause problems.  When you consider the potential race conditions inherent 
in updating not only block location mapping but also checksums for 
hundreds of thousands of extents, with real-time updates coming in that 
need written to disk in exactly the correct order along with the extent 
and checksum updates, and possibly compression thrown in if you have that 
turned on as well, plus the possibility of something crashing or in your 
case that extra bit of electronic noise at just the wrong moment, it's a 
wonder there aren't more issues than there are.

Fortunately, btrfs has a couple ways of ameliorating the problem.  First, 
there's the autodefrag mount option.  With this option enabled, btrfs 
will auto-detect file fragmenting writes and queue those files for later 
automatic defrag by a background defrag thread.

This works well for reasonably small database files upto a few hundred 
MiB in size.  Firefox's sqlite based history and etc database files are a 
good example, and autodefrag works well with them.

But as file sizes approach a GiB, particularly for fairly active 
databases or VMs, autodefrag doesn't work so well, because larger files 
take longer for the defrag thread to rewrite, and at some point, the 
changes are coming in faster than the file can be rewritten! =:^(

The next alternative is similar to autodefrag, except at a different 
level.  Script the defrags and have a timer-based trigger.  
Traditionally, it'd be a cronjob, but in today's new systemd based world, 
the trigger could just as easily be a systemd timer.  Either way, the 
idea here is to run the defrag once a day or so, probably when the system 
or at least the database or VM image in question isn't so active.  That 
way, more fragmentation will build up during the hours between defrags, 
but it'll be limited to a day's worth, with the defrag being scheduled to 
take care of the problem during a daily low activity period, overnight or 
whatever it may be.  A number of people have reported that this works 
better for them than autodefrag, particularly as files approach and 
exceed a GiB in size.

Finally, btrfs has the NOCOW file attribute, set using chattr +C.  
Basically, it tells btrfs to handle this file like a normal update-in-
place filesystem would, instead of doing the COW thing btrfs does for 
most files.  But there are a few significant limitations.

First of all, NOCOW must be set on a file before it has any content.  
Setting it on a file that already has data doesn't guarantee NOCOW.  The 
easiest way to do this is to set NOCOW on the directory that will hold 
the files that you want NOCOWed, after which any newly created file (or 
subdir) in that directory will inherit the NOCOW attribute at creation, 
thus before it gets any data.  Existing database and VM-image files can 
then be copied (NOT moved, unless it's between filesystems, as a move on 
the same filesystem won't trigger the creation) into the NOCOW directory, 
and should get the attribute properly that way.

Second, NOCOW turns off both btrfs checksumming and (if otherwise 
enabled) compression for that file.  This is because updating the file in-
place introduces all sorts of race conditions and etc that make 
checksumming and compression impractical.  The reason btrfs can normally 
do them is due to its COW nature, and as a result, turning that off turns 
off checksumming and compression as well.

Now loss of checksumming in particular sounds pretty bad, but for this 
type of file, it's not actually quite as bad as it sounds, because as I 
mentioned above, apps that routinely do update-in-place have generally 
evolved their own error detection and correction procedures, so having 
btrfs do it too, particularly when they're not done in cooperation with 
each other, doesn't always work out so well anyway.

Third, NOCOW interacts badly with the btrfs snapshot feature, which 
depends on COW.  A btrfs snapshot locks the existing version of the file 
in place, relying on COW to create a new copy of any changed block 
somewhere else, while keeping the old unmodified copy where it is.  So 
any modification to a file block after a snapshot by definition MUST COW 
that block, even if the file is otherwise set NOCOW.  And that's 
precisely what happens -- the first write to a file block after a 
snapshot COWS that block, tho subsequent writes to the same file block 
(until the next snapshot) will overwrite in-place once again, due to the 
NOCOW.

The implications of "the snapshot COW exception" are particularly bad 
when automated snapshotting, perhaps hourly or even every minute, is 
happening.  Snapper and a number of other automated snapshotting scripts 
do this.  But what the snapshot COW exception in combination with 
frequent snapshotting means, is that NOCOW basically loses its effect, 
because the first write to a file-block after a snapshot must be COW in 
any case.

Tho there's a workaround for that, too.  Since btrfs snapshots stop at 
btrfs subvolume boundaries, make that NOCOW directory a dedicated 
subvolume, so snapshots of the parent don't include it, and then use 
conventional backups instead of snapshotting on that subvolume.

So basically what I said about NOCOW above is exactly that: btrfs handles 
the file as if it were a normal filesystem, not the COW based filesystem 
btrfs normally is.  That means normal filesystem rules apply, which means 
the COW-dependent features that btrfs normally has simply don't work on 
NOCOW files.  Which is a bit of a negative, yes, but consider this, the 
features you're losing you wouldn't have on a normal filesystem anyway, 
so compared to a normal filesystem you're not losing them.  And btrfs 
features that don't depend on COW, like the btrfs multi-device-filesystem 
option, and the btrfs subvolume option, can still be used. =:^)

Still, one of the autodefrag options may be better, since they do NOT 
kill btrfs' COW based features as NOCOW does.

> As a excercise in btrfs managment I've run btrfsck --repair - did not
> help. Repeated with --init-csum-tree - turned out that this left me with
> blank system array. Nice ! could use some warning here.

As Austin mentioned, btrfsck --repair is normally recommended only as a 
last resort, to be run either on the recommendation of a developer when 
they've decided it should fix the problem without making it worse, or if 
you've tried everything else and the next step would be blowing away the 
filesystem with a new mkfs anyway, so you've nothing to lose.

Normally before that, you'd try mounting with the recovery and then the 
recovery,ro options, and if that didn't work, you'd try btrfs restore, 
possibly in combination with btrfs-find-root, as detailed on the wiki.  
(I actually had to do this recently, mounting recovery or recovery,ro 
didn't work, but btrfs restore did.  FWIW the wiki page on restore 
helped, but I think it could use some further improvement, which I might 
give it if I ever get around to registering on the wiki so I can edit it.)

As for the blank array after --init-csum-tree, some versions back there 
was a bug of just that sort. Without knowing for sure which versions you 
have and going back to look, I can't say for sure that's the bug you ran 
into, but it was a known problem back then, it has been fixed in current 
versions, and if you're running old versions, that's /exactly/ the sort 
of risk that you are taking!

> I've moved all drives and move those to my main rig which got a nice
> 16GB of ecc ram, so errors of ram, cpu, controller should be kept
> theoretically eliminated.

It's worth noting that ECC RAM doesn't necessarily help when it's an in-
transit bus error.  Some years ago I had one of the original 3-digit 
Opteron machines, which of course required registered and thus ECC RAM.  
The first RAM I purchased for that board was apparently borderline on its 
timing certifications, and while it worked fine when the system wasn't 
too stressed, including with memtest, which passed with flying colors, 
under medium memory activity it would very occasionally give me, for 
instance, a bad bzip2 csum, and with intensive memory activity, the 
problem would be worse (more bz2 decompress errors, gcc would error out 
too sometimes and I'd have to restart my build, very occasionally the 
system would crash).

Some of the time I'd get machine-checks from it, usually not, and as I 
said, memcheck passed with flying colors.

Eventually a BIOS update gave me the ability to declock memory timings 
from what the memory was supposedly certified at, and at the next lower 
speed memory clock, it was solid as a rock, even when I then tightened up 
some of the individual wait-state timings from what it was rated for.  
And later I upgraded memory, with absolutely no problems with the new 
memory, either.  It was simply that the memory (original DDR) was PC3200 
certified when it could only reliably do PC3000 speeds.

The point being, just because it's ECC RAM doesn't mean errors will 
always be reported, particularly when it's bus errors due to effectively 
overclocking -- I wasn't overclocking from the certification, it was 
simply cheap RAM and the certification was just a bit "optimistic".

That's the other hardware issue possibility I mentioned above, that I 
punted discussing until here as a reply to your ECC comments.

(FWIW, I was running reiserfs at the time, and thru all the bad memory 
problems, reiserfs was solid as a rock.  That was /after/ reiserfs got 
the data=ordered by default behavior, which Chris Mason, yes, the same 
one leading btrfs now, helped with as it happens (IDR if he was patch 
author or not but IIRC he was kernel reiserfs maintainer at the time), 
curing the risky reiserfs data=writeback behavior that reiserfs 
originally had that's the reason it got its reputation for poor 
reliability.  I'm still solidly impressed with reiserfs reliability and 
continue running it on my spinning rust to this day, tho with the journal 
it's not particularly appropriate for ssds, which is where I run btrfs.)

> I've used system array drives and spare drive
> to extract all "dear to me" files to newly created array (1tb + 500GB +
> 640GB). Runned a scrub on it and everything seemed OK. At this point
> I've deleted "dear to me" files from storage array and ran  a scrub.
> Scrub now showed even more csum errors in transactions and one large
> file that was not touched FOR VERY LONG TIME (size ~1GB).

Btrfs scrub, right?  Not mdraid or whatever scrub.

Here's where btrfs raid mode comes in.  If you are running btrfs raid1 or 
raid10 mode, there's two copies of the data/metadata on the filesystem, 
and if one is bad, scrub csum-verifies the other and assuming it's good, 
rewrites the bad copy.

If you're running btrfs on a single device with mdraid or whatever 
underneath it, then btrfs will default to dup mode for metadata -- two 
copies of it -- but only single mode for data, and if that copy doesn't 
csum-validate, there's no second copy for btrfs scrub to try to recover 
from. =:^(

Which is why the sort of raid you are running is important.  Btrfs 
raid1/10 gives you that extra csummed copy in case the other fails csum-
verification.  Single-device btrfs on top of some other raid won't give 
you that for data, only for metadata, and because you don't have direct 
control of which lower-level raid component the copy it supplies gets 
pulled from, and (with the possible exception of hardware raid if it's 
the expensive stuff) it's not checksummed, for all you know what the 
lower level raid feeds btrfs is the bad copy, and while there may or may 
not be a good copy elsewhere, there's no way for you to ensure btrfs gets 
a chance at it.

My biggest complaint with that, is that regardless of the number of 
devices, both btrfs raid1 and raid10 modes only have two copies of the 
data.  More devices still means only two copies, just more capacity.  N-
way-mirroring is on the roadmap, but it's not here yet.  Which is 
frustrating as my ideal balance between risk and expense would be 3-way-
mirroring, giving me a second fallback in case the first TWO copies csum-
verify-fail.  But it's roadmapped, and at this point btrfs is still 
immature enough that the weak point isn't yet the limit of two copies, 
but instead the risk of btrfs itself being buggy, so I have to be patient.

> Deleted file. Ran scrub - no errors. Copied "dear to me files" back to
> storage array. Ran scrub - no issues. Deleted files from my backup array
> and decided to call a day. Next day I've decided to run a scrub once
> more "just to be sure" this time it discovered a myriad of errors in
> files and transactions. Since I've had no time to continue decided to
> postpone on next day - next day I've started my rig and noticed that
> both backup array and storage array does not mount anymore.

That really *REALLY* sounds to me like hardware issues.  If you ran scrub 
and it said no errors, and you properly umounted at shutdown, then the 
filesystem /should/ be clean.  If scrub is giving you that many csum-
verify errors that quickly, on the same data that passed without error 
the day before, then I really don't see any other alternative /but/ 
hardware errors.  It was safely on disk and verifying the one day.  It's 
not the next.  Either the disk is rotting out from under you in real time 
-- rather unlikely especially if SMART is saying it's fine, or you have 
something else dynamically wrong with your hardware.  It could be power.  
It could be faulty memory.  It could be bad caps on the mobo.  It could 
be a bad SATA cable or controller.  Whatever it is, at this point all the 
experience I have is telling me that's a hardware error, and you're not 
going to be safe until you get it fixed.

That said, something ELSE I can definitely say from experience, altho 
btrfs is several kernels better at this point than it was for my 
experience, is that btrfs isn't a particularly great filesystem to be 
running with faulty hardware.  I already mentioned some of the stuff I've 
put reiserfs thru over the years, and it's really REALLY better at 
running on faulty hardware than btrfs is.

Bottom line, if your hardware is faulty and I believe it is, if you 
simply don't have the economic resources to fix it properly at this 
point, I STRONGLY recommend a mature and proven stable filesystem like 
(for me at least) reiserfs, not something as immature and still under 
intensive development as btrfs is at this point.  I can say from 
experience that there's a *WORLD* of difference between trying to run 
btrfs on known unstable hardware, and running it on rock-stable, good 
hardware.

Now I'm not saying you have to go with reiserfs.  Ext3 or something else 
may be a better choice for you.  But I'd DEFINITELY not recommend btrfs 
for unstable hardware, and if the hardware is indeed unstable, I don't 
believe I'd recommend ext4 either, because ext4 simply doesn't have the 
solid maturity either, for the unstable hardware situation.

> I was
> attempting to rescue situation without any luck. Power cycled PC and on
> next startup both arrays failed to mount, when I tried to mount backup
> array mount told me that this specific uuid DOES NOT EXIST !?!?!
> 
> my fstab uuid:
> fcf23e83-f165-4af0-8d1c-cd6f8d2788f4 new uuid:
> 771a4ed0-5859-4e10-b916-07aec4b1a60b
> 
> 
> tried to mount by /dev/sdb1 and it did mount. Tried by new uuid and it
> did mount as well.

I haven't a clue on that.  The only thing remotely connected that I can 
think of is that I know btrfs has a UUID tree as I've seen it dealt with 
in various patches, that I have some vague idea is somehow related to the 
various btrfs subvolumes and snapshots.  But I'm not a dev and other than 
thinking it might possibly have something to do with an older snapshot of 
the filesystem if you had made one, I haven't a clue at all.  And even 
that is just the best guess I could come up with, that I'd say is more 
likely wrong than right.

I take it you've considered and eliminated the possibility of your fstab 
somehow getting replaced with a stale backup from a year ago or whatever, 
that had the other long stale and forgotten UUID in it?

(FWIW, I prefer LABEL= to UUID= in my fstabs here, precisely because UUIDs 
are so humanly unreadable that I can see myself making just this sort of 
error.  My labeling scheme is a bit strange and is in effect its own ID 
system for my own use, but I can make a bit more sense of it than UUIDs, 
and thus I'd be rather more likely to catch a label error I made than a 
corresponding UUID error.  Of course as they say, YMMV.  By all means if 
you prefer UUIDs, stick with them!  I just can't see myself using them, 
when labels are /so/ much easier to deal with!)


> ps. needles to say: SMART - no sata CRC errors, no relocated sectors, no
> errors what so ever (as much as I can see).


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

