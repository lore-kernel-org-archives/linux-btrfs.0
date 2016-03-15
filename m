Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42349 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489AbcCOPwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 11:52:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1afrHA-0003Ku-6i
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 16:52:52 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 16:52:52 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 16:52:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshots slowing system
Date: Tue, 15 Mar 2016 15:52:44 +0000 (UTC)
Message-ID: <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

pete posted on Mon, 14 Mar 2016 23:03:52 +0000 as excerpted:

> [Duncan wrote...]

>>pete posted on Sat, 12 Mar 2016 13:01:17 +0000 as excerpted:
>>> 
>>> Subvolumes are mounted with the following options:
>>> autodefrag,relatime,compress=lzo,subvol=<sub vol name>>
> 
>>That relatime (which is the default), could be an issue.  See below.
> 
> I've now changed that to noatime.  I think I read or missread relatime
> as a good comprimise sometime in the past.

Well, "good" is relative (ha! much like relatime itself! =:^).

Relatime is certainly better than strictatime as it cuts down on atime 
updates quite a bit, and as a default it's a reasonable compromise (at 
least for most filesystems), because it /does/ do a pretty good job of 
eliminating /most/ atime updates while still doing the minimal amount to 
avoid breaking all known apps that still rely on what is mostly a legacy 
POSIX feature that very little actually modern software actually relies 
on any more.

For normal filesystems and normal use-cases, relatime really is a 
reasonably "good" compromise.  But btrfs is definitely not a traditional 
filesystem, relying as it does on COW, and snapshotting is even more 
definitely not a traditional filesystem feature.  Relatime does still 
work, but it's just not particularly suitable to frequent snapshotting.

Meanwhile, so little actually depends on atime these days, that unless 
you're trying to work out a compromise solution for a kernel with a 
standing rule that breaking working userspace is simply not acceptable, 
the context in which relatime was developed and for which it really is a 
good compromise, chances are pretty high that unless you are running 
something like mutt that is /known/ to need atime, you can simply set 
noatime and forget about it.

And I'm sure, were the kernel rules on avoiding breaking old but 
otherwise still working userspace somewhat less strict, noatime would be 
the kernel default now, as well.


Meanwhile, FWIW, some months ago I finally got tired of having to specify 
noatime on all my mounts, expanding my fstab width by 8 chars (including 
the ,) and the total fstab character count by several multiples of that 
as I added it to all entries, and decided to see if I might per chance, 
even as a sysadmin not a dev, be able to come up with a patch that 
changed the kernel default to noatime.  It wasn't actually hard, tho were 
I a coder and actually knew what I was doing, I imagine I could create a 
much better patch.  So now all my filesystems (barring a few of the 
memory-only virtual-filesystem mounts) are mounted noatime by default, as 
opposed to the unpatched relatime, and I was able to take all the noatimes 
out of my fstab. =:^)

>>Normally when posting, either btrfs fi df *and* btrfs fi show are
>>needed, /or/ (with a new enough btrfs-progs) btrfs fi usage.  And of
>>course the kernel (4.0.4 in your case) and btrfs-progs (not posted, that
>>I saw) versions.
> 
> OK, I have usage.  For the SSD with the system:
> 
> root@phoenix:~# btrfs fi usage /
> Overall:
>     Device size:		 118.05GiB
>     Device allocated:		 110.06GiB
>     Device unallocated:	   7.99GiB
>     Used:			 103.46GiB
>     Free (estimated):		  11.85GiB	(min: 11.85GiB)
>     Data ratio:		      1.00
>     Metadata ratio:		      1.00
>     Global reserve:		 512.00MiB	(used: 0.00B)
> 
> Data,single: Size:102.03GiB, Used:98.16GiB
>    /dev/sda3	 102.03GiB
> 
> Metadata,single: Size:8.00GiB, Used:5.30GiB
>    /dev/sda3	   8.00GiB
> 
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/sda3	  32.00MiB
> 
> Unallocated:
>    /dev/sda3	   7.99GiB
> 
> 
> Hmm.  A bit tight.  I've just ordered a replacement SSD.

While ~8 GiB unallocated on a ~118 GiB filesystem is indeed a bit tight, 
it's nothing that should be giving btrfs fits yet.

Tho even with autodefrag, given the previous relatime and snapshotting, 
it could be that the free-space in existing chunks is fragmented, which 
over time and continued usage would force higher file fragmentation 
despite the autodefrag, since there simply aren't any large contiguous 
free-space areas left in which to write files.

> Slackware
> should it in about 5GB+ of disk space I've seen on a website?  Hmm. 
> Don't beleive that.  I'd allow at least 10GB and more if I want to add
> extra packages such as libreoffice.  If I have no snapshots it seems to
> get to 45GB with various extra packages installed and grows to 100ish
> with snapshotting probally owing to updates.

FWIW, here on gentoo and actually using separate partitions and btrfs,
/not/ btrfs subvolumes (because I don't want all my data eggs in the same 
filesystem basket, should that filesystem go bad)...

My / is 8 GiB (per device, btrfs raid1 both data and metadata on 
partitions from two ssds, so same stuff on each device) including all 
files installed by packages except some individual subdirs in /var/ which 
are symlinked to dirs in /home/var/ where necessary, because I keep / 
read-only mounted by default, and some services want a writable /var/ 
config.

Tho I don't have libreoffice installed, nor multiple desktop environments 
as I prefer (a much slimmed down) kde, but I have had multiple versions 
of kde (kde 3/4 back when, kde 4/5 more recently) installed at the same 
time as I was switching from one to the other.  While gentoo allows 
pulling in rather fewer deps than many distros if one is conservative 
with their USE flag settings, that's probably roughly canceled out by the 
fact that it's build-from-source and thus all the developer package 
halves not installed on binary distros need installed on gentoo, in 
ordered to build packages that depend on them.

Anyway, with compress=lzo, here's my root usage:

$$ sudo btrfs fi usage /
Overall:
    Device size:                  16.00GiB
    Device allocated:              9.06GiB
    Device unallocated:            6.94GiB
    Device missing:                  0.00B
    Used:                          5.41GiB
    Free (estimated):              4.99GiB      (min: 4.99GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               64.00MiB      (used: 0.00B)

Data,RAID1: Size:4.00GiB, Used:2.47GiB
   /dev/sda5       4.00GiB
   /dev/sdb5       4.00GiB

Metadata,RAID1: Size:512.00MiB, Used:237.55MiB
   /dev/sda5     512.00MiB
   /dev/sdb5     512.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/sda5      32.00MiB
   /dev/sdb5      32.00MiB

Unallocated:
   /dev/sda5       3.47GiB
   /dev/sdb5       3.47GiB


So of that 8 gig (per device, two device raid1), nearly half, ~3.5 GiB, 
remains unallocated.  Data is 4 GiB allocated, ~2.5 GiB used.  Metadata 
is half a GiB allocated, just over half used, and there's 32 MiB of 
system allocated as well, with trivial usage.  Including both the 
allocated but unused data space and the entirely unallocated space, I 
should still be able to write nearly 5 GiB (the free estimate already 
accounts for the raid1).

Regular df (not btrfs fi df) reports similar numbers, 8192 MiB total, 
2836 MiB used, 5114 MiB available, tho with non-btrfs df the numbers are 
going to be fuzzy since its understanding of btrfs internals is somewhat 
fuzzy.

But either way, given the LZO compression it appears I've used under half 
the 8 GiB capacity.  Meanwhile, du -xBM / says 4158M, so just over half 
in uncompressed data  (with --apparent-size added it says 3624M).

So installation-only may well fit in under 5 GiB, and indeed, some years 
ago (before btrfs and the ssds, so reiserfs on spinning rust), I was 
running 5 GiB /, which on reiserfs was possible due to tail packing even 
without compression, but it was indeed a bit tighter than I was 
comfortable with, thus the 8 GiB I'm much happier with, today, when I 
partitioned up the ssds with btrfs and lzo compression in mind.

My /home is 20 GiB (per device, dual-ssd-partition btrfs raid1), tho 
that's with a separate media partition and will obviously vary *GREATLY* 
per person/installation.   My distro's git tree and overlays, along with 
sources tarball cache, built binpkgs cache, ccache build cache, and 
mainline kernel git repo, is 24 GiB.

Log is separate to avoid runaway logging filling up more critical 
filesystems and is tiny, 640 MiB, which I'll make smaller, possibly half 
a GiB, next time I repartition.

Boot is an exception to the usual btrfs raid1, with a separate working 
boot partition on one device and its backup on the other, so I can point 
the BIOS at and boot either one.  It's btrfs mixed-bg mode dup, 256 MiB 
for each of working and backup, which because it's dup means 128 MiB 
capacity.  That's actually a bit small, and why I'll be shrinking the log 
partition the next time I repartition.  Making it 384 MiB dup, for 192 
MiB capacity, would be much better, and since I can shrink the log 
partition by that and still keep the main partitions GiB aligned, it all 
works out.

Under the GiB boundary in addition to boot and log I also have separate 
BIOS and EFI partitions.  Yes, both, for compatibility. =:^)  The sizes 
of all the sub-GiB partitions are calculated so (as I mentioned) the main 
partitions are all GiB aligned.

Further, all main partitions have both a working and a backup partition, 
the same size, which combined with the dual-SSD btrfs raid1 and a btrfs 
dup boot on each device, gives me both working copy and primary backups 
on the SSDs (except for log, which is btrfs raid1 but without a backup 
copy as I didn't see the point).

As I mentioned elsewhere, with another purpose-dedicated partition or two 
and their backups, that's about 130 GiB out of the 256 GB ssds, with the 
rest left unpartitioned for use by the ssd FTL.

I also mentioned a media partition.  That's on spinning rust, along with 
the secondary backups for the main system.  It too is bootable on its 
own, should I need to resort to that, tho I don't keep the secondary 
backups near as current as the primary backups on the SSDs, because I 
figure between the raid1 and the primary backups on the ssds, there's a 
relatively small chance I'll actually have to resort to the secondary 
backups on spinning rust.

> Anyway, took the lazy, but less tearing less hair out route and ordered
> a 500GB drive.  Prices have dropped and fortunately a new drive is not a
> major issue.  Timing is also good with Slack 14.2 immanent. You rarely
> hear people complaining about disk too empty problems...

If I had 500 GiB SSDs like the one you're getting, I could put the media 
partition on SSDs and be rid of the spinning rust entirely.  But I seem 
to keep finding higher priorities for the money I'd spend on a pair of 
them...

(Tho I'm finding I do online media enough these days that I don't use the 
media partition so much these days.  I could probably go thru it, delete 
some stuff, and shrink what I have stored on it.  Given the near 50% 
unpartitioned space on the SSDs if I could get it to 64 GiB or under, I'd 
still have the recommended 20% unallocated space for the FTL to use, and 
wouldn't need to wait to upgrade the SSDs to put media on the SSDs and 
could then unplug the then only "secondary backup usage" spinning rust, 
except for doing those backups.)

> Note that the system btrfs does not get 127GB, it gets /dev/sda3, not
> far off, but I've a 209MB partition for /boot and a 1G partition for a
> very cut down system for maintenance purposes (both ext4).  On the new
> drive I'll keep the 'maintenance' ext4 install but I could use /boot
> from that filesystem using bind mounts, a bit cleaner.

Good point.  Similar here except the backup/maintenance isn't a cutdown 
system, it's a snapshot (in time, not btrfs snapshot) of exactly what was 
on the system when I did the backup.  That way, should it be necessary, I 
can boot the backup and have a fully functional system exactly as it was 
the day I took that backup.  That's very nice to have for a maintenance 
setup, since it means I have access to full manpages, even a full X, 
media players, a full graphical browser to google my problems with, etc.

And of course I have it partitioned up into much smaller pieces, with the 
second device in raid1 as well as having the backup partition copies.

> Rarely use them except when I either delete the wrong file or do
> something very sneaky but dumb like inavertently set umask for root and
> install a package and break _lots_ of file system permissions.  Easiest
> to recover from a good snapshot than try to fix that mess...

Of course snapshots aren't backups as if the filesystem goes south, it 
takes the snapshots with it.  But it's still great for fat-fingering 
issues, as you mention.  But I still prefer smaller and easier/faster 
maintained partitions, with backup partition copies that are totally 
independent filesystems from the working copies.  Between that and the 
btrfs raid1 to cover device failure, AND secondary backups on spinning 
rust, I guess I'm /reasonably/ prepared.

(I don't worry much about or bother with offsite backups, however, as I 
figure if I'm forced to resort to them, I'll have a whole lot more 
important things to worry about, like where I'm going to live if a fire 
or whatever took them out, or simply what sort of computer I'll replace 
it with and how I'll actually set it up, if it was simply burglarized.  
After all, the real important stuff is in my head anyway, and if I lose 
/that/ backup I'm not going to be caring much about /anything/, so...)

>>FWIW, I ended up going rather overboard with that here, as I knew I
> <snip>
> 
> So have I.  The price seems almost linear per gigabyte perhaps?
> Suspected it was better to go larger if I could and delay the time until
> the new disk runs out.  Could put the old disk in the laptop for
> experimentation with distros.

It seems to be more or less linear within a sweet-spot, yes.  Back when I 
bought mine, the sweet-spot was 32-256 GiB or so, smaller you paid more 
due to overhead, larger simply wasn't manufactured in high enough 
quantities yet.

Now it seems the sweet-spot is 256 GB to 1 TB, at around 3 GB/USD
low end price (pricewatch.com, SATA-600).  (128 GB is available at that, 
but only for bare laptop OEM models, M2 I'd guess, possibly used.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

